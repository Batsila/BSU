import os
import glob

count = 0

for fouldername in os.listdir(os.getcwd()):
    files = glob.glob(os.path.join(os.getcwd(), fouldername, '*.pdbqt'))
    if len(files) is 0:
        continue
    filepath = files[0]
    pdbqt_file = open(filepath, 'r')
    pdbqt = pdbqt_file.read()
    
    lines = pdbqt.split('\n')
    energy = lines[1].split()[3]
    pdbqt_file.close()
    
    energy_file = open(os.path.join(os.getcwd(), fouldername, fouldername + '_energy.txt'), 'w+')
    energy_file.write(energy)
    energy_file.close()

    count += 1
    
    print(fouldername + ' DONE')

print('Process is finished. \nFiles ' + str(count) + ' \nPress ENTER to exit...')
input()
