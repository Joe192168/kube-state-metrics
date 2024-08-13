ARG GOVERSION=1.22
ARG GOARCH
ARG GOARCH=adm64
FROM registry.cn-qingdao.aliyuncs.com/joe0519/kube-state-metrics:1.22 as builder
ARG GOARCH
ENV GOARCH=${GOARCH}
WORKDIR /go/src/k8s.io/kube-state-metrics/
COPY . /go/src/k8s.io/kube-state-metrics/

RUN make install-tools && make build-local

FROM gcr.io/distroless/static:latest-${GOARCH}
COPY --from=builder /go/src/k8s.io/kube-state-metrics/kube-state-metrics /

USER nobody

ENTRYPOINT ["/kube-state-metrics", "--port=8080", "--telemetry-port=8081"]

EXPOSE 8080 8081
