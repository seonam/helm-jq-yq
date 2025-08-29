### now
```
# 1. 빌드
docker buildx build \
  --platform linux/arm64 \
  -t helm:3.18.6-jq-yq-arm64 \
  --load -f Dockerfile-arch .

# 2. tar
docker save -o helm-arm64.tar helm:3.18.6-jq-yq-arm64

...
# 3. load
docker load i helm-arm64.tar
```


### test
```
# docker 는 단일만 지원
docker buildx build \
  --platform linux/arm64 \
  --output type=docker,dest=helm-arm64.tar \
  -f Dockerfile-arch .

docker buildx build \
  --platform linux/amd64 \
  --output type=docker,dest=helm-amd64.tar \
  -f Dockerfile-arch .

# oci 는 멀티 가능
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --output type=oci,dest=helm-oci.tar \
  -f Dockerfile-arch .

# (권장) 레지스트리에 바로 push
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t helm:3.18.6-jq-yq \
  --push -f Dockerfile-arch .
```
