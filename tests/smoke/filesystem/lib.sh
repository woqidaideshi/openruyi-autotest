# library-prefix = smoke_fs
#
# Smoke FS suite-level shared library
# Uses flag-file + reference counting to ensure the filesystem-related
# packages are checked only ONCE across all test cases.
# Core filesystem commands (cat, cp, ls, etc.) are from coreutils and
# are always present on the system; this lib verifies rather than installs.
#
# Usage in each test file:
#. "$(dirname "$0")/../lib.sh" # from test_smoke_xxx/ subdirectories

SMOKE_FS_FLAG="/tmp/.beakerlib_smoke_fs_suite"

smokeFSSetup() {
 if [ ! -f "$SMOKE_FS_FLAG" ]; then
 echo "installed=0" > "$SMOKE_FS_FLAG"
 echo "ref=1" >> "$SMOKE_FS_FLAG"
 rlLogInfo "smoke-filesystem: corecommand availabilityalreadyconfirm"
 else
 local ref
 ref=$(grep "^ref=" "$SMOKE_FS_FLAG" | cut -d= -f2)
 ref=$((ref + 1))
 sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_FS_FLAG"
 rlLogInfo "smoke-filesystem already initialized by other tests，reference count: $ref"
 fi
 rlCleanupAppend "smokeFSCleanup"
}

smokeFSCleanup() {
 if [ ! -f "$SMOKE_FS_FLAG" ]; then
 return 0
 fi
 local ref
 ref=$(grep "^ref=" "$SMOKE_FS_FLAG" | cut -d= -f2)
 ref=$((ref - 1))
 if [ "$ref" -le 0 ]; then
 rm -f "$SMOKE_FS_FLAG"
 rlLogInfo "smoke-filesystem: Cleanup complete（posttest）"
 else
 sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_FS_FLAG"
 rlLogInfo "smoke-filesystem: Retain（still have $ref test(s) not completed）"
 fi
}