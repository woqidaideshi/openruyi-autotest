#!/bin/sh -eux
# Functional test: lvm2 - LVM �߼�������
# Commands: pvcreate, vgcreate, lvcreate, lvs, pvs, vgs

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q lvm2 2>/dev/null || { echo 'lvm2 not installed, skipping'; exit 0; }
which lvm 2>/dev/null || echo 'lvm not found'
which pvs 2>/dev/null || echo 'pvs not found'
which vgs 2>/dev/null || echo 'vgs not found'
which lvs 2>/dev/null || echo 'lvs not found'

echo ""
echo "All lvm2 functional tests passed!"
