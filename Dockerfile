# 编译阶段
FROM golang:alpine AS builder

# 接收从 YAML 传入的版本号
ARG DERP_VERSION

# 安装 git（go install 拉取源码必需）
RUN apk add --no-cache git

# RUN go env -w GOPROXY=https://goproxy.cn,direct

RUN go install tailscale.com/cmd/derper@${DERP_VERSION}

# 运行阶段
FROM alpine:latest
WORKDIR /app

# 拷贝编译好的 derper 二进制
COPY --from=builder /go/bin/derper .

# 创建证书目录并拷贝证书
# RUN mkdir /ssl
# COPY ssl/ /ssl/

# 时区设置（可选）
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo 'Asia/Shanghai' > /etc/timezone

ENV LANG=C.UTF-8

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
