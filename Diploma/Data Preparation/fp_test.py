from rdkit.Chem import MACCSkeys
from rdkit import Chem

def smi2fp(smi):
    try:
        m = Chem.MolFromSmiles(smi)
        fp = MACCSkeys.GenMACCSKeys(m)
        fp_str = ''
        for byte in fp:
            fp_str += str(byte)
        fp_str = fp_str[1:]
        return fp_str
    except:
        return '0'

fp = smi2fp('CC')
print(str(fp))