#!/bin/sh

# build.sh
# dXml
#
# Created by Derek Clarkson on 27/08/10.
# Copyright 2010 Derek Clarkson. All rights reserved.

# Exit if an error occurs.
set -o errexit
# Disallows unset variables.
set -o nounset

SCRIPTS_DIR=../dUsefulStuff/scripts
TOOLS_DIR=../tools
EXTERNAL_DIR=../External

PRODUCT_NAME=dXml
PROJECT_NAME=$PRODUCT_NAME
CURRENT_PROJECT_VERSION=${CURRENT_PROJECT_VERSION=0.1.4}
SRC=src/code

BUILD_TARGET="Build Library"

SIMULATOR_SDK=iphonesimulator3.2
SIMULATOR_ARCHS=i386
SIMULATOR_VALID_ARCHS=i386
DEVICE_SDK=iphoneos3.2
DEVICE_ARCHS="armv6 armv7"
DEVICE_VALID_ARCHS="armv6 armv7"

PROJECT_DIR=${PROJECT_DIR=.}
BUILD_DIR=${BUILD_DIR=build}

ARTIFACT_DIR=Releases/v$CURRENT_PROJECT_VERSION
DMG_FILE=Releases/$PRODUCT_NAME-$CURRENT_PROJECT_VERSION.dmg

export SCRIPTS_DIR TOOLS_DIR EXTERNAL_DIR SIMULATOR_SDK SIMULATOR_ARCHS SIMULATOR_VALID_ARCHS DEVICE_SDK DEVICE_ARCHS DEVICE_VALID_ARCHS PROJECT_NAME PRODUCT_NAME BUILD_DIR PROJECT_DIR CURRENT_PROJECT_VERSION BUILD_TARGET ARTIFACT_DIR DMG_FILE SRC

$SCRIPTS_DIR/clean.sh
$SCRIPTS_DIR/buildStaticLibrary.sh
$SCRIPTS_DIR/createDocumentation.sh
$SCRIPTS_DIR/assembleFramework.sh
$SCRIPTS_DIR/createDmg.sh

echo "Finished."


