--������������ ����������� � ����  Oracle. 
--C��������� ����  FPMI-STUD\SUBFACULTY\��� ���\��������\������������\EDU5.sql  � ������� C:\TEMP .
--��������� ���� � ����������� �� �������� �������� � ���������� ������ ��� ���������� ������������. 
--������� Emp ����� �������������� ������� mstat (�������� ���������), Nchild (���������� ������������������ �����).  
--����������� ������ Oracle.  ��������� ������� EDU4.sql �� ����������.
--������� � ��� ������ ���� ���, ����� ������, �����. �������� ������� ��������, ������ 3, ���� 4.      
--���� � ������� � ���������� ������������ �������� ���� ������� ��������, ��������� ���� �������� ����� ������� 1-5.
--���� ������ ��������� �������� ��������  � ���������� ������������, � ����������� .txt � ����������� � �������  fpmi-serv604\comman_stud\��������\���\������_.                  .

--1. �������� �������, ������� ��� ���������� ��� ���������� ������ � ������� EMP 
-- ������ �������� �������� � �������� �� ������:
--a) ���� ��� ���������� � �������� ���������� ������ (s)  � ������� Nchild ����������� ������, �������� �� NULL ��� 0;
--b) ���� ��� ������ ���������� ����������� ������������� ���������� �����.

CREATE OR REPLACE TRIGGER emp_trigger1
BEFORE INSERT OR UPDATE ON emp
FOR EACH ROW
BEGIN
  IF (:new.mstat = 's' AND NOT(:new.nchild IS NULL OR :new.nchild = 0))
  THEN RAISE_APPLICATION_ERROR(-20042, 'Number of children must be 0 or NULL for single person!');
  END IF;
  
  IF (:new.nchild < 0)
  THEN RAISE_APPLICATION_ERROR(-20420, 'Number of children can not be less than zero!');
  END IF;
END;

--2. �������� �������, ������� ��� ���������� ��� ���������� ������ � ������� EMP ������:
--a) ������������ ������� ������� ������� 0,
-- ���� ��� ���������� � �������� ���������� ������ (s)  � ������� Nchild ����������� ������, �������� �� NULL ��� 0;
--b) ������������ ������� ������� NULL,
--���� ��� ������ ���������� ����������� ������������� ���������� �����.

CREATE OR REPLACE TRIGGER emp_trigger2
BEFORE INSERT OR UPDATE ON emp
FOR EACH ROW
BEGIN
  IF (:new.mstat = 's' AND NOT(:new.nchild IS NULL OR :new.nchild = 0))
  THEN :new.nchild := 0;
  END IF;
  
  IF (:new.nchild < 0)
  THEN :new.nchild := NULL;
  END IF;
END;

--3. �������� �������, ������� ��� ���������� ������ � ������� EMP 
--������ �������� �������� � �������� �� ������, ���� ��� �����������, ����������� � ����� (m) � ������� Nchild 
--����� �������� ���������� �� �������� ����� ��� �� 1.

CREATE OR REPLACE TRIGGER emp_trigger3
BEFORE UPDATE ON emp FOR EACH ROW
BEGIN
  IF (:new.mstat = 'm' AND ABS(:new.nchild - :old.nchild) > 1)
  THEN RAISE_APPLICATION_ERROR(-20402, 'It is forbidden to change amount of the children more than 1!');
  END IF;
END;

--4. ������� �������, ������� �������� ����� �������� (����������, ���������, ��������) � �������� (������� bonus) 
-- ������������ � ��������� ������ � ����������� ����������� � �������� �� ������.

CREATE OR REPLACE TRIGGER bonus_trigger4
BEFORE INSERT OR UPDATE OR DELETE ON bonus
FOR EACH ROW
DECLARE
  careers INTEGER;
BEGIN
  SELECT COUNT(*) into careers FROM career
  WHERE empno = :new.empno and enddate IS NULL;

  IF careers = 0
  THEN RAISE_APPLICATION_ERROR(-20228, 'The employee does not work anymore!');
  END IF;
END;

--5. �������� �������, ������� �� ���������� �������� (�������, ����������, ��������) � �������� job
--������ ������ � ������� temp_table, � ��������� �������� �������� (delete, update, insert) ��������������� �������.

CREATE OR REPLACE TRIGGER job_trigger5
BEFORE INSERT OR UPDATE OR DELETE ON job
FOR EACH ROW
BEGIN
  IF INSERTING
  THEN INSERT INTO temp_table VALUES('insert');
  END IF;

  IF UPDATING
  THEN INSERT INTO temp_table VALUES('update');
  END IF;

  IF DELETING
  THEN INSERT INTO temp_table values('delete');
  END IF;
END;
