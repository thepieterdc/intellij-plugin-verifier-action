# Set the base image.
FROM gradle:jdk11

# Download the plugin verifier.
RUN curl -L --output /verifier.jar https://dl.bintray.com/jetbrains/intellij-plugin-service/org/jetbrains/intellij/plugins/verifier-cli/1.240/verifier-cli-1.240-all.jar

# Copy and compile the sources of the parser into a jar.
RUN mkdir /tmp/build-parser
COPY src/ /tmp/build-parser
RUN find /tmp/build-parser -name *.java | xargs javac -classpath /tmp/build-parser/build -d /tmp/build-parser/build -sourcepath /tmp/build-parser
RUN jar -cvf /parser.jar -C /tmp/build-parser/build .

# Copy the initialisation script.
COPY docker-entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT entrypoint.sh
