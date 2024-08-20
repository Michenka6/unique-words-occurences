#!/bin/bash

set -xe

# odin build . -out:main -o:none -debug
odin build . -out:main -o:aggressive -debug

# ./main ./text-files/email.txt
# ./main ./text-files/the-tyburn-tree.txt
# ./main ./text-files/stb_ds.h
# ./main ./text-files/stb_image_resize2.h
# ./main ./text-files/miniaudio.h
./main ./text-files/sherlock-holms.txt

# jq --sort-keys . ./occurence-tables/solution-1.json > ./occurence-tables/solution-1-sorted.json
# jq --sort-keys . ./occurence-tables/solution-2.json > ./occurence-tables/solution-2-sorted.json
# jq --sort-keys . ./occurence-tables/solution-3.json > ./occurence-tables/solution-3-sorted.json
# jq --sort-keys . ./occurence-tables/solution-4.json > ./occurence-tables/solution-4-sorted.json
# jq --sort-keys . ./occurence-tables/solution-5.json > ./occurence-tables/solution-5-sorted.json
# diff ./occurence-tables/solution-2-sorted.json ./occurence-tables/solution-1-sorted.json
# diff ./occurence-tables/solution-2-sorted.json ./occurence-tables/solution-3-sorted.json
# diff ./occurence-tables/solution-2-sorted.json ./occurence-tables/solution-4-sorted.json
# diff ./occurence-tables/solution-2-sorted.json ./occurence-tables/solution-5-sorted.json
# diff ./occurence-tables/solution-3-sorted.json ./occurence-tables/solution-4-sorted.json
# diff ./occurence-tables/solution-3-sorted.json ./occurence-tables/solution-5-sorted.json
# diff ./occurence-tables/solution-4-sorted.json ./occurence-tables/solution-5-sorted.json
