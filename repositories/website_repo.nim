import os, json, strformat, times, algorithm

type
    Website* = object
        name*: string
        pageName*: string
        url*: string
        xpath*: string

const dataDir = "data"
const repoFile = &"{dataDir}/websites.json"

proc getPageDir(site: Website): string =
    return &"{dataDir}/{site.name}/{site.pageName}"

proc getAllPages*(site: Website): seq[string] =
    var pages = newSeq[string]()
    for page in getPageDir(site).walkDir:
        let path = page.path
        pages.insert(path, pages.upperBound(path))
    return pages

proc getAll*(): seq[Website] =
    return to(parseFile(repoFile), seq[Website])

proc getLatestContent*(site: Website): string =
    let pages = site.getAllPages()
    if pages.len > 0:
        let latest = readFile(pages.max)
        return latest
    else:
        return ""

proc saveContent*(site: website_repo.Website, text: string) =
    let dir = getPageDir(site)
    createDir(dir)
    let t = $now()
    let fileName = &"{dir}/{t}.txt"
    writeFile(fileName, text)

proc getAllContent*(site: Website): seq[string] =
    let pages = site.getAllPages()
    var contents = newSeq[string]()
    for page in pages:
        contents.add(readFile(page))
    return contents
