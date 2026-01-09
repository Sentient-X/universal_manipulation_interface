#!/bin/bash
set -e

# check for uv
if ! command -v uv &> /dev/null; then
    echo "uv could not be found. Please install it first."
    echo "curl -LsSf https://astral.sh/uv/install.sh | sh"
    exit 1
fi

# check for system dependencies
echo "Checking system dependencies..."
MISSING_DEPS=()

if ! command -v ffmpeg &> /dev/null; then
    MISSING_DEPS+=("ffmpeg")
fi

if ! command -v exiftool &> /dev/null; then
    MISSING_DEPS+=("exiftool")
fi

if [ ${#MISSING_DEPS[@]} -ne 0 ]; then
    echo "Missing system dependencies: ${MISSING_DEPS[*]}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Attempting to install via homebrew..."
        brew install "${MISSING_DEPS[@]}"
    else
        echo "Please install them manually using your package manager."
        exit 1
    fi
fi

echo "System dependencies are satisfied."

# init/sync uv
echo "Syncing python dependencies with uv..."
uv sync
# Explicitly install workspace packages in editable mode
uv pip install -e packages/umi

echo "Setup complete!"
echo "To activate: source .venv/bin/activate"
echo "To install training dependencies (optional): uv sync --extra train && uv pip install -e packages/diffusion_policy"
