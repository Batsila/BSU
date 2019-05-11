import os
import glob
import pandas as pd
import numpy as np
from rdkit.Chem import MACCSkeys
from rdkit import Chem
from operator import itemgetter
from tqdm import tqdm

def smi2fp(smi):
    m = Chem.MolFromSmiles(smi)
    fp = MACCSkeys.GenMACCSKeys(m)
    fp_array = []
    for byte in fp:
        fp_array.append(byte)
    fp_array = fp_array[1:]
    return fp_array

data = []
count = 0

for fouldername in tqdm(os.listdir(os.getcwd())):
    files = glob.glob(os.path.join(os.getcwd(), fouldername, '*.smi'))
    if len(files) is 0:
        continue
    filepath = files[0]
    smi_file = open(filepath, 'r')
    smi = smi_file.read()
    smi_file.close()
    try:
        fp = smi2fp(smi)
    except:
        continue
    files = glob.glob(os.path.join(os.getcwd(), fouldername, '*energy.txt'))
    if len(files) is 0:
        continue
    filepath = files[0]
    energy_file = open(filepath, 'r')
    energy = energy_file.read()
    energy_file.close()

    row = []
    row.append(energy)
    for byte in fp:
        row.append(byte)
    data.append(row)
    

df = pd.DataFrame(data=data)
headers = []
headers.append('energy')
for i in range(1, 167):
    headers.append(i)
df.to_csv('energy_and_fp.csv', index=False, header=headers)
print('Process is finished.\nRows added ' + str(len(data)))