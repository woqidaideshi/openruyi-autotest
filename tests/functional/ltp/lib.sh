# library-prefix = ltp
#
# LTP suite-level shared library
# Uses flag-file + reference counting to ensure LTP is installed
# only ONCE across all test cases.
#
# Strategy:
# 1. Try dnf install (fast if package is in repo)
# 2. If dnf fails or kirk not found, compile from source (tag 20260529)
#
# Reference: https://github.com/linux-test-project/ltp
# Docs: https://git.openruyi.cn/woqidaideshi/docs/src/branch/main/guide/Testing-Guide/Testing-Guide.md#11-ltp
# Usage:. "$(dirname "$0")/../../lib.sh"; ltpSetup

LTP_FLAG="/tmp/.beakerlib_ltp_suite"
LTP_INSTALL_DIR="/opt/ltp"
LTP_TAG="20260529"

_ltpSetupPath() {
 export PATH="$LTP_INSTALL_DIR:$LTP_INSTALL_DIR/tools:$PATH"
 export LTPROOT="$LTP_INSTALL_DIR"
}

# Run a single LTP test case via kirk and report result to BeakerLib.
# Pass / Fail / Skip are correctly mapped to tmt result states.
# Usage: _ltpRunCase <suite> <case>
_ltpRunCase() {
 local suite="$1"
 local case="$2"
 local out="/tmp/ltp_out_$$"

 # Try kirk first (newer LTP), fall back to runltp (older LTP)
 if command -v kirk >/dev/null 2>&1; then
 kirk -f "$suite" -p "$case" 2>&1 | tee "$out"
 elif command -v runltp >/dev/null 2>&1; then
 # runltp may be a stub ("runltp was removed from LTP") in newer LTP
 if runltp 2>&1 | grep -q "runltp was removed"; then
 rlFail "LTP runner: runltp is a stub, need kirk (LTP >= 2026)"
 return 1
 fi
 runltp -f "$suite" -s "$case" -q 2>&1 | tee "$out"
 else
 rlFail "LTP runner not found (kirk or runltp)"
 return 1
 fi
 local rc=${PIPESTATUS[0]}

 if [ "$rc" -ne 0 ]; then
 rlFail "LTP withExecution failed (kirk exit=$rc)"
 rm -f "$out"
 return 1
 fi

 # All skipped, nothing actually passed — map to tmt SKIP
 if grep -qE 'Passed:[[:space:]]*0' "$out" && \
 grep -qE 'Skipped:[[:space:]]*[1-9]' "$out" && \
 grep -qE 'Failed:[[:space:]]*0' "$out" && \
 grep -qE 'Broken:[[:space:]]*0' "$out"; then
 rlTestSkip "LTP withskip（Environmentnot supported）"
 rm -f "$out"
 return 0
 fi

 # Has failures or broken — map to tmt FAIL
 if grep -qE 'Failed:[[:space:]]*[1-9]' "$out" || \
 grep -qE 'Broken:[[:space:]]*[1-9]' "$out"; then
 rlFail "LTP withexistsfailedor"
 rm -f "$out"
 return 1
 fi

 # All good (pass, possibly with some skipped)
 rlPass "LTP withpassed"
 rm -f "$out"
 return 0
}

