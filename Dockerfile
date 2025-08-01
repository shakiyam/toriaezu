ARG BASE_IMAGE=oraclelinux:8
# hadolint ignore=DL3006
FROM ${BASE_IMAGE}
RUN if command -v dnf >/dev/null 2>&1; then \
      dnf -y install sudo && dnf clean all; \
    elif command -v apt-get >/dev/null 2>&1; then \
      apt-get update && apt-get install -y sudo && apt-get clean && rm -rf /var/lib/apt/lists/*; \
    fi \
      && useradd -m -s /bin/bash testuser \
      && echo "testuser ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/testuser >/dev/null \
      && chmod 440 /etc/sudoers.d/testuser
WORKDIR /home/testuser/toriaezu
COPY --chown=testuser:testuser . .
USER testuser
ENV PATH="/home/testuser/.local/bin:/home/testuser/go/bin:${PATH}"
CMD ["/bin/bash"]
