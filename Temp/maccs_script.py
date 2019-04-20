import os
import glob
import time

count = 0

for fouldername in os.listdir(os.getcwd()):
    files = glob.glob(os.path.join(os.getcwd(), fouldername, '*.smi'))
    if len(files) is 0:
        continue
    filepath = files[0]

    maccs_file_path = os.path.join(os.getcwd(), fouldername, fouldername + '_maccs.txt')
    command = 'babel ' + filepath + ' -ofpt -xfMACCS ' + maccs_file_path
    os.popen(command)

    count += 1
    print(fouldername + ' DONE')

print('Process is finished. \nFiles ' + str(count) + ' \nPress ENTER to exit...')
input()
