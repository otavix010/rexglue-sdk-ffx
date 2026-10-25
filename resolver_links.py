"""Replaces git symlinks checked out as text files (core.symlinks off on Windows) with copies of their targets, in a
repository and its submodules: py resolve_links.py <repo>"""
import shutil
import subprocess
import sys
from pathlib import Path

root = Path(sys.argv[1]).resolve()
repos = [root]
out = subprocess.run(['git', '-C', str(root), 'submodule', 'foreach', '--recursive', '--quiet', 'echo $toplevel/$sm_path'],
                     capture_output=True, text=True).stdout.split()
repos += [Path(p) for p in out]
fixed = 0
for repo in repos:
    listing = subprocess.run(['git', '-C', str(repo), 'ls-files', '-s'], capture_output=True, text=True).stdout
    for line in listing.splitlines():
        meta, _, path = line.partition('\t')
        if not meta.startswith('120000'):
            continue
        link = repo / path
        if not link.is_file() or link.stat().st_size > 1024:
            continue
        target = (link.parent / link.read_text(encoding='utf-8', errors='replace').strip()).resolve()
        if target.is_file():
            link.unlink()
            shutil.copyfile(target, link)
            fixed += 1
        elif target.is_dir():
            link.unlink()
            shutil.copytree(target, link)
            fixed += 1
        else:
            print('alvo não encontrado:', link, '->', target)
print(f'{fixed} links trocados por cópias em {len(repos)} repositórios')
