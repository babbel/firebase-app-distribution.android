#!/bin/sh

git config --global --add safe.directory /github/workspace

RELEASE_NOTES=""
RELEASE_NOTES_FILE=""

if [[ -z ${INPUT_RELEASENOTES} ]]; then
        RELEASE_NOTES="$(git log -1 --pretty=short)"
else
        RELEASE_NOTES=${INPUT_RELEASENOTES}
fi

if [[ ${INPUT_RELEASENOTESFILE} ]]; then
        RELEASE_NOTES=""
        RELEASE_NOTES_FILE=${INPUT_RELEASENOTESFILE}
fi

if [ -n "${INPUT_SERVICECREDENTIALSFILE}" ] ; then
    export GOOGLE_APPLICATION_CREDENTIALS="${INPUT_SERVICECREDENTIALSFILE}"
fi

if [ -n "${INPUT_SERVICECREDENTIALSFILECONTENT}" ] ; then
    printf "${INPUT_SERVICECREDENTIALSFILECONTENT}" > service_credentials_content.json
    export GOOGLE_APPLICATION_CREDENTIALS="service_credentials_content.json"
fi

firebase \
        appdistribution:distribute \
        "$INPUT_FILE" \
        --app "$INPUT_APPID" \
        --groups "$INPUT_GROUPS" \
        --testers "$INPUT_TESTERS" \
        ${RELEASE_NOTES:+ --release-notes "${RELEASE_NOTES}"} \
        ${INPUT_RELEASENOTESFILE:+ --release-notes-file "${RELEASE_NOTES_FILE}"} \
        $( (( $INPUT_DEBUG )) && printf %s '--debug' )

