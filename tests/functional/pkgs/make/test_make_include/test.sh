#!/bin/sh -eux
# Functional test: make - Include

. "../setup.sh"

echo "=== Test 7: Include ==="
echo 'INCLUDED_VAR = included_value' > inc.mk
cat > Makefile << 'EOF'
include inc.mk
.PHONY: all
all:
	@echo $(INCLUDED_VAR)
EOF
rlRun 'make | grep included_value' 0 "Include file"

. "../teardown.sh"
echo "All make Include tests passed!"
