#!/bin/bash

# Fast fail the script on failures.
set -e

# Run the analyze/test/build script.
dart tool/grind.dart buildbot

pub build