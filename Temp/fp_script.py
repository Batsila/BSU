import os
import glob
import pandas as pd
import numpy as np
from rdkit.Chem import AllChem as Chem
from operator import itemgetter
from tqdm import tqdm

def smi2fp(filepath):
    sf = Chem.SmilesMolSupplier(filepath, titleLine=False)

    fp_bytes = list(Chem.GetMACCSKeysFingerprint(sf[0]))
    
    fp_str = ''

    for fp_byte in fp_bytes:
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
    fp = smi2fp(filepath)

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