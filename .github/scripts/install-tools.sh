#!/bin/bash

set -e # exit on first failed command
set -x # print all executed commands to the log

flutter pub global activate very_good_cli
flutter pub global activate flutter_plugin_tools
flutter pub global activate remove_from_coverage
