FROM node

VOLUME ["/usr/share/nginx/html"]

LABEL version=1.1

ARG SRC_DIR=/var/node/

ENV PORT 5000

RUN mkdir -p $SRC_DIR

ADD app/ $SRC_DIR

WORKDIR $SRC_DIR

RUN npm install

EXPOSE $PORT

CMD node src/app.js



