FROM mirror.gcr.io/python:3.13-alpine

LABEL "com.github.actions.name"="Sync to S3"
LABEL "com.github.actions.description"="Sync a directory to an AWS S3 repository"
LABEL "com.github.actions.icon"="refresh-cw"
LABEL "com.github.actions.color"="green"

LABEL version="0.6.0"
LABEL repository="https://github.com/FugaCloud/s3-sync-action"
LABEL homepage="https://cyso.cloud/"
LABEL maintainer="Sam Toxopeus <sam@cyso.cloud>"

# https://github.com/aws/aws-cli/blob/master/CHANGELOG.rst
ENV AWSCLI_VERSION='1.37.15'

RUN pip install --quiet --no-cache-dir awscli==${AWSCLI_VERSION}

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
