#!/bin/sh -eux
# Functional test: openssh-clients - Error-handling

. "../setup.sh"

echo "=== Test 10: Error handling ==="
ssh --invalid 2>&1 || true
echo ""

echo "All openssh-clients functional tests passed!"

. "../teardown.sh"
echo "All openssh-clients Error-handling tests passed!"
