FROM debian:12-slim

RUN apt-get update && apt-get install -y \
    borgbackup \
    openssh-client \
    pipx \
    && rm -rf /var/lib/apt/lists/*

RUN pipx install borgmatic
ENV PATH "/root/.local/bin:$PATH"
RUN /root/.local/bin/borgmatic --version
RUN /root/.local/bin/borgmatic config generate

ENTRYPOINT ["/root/.local/bin/borgmatic"]
