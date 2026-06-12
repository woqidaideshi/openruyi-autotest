#!/bin/sh -eux
# Functional test: coreutils - Path-operations--basename--dirname--pwd

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install coreutils ===
INSTALLED_BY_TEST=0
if ! rpm -q coreutils 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y coreutils 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed coreutils"
    else
        echo "SKIP: coreutils not available in repos"
        exit 0
    fi
else
    echo "SETUP: coreutils already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 10: Path operations (basename, dirname, pwd) ==="

# 10.1 basename
rlRun 'test "$(basename /usr/bin/grep)" = "grep"' 0 "basename extract filename"
rlRun 'test "$(basename /path/to/file.txt .txt)" = "file"' 0 "basename strip suffix"

# 10.2 dirname
rlRun 'test "$(dirname /usr/bin/grep)" = "/usr/bin"' 0 "dirname extract directory"
rlRun 'test "$(dirname /path/to/file.txt)" = "/path/to"' 0 "dirname path extraction"

# 10.3 pwd
rlRun 'pwd' 0 "pwd print working directory"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y coreutils 2>/dev/null || true
    echo "TEARDOWN: removed coreutils"
fi
echo ""
echo "All coreutils Path-operations--basename--dirname--pwd tests passed!"
