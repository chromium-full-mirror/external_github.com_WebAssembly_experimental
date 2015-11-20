#! /usr/bin/env python

import os
import shutil
import subprocess
import sys


SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
WORK_DIR = os.path.join(SCRIPT_DIR, 'work')
LLVM_DIR = os.path.join(WORK_DIR, 'llvm')
CLANG_DIR = os.path.join(LLVM_DIR, 'tools', 'clang')
CHROMIUM_CLANG = os.path.join(WORK_DIR, 'chromium-clang')
CHROMIUM_CLANG_TOOLS = os.path.join(CHROMIUM_CLANG, 'tools')
CHROMIUM_CLANG_TOOLS_CLANG = os.path.join(CHROMIUM_CLANG_TOOLS, 'clang')
CHROMIUM_CLANG_BIN = os.path.join(
    CHROMIUM_CLANG, 'third_party', 'llvm-build', 'Release+Asserts', 'bin')
OUT_DIR = os.path.join(WORK_DIR, 'out')
INSTALL_DIR = os.path.join(WORK_DIR, 'install')
INSTALL_TAR = os.path.join(WORK_DIR, 'install.tbz2')
SEXPR_DIR = os.path.join(WORK_DIR, 'sexpr-wasm-prototype')


# Try to use the llvm revision provided by buildbot.
LLVM_REVISION = os.environ.get('BUILDBOT_REVISION', 'None')
if LLVM_REVISION == 'None':
  LLVM_REVISION = 'origin/master'


def BuildStep(name):
  sys.stderr.write('\n@@@BUILD_STEP %s@@@\n' % name)


def Chdir(path):
  print 'Change directory to: %s' % path
  os.chdir(path)


def Mkdir(path):
  if os.path.exists(path):
    if not os.path.isdir(path):
      raise Error('Path %s is not a directory!' % path)
    print 'Directory %s already exists' % path
  else:
    os.mkdir(path)


def Remove(path):
  if os.path.exists(path):
    print 'Removing %s' % path
    os.remove(path)


def FindPriorRev(path, goal):
  revs = subprocess.check_output(
      ['git', 'rev-list', 'origin/master'], cwd=path).splitlines()
  for rev in revs:
    num = int(subprocess.check_output(
        ['git', 'svn', 'find-rev', rev], cwd=path).strip())
    if num <= rev:
      return rev
  raise Error('Cannot find clang rev at or before %d' % goal)


def Sync():
  BuildStep('Sync LLVM')
  Chdir(SCRIPT_DIR)
  Mkdir(WORK_DIR)
  if os.path.exists(LLVM_DIR):
    print 'LLVM directory already exists'
  else:
    print 'Cloning llvm and clang'
    subprocess.check_call(
        ['git', 'clone',
         'https://chromium.googlesource.com/chromiumos/third_party/llvm',
         LLVM_DIR])
    subprocess.check_call(
        ['git', 'config', 'branch.master.rebase', 'true'], cwd=LLVM_DIR)
    subprocess.check_call(
        ['git', 'clone',
         'https://chromium.googlesource.com/chromiumos/third_party/clang',
         CLANG_DIR])
    subprocess.check_call(
        ['git', 'config', 'branch.master.rebase', 'true'], cwd=CLANG_DIR)
  print 'Syncing llvm'
  subprocess.check_call(['git', 'fetch'], cwd=LLVM_DIR)
  subprocess.check_call(['git', 'checkout', LLVM_REVISION], cwd=LLVM_DIR)
  print 'Getting svn rev'
  svn_rev = int(subprocess.check_output(
      ['git', 'svn', 'find-rev', 'HEAD'], cwd=LLVM_DIR).strip())
  print 'SVN REV: %d' % svn_rev
  print 'Finding prior clang rev'
  prior_rev = FindPriorRev(CLANG_DIR, svn_rev)
  print 'Checking out clang rev: %s' % prior_rev
  subprocess.check_call(['git', 'checkout', prior_rev], cwd=CLANG_DIR)

  if os.path.exists(CHROMIUM_CLANG_TOOLS_CLANG):
    print 'Chromium clang directory already exists'
  else:
    print 'Cloning chromium clang directory'
    Mkdir(CHROMIUM_CLANG)
    Mkdir(CHROMIUM_CLANG_TOOLS)
    subprocess.check_call(
        ['git', 'clone',
         'https://chromium.googlesource.com/chromium/src/tools/clang',
         CHROMIUM_CLANG_TOOLS_CLANG])
    subprocess.check_call(
        ['git', 'config', 'branch.master.rebase', 'true'],
        cwd=CHROMIUM_CLANG_TOOLS_CLANG)
  print 'Syncing chromium clang scripts'
  subprocess.check_call(['git', 'fetch'], cwd=CHROMIUM_CLANG_TOOLS_CLANG)
  print 'Syncing chromium clang'
  subprocess.check_call(
      [os.path.join(CHROMIUM_CLANG_TOOLS_CLANG, 'scripts', 'update.py')])
  return svn_rev


