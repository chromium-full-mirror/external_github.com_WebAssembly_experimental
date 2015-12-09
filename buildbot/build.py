#! /usr/bin/env python

#   Copyright 2015 WebAssembly Community Group participants
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.


import os
import shutil
import subprocess
import sys
import torture_test


SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
WORK_DIR = os.path.join(SCRIPT_DIR, 'work')

LLVM_DIR = os.path.join(WORK_DIR, 'llvm')
CLANG_DIR = os.path.join(LLVM_DIR, 'tools', 'clang')
LLVM_KNOWN_TORTURE_FAILURES = os.path.join(
  LLVM_DIR, 'lib', 'Target', 'WebAssembly', 'known_gcc_test_failures.txt')

GCC_DIR = os.path.join(WORK_DIR, 'gcc')
GCC_TEST_DIR = os.path.join(GCC_DIR, 'gcc', 'testsuite')

PREBUILT_CLANG = os.path.join(WORK_DIR, 'chromium-clang')
PREBUILT_CLANG_TOOLS = os.path.join(PREBUILT_CLANG, 'tools')
PREBUILT_CLANG_TOOLS_CLANG = os.path.join(PREBUILT_CLANG_TOOLS, 'clang')
PREBUILT_CLANG_BIN = os.path.join(
    PREBUILT_CLANG, 'third_party', 'llvm-build', 'Release+Asserts', 'bin')

SEXPR_DIR = os.path.join(WORK_DIR, 'sexpr-wasm-prototype')

OUT_DIR = os.path.join(WORK_DIR, 'out')
INSTALL_DIR = os.path.join(WORK_DIR, 'install')
INSTALL_TAR = os.path.join(WORK_DIR, 'install.tbz2')

GIT_MIRROR_BASE = 'https://chromium.googlesource.com/'
LLVM_GIT = GIT_MIRROR_BASE + 'chromiumos/third_party/llvm'
CLANG_GIT = GIT_MIRROR_BASE + 'chromiumos/third_party/clang'
PREBUILT_CLANG_GIT = GIT_MIRROR_BASE + 'chromium/src/tools/clang'
GCC_GIT = GIT_MIRROR_BASE + 'chromiumos/third_party/gcc'
SEXPR_GIT = (GIT_MIRROR_BASE + 'external/' +
             'github.com/WebAssembly/sexpr-wasm-prototype.git')

# Try to use the llvm revision provided by buildbot.
LLVM_REVISION = os.environ.get('BUILDBOT_REVISION', 'None')
if LLVM_REVISION == 'None':
  LLVM_REVISION = 'origin/master'

GCC_REVISION = os.environ.get('BUILDBOT_GCC_REVISION', 'None')
if GCC_REVISION == 'None':
  GCC_REVISION = 'origin/master'


def BuildStep(name):
  sys.stdout.flush()
  sys.stderr.flush()
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


def GitConfigRebaseMaster(cwd):
  # The upstream repository is in Subversion, use git pull --rebase instead
  # of git pull to avoid generating a non-linear history in the clone:
  #   llvm.org/docs/GettingStarted.html#git-mirror
  subprocess.check_call(
    ['git', 'config', 'branch.master.rebase', 'true'], cwd=cwd)


def FindPriorRev(path, goal):
  revs = subprocess.check_output(
      ['git', 'rev-list', 'origin/master'], cwd=path).splitlines()
  for rev in revs:
    num = subprocess.check_output(
        ['git', 'svn', 'find-rev', rev], cwd=path).strip()
    if int(num) <= goal:
      return rev
  raise Error('Cannot find clang rev at or before %d' % goal)


