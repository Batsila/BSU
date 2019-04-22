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
    
    fp_str = ''

    for fp_byte in fp:
        fp_str += str(fp_byte)
    
    return fp_str

energies = []
fps = []
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

    fps.append(fp)
    energies.append(energy)

data = {'energy': energies, 'fingerprints': fps}
df = pd.DataFrame(data=data)

df.to_csv('energy_and_fp.csv', index=False, header=False)
print('Process is finished.\nRows added ' + str(len(data['energy'])))