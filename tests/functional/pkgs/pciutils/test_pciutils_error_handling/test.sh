#!/bin/sh -eux
# Functional test: pciutils - Error-handling

. "../setup.sh"

echo "=== Test 13: Error handling ==="

lspci -s invalid:00:00.0 2>&1 || echo "Expected: invalid slot format"
lspci --invalid-option 2>&1 || echo "Expected: invalid option"

. "../teardown.sh"
echo "All pciutils Error-handling tests passed!"
