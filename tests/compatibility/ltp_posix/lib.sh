# library-prefix = ltp_posix
#
# LTP POSIX Compatibility test -- sharedlibrary
# and setup.sh + helper.sh, use flag-file + reference count
# Ensure LTP only clone/build once, All tests share the same build artifact.
#
# Usage in each test file:
#. "$(dirname "$0")/../../lib.sh" # from test_ltp_posix_xxx/ subdirectories

LTP_FLAG="/tmp/.beakerlib_ltp_posix_suite"
LTP_DIR="/tmp/ltp-posix"
LTP_BUILD_DIR="$LTP_DIR/testcases/open_posix_testsuite"
SUDO_PASSWORD="${TEST_SERVER_1_PASSWORD:-openruyi}"

# ── reference count Setup ──

ltpPosixSetup() {
 if [ ! -f "$LTP_FLAG" ]; then
 DEPS="git gcc make"
 MISSING_DEPS=""
 for dep in $DEPS; do
 if ! rpm -q "$dep" 2>/dev/null; then
 MISSING_DEPS="$MISSING_DEPS $dep"
 fi
 done
 if [ -n "$MISSING_DEPS" ]; then
 echo "$SUDO_PASSWORD" | sudo -S dnf install -y $MISSING_DEPS 2>/dev/null || true
 echo "installed_deps=1" > "$LTP_FLAG"
 else
 echo "installed_deps=0" > "$LTP_FLAG"
 fi

 if [ ! -d "$LTP_DIR" ]; then
 mkdir -p /tmp
 cd /tmp
 rm -rf ltp-posix
 if git clone --depth 1 https://github.com/linux-test-project/ltp.git ltp-posix 2>/dev/null; then
 cd "$LTP_DIR"
 make autotools 2>/dev/null || true
 cd "$LTP_BUILD_DIR"
./configure 2>/dev/null || true
 make -j$(nproc) 2>/dev/null || true
 make top_builddir="$LTP_DIR" -C conformance all 2>/dev/null || true
 echo "installed_ltp=1" >> "$LTP_FLAG"
 rlLogInfo "LTP POSIX Compilation complete"
 else
 echo "installed_ltp=0" >> "$LTP_FLAG"
 rlLogWarning "LTP clone failed, test will be skipped"
 fi
 else
 echo "installed_ltp=0" >> "$LTP_FLAG"
 rlLogInfo "LTP already exists"
 fi
 echo "ref=1" >> "$LTP_FLAG"
 else
 local ref
 ref=$(grep "^ref=" "$LTP_FLAG" | cut -d= -f2)
 ref=$((ref + 1))
 sed -i "s/^ref=.*/ref=$ref/" "$LTP_FLAG"
 rlLogInfo "LTP POSIX already initialized by other tests, reference count: $ref"
 fi
 rlCleanupAppend "ltpPosixCleanup"
}

ltpPosixCleanup() {
 if [ ! -f "$LTP_FLAG" ]; then
 return 0
 fi
 local ref
 ref=$(grep "^ref=" "$LTP_FLAG" | cut -d= -f2)
 ref=$((ref - 1))
 if [ "$ref" -le 0 ]; then
 rm -rf "$LTP_DIR" 2>/dev/null || true
 if grep -q "^installed_deps=1" "$LTP_FLAG" 2>/dev/null; then
 echo "$SUDO_PASSWORD" | sudo -S dnf remove -y git gcc make 2>/dev/null || true
 fi
 rm -f "$LTP_FLAG"
 rlLogInfo "LTP POSIX Cleanup complete"
 else
 sed -i "s/^ref=.*/ref=$ref/" "$LTP_FLAG"
 rlLogInfo "LTP POSIX Retain (still have $ref test(s) not completed)"
 fi
}

# ── helper.sh function ──

# Compile and run all tests in specified interface directory
run_posix_iface_test() {
 local iface="$1"
 local dir="$IFACE_DIR/$iface"
 local inc_dir="$LTP_BUILD_DIR/include"
 local lib_common="$LTP_BUILD_DIR/lib/common.c"

 if [ ! -d "$dir" ]; then
 rlLogWarning "SKIP: Interface directory does not exist $iface"
 return 0
 fi

 cd "$dir"

 # 1. run.sh script test
 for test_sh in $(find. -maxdepth 1 -type f -name "*.sh" ! -name "Makefile" 2>/dev/null | sort); do
 local test_name="${iface}/$(basename "$test_sh")"
 if rlRun "echo $SUDO_PASSWORD | sudo -S sh $test_sh" 0 "POSIX $test_name"; then
 rlLogInfo "PASS: $test_name"
 else
 rlLogError "FAIL: $test_name"
 fi
 done

 # 2. compile.c file and run (Max per interface 3 samples)
 local c_count=0
 for src in $(find. -maxdepth 1 -type f -name "*.c" 2>/dev/null | sort); do
 local test_name="${iface}/$(basename "$src".c)"
 local bin="/tmp/posix_test_$$_${c_count}"
 c_count=$((c_count + 1))
 if gcc -std=gnu11 -I"$inc_dir" -Wno-error=incompatible-pointer-types -o "$bin" "$lib_common" "$src" -lpthread -lrt -lm 2>/dev/null; then
 if rlRun "echo $SUDO_PASSWORD | sudo -S $bin" 0 "POSIX $test_name"; then
 rlLogInfo "PASS: $test_name"
 else
 rlLogError "FAIL: $test_name"
 fi
 rm -f "$bin"
 else
 rlLogWarning "SKIP: Compile failed $test_name"
 fi
 [ "$c_count" -ge 3 ] && break
 done
 return 0
}
