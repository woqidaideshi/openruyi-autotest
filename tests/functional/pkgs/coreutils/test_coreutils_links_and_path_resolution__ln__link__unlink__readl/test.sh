#!/bin/bash
# Functional test: coreutils - Links-and-path-resolution--ln--link--unlink--readl
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    coreutilsSetup
    TmpDir=$(mktemp -d)
    rlRun "cd $TmpDir" 0 "Enter temporary test directory"
    rlPhaseEnd

    rlPhaseStartTest "Links-and-path-resolution--ln--link--unlink--readl"
    rlRun "echo \"link content\" > link_src.txt" 0 "Create link source"
    rlRun "ln link_src.txt link_hard.txt" 0 "ln create hard link"
    rlRun "test link_src.txt -ef link_hard.txt" 0 "ln: hard link same inode"
    rlRun "ln -s link_src.txt link_soft.txt" 0 "ln -s symbolic link"
    rlRun "test -L link_soft.txt" 0 "ln -s: symlink exists"
    rlRun "cat link_soft.txt" 0 "ln -s: read through symlink"
    rlRun "ln -sf link_src.txt link_soft.txt" 0 "ln -sf force recreate symlink"
    rlRun "link link_src.txt link_via_link.txt" 0 "link create hard link"
    rlRun "test link_src.txt -ef link_via_link.txt" 0 "link: same inode"
    rlRun "unlink link_via_link.txt" 0 "unlink remove hard link"
    rlRun "test ! -f link_via_link.txt" 0 "unlink: file removed"
    rlRun "readlink link_soft.txt" 0 "readlink show symlink target"
    rlRun "test \"$(readlink link_soft.txt)\" = \"link_src.txt\"" 0 "readlink: correct target"
    rlRun "readlink -f link_soft.txt" 0 "readlink -f canonicalize"
    rlRun "realpath link_soft.txt" 0 "realpath canonical path"
    rlPhaseEnd


    rlPhaseStartCleanup "Clean up test environment"
    rlRun "cd /" 0 "Leave test directory"
    if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
    rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
    fi
    # coreutils Package managed by lib.sh 's reference counting auto-uninstall
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
