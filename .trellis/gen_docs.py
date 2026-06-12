"""Generate functional coverage doc from test scripts."""
import os, re

BASE = 'tests/functional'

# English -> Chinese translation mapping for common test descriptions
TRANS = {
    'check': '检查', 'test': '测试', 'verify': '验证', 'create': '创建',
    'remove': '删除', 'list': '列出', 'show': '显示', 'get': '获取',
    'set': '设置', 'run': '运行', 'compile': '编译', 'link': '链接',
    'generate': '生成', 'copy': '复制', 'move': '移动', 'rename': '重命名',
    'delete': '删除', 'kill': '终止', 'start': '启动', 'stop': '停止',
    'install': '安装', 'configure': '配置', 'build': '构建',
    'download': '下载', 'upload': '上传', 'pull': '拉取', 'push': '推送',
    'attach': '附加', 'detach': '分离', 'split': '分割', 'join': '合并',
    'enable': '启用', 'disable': '禁用', 'restart': '重启',
    'basic': '基本', 'advanced': '高级', 'options': '选项',
    'mode': '模式', 'error': '错误', 'help': '帮助', 'version': '版本',
    'output': '输出', 'input': '输入', 'file': '文件', 'directory': '目录',
    'package': '软件包', 'command': '命令', 'service': '服务',
    'available': '可用', 'installed': '已安装', 'exists': '存在',
    'standard': '标准', 'optimization': '优化', 'debug': '调试',
    'warning': '警告', 'preprocessor': '预处理器', 'template': '模板',
    'include': '包含', 'path': '路径', 'alias': '别名',
    'fingerprint': '指纹', 'passphrase': '密码', 'comment': '注释',
    'public key': '公钥', 'private key': '私钥', 'key generation': '密钥生成',
    'repository': '仓库', 'branch': '分支', 'commit': '提交',
    'remote': '远程', 'log': '日志', 'diff': '差异', 'status': '状态',
    'tag': '标签', 'stash': '暂存', 'blame': '追溯', 'grep': '搜索',
    'clean': '清理', 'reset': '重置', 'restore': '恢复',
    'container': '容器', 'image': '镜像', 'network': '网络',
    'volume': '卷', 'pod': 'Pod', 'manifest': '清单',
    'compose': '编排', 'health': '健康检查',
    'recursive': '递归', 'symbolic link': '符号链接',
    'inheritance': '继承', 'permission': '权限',
    'session': '会话', 'window': '窗口', 'pane': '窗格',
    'buffer': '缓冲区', 'layout': '布局', 'binding': '绑定',
    'history': '历史', 'hook': '钩子', 'environment': '环境变量',
    'lock': '锁定', 'unlock': '解锁', 'suspend': '挂起',
    'capture': '捕获', 'resize': '调整大小', 'swap': '交换',
    'rotate': '旋转', 'select': '选择', 'break': '分离',
    'pipe': '管道', 'respawn': '重生',
    'backup': '备份', 'extract': '提取', 'archive': '归档',
    'encoding': '编码', 'locale': '区域设置', 'hostname': '主机名',
    'timezone': '时区', 'ntp': 'NTP同步', 'profiling': '性能分析',
    'cgroup': '控制组', 'dbus': 'D-Bus', 'systemd': '系统管理',
    'journal': '日志', 'init': '初始化', 'escape': '转义',
    'mount': '挂载', 'tmpfiles': '临时文件', 'notify': '通知',
    'detect': '检测', 'virtual': '虚拟化', 'power': '电源',
    'chacl': 'chacl命令', 'getfacl': 'getfacl命令', 'setfacl': 'setfacl命令',
    'acl': 'ACL权限', 'access': '访问控制', 'default': '默认',
    'mask': '掩码', 'other': '其他用户', 'user': '用户', 'group': '组',
}

