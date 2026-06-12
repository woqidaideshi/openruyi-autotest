#!/bin/sh -eux
# Functional test: vim - Search-and-replace--ex-mode

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

echo "=== Test 6: Search and replace (ex mode) ==="
echo "foo bar baz" > search.txt
rlRun 'vim -e -s search.txt -c "%s/bar/XXX/g" -c "wq" 2>&1 || true' 0 "vim: search and replace"
rlRun 'grep -q XXX search.txt' 0 "Replace verified"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y vim 2>/dev/null || true
    echo "TEARDOWN: removed vim"
fi
echo ""
echo "All vim Search-and-replace--ex-mode tests passed!"
