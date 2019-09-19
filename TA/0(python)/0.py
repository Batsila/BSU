with open('input.txt') as f:
    array = []
    for line in f:
        array.append(int(line))
fout = open('output.txt', 'w')
array = set(array)
s = 0
for x in array:
	s += x
fout.write(str(s))