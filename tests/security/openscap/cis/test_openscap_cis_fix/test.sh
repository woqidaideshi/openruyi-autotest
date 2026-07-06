#!/bin/bash
# Security test: openscap cis - fix script generation
# Self-contained: runs eval, generates fix script, validates syntax

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname $0)/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment Setup"
        cisSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "Enter tmp dir"
    rlPhaseEnd

    rlPhaseStartTest "CIS Fix Generation"
        if [ ! -f "$CIS_DS" ]; then
            rlFail "Data stream not found"
        else
            local out=/tmp/cis_fix_$$
            local xml=/tmp/cis_fix_xml_$$.xml
            local fix=/tmp/cis_fix_$$.sh
            oscap xccdf eval --profile "$CIS_PROFILE" --results "$xml" "$CIS_DS" 2>&1 | tee $out
            local rc=${PIPESTATUS[0]}
            if [ $rc -ne 0 ] || [ ! -f "$xml" ]; then
                rlFail "oscap eval failed (exit=$rc)"
            else
                local rid=$(grep -oP 'id="\K[^"]+' "$xml" | head -1)
                if [ -z "$rid" ]; then
                    rlFail "Cannot extract TestResult id"
                else
                    oscap xccdf generate fix --fix-type bash --result-id "$rid" --output "$fix" "$xml" 2>&1 | tee -a $out
                    if [ ${PIPESTATUS[0]} -ne 0 ]; then
                        rlFail "Fix generation failed"
                    elif [ ! -s "$fix" ]; then
                        rlPass "CIS fix: no remediation needed (system compliant)"
                    elif bash -n "$fix" 2>/dev/null; then
                        rlPass "CIS fix script generated ($(wc -l < "$fix") lines, syntax OK)"
                    else
                        rlFail "CIS fix script syntax error"
                    fi
                fi
            fi
            rm -f $out $xml $fix
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        rlRun "cd /" 0 "Leave tmp dir"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Clean tmp"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd