#!/usr/bin/env python

import difflib
import glob
import os
import subprocess
import sys
import unittest

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
WASMATE = os.path.join(SCRIPT_DIR, 'wasmate.py')
ENVIRONMENT = 'misctest'

def DiffLines(expected, actual):
    expected_lines = expected.splitlines(1)
    actual_lines = actual.splitlines(1)
    return list(difflib.unified_diff(expected_lines, actual_lines,
                                     fromfile='expected', tofile='actual'))

class RunTests(unittest.TestCase):
    def _runTestFile(self, shortName, fileName):
        expectedLogPath = fileName.replace("test/", "test/expected-output/").replace(".s", ".wast")
        logPath = fileName.replace("test/", "test/output/").replace(".s", ".wast")
        try:
            os.remove(logPath)
        except OSError:
            pass

        commandStr = ("%s -l %s %s > %s") % (WASMATE, ENVIRONMENT, fileName, logPath)
        exitCode = subprocess.call(commandStr, shell=True)
        self.assertEqual(0, exitCode, "test runner failed with exit code %i" % exitCode)

        try:
            expected = open(expectedLogPath)
        except IOError:
            # print("// WARNING: No expected output found for %s" % fileName)
            return

        output = open(logPath)

        with expected:
            with output:
                expectedText = expected.read()
                actualText = output.read()
                if expectedText != actualText:
                    msg = ('Mismatch in stdout:\n' +
                           ''.join(DiffLines(expectedText, actualText)))
                    self.assertEqual(expectedText, actualText, msg)

def generate_test_case(attrName, fileName):
    return lambda self : self._runTestFile(attrName, fileName)

def generate_test_cases(cls, files):
    for fileName in files:
        attrName = fileName
        testCase = generate_test_case(attrName, fileName)
        setattr(cls, attrName, testCase)

if __name__ == "__main__":
    try:
        os.makedirs("test/output/")
    except OSError:
        pass

    testFiles = glob.glob("test/*.s")
    generate_test_cases(RunTests, testFiles)
    unittest.main()
