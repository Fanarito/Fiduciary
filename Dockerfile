FROM nimlang/nim:1.0.6-regular

RUN apt-get -qq update && apt-get install -y -qq git python3 python3-pip
RUN pip3 install ansi2html

WORKDIR /app

COPY . ./

RUN nim c -d:release -d:ssl fiduciary.nim

ENTRYPOINT [ "./fiduciary" ]
