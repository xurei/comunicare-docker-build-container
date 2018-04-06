FROM node:8.9.0-alpine
 
RUN apk update && \
	apk add --no-cache bash curl git openssh groff less python py-pip zip && \
	pip install awscli && \
	apk --purge -v del py-pip && \
	rm /var/cache/apk/*
	
RUN npm install -g cordova ionic mocha chai ts-node typescript	