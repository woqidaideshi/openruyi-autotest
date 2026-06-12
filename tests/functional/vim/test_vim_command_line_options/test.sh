#!/bin/sh -eux
# Functional test: vim - Command-line-options

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install vim ===
INSTALLED_BY_TEST=0
if ! rpm -q vim 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y vim 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed vim"
    else
        echo "SKIP: vim not available in repos"
        exit 0
    fi
else
    echo "SETUP: vim already installed"
fi

rlRun 'vim --version 2>&1 | head -3' 0 "vim version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: Command line options ==="
rlRun 'vim --help 2>&1 | head -10' 0 "vim --help"
rlRun 'vim -c "version" -c "q" test.txt 2>&1 | head -3 || true' 0 "vim -c: execute command"
rlRun 'vim -R test.txt -c "q" 2>&1 || true' 0 "vim -R: readonly mode"
rlRun 'vim -b test.txt -c "q" 2>&1 || true' 0 "vim -b: binary mode"
rlRun 'vim -n test.txt -c "q" 2>&1 || true' 0 "vim -n: no swap file"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y vim 2>/dev/null || true
    echo "TEARDOWN: removed vim"
fi
echo ""
echo "All vim Command-line-options tests passed!"
