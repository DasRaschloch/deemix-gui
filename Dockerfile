FROM node:16-alpine as builder

RUN apk --no-cache add git

WORKDIR /

RUN git clone --recursive https://github.com/DasRaschloch/deemix-gui.git

WORKDIR /deemix-gui

RUN yarn install-all

RUN yarn dist-server

FROM lsiobase/alpine:3.16

RUN apk add gcompat

RUN apk add libstdc++

LABEL \
    app.deemix.image.url="https://github.com/DasRaschloch/deemix-gui" \
    app.deemix.image.title="Docker image for Deemix" \
    app.deemix.image.description="Docker image for Deemix" \
    maintainer="Vaultalexandria"

COPY --from=builder /deemix-gui/dist/deemix-server-linux /deemix-server

COPY --from=builder /deemix-gui/docker/ /

EXPOSE 6595

ENTRYPOINT [ "/init" ]