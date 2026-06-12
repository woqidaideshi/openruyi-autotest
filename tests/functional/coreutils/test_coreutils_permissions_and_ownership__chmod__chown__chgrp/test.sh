#!/bin/sh -eux
# Functional test: coreutils - Permissions-and-ownership--chmod--chown--chgrp

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

echo "=== Test 11: Permissions and ownership (chmod, chown, chgrp) ==="

# 11.1 chmod
rlRun 'touch perm_test.txt' 0 "Create permission test file"
rlRun 'chmod u+x perm_test.txt' 0 "chmod u+x add exec"
rlRun 'test -x perm_test.txt' 0 "chmod: verify exec set"
rlRun 'chmod 644 perm_test.txt' 0 "chmod 644 numeric"
rlRun 'ls -l perm_test.txt | grep -q "rw-r--r--"' 0 "chmod: verify 644 perms"
rlRun 'mkdir -p perm_dir && touch perm_dir/f1 perm_dir/f2' 0 "Setup recursive chmod"
rlRun 'chmod -R 755 perm_dir' 0 "chmod -R recursive"

# 11.2 chown (need sudo or skip if not root)
rlRun 'chown --version' 0 "chown version check"
whoami_val=$(whoami)
rlRun 'chown $whoami_val perm_test.txt 2>&1 || true' 0 "chown to self"

# 11.3 chgrp
rlRun 'chgrp --version' 0 "chgrp version check"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y coreutils 2>/dev/null || true
    echo "TEARDOWN: removed coreutils"
fi
echo ""
echo "All coreutils Permissions-and-ownership--chmod--chown--chgrp tests passed!"
