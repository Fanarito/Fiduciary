import strutils, xmltree, sequtils, re, strformat

type
    XPathNode = object
        tag: string
        idx: int

proc walk(root: XmlNode, prepend="") =
  if root == nil or root.kind != xnElement:
    return
  echo prepend, root.tag
  for x in root.items:
    walk(x, &"{prepend}--")

proc getXpath*(str: string): seq[XPathNode] =
    var nodes = str.split('/')
    nodes.delete(0)
    return nodes.map(proc(n: string): XPathNode =
        let tokens = n.split('[')
        if tokens.len() == 1:
            return XPathNode(tag: tokens[0], idx: 1)
        elif tokens.len() == 2:
            let idx = parseInt(tokens[1].split(']')[0])
            return XPathNode(tag: tokens[0], idx: idx)
    )

proc getXpathText*(root: XmlNode, xpath: seq[XPathNode], maxDepth: int = 1000): string =
    var n = root
    var curr = 0
    while curr < len(xpath):
        let xpNode = xpath[curr]
        var idx = 0
        var found = false
        for child in n.items:
            # Ignore all non element nodes
            if child.kind != xnElement:
                continue
            if child.tag == xpNode.tag:
                idx += 1
            if child.tag == xpNode.tag and xpNode.idx == idx:
                n = child
                curr += 1
                found = true
                break
        if not found:
            # Somtimes the body tag is the child of the document node instead of the
            # html node, this fixes those cases
            if xpNode.tag == "body":
              n = root.child(xpNode.tag)
              if n != nil:
                curr += 1
                continue
              else:
                n = root.findAll("head")[0]
                if n != nil:
                    curr += 1
                    continue
            raise newException(Exception, "Could not find path")
    return n.innerText.strip.replace(re"[ ]{2,}", "\n")
