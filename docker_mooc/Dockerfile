FROM ubuntu:24.04

WORKDIR /mydir

RUN apt update && apt install -y curl python3 && apt install -y ffmpeg
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
RUN chmod a+x /usr/local/bin/yt-dlp

ENTRYPOINT ["/usr/local/bin/yt-dlp"]

CMD ["https://www.youtube.com/watch?v=Aa55RKWZxxI"]
