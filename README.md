#### Env
- 이미지 빌드 환경: macos(arm64) / ubuntu on multipass
- 이미지 실행 환경: linux(amd64)

#### type=load
```
# 1. 빌드
docker buildx build \
  --platform linux/arm64 \
  -t helm:3.18.6-jq-yq-arm64 \
  --load -f Dockerfile-arch .

docker buildx build \
  --platform linux/amd64 \
  -t helm:3.18.6-jq-yq-amd64 \
  --load -f Dockerfile-arch .

# 2. tar
docker save -o helm-arm64.tar helm:3.18.6-jq-yq-arm64
docker save -o helm-amd64.tar helm:3.18.6-jq-yq-amd64

# 3. load
docker load -i helm-arm64.tar  
docker load -i helm-amd64.tar

# 4. run
docker run -it helm:3.18.6-jq-yq-arm64 # amd 에서 불가(exec /bin/bash: exec format error)
docker run -it helm:3.18.6-jq-yq-amd64 # amd 에서 가능
```

#### type=docker
```
# 1. 빌드
# docker 는 단일 빌드만 지원
docker buildx build \
  --platform linux/arm64 \
  --output type=docker,name=helm:3.18.6-jq-yq-arm64-docker,dest=helm-arm64-docker.tar \
  -f Dockerfile-arch .

docker buildx build \
  --platform linux/amd64 \
  --output type=docker,name=helm:3.18.6-jq-yq-amd64-docker,dest=helm-amd64-docker.tar \
  -f Dockerfile-arch .

# 2. load
docker load -i helm-arm64.tar
docker load -i helm-amd64.tar

3. run
docker run -it helm:3.18.6-jq-yq-arm64-docker # amd 에서 불가(exec /bin/bash: exec format error)
docker run -it helm:3.18.6-jq-yq-amd64-docker # amd 에서 가능
```


#### type=oci
- multipass 환경에서 다시 테스트 필요. docker load 시 아래 에러 발생.
  - open /var/snap/docker/common/var-lib-docker/tmp/docker-import-2780373436/blobs/json: no such file or directory
```
# 1. 빌드
# oci 는 멀티 가능
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --output type=oci,name=helm:3.18.6-jq-yq-amd64-oci,dest=helm-oci.tar \
  -f Dockerfile-arch .

# 2. load
docker load -i helm-oci.tar  # amd 실행 가능.

# 3. run
docker run -it helm:3.18.6-jq-yq-arm64-oci # amd 에서 가능.
```

#### type=push (테스트 필요)
```
# (권장) 레지스트리에 바로 push
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t helm:3.18.6-jq-yq \
  --push -f Dockerfile-arch .

docker pull -
```
