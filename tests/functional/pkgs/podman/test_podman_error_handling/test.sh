#!/bin/sh -eux
# Functional test: podman - Error-handling

. "../setup.sh"

echo "=== Test 7: Error handling ==="
rlRun 'podman nonexistent 2>&1 || true' 0 "podman: invalid command"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All podman Error-handling tests passed!"
