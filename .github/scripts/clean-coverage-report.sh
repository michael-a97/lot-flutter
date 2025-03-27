#!/bin/bash

coverageFiles=$(find . -name "lcov.info")

echo "# Removing generated files from coverage report..."
for coverageFile in $coverageFiles; do
  flutter pub global run remove_from_coverage:remove_from_coverage -f "$coverageFile" -r '.g.dart$'
done
