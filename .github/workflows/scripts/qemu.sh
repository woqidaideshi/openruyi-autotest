#!/bin/bash
# QEMU startup script for CI (background mode)
# Usage: qemu.sh <image_path> [firmware_dir]
#   Starts QEMU in background, writes PID, outputs SSH_PORT=<port>

IMAGE="${1:-openruyi-virt_riscv64.qcow2}"
FW_DIR="${2:-.}"

START_PORT=12060
PORT=$START_PORT
while ss -tln 2>/dev/null | grep -qE ":${PORT}\b" || \
      netstat -tln 2>/dev/null | grep -qE ":${PORT}\b"; do
    ((PORT++))
done

echo "SSH_PORT=$PORT"

QEMU_CMD="qemu-system-riscv64"
VM_ARGS="-nographic -machine virt,pflash0=pflash0,pflash1=pflash1 \
  -smp 8 -m 12G \
  -cpu rva23s64 \
  -blockdev node-name=pflash0,driver=file,read-only=on,filename=${FW_DIR}/RISCV_VIRT_CODE.fd \
  -blockdev node-name=pflash1,driver=file,filename=${FW_DIR}/RISCV_VIRT_VARS.fd \
  -drive file=${IMAGE},format=qcow2,id=hd0,if=none \
  -object rng-random,filename=/dev/urandom,id=rng0 \
  -device virtio-rng-device,rng=rng0 \
  -device virtio-blk-device,drive=hd0 \
  -device virtio-net-device,netdev=usernet \
  -netdev user,id=usernet,hostfwd=tcp::${PORT}-:22"

echo "Starting: $QEMU_CMD $VM_ARGS"
$QEMU_CMD $VM_ARGS &
QEMU_PID=$!
echo $QEMU_PID > /tmp/qemu.pid

# Verify QEMU process is still running
sleep 3
if ! kill -0 $QEMU_PID 2>/dev/null; then
  echo "ERROR: QEMU process died immediately"
  exit 1
fi
echo "QEMU started (PID=$QEMU_PID, port=$PORT)"
