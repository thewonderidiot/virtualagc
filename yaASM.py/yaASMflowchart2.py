#!/usr/bin/python3
# Copyright 2023 Ronald S. Burkey <info@sandroid.org>
#
# This file is part of yaAGC.
#
# yaAGC is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# yaAGC is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with yaAGC; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
# Filename:     yaASMflowchart2.py
# Purpose:      Supersedes yaASMflowchart.py, which is now abandoned.
#               The idea behind this program is the observation that certain
#               aspects of the program comments of LVDC flight programs AS-512
#               and AS-513, particularly the markings in column 71, *may* be 
#               instructions for automated generation of flowcharts.  This 
#               program attempts to construct such flowcharts by extracting the
#               markings in question from the source code and generating a
#               program from them in the DOT language for subsequent processing
#               by graphviz software.  There is no assurance that the results
#               correctly reflect the software.  Requires source code in .lvdc
#               format (vs .lvdc8 format).  Note that the conversion to DOT is 
#               imperfect in many ways, but if desired, the DOT files can be
#               edited manually after they are created to produce better 
#               results.  For example, I cannot make the arrows from decision
#               boxes come out of the boxes' corners -- or more accurately, I 
#               can, though they would likely come out of the *wrong* corners --
#               but manually tweaking the DOT files can achieve that.
# Reference:    http://www.ibibio.org/apollo
# Mods:         2023-07-11 RSB  Began.

'''
Input is on stdin.  Any given source-code input file may actually represent
several flowcharts, and graphviz can only render a single flowchart from any
given DOT-language file.  Therefore, rather than output a DOT file on stdout,
one or more DOT files are generated directly.  These have names derived from
the names as given in the program comments, specifically in the comments which
are "J" annotations.  For example, a flowchart beginning with the source-code
line

*      ABSOLUTE/COMMAND FREEZE UTILITY (FR)                          *J

might have the filename ABSOLUTE-COMMAND_FREEZE_UTILITY.dot.

Usage is:

    yaASMflowchart2.py <SOURCE.lvdc

Convert the resulting DOT file(s) (one by one) to postscript format with

    dot -Tps -l sdl.ps <FILENAME.dot >FILENAME.ps

The temp.ps file is the rendering of the flowchart, and it can be viewed with
a postcript viewer or else somehow converted a some more-common format like
pdf, svg, or png.  For example, the postscript file could be converted to other 
formats with GIMP or ImageMagick.  The former is interactive and its usage is
obvious (for GIMP-savvy users), though be certain to select the strongest 
antialiasing options you're presented with.  With ImageMagick, you could use a 
command like

    convert -density 100 test.ps -background white -flatten test.png
    
where the DPI is adjustable by changing the number after the -density switch.
On Linux at least, there are other common converter programs such as ps2pdf, but
with the ones I've tried, care has to be taken with the paper sizes chosen, to 
avoid the drawing being clipped.  Whereas GIMP and ImageMagick don't have that 
problem and don't require selection of a paper size at all.

Warning:  It appears to me that ImageMagick may have overhauled its CLI
usage in the meantime, meaning that any ImageMagick commands I give you are not
guaranteed to work as given.

Note that by default these steps rely on a user contribution to graphviz, 
namely a file called sdl.ps that contains some box shapes not present in 
graphviz as-is.  That's because several of the natively-included node shapes 
just don't look good in the flowcharts.  It's the use of sdl.ps that results in
the need to output a postscript flowchart.  If one were willing to live with 
the native graphviz shapes, which can be done by using yaASMflowchart.py's 
CLI switch --no-sdl, then formats like could all be output directly from dot, 
without any extra conversion steps.  For example, the commands for directly 
producing svg (using native graphviz shapes) would be

    yaASMflowchart2.py --no-sdl <SOURCE.lvdc
    dot -Tsvg <FILENAME.dot >FILENAME.svg

and the other formats could be produced using obvious variants of the latter.

Here's my interpretation of what's in column 71:

    J Start of a flowchart.
    H End of a flowchart

    S Entry point.
    X Exit point (including RETURN).
    
    Q Decision box.
    Y "Yes" arrow from decision box.
    N "No" arrow from decision box.
    G Unconditional goto.
    
    P Process (subroutine all or macro expansion)
'''