def SyncSexpr():
  if os.path.exists(SEXPR_DIR):
    print 'Sexpr directory already exists'
  else:
    print 'Cloning Sexpr'
    subprocess.check_call(
        ['git', 'clone',
         'https://chromium.googlesource.com/external/'
         'github.com/WebAssembly/sexpr-wasm-prototype.git',
         SEXPR_DIR])
    subprocess.check_call(
        ['git', 'config', 'branch.master.rebase', 'true'], cwd=SEXPR_DIR)
  print 'Syncing sexpr'
  subprocess.check_call(['git', 'pull'], cwd=SEXPR_DIR)


def Clobber():
  if os.environ.get('BUILDBOT_CLOBBER'):
    BuildStep('Clobbering work dir')
    if os.path.exists(WORK_DIR):
      print 'Removing %s' % WORK_DIR
      shutil.rmtree(WORK_DIR)


def BuildLLVM():
  BuildStep('Build LLVM')
  print 'Running cmake on llvm'
  Mkdir(OUT_DIR)
  subprocess.check_call(
      ['cmake', '-G', 'Ninja', LLVM_DIR,
       '-DCMAKE_EXPORT_COMPILE_COMMANDS=ON',
       '-DLLVM_BUILD_TESTS=ON',
       '-DCMAKE_C_COMPILER=' + CHROMIUM_CLANG_BIN + '/clang',
       '-DCMAKE_CXX_COMPILER=' + CHROMIUM_CLANG_BIN + '/clang++',
       '-DCMAKE_BUILD_TYPE=Release',
       '-DCMAKE_INSTALL_PREFIX=' + INSTALL_DIR,
       '-DLLVM_ENABLE_ASSERTIONS=OFF',
       '-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly',
       '-DLLVM_TARGETS_TO_BUILD=X86'], cwd=OUT_DIR)
  print 'Running ninja'
  subprocess.check_call(['ninja'], cwd=OUT_DIR)


def TestLLVM():
  BuildStep('Test LLVM')
  subprocess.check_call(['ninja', 'check-all'], cwd=OUT_DIR)


def InstallLLVM():
  BuildStep('Install LLVM')
  if os.path.exists(INSTALL_DIR):
    print 'Removing %s' % INSTALL_DIR
    shutil.rmtree(INSTALL_DIR)
  subprocess.check_call(['ninja', 'install'], cwd=OUT_DIR)
  Remove(INSTALL_TAR)
  print 'Creating %s' % INSTALL_TAR
  subprocess.check_call(['tar', 'cjf', INSTALL_TAR, '.'], cwd=INSTALL_DIR)


def StepLink(label, url):
  print '@@@STEP_LINK@%s@%s@@@' % (label, url)


def ArchiveLLVM(svn_rev):
  if LLVM_REVISION == 'origin/master':
    return
  if not os.environ.get('BUILDBOT_BUILDERNAME'):
    return
  BuildStep('Archive')
  svn_gs = 'wasm-llvm/builds/svn/wasm-llvm-r%s.tbz2' % svn_rev
  git_gs = 'wasm-llvm/builds/git/wasm-llvm-%s.tbz2' % LLVM_REVISION
  subprocess.check_call(
      ['gsutil', 'cp' , '-a', 'public-read', INSTALL_TAR, 'gs://' + svn_gs])
  subprocess.check_call(
      ['gsutil', 'cp' , '-a',
       'public-read', 'gs://' + svn_gs, 'gs://' + git_gs])
  StepLink('download', 'https://storage.googleapis.com/%s' % svn_gs)
  StepLink('git_download', 'https://storage.googleapis.com/%s' % git_gs)


def main():
  Clobber()
  svn_rev = Sync()
  BuildLLVM()
  TestLLVM()
  InstallLLVM()
  ArchiveLLVM(svn_rev)


if __name__ == '__main__':
  main()
