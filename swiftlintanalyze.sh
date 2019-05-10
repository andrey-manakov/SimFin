#!/bin/bash
rm xcodebuild.log
rm analyze_result.html
xcodebuild  > xcodebuild.log
swiftlint analyze --compiler-log-path xcodebuild.log > analyze_result.html