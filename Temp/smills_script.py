import os
import glob
import time

count = 0

for fouldername in os.listdir(os.getcwd()):
    files = glob.glob(os.path.join(os.getcwd(), fouldername, '*.pdbqt'))
    if len(files) is 0:
        continue
    filepath = files[0]

    command = 'babel ' + filepath + ' ' + filepath.replace('.pdbqt', '.smi')
    os.popen(command)

    files = glob.glob(os.path.join(os.getcwd(), fouldername, '*.smi'))
    while len(files) is 0:
        time.sleep(0.1)
        files = glob.glob(os.path.join(os.getcwd(), fouldername, '*.smi'))

    filepath = files[0]
    smi_file = open(filepath, 'r')
    smills_list = smi_file.read()

    while len(smills_list) is 0 or len(smills_list.split()) is 1:
        time.sleep(0.1)
        smi_file = open(filepath, 'r')
        smills_list = smi_file.read()
    
    lines = smills_list.split('\n')
    smills = lines[0].split()[0]
    smi_file.close()

    smi_file = open(filepath, 'w')
    smi_file.write(smills)
    smi_file.close()
    count += 1
    print(fouldername + ' DONE')

print('Process is finished. \nFiles ' + str(count) + ' \nPress ENTER to exit...')
input()
