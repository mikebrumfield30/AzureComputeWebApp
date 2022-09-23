FROM ubuntu:latest
LABEL author="mikebrumfield30@gmail.com"
RUN apt-get update
RUN apt-get install -y curl sudo
RUN apt-get update -y
RUN apt-get install -y nodejs
RUN apt-get install -y npm
WORKDIR /webapp
COPY ./server.js .
COPY ./package.json .
RUN npm install
ENTRYPOINT [ "/usr/bin/node", "server.js" ]
# run container locally on port 8000 - docker run -p 8000:80 -d webapp