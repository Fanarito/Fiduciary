import httpclient, htmlparser, strformat, strutils, osproc, os, smtp
import ../repositories/website_repo, ../xpath

proc downloadWebsite*(site: Website): string =
    var client = newHttpClient()
    return client.getContent(site.url)

proc sendEmail(site: Website, title: string, message: string) =
    let smtpServer = getEnv("FID_SMTP_SERVER", "smtp.gmail.com")
    let smtpServerPort = Port getEnv("FID_SMTP_SERVER_PORT", "465").parseInt
    let sender = getEnv("FID_SENDER")
    let receiver = getEnv("FID_RECEIVER", sender)
    let password = getEnv("FID_PASSWORD")

    let title = &"Fiduciary: {title}"
    var msg = createMessage(title,
                            message,
                            @[sender],
                            @[],
                            @[("Content-Type", "text/html")])
    let smtpConn = newSmtp(useSsl = true)
    smtpConn.connect(smtpServer, smtpServerPort)
    smtpConn.auth(sender, password)
    smtpConn.sendMail(sender, @[receiver], $msg)

proc notifyByEmail(site: Website) =
    let pages = site.getAllPages()
    if pages.len >= 2:
        let h = pages.high
        let command = &"git diff --color-words --no-index {pages[h - 1]} {pages[h]} | ansi2html"
        let (output, _) = execCmdEx(command)
        site.sendEmail(&"{site.name} has been updated", &"{site.url}\n\n{output}")

proc downloadAll*() =
    let sites = getAll()
    for site in sites:
        echo &"Downloading ------------------ {site.name}"

        let latest = site.getLatestContent()

        try:
            let result = site.downloadWebsite()
            let root = parseHtml(result)
            let xpath = getXpath(site.xpath)
            let xpathText = getXpathText(root, xpath)

            if xpathText != latest:
              echo &"{site.name} has updated content"
              site.saveContent(xpathText)
              site.notifyByEmail()
        except:
            echo "Downloading or parsing site failed, notifying by email"
            site.sendEmail(&"{site.name} error fetching or parsing", &"{site.url} could not be fetched or parsed. Manual intervention needed.")


proc getAllSites*(): seq[Website] =
    return getAll()