import sys
import re
import textwrap
import copy

# Read CLI switches.  Define the shapes used for various flowchart boxes.
# Refer to https://graphviz.org/doc/info/shapes.html, in particular to the
# section describing SDL shapes for PostScript.
if "--no-sdl" not in sys.argv[1:]:
    startShape = "shape=sdl_start peripheries=0"
    callShape = "shape=sdl_call peripheries=0"
    decisionShape = "shape=diamond height=1.33"
    ioShape = "shape=sdl_save peripheries=0"
    connectorShape = "shape=sdl_connector peripheries=0"
else:
    startShape = "style=rounded"
    callShape = ""
    decisionShape = "shape=diamond height=1.33"
    ioShape = "shape=parallelogram height=1"
    connectorShape = "shape=circle"
simplified = ("--simplified" in sys.argv[1:])

lineNumber = -1
def error(msg):
    print("Line %d: %s" % (lineNumber, msg), file=sys.stderr)
def error71():
    error("Cannot interpret %s notation" % col71)

# Dissects a comment having the form "(...)...", "...(...)", or "(...)...(...)",
# possibly embedded in a full-line comment.  Returns 4-tuple of fields (let's 
# call them F1, F2, F3, and F4), from either the pattern
#    *F1 (F2)F3(F4)
# or the pattern
#    (F2)F3(F4)
# Multiple spaces are condensed to single spaces, and space between F2 and F3
# or F3 and F4 is optional.  Any field not present is returned as an empty
# string.
fullFrontPattern = re.compile("^\*[^ ]*")
commentPrefixPattern = re.compile("^\([^ )]+\)")
commentTailPattern = re.compile("\([^ )]+\)$")
multispacePattern = re.compile("\s\s+")
def dissectComment(comment):
    comment = multispacePattern.sub(" ", comment)
    fullCommentFront = ""
    commentPrefix = ""
    commentMiddle = ""
    commentTail = ""
    match = fullFrontPattern.search(comment)
    if match != None:
        fullCommentFront = match.group()
        if fullCommentFront == "*":
            fullCommentFront = ""
        if comment[-1:] == "*":
            comment = comment[:-1].rstrip()
        comment = comment[match.span()[1]:].lstrip()
    match = commentPrefixPattern.search(comment)
    if match != None:
        commentPrefix = match.group()
        comment = comment[match.span()[1]:].lstrip()
    match = commentTailPattern.search(comment)
    if match != None:
        commentTail = match.group()
        comment = comment[:match.span()[0]].rstrip()
    commentMiddle = comment
    return fullCommentFront, commentPrefix, commentMiddle, commentTail

# Loop that makes list (lines) containing all the source-code lines.  Each entry
# is a dictionary describing the relevant properties of the line.  In this loop
# we compute just the properties deducible from individual lines, but then
# do additional analysis in later loops to deduce more-global properties and
# to perform actual output.
defaultEntry = {
        "ignore": False,
        "lineNumber": 0,
        "raw": "",
        "col71": " ",
        "fullComment": False,
        "comment": "",
        "lhs": "",
        "opcode": "",
        "operand": "",
        # Parts of comments.
        "fullCommentFront": "",
        "commentPrefix": "",
        "commentMiddle": "",
        "commentTail": "",
        # For splitting nodes.
        "next": None
    }
