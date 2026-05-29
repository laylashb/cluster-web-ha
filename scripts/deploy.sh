#!/bin/bash
set -euo pipefail

CONTAINERS=("api1" "api2" "api3" "haproxy-streamflix")
NETWORK="streamflix-net"

start() {
  echo "Starting stack..."

  docker network create "$NETWORK" 2>/dev/null || true

  docker run -d --name api1 --network "$NETWORK" \
    -v "$(pwd)/../api1:/usr/share/nginx/html:ro" nginx:alpine

  docker run -d --name api2 --network "$NETWORK" \
    -v "$(pwd)/../api2:/usr/share/nginx/html:ro" nginx:alpine

  docker run -d --name api3 --network "$NETWORK" \
    -v "$(pwd)/../api3:/usr/share/nginx/html:ro" nginx:alpine

  docker run -d --name haproxy-streamflix \
    --network "$NETWORK" \
    -p 80:80 \
    -p 8404:8404 \
    -v "$(pwd)/../lb/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro" \
    haproxy:alpine

  echo "Stack started"
}

stop() {
  echo "Stopping stack..."

  for c in "${CONTAINERS[@]}"; do
    docker rm -f "$c" 2>/dev/null || true
  done

  echo "Stack stopped"
}

status() {
  echo "Container status:"
  docker ps -a --filter "name=api" --filter "name=haproxy"
}

case "${1:-}" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  status)
    status
    ;;
  *)
    echo "Usage: $0 {start|stop|status}"
    exit 1
    ;;
esac
