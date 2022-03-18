FROM openjdk:11
VOLUME /tmp
ARG JAVA_OPTS
ENV JAVA_OPTS=$JAVA_OPTS
COPY  /bank-microservice/target/bank-microservice-0.1.0.jar bank.jar
EXPOSE 8183
ENTRYPOINT exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar bank.jar
