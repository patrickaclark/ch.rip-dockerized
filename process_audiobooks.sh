#!/usr/bin/env bash

IMPORT_DIR="./Import"
OUTPUT_DIR="./Output"
PROCESSED_DIR="./Done"

mkdir -p "$OUTPUT_DIR"
mkdir -p "$PROCESSED_DIR"

for item in "$IMPORT_DIR"/*/; do
    [ -d "$item" ] || continue

    echo "Processing: $item"

    if node repack.js "$item" "$OUTPUT_DIR"; then
        echo "SUCCESS: $item"
        mv "$item" "$PROCESSED_DIR/"
    else
        echo "FAILED: $item"
    fi
done