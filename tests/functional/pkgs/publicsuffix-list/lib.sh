# library-prefix = publicsuffix_list
#
# publicsuffix-list suite-level shared library
# Uses flag-file + reference counting to ensure the package
# is installed only ONCE and uninstalled only ONCE across all
# test cases.

PKG_FLAG="/tmp/.beakerlib_publicsuffix_list_suite"

publicsuffixListSetup() {
 if [ ! -f "$PKG_FLAG" ]; then
 if ! rpm -q publicsuffix-list 2>/dev/null; then
 echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf install -y publicsuffix-list 2>/dev/null
 echo "installed=1" > "$PKG_FLAG"
 rlLogInfo "already publicsuffix-list soft ()"
 else
 echo "installed=0" > "$PKG_FLAG"
 rlLogInfo "publicsuffix-list softalready exists"
 fi
 echo "ref=1" >> "$PKG_FLAG"
 else
 local ref
 ref=$(grep "^ref=" "$PKG_FLAG" | cut -d= -f2)
 ref=$((ref + 1))
 sed -i "s/^ref=.*/ref=$ref/" "$PKG_FLAG"
 rlLogInfo "publicsuffix-list alreadybyothertest, reference count: $ref"
 fi
 rlCleanupAppend "publicsuffixListCleanup"
}

publicsuffixListCleanup() {
 if [ ! -f "$PKG_FLAG" ]; then
 return 0
 fi
 local ref
 ref=$(grep "^ref=" "$PKG_FLAG" | cut -d= -f2)
 ref=$((ref - 1))
 if [ "$ref" -le 0 ]; then
 if grep -q "^installed=1" "$PKG_FLAG"; then
 echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf remove -y publicsuffix-list 2>/dev/null || true
 rlLogInfo "already publicsuffix-list soft (posttest)"
 fi
 rm -f "$PKG_FLAG"
 else
 sed -i "s/^ref=.*/ref=$ref/" "$PKG_FLAG"
 rlLogInfo "publicsuffix-list Retain (still have $ref test(s) not completed)"
 fi
}
