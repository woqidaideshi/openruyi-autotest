# library-prefix = smoke_disk_fs
#
# Smoke disk_fs suite-level shared library
# Uses flag-file + reference counting to ensure the category's
# dependency packages are verified only ONCE across all test cases.
# Most smoke dependencies (util-linux) are always present on the system;
# this lib verifies their existence rather than installing.
#
# Usage in each test file:
#. "$(dirname "$0")/../lib.sh" # from test_smoke_xxx/ subdirectories

SMOKE_DISK_FS_FLAG="/tmp/.beakerlib_smoke_disk_fs_suite"

smokeDiskFsSetup() {
 if [ ! -f "$SMOKE_DISK_FS_FLAG" ]; then
 echo "installed=0" > "$SMOKE_DISK_FS_FLAG"
 echo "ref=1" >> "$SMOKE_DISK_FS_FLAG"
 rlLogInfo "smoke-disk_fs: coreDependenciesalreadyconfirmavailable"
 else
 local ref
 ref=$(grep "^ref=" "$SMOKE_DISK_FS_FLAG" | cut -d= -f2)
 ref=$((ref + 1))
 sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_DISK_FS_FLAG"
 rlLogInfo "smoke-disk_fs already initialized by other tests，reference count: $ref"
 fi
 rlCleanupAppend "smokeDiskFsCleanup"
}

smokeDiskFsCleanup() {
 if [ ! -f "$SMOKE_DISK_FS_FLAG" ]; then
 return 0
 fi
 local ref
 ref=$(grep "^ref=" "$SMOKE_DISK_FS_FLAG" | cut -d= -f2)
 ref=$((ref - 1))
 if [ "$ref" -le 0 ]; then
 rm -f "$SMOKE_DISK_FS_FLAG"
 rlLogInfo "smoke-disk_fs: Cleanup complete（posttest）"
 else
 sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_DISK_FS_FLAG"
 rlLogInfo "smoke-disk_fs: Retain（still have $ref test(s) not completed）"
 fi
}
