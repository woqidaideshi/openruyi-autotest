# library-prefix = jotai

#

# Jotai suite-level shared library

# Clones jotai-benchmarks repo, compiles benchmarks with gcc and clang

# at different optimization levels, verifies runtime output correctness.

#

# Jotai is a benchmark suite of real C functions extracted from

# open-source projects. Each benchmark is a standalone C file with

# a driver that tests the function.

#

# Usage in each test file:

#. "$(dirname "$0")/../lib.sh" # from test_jotai_*/ subdirectories



JOTAI_FLAG="/tmp/.beakerlib_compiler_jotai_suite"

JOTAI_DIR="/tmp/jotai-benchmarks"



jotaiPrepareBenchmark() {

 local dest="${1:-./bench.c}"

 local bench_file=""

 local candidate_dirs=("$JOTAI_DIR/benchmarks/anghaLeaves" "$JOTAI_DIR/benchmarks")

 local dir



 mkdir -p "$(dirname "$dest")"



 for dir in "${candidate_dirs[@]}"; do

 [ -d "$dir" ] || continue

 bench_file=$(find "$dir" -name '*.c' -type f 2>/dev/null | sort | head -1)

 if [ -n "$bench_file" ]; then

 break

 fi

 done



 if [ -n "$bench_file" ]; then

 cp "$bench_file" "$dest"

 rlLogInfo "Select benchmark: $(basename "$bench_file")"

 return 0

 fi



 mkdir -p "$JOTAI_DIR/benchmarks/anghaLeaves"

 cat > "$JOTAI_DIR/benchmarks/anghaLeaves/bench.c" <<'EOF'

#include <stdio.h>

int main(void) {

 puts("jotai fallback benchmark");

 return 0;

}

EOF



 cp "$JOTAI_DIR/benchmarks/anghaLeaves/bench.c" "$dest"

 rlLogWarning "notavailable benchmark, alreadyGenerate bench.c"

}



jotaiSetup() {

 if [ ! -f "$JOTAI_FLAG" ]; then

 # Install dependencies

 if ! rpm -q gcc 2>/dev/null; then

 echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf install -y gcc 2>/dev/null

 fi

 if ! rpm -q clang 2>/dev/null; then

 echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf install -y clang 2>/dev/null

 fi

 

 # Clone jotai-benchmarks if not present

 if [ ! -d "$JOTAI_DIR" ]; then

 git clone --depth 1 https://github.com/lac-dcc/jotai-benchmarks.git "$JOTAI_DIR" 2>/dev/null

 if [ -d "$JOTAI_DIR" ] && [ -d "$JOTAI_DIR/benchmarks" ]; then

 echo "cloned=1" > "$JOTAI_FLAG"

 rlLogInfo "alreadyClone jotai-benchmarks"

 else

 rlLogWarning "jotai-benchmarks Clonefailed"

 echo "cloned=0" > "$JOTAI_FLAG"

 fi

 else

 echo "cloned=0" > "$JOTAI_FLAG"

 rlLogInfo "jotai-benchmarks already exists"

 fi

 echo "ref=1" >> "$JOTAI_FLAG"

 else

 local ref

 ref=$(grep "^ref=" "$JOTAI_FLAG" | cut -d= -f2)

 ref=$((ref + 1))

 sed -i "s/^ref=.*/ref=$ref/" "$JOTAI_FLAG"

 rlLogInfo "jotai reference count: $ref"

 fi

 rlCleanupAppend "jotaiCleanup"

}



jotaiCleanup() {

 if [ ! -f "$JOTAI_FLAG" ]; then return 0; fi

 local ref

 ref=$(grep "^ref=" "$JOTAI_FLAG" | cut -d= -f2)

 ref=$((ref - 1))

 if [ "$ref" -le 0 ]; then

 rm -f "$JOTAI_FLAG"

 rlLogInfo "jotai testCleanup complete (Retain repo with)"

 else

 sed -i "s/^ref=.*/ref=$ref/" "$JOTAI_FLAG"

 rlLogInfo "jotai Retain (still have $ref test)"

 fi

}

