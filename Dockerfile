FROM centos:7
MAINTAINER fishro618 <fishro618@gmail.com>

# Install Dependencies 去掉 libstdc++.i686
RUN yum install -y wget unzip tar && \
    yum install -y glibc.i686 glibc-devel.i686 zlib-devel.i686 ncurses-devel.i686 libX11-devel.i686 libXrender.i686 libXrandr.i686

# Download JDK 8
#RUN wget -q --no-check-certificate -c \
#    --header "Cookie: oraclelicense=accept-securebackup-cookie" \
#    "http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-x64.tar.gz" \
#    -O jdk8.tar.gz && \
#    tar -xzf jdk8.tar.gz -C /opt && \
#    rm jdk8.tar.gz

COPY ./jdk8.tar.gz /opt

RUN tar -xzf /opt/jdk8.tar.gz -C /opt && \
    rm /opt/jdk8.tar.gz

# Configure Java Environment
ENV JAVA8_HOME /opt/jdk1.8.0_211
ENV JAVA_HOME $JAVA8_HOME
ENV PATH $PATH:$JAVA_HOME/bin

# Download Android SDK tools
RUN wget -q "http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz" -O /opt/android-sdk.tgz && \
    tar -xzf /opt/android-sdk.tgz -C /opt && \
    rm /opt/android-sdk.tgz

# Configure Android SDK Environment
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/tools/bin
ENV PATH $PATH:$ANDROID_HOME/platform-tools
ENV PATH $PATH:$ANDROID_HOME/build-tools/28.0.3

# Install Android SDK components
RUN echo y | android update sdk --no-ui --all --filter \
    "platform-tools,build-tools-28.0.3,android-28" && \
    echo y | android update sdk --no-ui --all --filter \
    "extra-android-m2repository,extra-google-m2repository,extra-android-support"

# Setup Gradle
ENV GRADLE_VERSION 4.10.1
RUN wget -q "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" -O /opt/gradle.zip && \
    unzip -q /opt/gradle.zip -d /opt && \
    ln -s "/opt/gradle-${GRADLE_VERSION}/bin/gradle" /usr/bin/gradle && \
    rm /opt/gradle.zip

# 查看opt目录下文件
# RUN ls /opt

# Configure Gradle Environment
ENV GRADLE_HOME /opt/gradle-${GRADLE_VERSION}
ENV PATH $PATH:$GRADLE_HOME/bin
RUN mkdir ~/.gradle
ENV GRADLE_USER_HOME ~/.gradle
