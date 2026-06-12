"""Upload tests as tarball, run all, generate CSV report."""
import paramiko, os, time, csv, tarfile, io

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

# Create tarball in memory
print('Creating tarball...')
buf = io.BytesIO()
with tarfile.open(fileobj=buf, mode='w:gz') as tar:
    for pkg, case, local_path in cases:
        with open(local_path, 'r', encoding='utf-8') as f:
            content = f.read().replace('\r\n', '\n').encode('utf-8')
        info = tarfile.TarInfo(name=f'{case}.sh')
        info.size = len(content)
        info.mode = 0o755
        tar.addfile(info, io.BytesIO(content))

# Upload tarball
print('Uploading tarball...')
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(SERVER, port=PORT, username=USER, password=PASS, timeout=15)
sftp = ssh.open_sftp()
sftp.putfo(io.BytesIO(buf.getvalue()), '/home/openruyi/all_tests.tar.gz')
sftp.close()

# Extract on server
print('Extracting on server...')
ssh.exec_command('rm -rf /home/openruyi/test_cases; mkdir -p /home/openruyi/test_cases; cd /home/openruyi/test_cases && tar xzf ../all_tests.tar.gz')

# Run all in parallel batches
print('Running tests...')
results = []
batch_size = 20
for i in range(0, len(cases), batch_size):
    batch = cases[i:i+batch_size]
    n = i // batch_size + 1
    total = (len(cases) + batch_size - 1) // batch_size
    
    for _, case, _ in batch:
        ssh.exec_command(f'nohup timeout 60 bash /home/openruyi/test_cases/{case}.sh > /home/openruyi/test_cases/{case}.log 2>&1 &')
    
    time.sleep(30)
    
    for pkg, case, _ in batch:
        stdin, stdout, stderr = ssh.exec_command(f'tail -3 /home/openruyi/test_cases/{case}.log 2>/dev/null')
        passed = 'tests passed' in stdout.read().decode().lower()
        results.append((pkg, case, 'PASS' if passed else 'FAIL'))
    
    pcount = sum(1 for r in results[-len(batch):] if r[2] == 'PASS')
    print(f'  Batch {n}/{total}: {pcount}/{len(batch)}')

# Write CSV
csv_path = 'docs/test_report.csv'
with open(csv_path, 'w', newline='', encoding='utf-8-sig') as f:
    writer = csv.writer(f)
    writer.writerow(['测试套', '测试用例', '测试结果'])
    for row in results:
        writer.writerow(row)

total_pass = sum(1 for r in results if r[2] == 'PASS')
print(f'\nReport: {csv_path}')
print(f'Total: {total_pass}/{len(results)} passed')
ssh.close()
