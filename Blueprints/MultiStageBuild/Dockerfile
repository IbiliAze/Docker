FROM node AS build

RUN mkdir -p $SRC_DIR

ADD app/ $SRC_DIR

WORKDIR /var/node

RUN npm install



FROM node:alpine

ARG SRC_DIR=/var/node/

ENV PORT 5000

COPY --from=build /var/node /var/node

WORKDIR /var/node

EXPOSE $PORT

ENTRYPOINT node /src/app.js


