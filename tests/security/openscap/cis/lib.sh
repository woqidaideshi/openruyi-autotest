# library-prefix = openscap_cis
#
# OpenSCAP CIS Benchmark suite-level shared library
# Each test case is fully independent: runs its own oscap command,
# checks its own results aspect.
# Uses flag-file + reference counting for suite-level setup/cleanup.
#
# Usage in each test file:
#   . "$(dirname "$0")/../../lib.sh"    # from test_openscap_cis_*/ subdirectories

CIS_DS="/usr/share/xml/scap/ssg/content/ssg-openruyi-ds.xml"
CIS_PROFILE="xccdf_org.ssgproject.content_profile_standard"
CIS_FLAG="/tmp/.beakerlib_openscap_cis_suite"

cisSetup() {
    if [ ! -f "$CIS_FLAG" ]; then
        if [ ! -f "$CIS_DS" ]; then
            echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf install -y scap-security-guide 2>/dev/null
            if [ ! -f "$CIS_DS" ]; then
                rlLogWarning "scap-security-guide 安装失败"
                echo "installed=0" > "$CIS_FLAG"
            else
                echo "installed=1" > "$CIS_FLAG"
                rlLogInfo "已安装 scap-security-guide"
            fi
        else
            echo "installed=0" > "$CIS_FLAG"
            rlLogInfo "scap-security-guide 已存在"
        fi
        echo "ref=1" >> "$CIS_FLAG"
    else
        local ref
        ref=$(grep "^ref=" "$CIS_FLAG" | cut -d= -f2)
        ref=$((ref + 1))
        sed -i "s/^ref=.*/ref=$ref/" "$CIS_FLAG"
        rlLogInfo "CIS 引用计数: $ref"
    fi
    rlCleanupAppend "cisCleanup"
}

cisCleanup() {
    if [ ! -f "$CIS_FLAG" ]; then return 0; fi
    local ref
    ref=$(grep "^ref=" "$CIS_FLAG" | cut -d= -f2)
    ref=$((ref - 1))
    if [ "$ref" -le 0 ]; then
        rm -f "$CIS_FLAG"
        rlLogInfo "CIS 测试套清理完成"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$CIS_FLAG"
        rlLogInfo "CIS 保留（还有 $ref 个测试）"
    fi
}