def translate(text):
    """Translate English test descriptions to Chinese."""
    chinese_chars = sum(1 for c in text if '\u4e00' <= c <= '\u9fff')
    if chinese_chars > len(text) * 0.3:
        return text
    
    # Pre-process: handle common patterns
    text = re.sub(r'\b(\w+)\s+is\s+(\w+)\b', r'\1 \2', text)  # "is installed" -> "installed" (already handled)
    
    # Apply word-level translations (longest first)
    for en, cn in sorted(TRANS.items(), key=lambda x: -len(x[0])):
        pattern = re.compile(r'\b' + re.escape(en) + r'\b', re.IGNORECASE)
        text = pattern.sub(cn, text)
    
    # Post-process: remove leftover English glue words
    text = re.sub(r'\bis\b', '', text)
    text = re.sub(r'\bto\b', '', text)
    text = re.sub(r'\bwith\b', '使用', text)
    text = re.sub(r'\bfor\b', '', text)
    text = re.sub(r'\bof\b', '', text)
    text = re.sub(r'\bthe\b', '', text)
    text = re.sub(r'\bcompiled\b', '已编译', text)
    text = re.sub(r'\binfo\b', '信息', text)
    text = re.sub(r'\bflag\b', '参数', text)
    text = re.sub(r'\bcompilation\b', '编译', text)
    text = re.sub(r'\bstandards\b', '标准', text)
    text = re.sub(r'\blevels\b', '级别', text)
    text = re.sub(r'\bstatic\b', '静态', text)
    text = re.sub(r'\banalysis\b', '分析', text)
    text = re.sub(r'\bcompat\b', '兼容', text)
    text = re.sub(r'\bverbose\b', '详细', text)
    text = re.sub(r'\bonly\b', '仅', text)
    text = re.sub(r'\band\b', '和', text)
    text = re.sub(r'\bStatic\b', '静态', text)
    text = re.sub(r'\bLinking\b', '链接', text)
    text = re.sub(r'\bVerbose\b', '详细', text)
    text = re.sub(r'\bDisk\b', '磁盘', text)
    text = re.sub(r'\bhandling\b', '处理', text)
    text = re.sub(r'\bpercent\b', '百分比', text)
    text = re.sub(r'\bpartition\b', '分区', text)
    text = re.sub(r'\bDry\b', '模拟', text)
    text = re.sub(r'\bFree\b', '空闲', text)
    text = re.sub(r'\bactual\b', '实际', text)
    text = re.sub(r'\bno\b', '无', text)
    text = re.sub(r'\boption\b', '选项', text)
    text = re.sub(r'\bwarnings\b', '警告', text)
    
    # Clean up whitespace
    text = re.sub(r'\s+', ' ', text).strip()
    
    return text

packages = []
for d in sorted(os.listdir(BASE)):
    path = os.path.join(BASE, d, 'test.sh')
    if not os.path.isfile(path):
        continue
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Extract test points
    points = re.findall(r'rlRun\s+.*?\d+\s+"(.+?)"', content)
    sections = re.findall(r'echo\s+"=== Test \d+:\s*(.+?)"', content)
    count = len(re.findall(r'rlRun\s+', content))
    
    # Get commands info - fix regex to not capture trailing quotes
    cmds_covered = re.findall(r'which\s+(\S+)', content)
    cmds_covered = [c.strip("'\"") for c in cmds_covered if c]
    
    # For non-rlRun tests, count echo "Test" sections and direct command calls
    if count == 0:
        count = len(re.findall(r'echo\s+"=== Test\b', content))
        if count == 0:
            count = len(points) if points else len(content.split('\n')) // 10  # rough estimate
    if not points:
        points = [f'Test section: {s}' for s in sections] if sections else ['Functional verification']
    ver_match = re.search(r'# Version:\s*(.+)', content)
    version = ver_match.group(1) if ver_match else ''
    
    packages.append({
        'name': d,
        'version': version,
        'count': count,
        'commands': cmds_covered,
        'sections': sections,
        'points': points
    })

# Generate markdown
lines = []
lines.append('# 功能测试覆盖详情')
lines.append('')
lines.append(f'> 共 **{len(packages)}** 个软件包，**{sum(p["count"] for p in packages)}** 个测试点')
lines.append('> 点击展开查看各软件包详情')
lines.append('')

# Table of contents
lines.append('## 目录')
lines.append('')
lines.append('| 软件包 | 测试点 | 版本 |')
lines.append('|--------|:-----:|------|')
for p in packages:
    lines.append(f'| [{p["name"]}](#{p["name"].replace("+","")}) | {p["count"]} | {p["version"]} |')
lines.append('')

# Detail sections
for p in packages:
    lines.append(f'---')
    lines.append(f'')
    lines.append(f'## {p["name"]}')
    lines.append(f'')
    lines.append(f'- **版本**: {p["version"]}')
    lines.append(f'- **测试点**: {p["count"]}')
    if p['commands']:
        lines.append(f'- **被测命令**: {", ".join(f"`{c}`" for c in p["commands"])}')
    lines.append('')
    
    if p['sections']:
        for i, sec in enumerate(p['sections']):
            # Translate section header too
            sec_cn = translate(sec.replace('===', '').strip())
            lines.append(f'<details>')
            lines.append(f'<summary><b>{sec_cn}</b></summary>')
            lines.append('')
            # Get a subset of points for this section
            start_idx = i * 10
            end_idx = start_idx + 10
            sec_points = p['points'][start_idx:end_idx]
            if sec_points:
                for pt in sec_points:
                    lines.append(f'- {translate(pt)}')
            else:
                lines.append('- 执行相关功能验证')
            lines.append('')
            lines.append(f'</details>')
            lines.append('')
    else:
        lines.append('<details>')
        lines.append('<summary><b>测试点列表</b></summary>')
        lines.append('')
        for pt in p['points']:
            lines.append(f'- {translate(pt)}')
        lines.append('')
        lines.append('</details>')
    lines.append('')

with open('docs/functional-coverage.md', 'w', encoding='utf-8') as f:
    f.write('\n'.join(lines))

print(f'Generated docs/functional-coverage.md with {len(packages)} packages')
