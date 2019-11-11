from tqdm import tqdm
import requests
import pyodbc
from rdkit.Chem import MACCSkeys
from rdkit import Chem


conn = pyodbc.connect('Driver={SQL Server};'
                      'Server=.;'
                      'Database=FP;'
                      'Trusted_Connection=yes;')


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
        return ''


def insert(smi, id, fp):
    cursor = conn.cursor()
    try:
        cursor.execute("insert into drug_like values('{}', '{}', 0x{});".format(id, smi, fp))
        conn.commit()
        return True
    except:
        return False


def fill_db(smi_id_arr):
    inserted = 0
    duplicated = 0
    for smi_id in tqdm(smi_id_arr):
        fp = smi2fp(smi_id[0])
        if insert(smi_id[0], smi_id[1], fp):
            inserted += 1
        else:
            duplicated += 1
    return inserted, duplicated


def parse_response(response):
    arr = []
    for res_line in response.splitlines():
        arr.append([p.decode("utf-8")  for p in res_line.split()])
    return arr


def load_from_zinc(uri):
    res = requests.get(uri)
    if res.status_code is 200:
        return parse_response(res.content)
    else:
        return None


def main():
    filepath ='D:/BSU/Temp/fp_db/ZINC-downloader-3D-smi.uri'
    total_inserted = 0
    total_duplicated = 0
    with open(filepath) as input_file:
        line = input_file.readline()
        cnt = 1
        while line:
            print('Uri {}: {}'.format(cnt, line.strip()))
            smi_id_arr = load_from_zinc(line.replace('\n', ''))
            if smi_id_arr is not None:
                inserted, duplicated = fill_db(smi_id_arr[1:])
                print('Inserted: {}; Duplicated: {}'.format(inserted, duplicated))
                total_inserted += inserted
                total_duplicated += duplicated
            line = input_file.readline()
            cnt += 1
    print('Total inserted: {}; Total duplicated: {}'.format(total_inserted, total_duplicated))


if __name__ == "__main__":
    main()