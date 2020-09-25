import csv
import pyodbc

conn = pyodbc.connect('Driver={SQL Server};'
                      'Server=.;'
                      'Database=FP;'
                      'Trusted_Connection=yes;')

def check(fp):
    cursor = conn.cursor()

    sqlq = f"SELECT * FROM drug_like WHERE fp = 0x{fp}"

    cursor.execute(sqlq)
    for row in cursor.fetchall():
        print(row)
        return True

    return False

    
with open('energy_and_fp.csv') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    line_count = 0
    fp_in_db = 0
    for row in csv_reader:
        if line_count == 0:
            line_count += 1
        else:
            fp = ''.join(row[1:])
            in_db = check(fp)
            print(f'\tLine {line_count} {fp} {in_db}')
            line_count += 1
            if in_db:
                fp_in_db += 1
    print(f'Processed {line_count} fp.')
    print(f'{fp_in_db} fp in db.')