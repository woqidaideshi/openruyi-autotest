#!/bin/sh -eux
# Functional test: make - Options

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

echo "=== Test 3: Options ==="
cat > Makefile << 'EOF'
.PHONY: all
all:
	@echo "target"
EOF
rlRun 'make -n' 0 "make -n: dry run"
rlRun 'make -B' 0 "make -B: always make"
rlRun 'make --just-print' 0 "make --just-print"
rlRun 'make -d 2>&1 | head -5' 0 "make -d: debug output"
rlRun 'make --debug=b 2>&1 | head -5' 0 "make --debug=b: basic debug"
rlRun 'make -q' 0 "make -q: question mode"
rlRun 'make -s' 0 "make -s: silent"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y make 2>/dev/null || true
    echo "TEARDOWN: removed make"
fi
echo ""
echo "All make Options tests passed!"
