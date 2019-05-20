import os, times, strformat, services/website_service

let to_sleep = 3600000

while true:
    let time = now()
    echo &"{time.utc} - downloading pages"
    downloadAll()
    echo &"Sleeping {to_sleep}"
    sleep(to_sleep)
