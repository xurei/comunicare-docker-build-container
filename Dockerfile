FROM node:9.10.1-alpine
 
RUN apk update && \
	apk add --no-cache bash curl git openssh groff less python py-pip zip make g++ mongodb-tools mongodb unzip libstdc++ openjdk8 && \
	apk add --no-cache ca-certificates wget && update-ca-certificates && \
	apk --purge -v del py-pip && \
	rm /var/cache/apk/*
	
RUN npm i -g npm@5.6.0 && npm install -g cordova ionic mocha chai ts-node typescript && npm cache clean --force

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk

### Install Android Studio

ENV ANDROID_HOME="/opt/android-sdk-linux" \
    SDK_TOOLS_VERSION="25.2.5" \
    API_LEVELS="android-27" \
    BUILD_TOOLS_VERSIONS="build-tools-27.0.3" \
    ANDROID_EXTRAS="extra-android-m2repository,extra-android-support,extra-google-google_play_services,extra-google-m2repository"

RUN mkdir -p ${ANDROID_HOME} && mkdir -p /tmp/android-install && cd /tmp/android-install && \
    wget -q http://dl.google.com/android/repository/tools_r${SDK_TOOLS_VERSION}-linux.zip -O android-sdk-tools.zip && \
    unzip -q android-sdk-tools.zip -d ${ANDROID_HOME} && \
    rm -f android-sdk-tools.zip
    
RUN rm -f android-sdk-tools.zip && \
    echo y | ${ANDROID_HOME}/tools/android update sdk --no-ui -a --filter tools,platform-tools,${ANDROID_EXTRAS},${API_LEVELS},${BUILD_TOOLS_VERSIONS} --no-https

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

# Install gradle
ENV GRADLE_VERSION 4.7
ENV GRADLE_HOME /usr/local/gradle
ENV PATH ${PATH}:${GRADLE_HOME}/bin

WORKDIR /usr/local
RUN wget  https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip && \ 
    unzip gradle-$GRADLE_VERSION-bin.zip && \
    rm -f gradle-$GRADLE_VERSION-bin.zip && \
    ln -s gradle-$GRADLE_VERSION gradle && \
    echo -ne "- with Gradle $GRADLE_VERSION\n" >> /root/.built