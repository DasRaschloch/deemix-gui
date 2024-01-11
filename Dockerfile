FROM node:20-alpine as builder

RUN apk --no-cache add git

RUN npm install yarn

WORKDIR /

RUN git clone --recursive https://github.com/DasRaschloch/deemix-gui.git

RUN yarn install-all

RUN yarn dist-server

FROM lsiobase/alpine:3.16

COPY --from=builder /deemix-gui/dist/deemix-server-linux /deemix

COPY --from=builder /deemix-gui/docker/ /

EXPOSE 6595

ENTRYPOINT [ "/init" ]

ARG BUILDDATE
ENV BUILDDATEENV=${BUILDDATE}

LABEL \
    app.deemix.image.created="${BUILDDATE}" \
    app.deemix.image.url="https://github.com/DasRaschloch/deemix-gui" \
    app.deemix.image.title="Docker image for Deemix" \
    app.deemix.image.description="Docker image for Deemix" \
    maintainer="Vaultalexandria"