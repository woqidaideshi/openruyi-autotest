#!/bin/sh -eux
# Functional test: coreutils - System-information--uname--who--whoami--id--groups

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

echo "=== Test 15: System information (uname, who, whoami, id, groups, users, hostid, nproc, tty, logname, pinky) ==="

# 15.1 uname
rlRun 'uname' 0 "uname system name"
rlRun 'uname -a' 0 "uname -a all info"
rlRun 'uname -r' 0 "uname -r kernel release"
rlRun 'uname -m' 0 "uname -m machine hardware"

# 15.2 who
rlRun 'who' 0 "who show logged in users"

# 15.3 whoami
rlRun 'whoami' 0 "whoami current user"

# 15.4 id
rlRun 'id' 0 "id user identity"
rlRun 'id -u' 0 "id -u user ID"
rlRun 'id -g' 0 "id -g group ID"

# 15.5 groups
rlRun 'groups' 0 "groups show group membership"
rlRun 'groups $(whoami)' 0 "groups for specific user"

# 15.6 users
rlRun 'users' 0 "users list logged in users"

# 15.7 hostid
rlRun 'hostid' 0 "hostid numeric host identifier"

# 15.8 nproc
rlRun 'nproc' 0 "nproc number of CPUs"
rlRun 'nproc --all' 0 "nproc --all all processors"

# 15.9 tty
rlRun 'tty' 0 "tty terminal name"

# 15.10 logname
rlRun 'logname' 0 "logname login name"

# 15.11 pinky
rlRun 'pinky' 0 "pinky user info"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y coreutils 2>/dev/null || true
    echo "TEARDOWN: removed coreutils"
fi
echo ""
echo "All coreutils System-information--uname--who--whoami--id--groups tests passed!"
