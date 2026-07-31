#!/bin/sh
# entrypoint.sh - 支持环境变量动态配置 derper

# 默认值
DERP_HOSTNAME="${DERP_HOSTNAME:-derp.example.com}"
DERP_ADDR="${DERP_ADDR:-:443}"
DERP_CERT_MODE="${DERP_CERT_MODE:-manual}"
DERP_CERT_DIR="${DERP_CERT_DIR:-/ssl}"
DERP_STUN_PORT="${DERP_STUN_PORT:-3478}"
VERIFY_CLIENTS="${VERIFY_CLIENTS:-true}"

# 构建启动参数
ARGS="-hostname=${DERP_HOSTNAME}"
ARGS="${ARGS} -a=${DERP_ADDR}"
ARGS="${ARGS} -certmode=${DERP_CERT_MODE}"
ARGS="${ARGS} -certdir=${DERP_CERT_DIR}"
ARGS="${ARGS} -stun"
ARGS="${ARGS} -stun-port=${DERP_STUN_PORT}"

# 启用客户端验证（默认开启）
if [ "${VERIFY_CLIENTS}" = "true" ]; then
    ARGS="${ARGS} --verify-clients"
fi

# 可选：禁用 HTTP 调试端口（不暴露 80）
if [ "${DERP_HTTP_PORT_DISABLE}" = "true" ]; then
    ARGS="${ARGS} -http-port=-1"
fi

echo "Starting derper with args: ${ARGS}"
exec ./derper ${ARGS}
