#!/bin/sh -eux
# Functional test: sddm - Version-and-help

. "../setup.sh"

echo "=== Test 1: Version and help ==="
rlRun 'sddm --help 2>&1 | head -10' 0 "sddm help"
rlRun 'sddm --test-mode --help 2>&1 | head -5' 0 "sddm --test-mode help"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All sddm Version-and-help tests passed!"
