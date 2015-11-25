#!/bin/bash
set -o nounset
set -o errexit

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
ROOT_DIR="$(dirname "${SCRIPT_DIR}")"
LLVM_SVN=http://llvm.org/svn/llvm-project/llvm/trunk
LLVM_DIR="${ROOT_DIR}/third_party/llvm"
REV=254826

(cd ${SCRIPT_DIR} && svn co -r ${REV} ${LLVM_SVN} ${LLVM_DIR})
