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
import os.path
import multiprocessing
import subprocess
import sys


class Result:
  """Result from a single test that was run."""

  def __init__(self, test, success, output):
    self.test = test
    self.success = success
    self.output = output

  def __str__(self):
    return '%s %s%s%s' % ('SUCCEEDED' if self.success else 'FAILED',
                          self.test, '\n' if self.output else '', self.output)

  def __nonzero__(self):
    return self.success

  def __lt__(self, other):
    """Sort by test name so that the output files can be compared easily."""
    return self.test < other.test


class Tester(object):
  """Test runner."""

  def __init__(self, command_ctor, outdir, extras):
    """Command-line constructor accepting input and output file names."""
    assert os.path.isdir(outdir)
    self.command_ctor = command_ctor
    self.outdir = outdir
    self.extras = extras

  def __call__(self, test_file):
    """Execute a single test."""
    basename = os.path.basename(test_file)
    outname = basename + '.s'
    outfile = os.path.join(self.outdir, outname)
    # Print something simple so buildbots don't think the script is dead.
    sys.stdout.write('.')
    sys.stdout.flush()
    try:
      output = subprocess.check_output(
          self.command_ctor(test_file, outname, self.extras),
          stderr=subprocess.STDOUT, cwd=self.outdir)
      assert os.path.isfile(outfile), 'Missing output file %s'
      return Result(test=basename, success=True, output=output)
    except subprocess.CalledProcessError as e:
      return Result(test=basename, success=False, output=e.output)


def get_expected_failures(fails):
  """One failure per line, some whitespace, Python-style comments."""
  assert os.path.isfile(fails), 'Cannot find known failures at %s' % fails
  res = []
  with open(fails, 'r') as fails_file:
    res = fails_file.readlines()
  return sorted([r for r in [r.split('#')[0].strip() for r in res] if len(r)])


def execute(tester, inputs, fails):
  """Execute tests in parallel, output results, return failure count."""
  expected_failures = get_expected_failures(fails)
  pool = multiprocessing.Pool()
  sys.stdout.write('Executing tests.')
  results = sorted(pool.map(tester, inputs))
  sys.stdout.write('\nDone.')
  r_successes = [r for r in results if r]
  r_failures = [r for r in results if not r]
  r_expected_failures = [t for t in r_failures
                         if t.test in expected_failures]
  r_unexpected_failures = [t for t in r_failures
                           if t.test not in expected_failures]
  r_unexpected_successes = [t for t in r_successes
                            if t.test in expected_failures]
  sys.stdout.write('Results:\n')
  for result in results:
    sys.stdout.write(str(result) + '\n\n')
  if r_expected_failures:
    sys.stdout.write('Expected failures:\n')
    for f in r_expected_failures:
      sys.stdout.write('\t%s\n' % f.test)
  if r_unexpected_failures:
    sys.stdout.write('Unexpected failures:\n')
    for f in r_unexpected_failures:
      sys.stdout.write('\t%s\n' % f.test)
  if r_unexpected_successes:
    sys.stdout.write('Unexpected successes:\n')
    for f in r_unexpected_successes:
      sys.stdout.write('\t%s\n' % f.test)
  sys.stdout.write(
      '\n'.join(['\n',
                 'Ran %s tests.' % len(results),
                 'Got %s successes.' % len(r_successes),
                 'Got %s failures.' % len(r_failures),
                 'Expected %s failures.' % len(expected_failures),
                 'Got %s expected failures.' % len(r_expected_failures),
                 'Got %s unexpected failures.' % len(r_unexpected_failures),
                 'Got %s unexpected successes.' % len(r_unexpected_successes),
                 '\n']))
  return len(r_unexpected_failures) + len(r_unexpected_successes)
