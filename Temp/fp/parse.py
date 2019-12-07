in_file = open('minus_8_updated_model.csv', 'r')
out_file = open('minus_8.csv', 'w')
text = in_file.read()
lines = text.split('\n')
for line in lines:
    if line is '':
        continue
    arr = line.split(',')
    fp = ''
    for e in arr:
        if float(e) < 0.5:
            fp += '0'
        else:
            fp += '1'
    out_file.write(fp + '\n')