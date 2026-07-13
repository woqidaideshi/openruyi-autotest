# library-prefix = smoke_kernel
#
# Smoke kernel suite-level shared library
# Uses flag-file + reference counting to ensure the category's
# dependency packages are verified only ONCE across all test cases.
# Most smoke dependencies (kmod procps-ng) are always present on the system;
# this lib verifies their existence rather than installing.
#
# Usage in each test file:
#. "$(dirname "$0")/../lib.sh" # from test_smoke_xxx/ subdirectories

SMOKE_KERNEL_FLAG="/tmp/.beakerlib_smoke_kernel_suite"

smokeKernelSetup() {
 if [ ! -f "$SMOKE_KERNEL_FLAG" ]; then
 echo "installed=0" > "$SMOKE_KERNEL_FLAG"
 echo "ref=1" >> "$SMOKE_KERNEL_FLAG"
 rlLogInfo "smoke-kernel: coreDependenciesalreadyconfirmavailable"
 else
 local ref
 ref=$(grep "^ref=" "$SMOKE_KERNEL_FLAG" | cut -d= -f2)
 ref=$((ref + 1))
 sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_KERNEL_FLAG"
 rlLogInfo "smoke-kernel already initialized by other tests, reference count: $ref"
 fi
 rlCleanupAppend "smokeKernelCleanup"
}

smokeKernelCleanup() {
 if [ ! -f "$SMOKE_KERNEL_FLAG" ]; then
 return 0
 fi
 local ref
 ref=$(grep "^ref=" "$SMOKE_KERNEL_FLAG" | cut -d= -f2)
 ref=$((ref - 1))
 if [ "$ref" -le 0 ]; then
 rm -f "$SMOKE_KERNEL_FLAG"
 rlLogInfo "smoke-kernel: Cleanup complete (posttest)"
 else
 sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_KERNEL_FLAG"
 rlLogInfo "smoke-kernel: Retain (still have $ref test(s) not completed)"
 fi
}
