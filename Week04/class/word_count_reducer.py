#!/usr/bin/env python

import sys

# maps words to their counts
word2count = {}

for line in sys.stdin:
    line = line.strip()
    splitted_line = line.split('\t')
    if len(splitted_line) != 2:
    	continue

    ## parse the input we got from mapper
    word, count = splitted_line
    # convert count (currently a string) to int
    try:
        count = int(count)
    except ValueError:
        continue

    try:
        word2count[word] = word2count[word]+count
    except:
        word2count[word] = count

# write the tuples to stdout
# Note: they are unsorted
for word in word2count.keys():
    print('%s\t%s' % (word, str(word2count[word])))
