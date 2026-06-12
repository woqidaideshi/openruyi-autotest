#!/bin/sh -eux
# Functional test: make - Basic-Makefile-execution

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install make ===
INSTALLED_BY_TEST=0
if ! rpm -q make 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y make 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed make"
    else
        echo "SKIP: make not available in repos"
        exit 0
    fi
else
    echo "SETUP: make already installed"
fi

rlRun 'make --version' 0 "make version"
rlRun 'gmake --version' 0 "gmake version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: Basic Makefile execution ==="
cat > Makefile << 'EOF'
.PHONY: all hello clean
all: hello
hello:
	@echo "Hello Make"
clean:
	rm -f hello
EOF
rlRun 'make' 0 "Run default target"
rlRun 'make hello' 0 "Run specific target"
rlRun 'make clean' 0 "Run clean target"
rlRun 'make -s' 0 "make -s: silent mode"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y make 2>/dev/null || true
    echo "TEARDOWN: removed make"
fi
echo ""
echo "All make Basic-Makefile-execution tests passed!"
