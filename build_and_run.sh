#!/usr/bin/env bash

BUILD_DIR=.build
RUST_LIB=$BUILD_DIR/lib.a
TARGET=./callback-demo

mkdir -p $BUILD_DIR
rustc -o $RUST_LIB lib.rs 
swiftc -o $TARGET -import-objc-header bridging-header.h main.swift wrapper.swift $RUST_LIB
$TARGET