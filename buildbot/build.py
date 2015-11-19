#! /usr/bin/env python

import os
import subprocess
import sys


SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))


def BuildStep(name):
  sys.stderr.write('\n@@@BUILD_STEP %s@@@\n' % name)


def main():
  BuildStep('Sync')
  os.chdir(os.path.join(SCRIPT_DIR))
  print SCRIPT_DIR
  #subprocess.check_call(
  #    ['git', 'clone',
  #     'https://chromium.googlesource.com/chromiumos/third_party/llvm'])


if __name__ == '__main__':
  main()
