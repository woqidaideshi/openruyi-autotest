# library-prefix = perf_lmbench
#
# LMbench micro-benchmark suite-level shared library
# Measures OS latency and bandwidth across CPU, memory, process, file, network.
#
# Based on Testing-Guide.md section 2.5
#
# Key metrics categories:
# - Processor: null call, signal, fork, exec, shell (usec)
# - Integer ops: bit, add, mul, div, mod (nsec)
# - Float ops: add, mul, div (nsec)
# - Context switch: 2p/8p/16p with varying data sizes (usec)
# - Communication: pipe, TCP, UDP latency (usec)
# - File/VM: create, delete, mmap latency, page fault (usec)
#
# Usage: . "$(dirname "$0")/../lib.sh"

LMBENCH_FLAG="/tmp/.beakerlib_lmbench_suite"
LMBENCH_DIR="/tmp/lmbench-3.0-a9"

lmbenchSetup() {
 if [ ! -f "$LMBENCH_FLAG" ]; then
 # Install build dependencies
 for dep in gcc make wget tar patch libtirpc-devel automake; do
 if ! rpm -q "$dep" 2>/dev/null; then
 echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf install -y "$dep" 2>/dev/null
 fi
 done

 # Download and build if not present
 if [ ! -f "$LMBENCH_DIR/Makefile" ]; then
 cd /tmp
 rm -rf lmbench-3.0-a9 2>/dev/null || true
 wget -q https://sourceforge.net/projects/lmbench/files/development/lmbench-3.0-a9/lmbench-3.0-a9.tgz 2>/dev/null
 if [ -f lmbench-3.0-a9.tgz ]; then
 tar xzf lmbench-3.0-a9.tgz 2>/dev/null
 cd "$LMBENCH_DIR"

 # Fix build errors (patch inline)
 sed -i 's/\(CFLAGS.*\)=/\1+=/' src/Makefile 2>/dev/null || true
 sed -i 's/ -Wall / /' src/Makefile 2>/dev/null || true
 sed -i 's|uint|unsigned int|g' src/lat_unix.c 2>/dev/null || true
 sed -i 's|uint|unsigned int|g' src/lat_tcp.c 2>/dev/null || true
 sed -i 's|#include <rpc/rpc.h>||' src/lm_tcp.c 2>/dev/null || true

 # Copy config.guess
 [ -f /usr/share/automake*/config.guess ] && \
 cp /usr/share/automake*/config.guess scripts/gnu-os 2>/dev/null || true

 # Create answer file for automated testing
 cat > /tmp/lmbench_answers.txt << 'ANSWERS'
1
1
512
OS
no
no
none
none
2599
/usr/tmp
/dev/tty
no
ANSWERS

 make clean 2>/dev/null
 make 2>/dev/null
 if [ -f bin/lmbench ]; then
 echo "built=1" > "$LMBENCH_FLAG"
 rlLogInfo "LMbench Compile succeeded"
 else
 echo "built=0" > "$LMBENCH_FLAG"
 rlLogWarning "LMbench Compile failed"
 fi
 cd - >/dev/null
 else
 echo "built=0" > "$LMBENCH_FLAG"
 rlLogWarning "LMbench downloadfailed"
 fi
 else
 echo "built=0" > "$LMBENCH_FLAG"
 rlLogInfo "LMbench already exists"
 fi
 echo "ref=1" >> "$LMBENCH_FLAG"
 else
 local ref
 ref=$(grep "^ref=" "$LMBENCH_FLAG" | cut -d= -f2)
 ref=$((ref + 1))
 sed -i "s/^ref=.*/ref=$ref/" "$LMBENCH_FLAG"
 fi
 rlCleanupAppend "lmbenchCleanup"
}

lmbenchCleanup() {
 if [ ! -f "$LMBENCH_FLAG" ]; then return 0; fi
 local ref
 ref=$(grep "^ref=" "$LMBENCH_FLAG" | cut -d= -f2)
 ref=$((ref - 1))
 if [ "$ref" -le 0 ]; then rm -f "$LMBENCH_FLAG"; else sed -i "s/^ref=.*/ref=$ref/" "$LMBENCH_FLAG"; fi
}

# Run LMbench with automated answers and generate results
_lmbenchRun() {
 cd "$LMBENCH_DIR"
 if [ ! -f bin/lmbench ]; then
 rlFail "LMbench notcompile"; return 1
 fi

 # Run with pre-configured answers (non-interactive)
 cat /tmp/lmbench_answers.txt | make results 2>&1

 # Generate summary
 make see 2>&1

 # Print results
 if [ -f results/summary.out ]; then
 cat results/summary.out
 fi
 return 0
}

# Parse summary.out and extract a specific section
_lmbenchParseSection() {
 local section="$1"
 local log="${2:-/tmp/lmbench_summary.txt}"
 if [ ! -f "$log" ]; then return 1; fi
 echo "=== $section ==="
 awk "/^${section}/,/^\$/" "$log" | head -20
}