def SyncLLVMClang():
  BuildStep('Sync LLVM')
  Chdir(SCRIPT_DIR)
  Mkdir(WORK_DIR)
  if os.path.exists(LLVM_DIR):
    assert os.path.exists(CLANG_DIR), 'Assuming LLVM present implies Clang too'
    print 'LLVM and Clang directories already exist'
  else:
    print 'Cloning LLVM and Clang'
    subprocess.check_call(['git', 'clone', LLVM_GIT, LLVM_DIR])
    GitConfigRebaseMaster(LLVM_DIR)
    subprocess.check_call(['git', 'clone', CLANG_GIT, CLANG_DIR])
    GitConfigRebaseMaster(CLANG_DIR)
  print 'Syncing LLVM'
  subprocess.check_call(['git', 'fetch'], cwd=LLVM_DIR)
  subprocess.check_call(['git', 'checkout', LLVM_REVISION], cwd=LLVM_DIR)
  print 'Getting SVN rev'
  svn_rev = int(subprocess.check_output(
      ['git', 'svn', 'find-rev', 'HEAD'], cwd=LLVM_DIR).strip())
  print 'SVN REV: %d' % svn_rev
  print 'Finding prior Clang rev'
  subprocess.check_call(['git', 'fetch'], cwd=CLANG_DIR)
  prior_rev = FindPriorRev(CLANG_DIR, svn_rev)
  print 'Checking out Clang rev: %s' % prior_rev
  subprocess.check_call(['git', 'checkout', prior_rev], cwd=CLANG_DIR)
  return svn_rev


def SyncGCC():
  if os.path.exists(GCC_DIR):
    print 'GCC directory already exists'
  else:
    print 'Cloning GCC'
    subprocess.check_call(['git', 'clone', GCC_GIT, GCC_DIR])
    GitConfigRebaseMaster(GCC_DIR)
  print 'Syncing GCC'
  subprocess.check_call(['git', 'fetch'], cwd=GCC_DIR)
  subprocess.check_call(['git', 'checkout', GCC_REVISION], cwd=GCC_DIR)


def SyncPrebuiltClang():
  if os.path.exists(PREBUILT_CLANG_TOOLS_CLANG):
    print 'Prebuilt Chromium Clang directory already exists'
  else:
    print 'Cloning Prebuilt Chromium Clang directory'
    Mkdir(PREBUILT_CLANG)
    Mkdir(PREBUILT_CLANG_TOOLS)
    subprocess.check_call(
        ['git', 'clone', PREBUILT_CLANG_GIT, PREBUILT_CLANG_TOOLS_CLANG])
    GitConfigRebaseMaster(PREBUILT_CLANG_TOOLS_CLANG)
  print 'Syncing Prebuilt Chromium Clang scripts'
  subprocess.check_call(['git', 'fetch'], cwd=PREBUILT_CLANG_TOOLS_CLANG)
  print 'Syncing Prebuilt Chromium Clang'
  subprocess.check_call(
      [os.path.join(PREBUILT_CLANG_TOOLS_CLANG, 'scripts', 'update.py')])


def SyncSexpr():
  if os.path.exists(SEXPR_DIR):
    print 'Sexpr directory already exists'
  else:
    print 'Cloning Sexpr'
    subprocess.check_call(['git', 'clone', SEXPR_GIT, SEXPR_DIR])
    GitConfigRebaseMaster(SEXPR_DIR)
  print 'Syncing Sexpr'
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
       '-DCMAKE_C_COMPILER=' + PREBUILT_CLANG_BIN + '/clang',
       '-DCMAKE_CXX_COMPILER=' + PREBUILT_CLANG_BIN + '/clang++',
       '-DCMAKE_BUILD_TYPE=Release',
       '-DCMAKE_INSTALL_PREFIX=' + INSTALL_DIR,
       '-DLLVM_ENABLE_ASSERTIONS=ON',
       '-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly',
       '-DLLVM_TARGETS_TO_BUILD=X86'], cwd=OUT_DIR)
  print 'Running ninja'
  subprocess.check_call(['ninja'], cwd=OUT_DIR)


def TestLLVM():
  BuildStep('Test LLVM')
  subprocess.check_call(['ninja', 'check-all'], cwd=OUT_DIR)


def TortureLLVM():
  BuildStep('Torture LLVM')
  c = os.path.join(OUT_DIR, 'bin', 'clang')
  cxx = os.path.join(OUT_DIR, 'bin', 'clang++')
  # TODO(jfb) Report failure.
  failure_count = torture_test.run(c, cxx, GCC_TEST_DIR,
                                   LLVM_KNOWN_TORTURE_FAILURES)


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
  svn_rev = SyncLLVMClang()
  SyncGCC()
  SyncPrebuiltClang()
  SyncSexpr()
  BuildLLVM()
  TestLLVM()
  TortureLLVM()
  InstallLLVM()
  ArchiveLLVM(svn_rev)


if __name__ == '__main__':
  main()
