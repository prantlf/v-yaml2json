#!/bin/sh

set -e

test() {
  if [ "$2" != "" ]; then
    echo "----------------------------------------"
  fi
  echo "$1"
  echo "----------------------------------------"
}

test "help"
./yaml2json -h

test "version" 1
./yaml2json -V

test "stdin and stdout" 1
cat .github/workflows/ci.yml | ./yaml2json > /dev/null

test "file input and output"
./yaml2json .github/workflows/ci.yml -l -p -o ci.json
rm ci.json

echo "done"
