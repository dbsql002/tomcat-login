# 빌드 스테이지에서 최소한의 패키지만 설치하여 Tomcat을 준비합니다.
FROM alpine:latest as builder

RUN apk add --no-cache openjdk8 curl tar && \
    curl -O https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.89/bin/apache-tomcat-9.0.89.tar.gz && \
    mkdir -p /usr/local/tomcat && \
    tar -xzf apache-tomcat-9.0.89.tar.gz -C /usr/local/tomcat --strip-components=1 && \
    curl -O https://downloads.mariadb.com/Connectors/java/connector-java-3.0.0/mariadb-java-client-3.0.0.jar && \
    mv mariadb-java-client-3.0.0.jar /usr/local/tomcat/lib/ && \
    rm apache-tomcat-9.0.89.tar.gz && \
    rm -rf /usr/local/tomcat/webapps/examples \
           /usr/local/tomcat/webapps/docs \
           /usr/local/tomcat/webapps/manager \
           /usr/local/tomcat/webapps/host-manager && \
    chmod +x /usr/local/tomcat/bin/*.sh

COPY index.jsp /usr/local/tomcat/webapps/ROOT/
COPY loginAction.jsp /usr/local/tomcat/webapps/ROOT/


# 최종 단계
FROM alpine:latest

RUN apk add --no-cache openjdk8-jre-base && \
    rm -rf /var/cache/apk/*

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk/jre
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $JAVA_HOME/bin:$CATALINA_HOME/bin:$PATH

COPY --from=builder /usr/local/tomcat /usr/local/tomcat

EXPOSE 8080

CMD ["catalina.sh", "run"]
