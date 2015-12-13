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

LLVM_OUT_DIR = os.path.join(WORK_DIR, 'llvm-out')
LLVM_INSTALL_DIR = os.path.join(WORK_DIR, 'llvm-install')
LLVM_INSTALL_TAR = os.path.join(WORK_DIR, 'llvm-install.tbz2')
TORTURE_OUT_DIR = os.path.join(WORK_DIR, 'torture-out')
TORTURE_TAR = os.path.join(WORK_DIR, 'torture.tbz2')

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
LLVM_SVN_REV = None # Found after the sync step, corresponds to LLVM_REVISION.

# Pin the GCC revision so that new torture tests don't break the bot. This
# should be manually updated when convenient.
GCC_REVISION = 'b6125c702850488ac3bfb1079ae5c9db89989406'


# Magic annotations:
# https://chromium.googlesource.com/chromium/tools/build/+/master/scripts/common/annotator.py
def BuildStep(name):
  sys.stdout.write('\n@@@BUILD_STEP %s@@@\n' % name)


def StepLink(label, url):
  sys.stdout.write('@@@STEP_LINK@%s@%s@@@\n' % (label, url))


def StepFail():
  """Mark one step as failing, but keep going. Throwing would stop all steps."""
  sys.stdout.write('\n@@@STEP_FAILURE@@@\n')


def Chdir(path):
  print 'Change directory to: %s' % path
  os.chdir(path)


def Mkdir(path):
  if os.path.exists(path):
    if not os.path.isdir(path):
      raise Exception('Path %s is not a directory!' % path)
    print 'Directory %s already exists' % path
  else:
    os.mkdir(path)


def Remove(path):
  """Remove file or directory if it exists, do nothing otherwise."""
  if os.path.exists(path):
    print 'Removing %s' % path
    if os.path.isdir(path):
      shutil.rmtree(path)
    else:
      os.remove(path)


def Tar(tar, directory):
  """Create a tar file from directory."""
  Remove(tar)
  print 'Creating %s' % tar
  subprocess.check_call(['tar', 'cjf', tar, '.'], cwd=directory)


def Archive(name, tar):
  """Archive the tar file with the given name, and with the LLVM git hash."""
  if not os.environ.get('BUILDBOT_BUILDERNAME'):
    return
  BuildStep('Archive %s' % name)
  svn_gs = 'wasm-llvm/builds/svn/wasm-%s-r%s.tbz2' % (name, LLVM_SVN_REV)
  git_gs = 'wasm-llvm/builds/git/wasm-%s-%s.tbz2' % (name, LLVM_REVISION)
  subprocess.check_call(
      ['gsutil', 'cp' , '-a',
       'public-read', tar, 'gs://' + svn_gs])
  subprocess.check_call(
      ['gsutil', 'cp' , '-a',
       'public-read', 'gs://' + svn_gs, 'gs://' + git_gs])
  StepLink('download', 'https://storage.googleapis.com/%s' % svn_gs)
  StepLink('git_download', 'https://storage.googleapis.com/%s' % git_gs)


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
  raise Exception('Cannot find clang rev at or before %d' % goal)


def SyncLLVMClang():
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
  global LLVM_SVN_REV
  LLVM_SVN_REV = int(subprocess.check_output(
      ['git', 'svn', 'find-rev', 'HEAD'], cwd=LLVM_DIR).strip())
  print 'SVN REV: %d' % LLVM_SVN_REV
  print 'Finding prior Clang rev'
  subprocess.check_call(['git', 'fetch'], cwd=CLANG_DIR)
  prior_rev = FindPriorRev(CLANG_DIR, LLVM_SVN_REV)
  print 'Checking out Clang rev: %s' % prior_rev
  subprocess.check_call(['git', 'checkout', prior_rev], cwd=CLANG_DIR)


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


def SyncRepos():
  BuildStep('Sync Repos')
  SyncLLVMClang()
  SyncGCC()
  SyncPrebuiltClang()
  SyncSexpr()


def BuildLLVM():
  BuildStep('Build LLVM')
  print 'Running cmake on llvm'
  Mkdir(LLVM_OUT_DIR)
  subprocess.check_call(
      ['cmake', '-G', 'Ninja', LLVM_DIR,
       '-DCMAKE_EXPORT_COMPILE_COMMANDS=ON',
       '-DLLVM_BUILD_TESTS=ON',
       '-DCMAKE_C_COMPILER=' + PREBUILT_CLANG_BIN + '/clang',
       '-DCMAKE_CXX_COMPILER=' + PREBUILT_CLANG_BIN + '/clang++',
       '-DCMAKE_BUILD_TYPE=Release',
       '-DCMAKE_INSTALL_PREFIX=' + LLVM_INSTALL_DIR,
       '-DLLVM_ENABLE_ASSERTIONS=ON',
       '-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly',
       '-DLLVM_TARGETS_TO_BUILD=X86'], cwd=LLVM_OUT_DIR)
  print 'Running ninja'
  subprocess.check_call(['ninja'], cwd=LLVM_OUT_DIR)


def TestLLVM():
  BuildStep('Test LLVM')
  subprocess.check_call(['ninja', 'check-all'], cwd=LLVM_OUT_DIR)


def InstallLLVM():
  BuildStep('Install LLVM')
  Remove(LLVM_INSTALL_DIR)
  subprocess.check_call(['ninja', 'install'], cwd=LLVM_OUT_DIR)
  Tar(tar=LLVM_INSTALL_TAR, directory=LLVM_INSTALL_DIR)


def ArchiveLLVM():
  if LLVM_REVISION == 'origin/master':
    return
  Archive('LLVM', LLVM_INSTALL_TAR)


def TortureLLVM():
  name = 'Torture LLVM'
  BuildStep(name)
  c = os.path.join(LLVM_OUT_DIR, 'bin', 'clang')
  cxx = os.path.join(LLVM_OUT_DIR, 'bin', 'clang++')
  Remove(TORTURE_OUT_DIR)
  Mkdir(TORTURE_OUT_DIR)
  unexpected_result_count = torture_test.run(
    c=c, cxx=cxx, testsuite=GCC_TEST_DIR,
    fails=LLVM_KNOWN_TORTURE_FAILURES,
    out=TORTURE_OUT_DIR)
  # Create the tar file even if there were some failures.
  Tar(tar=TORTURE_TAR, directory=TORTURE_OUT_DIR)
  if 0 != unexpected_result_count:
    StepFail()
    return 1
  return 0


def ArchiveTorture():
  if os.path.isfile(TORTURE_TAR):
    Archive('Torture', TORTURE_TAR)


def Summary(failed_steps):
  BuildStep('Summary')
  sys.stdout.write('Failed steps: %s.' % failed_steps)


def main():
  failed_steps = 0
  Clobber()
  SyncRepos()
  BuildLLVM()
  TestLLVM()
  InstallLLVM()
  ArchiveLLVM()
  failed_steps = failed_steps + TortureLLVM()
  ArchiveTorture()
  # Keep the summary step last: it'll be marked as red if the return code is
  # non-zero. Individual steps are marked as red with StepFail().
  Summary(failed_steps)
  return failed_steps


if __name__ == '__main__':
  sys.exit(main())
