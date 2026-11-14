#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

PROJECT_NAME="${EDGEONE_PROJECT_NAME:-dinosaur-rabbit-overseas}"
AREA="${EDGEONE_AREA:-overseas}"
ENV="${EDGEONE_ENV:-production}"
TMP_DIR="$(mktemp -d)"
ZIP_PATH="$TMP_DIR/${PROJECT_NAME}.zip"
trap 'rm -rf "$TMP_DIR"' EXIT

# 只打包站点文件，避免把 .edgeone、截图、旧版本和部署脚本发到线上。
# 注意：直接 `edgeone makers deploy .` 会把目录名也打进 zip，线上根路径会 404；
# 这里手动打一个“index.html 就在根目录”的 zip。
zip -q -r "$ZIP_PATH" . \
  -x '.edgeone/*' \
     'screenshots/*' \
     'v1/*' \
     'deploy-overseas.sh' \
     'DEPLOY.md' \
     '.gitignore' \
     '.DS_Store' \
     '*/.DS_Store'

echo "==> Uploading $(du -h "$ZIP_PATH" | cut -f1) to EdgeOne ($PROJECT_NAME / $AREA / $ENV)"
edgeone makers deploy "$ZIP_PATH" \
  -n "$PROJECT_NAME" \
  -a "$AREA" \
  -e "$ENV" \
  --skip-ai-gateway-sync \
  --json
