#!/bin/bash

# Functional test: compiler - jotai - Environmentandrepolibrary

# Clone jotai-benchmarks repolibrary, verify benchmark fileavailable



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



BENCH_DIR="/tmp/jotai-benchmarks/benchmarks/anghaLeaves"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    jotaiSetup

    TmpDir=$(mktemp -d)

    rlRun "cd $TmpDir" 0 "Enter temporary directory"

    rlRun "which git" 0 "git commandavailable"

    rlPhaseEnd



    rlPhaseStartTest "repository verification"

    # checkrepolibrarydirectorywhetherexists

    if [ -d "/tmp/jotai-benchmarks" ]; then

    rlPass "jotai-benchmarks directory exists"

 

    # check benchmarks subdirectory

    if [ -d "/tmp/jotai-benchmarks/benchmarks" ]; then

    rlPass "benchmarks subdirectory exists"

 

    # listexportavailable benchmark file

    rlRun "find /tmp/jotai-benchmarks/benchmarks -name '*.c' -type f | head -20" 0 "listexportbefore 20 C benchmark file"

 

    # verifyhas C file

    count=$(find /tmp/jotai-benchmarks/benchmarks -name '*.c' -type f 2>/dev/null | wc -l)

    if [ "$count" -gt 0 ]; then

    rlPass "repolibrarycontains $count C benchmark file"

    else

    rlFail "repolibrarynocontains C benchmark file"

    fi

 

    # check anghaLeaves directory

    if [ -d "$BENCH_DIR" ]; then

    angha_count=$(find "$BENCH_DIR" -name '*.c' -type f 2>/dev/null | wc -l)

    rlPass "anghaLeaves directorycontains $angha_count benchmark file"

    fi

    else

    rlFail "benchmarks subdirectorydoes not exist"

    fi

    else

    rlFail "jotai-benchmarks Clonefailed"

    fi

    rlPhaseEnd



    rlPhaseStartCleanup "Cleanup"

    rlRun "cd /" 0 "Leave temporary directory"

    [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Clean up temporary directory"

    rlPhaseEnd



    rlJournalPrintText

rlJournalEnd

