#!/bin/sh
set -eu
SOURCE="${SCRIPT_INPUT_FILE_0}"
DEST="${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
case "$DEST" in
  *.app) ;;
  *) echo 'error: Unexpected App resources destination.' >&2; exit 1 ;;
esac
test -f "$SOURCE" || { echo 'error: CoastalWeave.dat is missing; run npm run pack:native.' >&2; exit 1; }
# Recoverably remove only a previous generated plaintext copy from this build product.
if [ -d "$DEST/RoomShellH5" ]; then
  FALLBACK="$(mktemp -d "${TEMP_DIR}/HairwrapLegacy.XXXXXX")"
  mv "$DEST/RoomShellH5" "$FALLBACK/RoomShellH5"
fi
if [ -f "$DEST/CoastalWeave.dat" ]; then
  FALLBACK="$(mktemp -d "${TEMP_DIR}/HairwrapLegacy.XXXXXX")"
  mv "$DEST/CoastalWeave.dat" "$FALLBACK/CoastalWeave.dat"
fi
mkdir -p "$DEST/HairwrapKnotDrape"
ditto "$SOURCE" "$DEST/HairwrapKnotDrape/CoastalWeave.dat"
