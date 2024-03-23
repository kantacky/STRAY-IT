#!/bin/sh

export REPOSITORY_DIR="/Volumes/workspace/repository"
export STRAYIT_PACKAGE_RESOURCES_DIR="$REPOSITORY_DIR/STRAYITPackage/Sources/STRAYITPackage/Resources"

mkdir $STRAYIT_PACKAGE_RESOURCES_DIR
echo $GOOGLE_SERVICE_INFO > $STRAYIT_PACKAGE_RESOURCES_DIR/GoogleService-Info.plist
