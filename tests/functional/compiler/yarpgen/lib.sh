# library-prefix = yarpgen
#
# YARPGen suite-level shared library
# Random C/C++ program generator targeting compiler optimization bugs.
# Generates random C++ programs, compiles with g++ and clang at
# different optimization levels, compares outputs for consistency.
#
# Reference: https://github.com/intel/yarpgen
#
# Usage in each test file:
#. "$(dirname "$0")/../lib.sh" # from test_yarpgen_*/ subdirectories

YARPGEN_FLAG="/tmp/.beakerlib_compiler_yarpgen_suite"
YARPGEN_DIR="/tmp/yarpgen"

yarpgenSetup() {
 if [ ! -f "$YARPGEN_FLAG" ]; then
 # Install build dependencies
 if ! rpm -q cmake 2>/dev/null; then
 echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf install -y cmake 2>/dev/null
 fi
 if ! rpm -q gcc-c++ 2>/dev/null; then
 echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf install -y gcc-c++ 2>/dev/null
 fi
 
 # Clone and build yarpgen if not present
 if [ ! -f "$YARPGEN_DIR/build/yarpgen" ]; then
 if [ ! -d "$YARPGEN_DIR" ]; then
 git clone --depth 1 https://github.com/intel/yarpgen.git "$YARPGEN_DIR" 2>/dev/null
 fi
 if [ -d "$YARPGEN_DIR" ]; then
 mkdir -p "$YARPGEN_DIR/build"
 cd "$YARPGEN_DIR/build"
 cmake.. 2>/dev/null && make -j$(nproc) 2>/dev/null
 cd - >/dev/null
 fi
 fi
 
 if [ -f "$YARPGEN_DIR/build/yarpgen" ]; then
 echo "built=1" > "$YARPGEN_FLAG"
 rlLogInfo "YARPGen Compile succeeded: $YARPGEN_DIR/build/yarpgen"
 else
 rlLogWarning "YARPGen Compile failed"
 echo "built=0" > "$YARPGEN_FLAG"
 fi
 echo "ref=1" >> "$YARPGEN_FLAG"
 else
 local ref
 ref=$(grep "^ref=" "$YARPGEN_FLAG" | cut -d= -f2)
 ref=$((ref + 1))
 sed -i "s/^ref=.*/ref=$ref/" "$YARPGEN_FLAG"
 rlLogInfo "yarpgen reference count: $ref"
 fi
 rlCleanupAppend "yarpgenCleanup"
}

yarpgenCleanup() {
 if [ ! -f "$YARPGEN_FLAG" ]; then return 0; fi
 local ref
 ref=$(grep "^ref=" "$YARPGEN_FLAG" | cut -d= -f2)
 ref=$((ref - 1))
 if [ "$ref" -le 0 ]; then
 rm -f "$YARPGEN_FLAG"
 rlLogInfo "yarpgen testCleanup complete（Retainbuildwith）"
 else
 sed -i "s/^ref=.*/ref=$ref/" "$YARPGEN_FLAG"
 rlLogInfo "yarpgen Retain（still have $ref test）"
 fi
}
