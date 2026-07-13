# library-prefix = smoke_archive
#
# Smoke archive suite-level shared library
# Uses flag-file + reference counting to ensure the category's
# dependency packages are verified only ONCE across all test cases.
# Most smoke dependencies (tar gzip xz) are always present on the system;
# this lib verifies their existence rather than installing.
#
# Usage in each test file:
#. "$(dirname "$0")/../lib.sh" # from test_smoke_xxx/ subdirectories

SMOKE_ARCHIVE_FLAG="/tmp/.beakerlib_smoke_archive_suite"

smokeArchiveSetup() {
 if [ ! -f "$SMOKE_ARCHIVE_FLAG" ]; then
 echo "installed=0" > "$SMOKE_ARCHIVE_FLAG"
 echo "ref=1" >> "$SMOKE_ARCHIVE_FLAG"
 rlLogInfo "smoke-archive: coreDependenciesalreadyconfirmavailable"
 else
 local ref
 ref=$(grep "^ref=" "$SMOKE_ARCHIVE_FLAG" | cut -d= -f2)
 ref=$((ref + 1))
 sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_ARCHIVE_FLAG"
 rlLogInfo "smoke-archive already initialized by other tests，reference count: $ref"
 fi
 rlCleanupAppend "smokeArchiveCleanup"
}

smokeArchiveCleanup() {
 if [ ! -f "$SMOKE_ARCHIVE_FLAG" ]; then
 return 0
 fi
 local ref
 ref=$(grep "^ref=" "$SMOKE_ARCHIVE_FLAG" | cut -d= -f2)
 ref=$((ref - 1))
 if [ "$ref" -le 0 ]; then
 rm -f "$SMOKE_ARCHIVE_FLAG"
 rlLogInfo "smoke-archive: Cleanup complete（posttest）"
 else
 sed -i "s/^ref=.*/ref=$ref/" "$SMOKE_ARCHIVE_FLAG"
 rlLogInfo "smoke-archive: Retain（still have $ref test(s) not completed）"
 fi
}
