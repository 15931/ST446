import sys

for line in sys.stdin:
   if "<row" in line:
      line = line.rstrip("\n").replace("\n", " ").replace("/>", "></row>")
      print(line)
