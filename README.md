# Fiduciary

A simple program that watches for text changes on a websites and 
notifies you by email if there are any changes.

## How to use

Create a file data/websites.json and put the websites you want to monitor
in there.
Example contents:
```
[
  {
    "name": "kaupsyslan.is",
    "pageName": "gjaldskra",
    "url": "https://www.kaupsyslan.is/gjaldskra",
    "xpath": "/html/body/div[2]/div/div/p[1]"
  }
]
```

Then setup the environment variables that allow you to send the emails.

- FID_SMTP_SERVER, defaults to smtp.gmail.com
- FID_SMTP_SERVER_PORT, defaults to 465
- FID_SENDER
- FID_RECEIVER, defaults to sender
- FID_PASSWORD

If using gmail only the sender and password is needed.

I recommend running the docker container with the environment variables you need.