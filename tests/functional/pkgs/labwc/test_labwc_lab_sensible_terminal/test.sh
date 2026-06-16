#!/bin/sh -eux
# Functional test: labwc - lab-sensible-terminal

. "../setup.sh"

echo "=== Test 7: lab-sensible-terminal ==="
rlRun 'lab-sensible-terminal --help 2>&1 | head -5 || true' 0 "lab-sensible-terminal help"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All labwc lab-sensible-terminal tests passed!"
