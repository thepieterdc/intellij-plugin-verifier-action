# Set the base image.
FROM gradle:jdk11

# Download the plugin verifier.
RUN curl -L --output /verifier.jar https://dl.bintray.com/jetbrains/intellij-plugin-service/org/jetbrains/intellij/plugins/verifier-cli/1.222/verifier-cli-1.222-all.jar

# Copy the initialisation script.
COPY docker-entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT entrypoint.sh
