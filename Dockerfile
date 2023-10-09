FROM alpine:latest as vendor

WORKDIR /usr/local/blender

ENV BLENDER_VERSION 3.6
ENV BLENDER_MINOR 3.6.2
ENV BLENDER_URL https://mirrors.iu13.net/blender/release/Blender3.6/blender-3.6.2-linux-x64.tar.xz

RUN wget "$BLENDER_URL" -O blender.tar.xz \
    && tar -xf blender.tar.xz --strip-components=1

WORKDIR /app

ENV FLAMENCO_VERSION 3.2
ENV FLAMENCO_URL https://flamenco.blender.org/downloads/flamenco-$FLAMENCO_VERSION-linux-amd64.tar.gz

RUN wget "$FLAMENCO_URL" -O flamenco.tar.gz \
    && tar -xf flamenco.tar.gz --strip-components=1

FROM nvidia/cuda:12.2.0-base-ubuntu22.04

RUN \
    apt-get update \
    && apt-get install -y \
    libfreetype6 \
    libgl1-mesa-dev \
    libglu1-mesa \
    libsm6 \
    libxi6 \
    libxrender1 \
    libxkbcommon-x11-0 \
    && apt-get -y autoremove

COPY --from=vendor /usr/local/blender /usr/local/blender
COPY --from=vendor /app/tools/ffmpeg-linux-amd64 /usr/local/ffmpeg/ffmpeg
COPY --from=vendor /app/flamenco-worker /app/flamenco-worker
COPY bootstrap.sh /app
COPY device.py /app

ENV PATH=/usr/local/blender:$PATH
ENV PATH=/usr/local/ffmpeg:$PATH

RUN chmod +x /app/bootstrap.sh
RUN chmod +x /app/device.py

WORKDIR /app

CMD [ "./bootstrap.sh" ]