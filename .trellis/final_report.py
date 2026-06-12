"""Clean upload, run all 447 tests, generate complete CSV."""
import paramiko, os, time, csv, tarfile, io

SERVER='10.20.237.192';PORT=12055;USER='openruyi';PASS='openruyi'
BASE='e:/code/openruyi-autotest/tests/functional'

# Discover all
cases=[]
for pkg in sorted(os.listdir(BASE)):
    pp=os.path.join(BASE,pkg)
    if not os.path.isdir(pp): continue
    for case in sorted(os.listdir(pp)):
        if not case.startswith('test_'): continue
        tf=os.path.join(pp,case,'test.sh')
        if os.path.isfile(tf): cases.append((pkg,case,tf))
print(f'Found {len(cases)} test cases')

# Create tarball
print('Creating tarball...')
buf=io.BytesIO()
with tarfile.open(fileobj=buf,mode='w:gz') as tar:
    for pkg,case,local in cases:
        with open(local,'r',encoding='utf-8') as f:
            data=f.read().replace('\r\n','\n').encode('utf-8')
        info=tarfile.TarInfo(name=f'{case}.sh')
        info.size=len(data); info.mode=0o755
        tar.addfile(info,io.BytesIO(data))

# Upload
print('Uploading...')
ssh=paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(SERVER,port=PORT,username=USER,password=PASS,timeout=180)
sftp=ssh.open_sftp()
sftp.putfo(io.BytesIO(buf.getvalue()),'/home/openruyi/tests.tar.gz')
sftp.close()

# Extract
print('Extracting...')
ssh.exec_command('rm -rf /home/openruyi/tc; mkdir -p /home/openruyi/tc; cd /home/openruyi/tc && tar xzf /home/openruyi/tests.tar.gz')

# Verify
stdin,stdout,sterr=ssh.exec_command('ls /home/openruyi/tc/*.sh 2>/dev/null|wc -l')
count=int(stdout.read().decode().strip())
print(f'Files on server: {count}')

# Run in batches of 30 (parallel)
print('Running tests...')
batch_size=30
results={}
for i in range(0,len(cases),batch_size):
    batch=cases[i:i+batch_size]
    n=i//batch_size+1
    total=(len(cases)+batch_size-1)//batch_size
    for _,case,_ in batch:
        ssh.exec_command(f'nohup timeout 30 bash /home/openruyi/tc/{case}.sh > /home/openruyi/tc/{case}.log 2>&1 &')
    time.sleep(25)
    for _,case,_ in batch:
        stdin,stdout,sterr=ssh.exec_command(f'tail -1 /home/openruyi/tc/{case}.log 2>/dev/null')
        passed='tests passed' in stdout.read().decode().lower()
        results[case]='PASS' if passed else 'FAIL'
    pcount=sum(1 for r in list(results.values())[-len(batch):] if r=='PASS')
    print(f'  Batch {n}/{total}: {pcount}/{len(batch)}')

# CSV
with open('docs/test_report.csv','w',newline='',encoding='utf-8-sig') as f:
    w=csv.writer(f)
    w.writerow(['测试套','测试用例','测试结果'])
    for pkg,case,_ in cases:
        w.writerow([pkg,case,results.get(case,'?')])

tp=sum(1 for v in results.values() if v=='PASS')
print(f'\nTotal: {tp}/{len(results)} passed')
ssh.close()
