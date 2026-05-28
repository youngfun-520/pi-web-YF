#!/bin/bash
# Apply patches to node_modules after npm install
# These patches fix DeepSeek thinking mode where response text
# is sent as reasoning_content instead of content

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "Applying pi patches..."

# Patch hoisted pi-ai
if [ -f "$PROJECT_DIR/node_modules/@earendil-works/pi-ai/dist/providers/openai-completions.js" ]; then
  cp "$PROJECT_DIR/patches/pi-ai/openai-completions.js" \
     "$PROJECT_DIR/node_modules/@earendil-works/pi-ai/dist/providers/openai-completions.js"
  echo "  ✅ pi-ai/openai-completions.js"
fi

# Patch nested pi-ai in pi-coding-agent
if [ -f "$PROJECT_DIR/node_modules/@earendil-works/pi-coding-agent/node_modules/@earendil-works/pi-ai/dist/providers/openai-completions.js" ]; then
  cp "$PROJECT_DIR/patches/pi-coding-agent-pi-ai/openai-completions.js" \
     "$PROJECT_DIR/node_modules/@earendil-works/pi-coding-agent/node_modules/@earendil-works/pi-ai/dist/providers/openai-completions.js"
  echo "  ✅ pi-coding-agent > pi-ai/openai-completions.js"
fi

# Patch pi-coding-agent's messages.js (timestamp injection)
if [ -f "$PROJECT_DIR/node_modules/@earendil-works/pi-coding-agent/dist/core/messages.js" ]; then
  cp "$PROJECT_DIR/patches/pi-coding-agent/messages.js" \
     "$PROJECT_DIR/node_modules/@earendil-works/pi-coding-agent/dist/core/messages.js"
  echo "  ✅ pi-coding-agent/messages.js (timestamp injection)"
fi

echo "Done!"
