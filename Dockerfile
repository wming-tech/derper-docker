# 编译阶段
FROM golang:alpine AS builder
RUN go env -w GOPROXY=https://goproxy.cn,direct
RUN go install tailscale.com/cmd/derper@latest

# 运行阶段
FROM alpine:latest
WORKDIR /app

# 拷贝编译好的 derper 二进制
COPY --from=builder /go/bin/derper .

# 创建证书目录并拷贝证书
RUN mkdir /ssl
COPY ssl/ /ssl/

# 时区设置（可选）
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo 'Asia/Shanghai' > /etc/timezone

ENV LANG C.UTF-8

CMD ["./derper", "-hostname", "derp.example.com", "-a", ":443", "-certmode", "manual", "-certdir", "/ssl"]