ltpSetup() {
 if [ ! -f "$LTP_FLAG" ]; then
 local method=""
 # Check if any working LTP exists (kirk or runltp)
 if command -v kirk >/dev/null 2>&1 || command -v runltp >/dev/null 2>&1; then
 method="system"
 echo "installed=0" > "$LTP_FLAG"
 elif [ -x "$LTP_INSTALL_DIR/runltp" ] || [ -x "$LTP_INSTALL_DIR/kirk" ]; then
 _ltpSetupPath
 method="source-cached"
 echo "installed=0" > "$LTP_FLAG"
 else
 rlLogInfo " LTP（）..."
 # Try dnf first
 if echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf install -y ltp 2>/dev/null && command -v kirk >/dev/null 2>&1; then
 method="dnf"
 echo "installed=1" > "$LTP_FLAG"
 else
 # dnf failed or kirk not in PATH — compile from source
 rlLogInfo "dnf failedorno kirk，fromsource codecompile（tag: $LTP_TAG）..."
 echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf install -y git make gcc gcc-c++ autoconf automake pkgconfig \
 zlib-devel keyutils-libs-devel libtirpc-devel libmnl-devel libaio-devel \
 libcap-devel openssl-devel numactl-devel 2>/dev/null || true
 if [ ! -d "$LTP_INSTALL_DIR" ]; then
 git clone --depth 1 --branch "$LTP_TAG" https://github.com/linux-test-project/ltp.git "$LTP_INSTALL_DIR" 2>/dev/null || true
 fi
 if [ -f "$LTP_INSTALL_DIR/Makefile" ]; then
 # Fix: riscv64 glibc already defines struct sched_attr /
 # sched_setattr / sched_getattr (conflicting with lapi/sched.h).
 # Wrap the LTP fallback with #ifndef guards.
 local sched_h="$LTP_INSTALL_DIR/include/lapi/sched.h"
 if [ -f "$sched_h" ] && grep -q'struct sched_attr' "$sched_h" 2>/dev/null; then
 sed -i '/^struct sched_attr {/,/^};/s/^/\/\//' "$sched_h"
 sed -i '/^static inline int sched_setattr/,/^}/s/^/\/\//' "$sched_h"
 sed -i '/^static inline int sched_getattr/,/^}/s/^/\/\//' "$sched_h"
 fi
 cd "$LTP_INSTALL_DIR" && make autotools &&./configure --prefix="$LTP_INSTALL_DIR" --with-open-posix-testsuite && make -j$(nproc) -k || true
 # Install whatever was built (kirk + test binaries). Some
 # test binaries may be missing due to kernel header
 # incompatibilities on riscv64, but kirk works fine.
 sudo make install 2>&1 | tail -3 || true
 fi
 _ltpSetupPath
 # Check for kirk first (required for LTP >= 2026).
 # runltp may be a leftover stub from dnf, don't trust it alone.
 if command -v kirk >/dev/null 2>&1; then
 method="source"
 echo "installed=2" > "$LTP_FLAG"
 elif [ -x "$LTP_INSTALL_DIR/tools/kirk" ]; then
 # kirk was built but make install failed — install manually
 cp -a "$LTP_INSTALL_DIR/tools/kirk" "$LTP_INSTALL_DIR/" 2>/dev/null || true
 _ltpSetupPath
 if command -v kirk >/dev/null 2>&1; then
 method="source"
 echo "installed=2" > "$LTP_FLAG"
 else
 rlLogWarning "LTP source codeCompile succeededbut kirk failed，testpossibleUnable toExecute"
 method="failed"
 echo "installed=3" > "$LTP_FLAG"
 fi
 elif command -v runltp >/dev/null 2>&1; then
 # Fallback: only rely on runltp (older LTP, pre-2026)
 method="source-legacy"
 echo "installed=2" > "$LTP_FLAG"
 else
 rlLogWarning "LTP source codeCompile failed，testpossibleUnable toExecute"
 method="failed"
 echo "installed=3" > "$LTP_FLAG"
 fi
 fi
 fi
 echo "ref=1" >> "$LTP_FLAG"
 rlLogInfo "LTP: $method"
 else
 local ref
 ref=$(grep "^ref=" "$LTP_FLAG" | cut -d= -f2)
 ref=$((ref + 1))
 sed -i "s/^ref=.*/ref=$ref/" "$LTP_FLAG"
 rlLogInfo "LTP already，reference count: $ref"
 # Restore PATH if source install
 if [ -x "$LTP_INSTALL_DIR/runltp" ] || [ -x "$LTP_INSTALL_DIR/kirk" ]; then
 _ltpSetupPath
 fi
 fi

 rlCleanupAppend "ltpCleanup"
}

ltpCleanup() {
 if [ ! -f "$LTP_FLAG" ]; then return 0; fi
 local ref
 ref=$(grep "^ref=" "$LTP_FLAG" | cut -d= -f2)
 ref=$((ref - 1))
 if [ "$ref" -le 0 ]; then
 local installed
 installed=$(grep "^installed=" "$LTP_FLAG" | cut -d= -f2)
 case "$installed" in
 1) echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf remove -y ltp 2>/dev/null || true
 rlLogInfo "already LTP（dnf ）";;
 2) rm -rf "$LTP_INSTALL_DIR"
 rlLogInfo "alreadydelete LTP source codedirectory";;
 esac
 rm -f "$LTP_FLAG"
 else
 sed -i "s/^ref=.*/ref=$ref/" "$LTP_FLAG"
 rlLogInfo "LTP Retain（still have $ref test(s) not completed）"
 fi
}