lines = []
lhsPattern = re.compile("^[A-Z][.A-Z0-9]*\\b")
operandPattern = re.compile("^[^ ]+")
for line in sys.stdin:
    entry = copy.deepcopy(defaultEntry)
    lines.append(entry)
    entry["lineNumber"] = len(lines)
    raw = "%-071s" % line.rstrip()
    entry["raw"] = raw
    if raw[0] in ["$", "#"] or raw.startswith("       TITLE"):
        continue
    col71 = raw[70]
    entry["col71"] = col71
    if raw[0] == "*":
        entry["fullComment"] = True
        comment = raw[:70].strip()
        entry["comment"] = comment
        fullCommentFront,commentPrefix,commentMiddle,commentTail = \
            dissectComment(comment)
        entry["fullCommentFront"] = fullCommentFront
        entry["commentPrefix"] = commentPrefix
        entry["commentMiddle"] = commentMiddle
        entry["commentTail"] = commentTail
        continue
    match = lhsPattern.search(raw)
    if match != None:
        lhs = match.group()
        if col71 == " ":
            col71 = "-"
            entry["col71"] = "-"
    else:
        lhs = ""
    entry["lhs"] = lhs
    s = line[:70].rstrip()
    if len(s) < 8:
        continue
    opcode = s[7:15].strip()
    entry["opcode"] = opcode
    s = s[15:]
    if len(s) < 1:
        continue
    if s[:8].strip() == "":
        operand = ""
        comment = s.lstrip()
    else:
        match = operandPattern.search(s)
        if match == None:
            continue
        operand = match.group()
        comment = s[match.span()[1]:].strip()
    entry["operand"] = operand
    entry["comment"] = comment
    fullCommentFront,commentPrefix,commentMiddle,commentTail = \
        dissectComment(comment)
    entry["fullCommentFront"] = fullCommentFront
    entry["commentPrefix"] = commentPrefix
    entry["commentMiddle"] = commentMiddle
    entry["commentTail"] = commentTail

# For debugging purposes ...
if False:
    for entry in lines:
        if entry["col71"] == " ":
            continue
        print("")
        for key in sorted(entry):
            print(key, ":", entry[key])

