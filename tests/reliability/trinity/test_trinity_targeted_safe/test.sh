#!/bin/bash
# Reliability: trinity - vssecurity syscall test (-c)
# Example: trinity -c splice
# testwithnowith syscall: getpid, getuid, gettimeofday, clock_gettime
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 trinitySetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary directory"
 TAINT_BEFORE=$(_trinityTaintBefore)
 chmod 777 "$TmpDir"
 rlPhaseEnd

 rlPhaseStartTest "vssecurity syscall"
 local safe_calls="getpid getuid getgid geteuid getppid gettimeofday clock_gettime nanosleep getcpu getrandom uname sysinfo"
 local tested=0

 for call in $safe_calls; do
 # check syscall whetheravailable
 if trinity -L 2>&1 | grep -qiw "$call"; then
 rlLogInfo "test syscall: $call"
 local log="$TmpDir/trinity_${call}.log"
 timeout 15 sudo -u "$TRINITY_USER" trinity -q -c "$call" -N 1000 > "$log" 2>&1
 local rc=$?
 tested=$((tested + 1))

 if [ "$rc" -eq 0 ] || [ "$rc" -eq 124 ]; then
 # checkoutputnocontains BUG
 if grep -q "BUG:" "$log" 2>/dev/null; then
 rlFail "syscall $call BUG"
 grep "BUG:" "$log" | head -5
 else
 rlPass "syscall $call: security ($([[ $rc -eq 124 ]] && echo timeout || echo done))"
 fi
 else
 rlLogWarning "syscall $call: exit code $rc"
 fi
 else
 rlLogInfo "syscall $call noavailable，skip"
 fi
 done

 rlLogInfo "sharedtest $tested security syscall"
 if [ "$tested" -gt 0 ]; then
 rlPass "vsSecurity testComplete ($tested syscalls)"
 fi
 rlPhaseEnd

 rlPhaseStartTest "tainted check"
 _trinityTaintCheck "$TAINT_BEFORE"
 rlPhaseEnd

 rlPhaseStartCleanup "Cleanup"
 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
 rlPhaseEnd
 rlJournalPrintText
rlJournalEnd
