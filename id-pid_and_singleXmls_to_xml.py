#!/usr/bin/python
# -*- coding: utf-8 -*-

import xml.etree.cElementTree as ET

from xml.etree.ElementTree import Element, tostring, SubElement, ElementTree
from ElementTree_pretty import prettify

from lxml import etree

import sys
DIR = sys.argv[1]
tsv = DIR + '/id-pid.tsv'

def grabXml(num):
    xmlFile = DIR + "/ImportXmls/" + num + '.xml'
    f = open(xmlFile)
    idXml = f.read()
    f.close()
    return idXml

def get_nodes(node):
    d = Element('page')

    if (node != 'Root' and node != "0"):
        filename = DIR + "/ImportXmls/" + node + '.xml'
        doc = etree.parse(filename)

        folder = SubElement(d, 'folder')
        folder.text = doc.find('folder').text

        url = SubElement(d, 'url')
        url.text = doc.find('url').text
    else:
        folder = SubElement(d, 'folder')
        folder.text = "nerokas XMLrakenne"
        url = SubElement(d, 'url')
        url.text = ''

    emptyElements = "content title keywords description language classes creatorUser creationTime modifierUser modificationTime".split(" ")
    for elName in emptyElements:
        newEl = SubElement(d, elName)
        newEl.text = ''

        


    # optional:

    children = get_children(node)

    if children:
        pages = SubElement(d, 'pages')
        pages.extend( [get_nodes(child) for child in children] )

    return d

def get_children(node):
    return [x[1] for x in links if x[0] == node]

#

links = []

import fileinput

# for line in fileinput.input():
# for line in input_.split('\n'):
for line in open(tsv):
    # child, parent = line.rstrip().split('	', 1)
    child, parent = line.rstrip().split("\t", 1)
    # child, parent = line.split('    ', 1)
    # if parent == "0":
    #    continue
    links.append( (parent, child) )

parents, children = zip(*links)
root_nodes = {x for x in parents if x not in children}
# root_nodes = {x for x in parents if x != "0"}
# tree = []

for node in root_nodes:
    # tree.append(('Root', node))
    # tree.append(get_nodes(node))
    links.append(('Root', node))

tree = get_nodes('Root')
#xmlTree = [
#    Element('page', id=str(node))
##    get_nodes(node)
#    ]

#print json.dumps(tree, indent=4)

#exit()

# XML
# top = ET.Element("root")
# top.extend(get_nodes('Root'))
#top.extend(tree)

top = Element('page')
top.extend(get_nodes('Root'))

print prettify(top).encode('utf-8')
# print top


xml = ET.fromstring(ET.tostring(top))
myxml = xml.findall("./pages/page/pages/page")
# root = myxml.getroot()
# print ET.tostring(root)