# The following function assumes that all the info for a flowchart has been
# turned into two structures, one representing the boxes (nodes[]) and one the 
# edges (arrows[]), and outputs a dot-file representing it.
def printFlowchart(nodes, arrows):
    global col71, lineNumber

    # Format text for inclusion in a box.
    def formatText(body, heading, lineLength=24):
        lines = []
        if body != "":
            # This performs word-wrapping.  The function from the textwrap
            # module works perfectly well, but I've replaced it with my own
            # code instead, in order to make the lines within any given box
            # more uniform in length.
            if False:
                lines = textwrap.wrap(body, lineLength, break_long_words=False)
            else:
                nominalLines = (len(body) + lineLength - 1) // lineLength
                nominalLineLen = (len(body) + nominalLines - 1) // nominalLines
                nominalLineLen += 2 # No good rationale. Maybe prettier.
                words = body.split()
                line = ""
                for word in words:
                    if len(line) == 0:
                        line = word
                    elif len(line) + 1 + len(word) <= nominalLineLen:
                        line = line + " " + word
                    else:
                        lines.append(line)
                        line = word
                if line != "":
                    lines.append(line)
        if heading != "":
            lines = [heading] + lines
        return "\n".join(lines)
    
    title = nodes[0]["commentMiddle"]
    if nodes[0]["commentTail"] != "":
        title = title + " " + nodes[0]["commentTail"]
    filename = title.replace("/", "-").replace(" ", "_") + ".dot"
    file = open(filename, "w")
    print("digraph {", file=file)
    print("\tlabel = \"%s\n \"" % title, file=file)
    print("\tlabelloc = t", file=file)
    print("\tfontsize = 20", file=file)
    print("\tfontcolor = blue", file=file)
    #print("\tsplines=false", file=file)
    print("\tnode [shape=rect fontsize=12]", file=file)
    
    print("", file=file)
    lastNode = ""
    # Loop on all nodes in the nodes[] array.
    # Here's an explanation of this "next" stuff: Nodes initially get added 
    # to the nodes[] array basically on a line-by-line basis, though some
    # are generally missing, and they're identified in the DOT file by 
    # the original line number.  However, the subsequent analysis sometimes 
    # chooses to split these entries so that some input lines are 
    # represented by two nodes (or perhaps more, for all I know right now).
    # When this is done, the node["next"] points to the 2nd node in the
    # split, node["next"]["next"] points to the 3rd node in the split, and
    # so on. 
    for next in nodes[1:]:
        while next != None:
            node = next # This is the node we'll process right now.
            next = node["next"] # This is for the next iteration of inner loop.
            lineNumber = node["lineNumber"]
            col71 = node["col71"]
            nodeIdentifier = node["key"]
            lhs = node["lhs"]
            fullCommentFront = node["fullCommentFront"]
            commentPrefix = node["commentPrefix"]
            commentMiddle = node["commentMiddle"]
            commentTail = node["commentTail"]
            opcode = node["opcode"]
            operand = node["operand"]
            heading = ""
            is_TRA_HOP = opcode.startswith("TRA") or opcode.startswith("HOP")
            boxWidth = 20
            if col71 in ["J", "H", "E"]:
                continue
            elif col71 in ["S"]:
                if lhs != "":
                    heading = lhs
                elif fullCommentFront != "":
                    heading = fullCommentFront
                elif commentPrefix != "":
                    heading = commentPrefix
                elif commentMiddle != "" and " " not in commentMiddle:
                    heading = commentMiddle
                else:
                    error71()
                    continue
                body = ""
                attributes = startShape
            elif col71 == "-":
                heading = lhs
                body = ""
                attributes = startShape
            elif col71 in ["X"]:
                if commentMiddle != "":
                    heading = commentMiddle
                    if heading.startswith("THRU "):
                        heading = heading[5:]
                        if heading == "" or " " in heading:
                            error71()
                            continue
                elif is_TRA_HOP:
                    heading = operand
                else:
                    error71()
                    continue
                body = ""
                attributes = startShape
            elif col71 in ["B", "D", "L", "M"]:
                if fullCommentFront != "":
                    heading = fullCommentFront
                elif commentPrefix != "":
                    heading = commentPrefix
                elif lhs != "":
                    heading = lhs
                body = commentMiddle
                attributes = "" # Default rectangular shape.
            elif col71 == "P":
                if commentPrefix != "":
                    heading = commentPrefix
                elif is_TRA_HOP or opcode == "CALL":
                    heading = operand
                else:
                    heading = ""
                body = commentMiddle
                attributes = callShape
            elif col71 == "I":
                heading = commentPrefix
                body = commentMiddle
                attributes = ioShape
            elif col71 == "G":
                heading = operand
                body = ""
                attributes = startShape
            elif col71 == "Q":
                heading = commentPrefix
                body = commentMiddle
                attributes = decisionShape
                boxWidth = 12
            else:
                error("Node type %s not yet implemented" % col71)
                continue
            if body == heading:
                body = ""
            text = formatText(body, heading, boxWidth)
            print("\t%s [%s label=\"%s\"]" \
                  % (nodeIdentifier, attributes, text), file=file)
            if len(arrows) == 0:
                # The following is just a temporary measure to keep the nodes
                # stacked vertically until I begin to add actual arrows.
                if lastNode != "":
                    print("\t%s -> %s [style=invis, weight=10]" \
                          % (lastNode, nodeIdentifier), file=file)
            lastNode = nodeIdentifier
    
    # Note that a source box for an arrow is the *last* box in a sequence of
    # nexts, whereas the destination box is the *first* box in a sequence of 
    # nexts.  With the exception that if the source and destination have the 
    # same line number, this is reversed.  For now, for simplicity, I'm going 
    # to assume that no node is split into more than 2, and I'll fix it later 
    # if it turns out that there are sometimes more splits.
    print("", file=file)
    for arrow in arrows:
        node0 = nodes[arrow[0]]
        node1 = nodes[arrow[1]]
        if arrow[0] == arrow[1]:
            if node1["next"] != None:
                node1 = node1["next"]
        else:
            if node0["next"] != None:
                node0 = node0["next"]
        caption = arrow[2]
        nodeIdentifier0 = node0["key"]
        if node0["col71"] not in ["S", "X", "D", "G", "-", "Q"]:
            nodeIdentifier0 = nodeIdentifier0 + ":s"
        nodeIdentifier1 = node1["key"]
        if node1["col71"] not in ["S", "X", "D", "G", "-"]:
            nodeIdentifier1 = nodeIdentifier1 + ":n"
        if arrow[2] != "":
            print("\t%s -> %s [label=\"%s\"]" % \
                  (nodeIdentifier0, nodeIdentifier1, caption), file=file)
        else:
            print("\t%s -> %s" % (nodeIdentifier0, nodeIdentifier1), \
                  file=file)
    
    print("}", file=file)
    file.close()

