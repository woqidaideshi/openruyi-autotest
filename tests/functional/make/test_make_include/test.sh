#!/bin/sh -eux
# Functional test: make - Include

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q make 2>/dev/null || { echo 'make not installed, skipping'; exit 0; }
which make 2>/dev/null || echo 'make not found'
which gmake 2>/dev/null || echo 'gmake not found'
rlRun 'make --version' 0 "make version"
rlRun 'gmake --version' 0 "gmake version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 7: Include ==="
echo 'INCLUDED_VAR = included_value' > inc.mk
cat > Makefile << 'EOF'
include inc.mk
.PHONY: all
all:
	@echo $(INCLUDED_VAR)
EOF
rlRun 'make | grep included_value' 0 "Include file"


echo ""
echo "All make Include tests passed!"
