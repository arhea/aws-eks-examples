FROM alpine:latest

RUN apk update \
    && apk add --no-cache bash jq aws-cli docker git curl wget alpine-sdk \
    && curl -o /usr/bin/kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.15.10/2020-02-22/bin/linux/amd64/kubectl \
    && chmod +x /usr/bin/kubectl \
    && mkdir -p /etc/kubernetes

COPY start-docker.sh /usr/bin/start-docker.sh

ENV KUBECONFIG /etc/kubernetes/kubeconfig.yml
