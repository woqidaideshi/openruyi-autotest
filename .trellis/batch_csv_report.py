"""Run all 447 test cases and generate CSV report."""
import paramiko, os, time, csv

SERVER = '10.20.237.192'; PORT = 12055; USER = 'openruyi'; PASS = 'openruyi'
BASE = 'e:/code/openruyi-autotest/tests/functional'

# Discover all test cases
cases = []
for pkg in sorted(os.listdir(BASE)):
    pkg_path = os.path.join(BASE, pkg)
    if not os.path.isdir(pkg_path): continue
    for case in sorted(os.listdir(pkg_path)):
        case_path = os.path.join(pkg_path, case)
        if not os.path.isdir(case_path) or not case.startswith('test_'): continue
        test_file = os.path.join(case_path, 'test.sh')
        if os.path.isfile(test_file):
            cases.append((pkg, case, test_file))

print(f'Found {len(cases)} test cases')

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(SERVER, port=PORT, username=USER, password=PASS, timeout=15)

# Upload all test scripts
print('Uploading...')
remote_dir = '/home/openruyi/test_cases'
ssh.exec_command(f'mkdir -p {remote_dir}; rm -rf {remote_dir}/*')
for pkg, case, local_path in cases:
    with open(local_path, 'r', encoding='utf-8') as f:
        content = f.read().replace('\r\n', '\n')
    sftp = ssh.open_sftp()
    remote_file = f'{remote_dir}/{case}.sh'
    with sftp.open(remote_file, 'w') as rf:
        rf.write(content)
    sftp.chmod(remote_file, 0o755)
    sftp.close()
print(f'Uploaded {len(cases)} scripts')

# Run in batches
batch_size = 10
results = []

for i in range(0, len(cases), batch_size):
    batch = cases[i:i+batch_size]
    batch_num = i // batch_size + 1
    total_batches = (len(cases) + batch_size - 1) // batch_size
    
    # Start batch
    for pkg, case, _ in batch:
        ssh.exec_command(
            f'nohup timeout 60 bash {remote_dir}/{case}.sh > {remote_dir}/{case}.log 2>&1 &'
        )
    
    time.sleep(45)  # wait for completion
    
    # Check results
    for pkg, case, _ in batch:
        stdin, stdout, stderr = ssh.exec_command(
            f'tail -3 {remote_dir}/{case}.log 2>/dev/null'
        )
        last_lines = stdout.read().decode()
        passed = 'tests passed' in last_lines.lower()
        result = 'PASS' if passed else 'FAIL'
        results.append((pkg, case, result))
    
    passed_in_batch = sum(1 for r in results[-len(batch):] if r[2] == 'PASS')
    print(f'  Batch {batch_num}/{total_batches}: {passed_in_batch}/{len(batch)} passed')

ssh.close()

# Write CSV
csv_path = 'docs/test_report.csv'
with open(csv_path, 'w', newline='', encoding='utf-8-sig') as f:
    writer = csv.writer(f)
    writer.writerow(['测试套', '测试用例', '测试结果'])
    for pkg, case, result in results:
        writer.writerow([pkg, case, result])

total_pass = sum(1 for r in results if r[2] == 'PASS')
print(f'\nReport: {csv_path}')
print(f'Total: {total_pass}/{len(results)} passed')
