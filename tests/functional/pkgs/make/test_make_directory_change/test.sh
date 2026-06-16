#!/bin/sh -eux
# Functional test: make - Directory-change

. "../setup.sh"

echo "=== Test 6: Directory change ==="
mkdir subdir
cat > subdir/Makefile << 'EOF'
.PHONY: all
all:
	@echo "subdir_make"
EOF
rlRun 'make -C subdir' 0 "make -C: change directory"

. "../teardown.sh"
echo "All make Directory-change tests passed!"
