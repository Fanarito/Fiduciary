FROM nimlang/nim:0.20.2-alpine

RUN apk update && apk upgrade && apk add git python3 py3-pip
RUN pip3 install ansi2html

WORKDIR /app

COPY . ./

RUN nim c -d:release -d:ssl fiduciary.nim

ENTRYPOINT [ "./fiduciary" ]
