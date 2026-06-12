#!/bin/sh -eux
# Functional test: coreutils - File-operations--dd--truncate--shred--sync--instal

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

echo "=== Test 20: File operations (dd, truncate, shred, sync, install, chroot) ==="

# 20.1 dd
rlRun 'dd if=file1.txt of=dd_out.txt 2>&1' 0 "dd copy file"

# 20.2 truncate
rlRun 'truncate -s 100 trunc_test.txt' 0 "truncate set size"
rlRun 'test $(stat -c %s trunc_test.txt) -eq 100' 0 "truncate: verify size"

# 20.3 shred
rlRun 'echo "secret data" > shred_test.txt' 0 "Create file to shred"
rlRun 'shred -n 1 -u shred_test.txt' 0 "shred remove file securely"
rlRun 'test ! -f shred_test.txt' 0 "shred: file removed"

# 20.4 sync
rlRun 'sync' 0 "sync flush filesystem buffers"

# 20.5 install
rlRun 'install -m 644 file1.txt install_dest.txt' 0 "install copy with mode"
rlRun 'test -f install_dest.txt' 0 "install: destination exists"
rlRun 'install -d install_dir' 0 "install -d create directory"
rlRun 'test -d install_dir' 0 "install -d: directory exists"

# 20.6 chroot (version check only, needs root)
rlRun 'chroot --version' 0 "chroot version check"

# 20.7 mkfifo (named pipe)
rlRun 'mkfifo mkfifo_pipe' 0 "mkfifo create named pipe"
rlRun 'test -p mkfifo_pipe' 0 "mkfifo: verify pipe created"

# 20.8 mknod (version check, needs root for device creation)
rlRun 'mknod --version' 0 "mknod version check"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y coreutils 2>/dev/null || true
    echo "TEARDOWN: removed coreutils"
fi
echo ""
echo "All coreutils File-operations--dd--truncate--shred--sync--instal tests passed!"
