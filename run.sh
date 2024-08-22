#!/bin/bash

# set -xe

# filepath="./text-files/email.txt"
# filepath="./text-files/the-tyburn-tree.txt"
# filepath="./text-files/stb_ds.h"
# filepath="./text-files/stb_image_resize2.h"
# filepath="./text-files/miniaudio.h"
filepath="./text-files/sherlock-holms.txt"

echo "NO  OPTIMIZATION |    BOUNDS_CHECK"
odin build . -out:main -o:none -debug
./main "$filepath"
#
# echo "NO  OPTIMIZATION | NO_BOUNDS_CHECK"
# odin build . -out:main -o:none -debug -no-bounds-check
# ./main "$filepath"
#
# echo "MAX OPTIMIZATION |    BOUNDS_CHECK"
# odin build . -out:main -o:aggressive -debug
# ./main "$filepath"
#
# echo "MAX OPTIMIZATION | NO_BOUNDS_CHECK"
# odin build . -out:main -o:aggressive -debug -no-bounds-check
# ./main "$filepath"


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
