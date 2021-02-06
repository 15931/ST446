#!/usr/bin/python

import sys;

def generateKeyValue(id):
    return id + "\t" + "1"

def main(argv):
    line = sys.stdin.readline();
    try:
        while line:
            line = line[:-1];
            fields = line.split("\t");
            print generateKeyValue(fields[0]);
            line = sys.stdin.readline();
    except "end of file":
        return None

if __name__ == "__main__":
     main(sys.argv)
