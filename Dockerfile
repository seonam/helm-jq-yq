FROM alpine:3.21

# helm version
ARG HELM_VERSION=3.18.6

# helm, jq, yq
RUN apk add --no-cache curl jq yq bash ca-certificates && \
    ARCH=$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/') && \
    curl -fsSL "https://get.helm.sh/helm-v${HELM_VERSION}-linux-${ARCH}.tar.gz" | \
    tar -xz --strip-components=1 -C /usr/local/bin linux-${ARCH}/helm && \
    chmod +x /usr/local/bin/helm

WORKDIR /app

CMD ["bash"]
