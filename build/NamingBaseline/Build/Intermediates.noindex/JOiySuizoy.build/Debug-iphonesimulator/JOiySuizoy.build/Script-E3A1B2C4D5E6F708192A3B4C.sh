#!/bin/sh
set -e
SOURCE="${SRCROOT}/../room-shell-h5/dist"
FALLBACK="${SRCROOT}/JOiySuizoy/RoomShellH5"
DEST="${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/RoomShellH5"
if [ -d "$SOURCE" ]; then
  ditto "$SOURCE" "$DEST"
elif [ -d "$FALLBACK" ]; then
  ditto "$FALLBACK" "$DEST"
else
  echo "error: Room Shell H5 dist missing. Build room-shell-h5 or keep JOiySuizoy/RoomShellH5." >&2
  exit 1
fi

