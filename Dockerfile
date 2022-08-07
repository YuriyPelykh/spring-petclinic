FROM maven:3.8.1-adoptopenjdk-11 as mvn-package
RUN mkdir "${PWD}/app"
COPY ${WORKSPACE}/ ${PWD}/app
COPY /home/vagrant/maven-repo/_data/ /root/.m2
RUN cd /app \
    && mvn package \
    && ls -lah \
    && ls -lah target

FROM openjdk:11
ARG TOMCAT_PORT
RUN mkdir "${PWD}/app"
COPY --from=mvn-package ./app/target/*.jar ${PWD}/app
CMD ["java", "-jar", "${PWD}/app/*.jar"]
EXPOSE ${TOMCAT_PORT}
