FROM ubuntu:latest

RUN useradd gitea -d /app -m

RUN apt-get update
RUN apt-get install -y git

ADD https://dl.gitea.io/gitea/1.0/gitea-1.0-linux-amd64 /app/gitea
ADD app.sh /app/entry
RUN chmod +x /app/gitea
RUN chmod +x /app/entry

RUN chown gitea:gitea /app/gitea

EXPOSE 3000
EXPOSE 22

ENTRYPOINT ["/app/entry"]
