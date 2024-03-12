#!/bin/bash

SDK_PATH=`xcrun --sdk iphonesimulator --show-sdk-path`
swift build -Xswiftc "-sdk" -Xswiftc "$SDK_PATH" -Xswiftc "-target" -Xswiftc "x86_64-apple-ios13.0-simulator"
