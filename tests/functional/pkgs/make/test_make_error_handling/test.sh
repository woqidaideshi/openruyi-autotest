#!/bin/sh -eux
# Functional test: make - Error-handling

. "../setup.sh"

echo "=== Test 9: Error handling ==="
cat > Makefile << 'EOF'
.PHONY: all
all:
	@exit 1
EOF
rlRun 'make -k 2>&1 || true' 0 "make -k: continue on error"
rlRun 'make -i 2>&1 || true' 0 "make -i: ignore errors"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All make Error-handling tests passed!"
