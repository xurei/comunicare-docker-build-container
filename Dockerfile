FROM node:9.10.1-alpine
 
RUN apk update && \
	apk add --no-cache bash curl git openssh groff less python py-pip zip make g++ mongodb-tools mongodb && \
	apk --purge -v del py-pip && \
	rm /var/cache/apk/*
	
RUN npm i -g npm && npm install -g cordova ionic mocha chai ts-node typescript && npm cache clean --force
