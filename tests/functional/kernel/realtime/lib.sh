# library-prefix = realtime
#
# Kernel Realtime suite-level shared library
# Reuses LTP installation from functional/ltp/lib.sh
# Uses flag-file + reference counting for suite-level setup/cleanup.
#
# Usage in each test file:
#. "$(dirname "$0")/../lib.sh" # from test_realtime_*/ subdirectories

# Reuse LTP setup/cleanup from functional/ltp suite
. "$(dirname "${BASH_SOURCE[0]}")/../../ltp/lib.sh"

REALTIME_FLAG="/tmp/.beakerlib_realtime_suite"

# Run a single LTP Realtime functional test via run.sh
# Pass / Fail / Skip are mapped to tmt result states.
#
# Result determination (in order):
# 1. Timeout (rc=137) → FAIL
# 2. Non-zero exit code → FAIL
# 3. "Result: FAIL" in output → FAIL
# 4. Build errors (make: ***, Permission denied for ld/compiler) → FAIL
# 5. "test appears to have completed" in output → PASS
# 6. Otherwise → FAIL (unknown result)
#
# Usage: _realtimeRunCase <func_name>
_realtimeRunCase() {
 local func="$1"
 local out="/tmp/realtime_out_$$"

 if [ ! -x "$LTP_INSTALL_DIR/testcases/realtime/run.sh" ]; then
 rlFail "LTP Realtime runner not found ($LTP_INSTALL_DIR/testcases/realtime/run.sh)"
 return 1
 fi

 cd "$LTP_INSTALL_DIR" 2>/dev/null || true
 timeout --signal=KILL --kill-after=10 600 \
./testcases/realtime/run.sh -t "func/$func" 2>&1 | tee "$out"
 local rc=${PIPESTATUS[0]}

 # 1. Timeout
 if [ "$rc" -eq 137 ]; then
 rlFail "LTP Realtime $func Executetimeout (by kill)"
 rm -f "$out"
 return 1
 fi

 # 2. Non-zero exit code
 if [ "$rc" -ne 0 ]; then
 rlFail "LTP Realtime $func Execution failed (exit=$rc)"
 rm -f "$out"
 return 1
 fi

 # 3. Explicit failure marker from LTP
 if grep -q "Result: FAIL" "$out"; then
 rlFail "LTP Realtime $func test failed (Result: FAIL)"
 rm -f "$out"
 return 1
 fi

 # 4. Build errors -- test couldn't compile, results are invalid
 if grep -qE 'make: \*\*\*|cannot open output file.*Permission denied' "$out"; then
 rlFail "LTP Realtime $func Compile failed (permissionnoorbuilderror)"
 rm -f "$out"
 return 1
 fi

 # 5. Explicit success marker from LTP
 if grep -q "test appears to have completed" "$out"; then
 rlPass "LTP Realtime $func testpassed"
 rm -f "$out"
 return 0
 fi

 # 6. Unknown result -- not safe to assume pass
 rlFail "LTP Realtime $func resultnot (missing pass/fail)"
 rm -f "$out"
 return 1
}

realtimeSetup() {
 # Reuse LTP setup from functional/ltp suite
 ltpSetup

 if [ ! -f "$REALTIME_FLAG" ]; then
 echo "ref=1" > "$REALTIME_FLAG"
 else
 local ref
 ref=$(grep "^ref=" "$REALTIME_FLAG" | cut -d= -f2)
 ref=$((ref + 1))
 sed -i "s/^ref=.*/ref=$ref/" "$REALTIME_FLAG"
 fi

 rlCleanupAppend "realtimeCleanup"
}

realtimeCleanup() {
 if [ ! -f "$REALTIME_FLAG" ]; then return 0; fi
 local ref
 ref=$(grep "^ref=" "$REALTIME_FLAG" | cut -d= -f2)
 ref=$((ref - 1))
 if [ "$ref" -le 0 ]; then
 rm -f "$REALTIME_FLAG"
 rlLogInfo "Realtime testCleanup complete"
 else
 sed -i "s/^ref=.*/ref=$ref/" "$REALTIME_FLAG"
 rlLogInfo "Realtime Retain (still have $ref test(s) not completed)"
 fi
}
