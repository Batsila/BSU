#! /usr/bin/env python

import sys
import glob
import shutil
import functools

def doit(n):
    file_names = glob.glob('*/*.pdbqt')
    everything = []
    failures = []
    print('Found', len(file_names), 'pdbqt files')
    for file_name in file_names:
        file = open(file_name)
        lines = file.readlines()
        file.close()
        try:
            line = lines[1]
            result = float(line.split(':')[1].split()[0])
            everything.append([result, file_name])
        except:
            failures.append(file_name)

    def compare(x, y):
        return x[0] - y[0]
    print('e', everything)
    everything.sort(key=functools.cmp_to_key(compare))
    for p in everything[:n]:
#        if float(p[0]) < -9.9:
            print('{0}:{1}'.format(p[0],p[1]))
#            shutil.copy(p[1], '../aro_best_10/'+p[1].split('/')[-1])
#        else:
#            break
    if len(failures) > 0:
        print('WARNING:', len(failures), 'pdbqt files could not be processed')

if __name__ == '__main__':
    doit(10)
