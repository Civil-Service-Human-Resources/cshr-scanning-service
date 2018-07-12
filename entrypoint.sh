#! /bin/bash
##
# Due to some restrictions with the Azure platform we need to
# run filebeat alongside the application in the same container.
# In order to achieve this we need an entrypoint file

echo "cshr-scanning-service: In entrypoint.sh"

echo "entrypoint.sh: command passed: " ${1}

if [[ ${#} -eq 0 ]]; then
    # -E to preserve the environment
    echo "Starting filebeat"
    sudo -E filebeat -e -c /etc/filebeat/filebeat.yml &
    echo "Starting application"
    java -Djava.security.egd=file:/dev/./urandom \
        -Dcshr.scanner.endpoint=${CSHR_SCANNER_ENDPOINT} \
        -Dserver.port=${SERVER_PORT} \
        -Dspring.security.service.password=${SPRING_SECURITY_SERVICE_PASSWORD} \
        -Dspring.security.service.username=${SPRING_SECURITY_SERVICE_USERNAME} \
        -jar /app/cshr-scanning-service.jar
else
    echo "Running command:"
    exec "$@"
fi