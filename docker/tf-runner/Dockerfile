ARG TF_CONTROLLER_VERSION
FROM ghcr.io/flux-iac/tf-runner:${TF_CONTROLLER_VERSION}-base

ARG TARGETARCH
ARG TF_VERSION

# Switch to root to have permissions for operations
USER root

ADD https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_${TARGETARCH}.zip /terraform_${TF_VERSION}_linux_${TARGETARCH}.zip
RUN unzip -q /terraform_${TF_VERSION}_linux_${TARGETARCH}.zip -d /usr/local/bin/ && \
    rm /terraform_${TF_VERSION}_linux_${TARGETARCH}.zip && \
    chmod +x /usr/local/bin/terraform

# Switch back to the non-root user after operations
USER 65532:65532
