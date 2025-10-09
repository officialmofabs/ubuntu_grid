#!/usr/bin/env bash
set -euo pipefail

# Auto-detect host IP and mode, default to localhost for plug-and-play
ENV_FILE=".env"

# create .env if missing
if [ ! -f "$ENV_FILE" ]; then
  cat > "$ENV_FILE" <<EOF
MOSGARAGE_MODE=auto
HOST_IP=localhost
EOF
fi

# load env
export $(grep -v '^#' $ENV_FILE | xargs)

# detect primary IP if not localhost
if [ "$HOST_IP" = "localhost" ] || [ -z "$HOST_IP" ]; then
  DETECTED=$(hostname -I 2>/dev/null | awk '{print $1}' || echo "127.0.0.1")
  if [ -n "$DETECTED" ] && [ "$DETECTED" != "127.0.0.1" ]; then
    HOST_IP=$DETECTED
    # persist
    sed -i "s|HOST_IP=.*|HOST_IP=$HOST_IP|" "$ENV_FILE" || true
  fi
fi

echo "🚀 Starting MosGarage (host IP: $HOST_IP)..."

# bring up core services
docker compose -f docker-compose.yml -f docker-compose.override.yml up -d dashboard dashboard-api caddy dev-core

# handle modules passed as arguments
if [ "$#" -gt 0 ]; then
  for mod in "$@"; do
    case $mod in
      all)
        docker compose up -d sharepoint-dev powerapps-dev teams-dev functions-dev
        ;;
      sharepoint|sharepoint-dev)
        docker compose up -d sharepoint-dev
        ;;
      powerapps|powerapps-dev)
        docker compose up -d powerapps-dev
        ;;
      teams|teams-dev)
        docker compose up -d teams-dev
        ;;
      functions|functions-dev)
        docker compose up -d functions-dev
        ;;
      *)
        echo "Unknown module: $mod"
        ;;
    esac
  done
fi

echo "✅ MosGarage is ready."
echo "Access locally: https://localhost"
echo "Access on LAN: https://$HOST_IP"
