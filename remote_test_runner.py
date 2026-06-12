#!/usr/bin/env python3
"""
远程服务器批量测试编排脚本
1. 打包 tests/functional/ 目录
2. 上传到服务器
3. 在服务器上解压并执行批量测试
4. 下载结果
"""

import os
import sys
import time
import tarfile
import io
import paramiko

# 服务器配置
SERVER_HOST = "10.20.237.192"
SERVER_PORT = 12055
SERVER_USER = "openruyi"
SERVER_PASS = "openruyi"
SERVER_WORK_DIR = "/home/openruyi/autotest"

# 本地路径
LOCAL_BASE = os.path.dirname(os.path.abspath(__file__))
FUNCTIONAL_DIR = os.path.join(LOCAL_BASE, "tests", "functional")
BATCH_SCRIPT = os.path.join(LOCAL_BASE, "run_all_tests.sh")

def create_tarball():
    """打包 tests/functional 和 run_all_tests.sh"""
    print("[1/5] 创建 tar 包...")
    tar_buffer = io.BytesIO()
    with tarfile.open(fileobj=tar_buffer, mode='w:gz') as tar:
        # 添加 run_all_tests.sh
        tar.add(BATCH_SCRIPT, arcname="run_all_tests.sh")
        # 添加 tests/functional 目录（跳过 __pycache__ 等）
        for root, dirs, files in os.walk(FUNCTIONAL_DIR):
            dirs[:] = [d for d in dirs if not d.startswith('__pycache__')]
            for f in files:
                full_path = os.path.join(root, f)
                arcname = os.path.relpath(full_path, LOCAL_BASE)
                tar.add(full_path, arcname=arcname)
        # 添加 tests/main.fmf
        main_fmf = os.path.join(LOCAL_BASE, "tests", "main.fmf")
        if os.path.exists(main_fmf):
            tar.add(main_fmf, arcname="tests/main.fmf")
    
    tar_data = tar_buffer.getvalue()
    print(f"  tar 包大小: {len(tar_data) / 1024:.1f} KB")
    return tar_data

def connect_ssh():
    """建立 SSH 连接"""
    print("[2/5] 连接服务器...")
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(
        hostname=SERVER_HOST,
        port=SERVER_PORT,
        username=SERVER_USER,
        password=SERVER_PASS,
        timeout=30
    )
    print("  SSH 连接成功")
    return client

def upload_and_extract(sftp, tar_data):
    """上传 tar 包并解压"""
    print("[3/5] 上传文件到服务器...")
    
    # 创建工作目录
    try:
        sftp.mkdir(SERVER_WORK_DIR)
    except:
        pass
    
    # 上传 tar 包
    remote_tar = f"{SERVER_WORK_DIR}/test_bundle.tar.gz"
    sftp.putfo(io.BytesIO(tar_data), remote_tar)
    print(f"  已上传到 {remote_tar}")
    
    return remote_tar

def run_tests(ssh):
    """在服务器上解压并执行测试"""
    print("[4/5] 在服务器上执行测试...")
    
    commands = f"""
cd {SERVER_WORK_DIR}
# 清空旧结果
rm -rf test_results_* 2>/dev/null
# 解压
tar xzf test_bundle.tar.gz
# 设置执行权限
chmod +x run_all_tests.sh
# 后台执行（防止 SSH 断开）
nohup bash run_all_tests.sh > nohup_output.log 2>&1 &
echo "PID: $!"
"""
    
    stdin, stdout, stderr = ssh.exec_command(commands)
    output = stdout.read().decode()
    error = stderr.read().decode()
    print(f"  输出: {output.strip()}")
    if error:
        print(f"  错误: {error.strip()}")
    
    # 提取 PID
    pid = None
    for line in output.split('\n'):
        if 'PID:' in line:
            pid = line.split('PID:')[1].strip()
    
    if pid:
        print(f"  后台进程 PID: {pid}")
        return pid
    return None

def wait_and_download(ssh, sftp):
    """等待测试完成并下载结果"""
    print("[5/5] 等待测试完成...")
    
    # 轮询等待 nohup 进程结束
    max_wait = 3600  # 最多等 1 小时
    check_interval = 30
    
    for i in range(max_wait // check_interval):
        time.sleep(check_interval)
        
        stdin, stdout, stderr = ssh.exec_command(
            f"ls -d {SERVER_WORK_DIR}/test_results_* 2>/dev/null && "
            f"cat {SERVER_WORK_DIR}/test_results_*/summary.csv 2>/dev/null | tail -1"
        )
        output = stdout.read().decode().strip()
        
        # 检查 run_all_tests.sh 是否还在运行
        stdin2, stdout2, stderr2 = ssh.exec_command(
            f"pgrep -f 'run_all_tests.sh' > /dev/null && echo 'RUNNING' || echo 'DONE'"
        )
        status = stdout2.read().decode().strip()
        
        if output:
            lines = output.split('\n')
            result_dir = lines[0]
            progress = lines[-1] if len(lines) > 1 else ""
            elapsed = (i + 1) * check_interval
            print(f"  [{elapsed}s] {status} | {progress}")
        
        if status == 'DONE':
            print("  测试全部完成!")
            break
    else:
        print("  等待超时，尝试收集已有结果...")
    
    # 查找结果目录
    stdin, stdout, stderr = ssh.exec_command(
        f"ls -d {SERVER_WORK_DIR}/test_results_* 2>/dev/null | head -1"
    )
    result_dir = stdout.read().decode().strip()
    
    if not result_dir:
        print("  未找到结果目录!")
        return
    
    print(f"  结果目录: {result_dir}")
    
    # 下载 summary.csv
    local_results = os.path.join(LOCAL_BASE, "test_results_server")
    os.makedirs(local_results, exist_ok=True)
    
    try:
        sftp.get(f"{result_dir}/summary.csv", os.path.join(local_results, "summary.csv"))
        print(f"  已下载 summary.csv")
    except Exception as e:
        print(f"  下载 summary.csv 失败: {e}")
    
    # 下载 run_all.log
    try:
        sftp.get(f"{result_dir}/run_all.log", os.path.join(local_results, "run_all.log"))
        print(f"  已下载 run_all.log")
    except Exception as e:
        print(f"  下载 run_all.log 失败: {e}")
    
    # 下载所有失败测试的详细日志
    summary_path = os.path.join(local_results, "summary.csv")
    if os.path.exists(summary_path):
        with open(summary_path, 'r') as f:
            for line in f:
                parts = line.strip().split(',')
                if len(parts) >= 2 and parts[1] in ('FAIL', 'TIMEOUT'):
                    pkg = parts[0]
                    try:
                        sftp.get(
                            f"{result_dir}/result_{pkg}.log",
                            os.path.join(local_results, f"result_{pkg}.log")
                        )
                    except:
                        pass
    
    print(f"  本地结果目录: {local_results}")

def main():
    # 1. 打包
    tar_data = create_tarball()
    
    # 2. 连接
    ssh = connect_ssh()
    sftp = ssh.open_sftp()
    
    try:
        # 3. 上传
        upload_and_extract(sftp, tar_data)
        
        # 4. 执行
        pid = run_tests(ssh)
        
        # 5. 等待并下载
        wait_and_download(ssh, sftp)
        
    finally:
        sftp.close()
        ssh.close()
    
    print("\n✅ 完成! 结果已保存到 test_results_server/")

if __name__ == "__main__":
    main()