# This is a function that processes a sequence of lines (literally, from 
# the lines[] array) representing a flowchart.  Both parameters are line 
# numbers, with startLine being the first line of the flowchart and afterLine
# being the next line number after the end of the flowchart.  These parameters
# start from 1, thus the corresponding source lines are lines[startLine-1] and
# lines[afterLine-1].
def processFlowchart(startLine, afterLine):
    start = startLine - 1
    after = afterLine - 1
    # There's one entry in nodes[] for each box.  In the dot file, the nodes
    # will be identified as "n%06d" % lineNumber.  Or if we have need to split
    # a node into a sequence of two or more nodes, the subsequent nodes will
    # have identifiers suffixed by "A", "B", C", etc.  The entries
    # in arrows[] are 3-tuples, consisting of the index (into nodes) of the
    # source box, the index of the destination box, and the caption (or "")
    # on the line.
    nodes = []
    arrows = []
    # Let's accumulate some nodes, and add some status variables (key, ...)
    # to them.
    for i in range(start, after):
        entry = lines[i]
        col71 = entry["col71"]
        opcode = entry["opcode"]
        operand = entry["operand"]
        commentMiddle = entry["commentMiddle"]
        if col71 == "C" and opcode == "HOP" and \
                (operand.startswith("77") or commentMiddle == "RETURN"):
            # Pure ad-hoc'ery here!  I hope it doesn't come back to bite me.
            col71 = "X"
            entry["col71"] = col71
        if col71 in [" ", "$", "*", "H", "Y", "N", "C", "E"]:
            continue
        if entry["fullComment"] and entry["comment"] == "*":
            continue
        if col71 == "G" and \
                not (opcode.startswith("TRA") or opcode.startswith("HOP")):
            continue
        key = "n%06d" % entry["lineNumber"]
        entry["key"] = key
        entry["yes"] = False
        entry["no"] = False
        entry["index"] = len(nodes)
        nodes.append(entry)
    
    # And some arrows.  If the --simplified CLI switch is used, only the 
    # boxes and their default fallthrough arrows are depicted.  That helps in
    # certain aspects of debugging, but isn't for "production" flowcharts.
    if not simplified:
        pass 
    
    # Here are the default fallthrough arrows.
    prior = nodes[1]
    for node in nodes[2:]:
        caption = ""
        fallthrough = ("hang" not in prior)
        col71 = node["col71"]
        prior71 = prior["col71"]
        priorOpcode = prior["opcode"]
        if prior71 == "X":
            fallthrough = False
        elif prior71 == "G" and \
                (priorOpcode.startswith("TRA") or \
                 priorOpcode.startswith("HOP")):
            fallthrough = False
        elif prior71 == "Q":
            if prior["yes"] and not prior["no"]:
                caption = "NO"
                prior["no"] = True
            elif prior["no"] and not prior["yes"]:
                caption = "YES"
                prior["yes"] = True
            elif prior["yes"] and prior["no"]:
                fallthrough = False
        if fallthrough:
            arrows.append((prior["index"], node["index"], caption))
        elif col71 not in ["S", "-"]:
            # Here we have a node that's marked with flowchart notations, but
            # no way to get to it, and not already having an entry-point shape.
            # We're going to split it so that an entry-point box feeds it.
            next = copy.deepcopy(node)
            next["key"] = next["key"] + "A"
            node["next"] = next
            node["col71"] = "S"
            arrows.append((node["index"], node["index"], ""))
        if node["opcode"] == "TRA" and node["lhs"] == node["operand"]:
            node["hang"] = True
            arrow = (node["index"], node["index"], "")
            if len(arrows) < 1 or arrows[-1] != arrow:
                arrows.append(arrow)
        prior = node
    
    # For debugging purposes ...
    if False:
        for node in nodes:
            print("")
            for key in sorted(node):
                print(key, ":", node[key])
    
    printFlowchart(nodes, arrows)


# This loop determines where flowcharts begin and end, processing them as it
# finds them.  They start at J and end at H.
inJ = False
startLine = -1
for entry in lines:
    col71 = entry["col71"]
    lineNumber = entry["lineNumber"]
    if col71 == "H":
        if inJ:
            processFlowchart(startLine, lineNumber)
        else:
            error("H outside of flowchart, no preceding J")
        inJ = False
    elif col71 == "J":
        if inJ:
            error("Duplicated J without intervening H")
            processFlowchart(startLine, lineNumber)
        inJ = True
        startLine = lineNumber
if inJ:
    error("No terminating H for final J")
    processFlowchart(startLine, lines[-1]["lineNumber"]+1)