#!/bin/sh

set -e

./yaml2json -h
./yaml2json -V
cat .github/workflows/ci.yml | ./yaml2json > /dev/null
./yaml2json .github/workflows/ci.yml -l -p -o ci.json
rm ci.json
