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
  print 'Syncing clang'
  subprocess.check_call(['git', 'pull'], cwd=CLANG_DIR)
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
  subprocess.check_call(['git', 'pull'], cwd=CHROMIUM_CLANG_TOOLS_CLANG)
  print 'Syncing chromium clang'
  subprocess.check_call(
      [os.path.join(CHROMIUM_CLANG_TOOLS_CLANG, 'scripts', 'update.py')])


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


def BuildLLVM():
  BuildStep('Build LLVM')
  print 'Running cmake on llvm'
  if os.environ.get('BUILDBOT_CLOBBER'):
    if os.path.exists(OUT_DIR):
      print 'Removing %s' % OUT_DIR
      shutil.rmtree(OUT_DIR)
  Mkdir(OUT_DIR)
  subprocess.check_call(
      ['cmake', '-G', 'Ninja', LLVM_DIR,
       '-DCMAKE_EXPORT_COMPILE_COMMANDS=ON',
       '-DLLVM_BUILD_TESTS=ON',
       '-DCMAKE_C_COMPILER=' + CHROMIUM_CLANG_BIN + '/clang',
       '-DCMAKE_CXX_COMPILER=' + CHROMIUM_CLANG_BIN + '/clang++',
       '-DCMAKE_BUILD_TYPE=Debug',
       '-DLLVM_ENABLE_ASSERTIONS=ON',
       '-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly',
       '-DLLVM_TARGETS_TO_BUILD=X86'], cwd=OUT_DIR)
  print 'Running ninja'
  subprocess.check_call(['ninja'], cwd=OUT_DIR)


def TestLLVM():
  BuildStep('Test LLVM')
  subprocess.check_call(['ninja', 'check-all'], cwd=OUT_DIR)


def main():
  Sync()
  BuildLLVM()
  TestLLVM()


if __name__ == '__main__':
  main()
