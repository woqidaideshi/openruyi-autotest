#!/bin/sh -eux
# Functional test: coreutils - Numbers-and-expressions--seq--factor--shuf--numfmt

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

echo "=== Test 21: Numbers and expressions (seq, factor, shuf, numfmt, expr) ==="

# 21.1 seq
rlRun 'seq 1 5' 0 "seq generate sequence"
rlRun 'test $(seq 1 5 | wc -l) -eq 5' 0 "seq: 5 numbers"
rlRun 'seq -s, 1 3' 0 "seq -s custom separator"

# 21.2 factor
rlRun 'factor 42' 0 "factor prime factorization"
rlRun 'factor 97' 0 "factor prime number"

# 21.3 shuf
rlRun 'echo -e "a\nb\nc\nd\ne" | shuf' 0 "shuf randomize lines"
rlRun 'test $(echo -e "a\nb\nc\nd\ne" | shuf | wc -l) -eq 5' 0 "shuf: same line count"

# 21.4 numfmt
rlRun 'echo 1234567 | numfmt --to=si' 0 "numfmt to SI units"
rlRun 'echo 1M | numfmt --from=si' 0 "numfmt from SI units"
rlRun 'echo 1048576 | numfmt --to=iec' 0 "numfmt to IEC units"

# 21.5 expr
rlRun 'expr 1 + 1' 0 "expr basic arithmetic"
rlRun 'test $(expr 3 \* 4) -eq 12' 0 "expr multiplication"
rlRun 'expr length "hello"' 0 "expr string length"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y coreutils 2>/dev/null || true
    echo "TEARDOWN: removed coreutils"
fi
echo ""
echo "All coreutils Numbers-and-expressions--seq--factor--shuf--numfmt tests passed!"
