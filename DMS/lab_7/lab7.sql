--������������ ����������� � ����  Oracle. 
--C��������� ����  FPMI\SERV314\SUBFACULTY\��� ���\��������\������������\EDU7.sql  � ������� C:\TEMP .
--��������� ���� � ����������� �� �������� �������� � ���������� ������ ��� ���������� ������������. 
--���� ������ ����� �������������� ������� t_error.  
--����������� ������ Oracle.  ��������� ������� EDU7.sql �� ����������.
--������� � ��� ������ ���� ���, ����� ������, �����. �������� ������� ��������, ������ 3, ���� 4.      
--���� � ������� � ���������� ������������ �������� ���� ������� ��������, ��������� ���� �������� ����� ������� 1, 2.
--���� ������ ��������� �������� ��������  � ���������� ������������, � ����������� .txt � ����������� � �������  fpmi-serv604\comman_stud\��������\������3                  .

--1a. ������� PL/SQL-�����, ���������� ��������� ���������:
/*declare
     empnum integer; 
     begin
      insert into bonus values (505,15, 2018, 500, null);
end;/*

/*declare
     empnum integer; 
     begin
      insert into job values (1010, 'Accountant xxxxxxxxxx',5500);
end;/*

/*declare
     empnum integer; 
     begin
      select empno into empnum from emp where empno=505 or empno=403;
end;/*
--�������� ������������ ������� �������� ��������������� ���������� �� ������ ����������������
--����� � ����������. 
--��������� ����� ��������� ��������� �������������� ��������. 
--��������� ������ �������� ������� � ��������� � ������� t_error ��������������� ���� ������, 
--��������� �� ������ � ������� ���� � �������, ����� ������ ���������.

DECLARE
  error_code INTEGER;
  error_message VARCHAR(100);
BEGIN
  INSERT INTO bonus VALUES (505, 15, 2018, 500, NULL);

  EXCEPTION WHEN OTHERS THEN error_code := SQLCODE;
    error_message := SUBSTR(SQLERRM, 1, 100);
    INSERT INTO T_ERROR VALUES (error_code, error_message, SYSDATE);
END;
/
DECLARE
  error_code INTEGER;
  error_message VARCHAR(100);
BEGIN
  INSERT INTO job VALUES (1010, 'Accountant xxxxxxxxxx', 5500);

  EXCEPTION WHEN OTHERS THEN error_code := SQLCODE;
    error_message := SUBSTR(SQLERRM, 1, 100);
    INSERT INTO T_ERROR VALUES (error_code, error_message, SYSDATE);
END;
/
DECLARE
  emp_num INTEGER;
  error_code INTEGER;
  error_message VARCHAR(100);
BEGIN
  SELECT empno INTO emp_num FROM emp
    WHERE empno = 505 OR empno = 403;

  EXCEPTION WHEN OTHERS THEN error_code := SQLCODE;
    error_message := SUBSTR(SQLERRM, 1, 100);
    INSERT INTO T_ERROR VALUES (error_code, error_message, SYSDATE);
END;

--1b. �������� ����������� �������������� �������� � ����� -26000 � ���������� 
--'January bonus greater February bonus' ��� 'February bonus greater March bonus' � ����������� �� ������,
--������ �� ������� ������� ��������.
--�������������� �������� ��������� ��� ��������� ������-�������: "����� ������, ����������� 
--� ���������� ������ 2018 ����, �� ����� ���� ������ ����� ������, ����������� � ���������� 
--����� ����� �� ����".
--����� ������� ��������������� ������ ������, ������� � ���� 2018 ����.
--�������� ���� � �����������, ����������� ��������� ������-������� � ��������� �������������� ��������.
--��� ����������� ��������������� �������������� �������� ��������� ������� � ��������� ������ � ��� 
--(���������� ������� 1a) � ������� t_error.    
 
DECLARE
  CURSOR total_bonus_by_month (year INTEGER) IS
  SELECT MONTH, SUM(bonvalue) AS bonvalue FROM bonus
  WHERE YEAR = year GROUP BY MONTH ORDER BY MONTH;

  prev_month_bonus REAL := 0;
  prev_month INTEGER := 0;
  prev_month_name VARCHAR(20);
  curr_month_name VARCHAR(20);
  error_code INTEGER;
  error_message VARCHAR(100);
BEGIN
  FOR i IN total_bonus_by_month(2018)
    LOOP
      IF ((prev_month = i.month - 1) AND (prev_month_bonus > i.bonvalue)) THEN
        SELECT TO_CHAR(TO_DATE(i.month - 1, 'MM'), 'MONTH')
        INTO prev_month_name FROM DUAL;

        SELECT TO_CHAR(TO_DATE(i.month, 'MM'), 'MONTH')
        INTO curr_month_name FROM DUAL;

        RAISE_APPLICATION_ERROR(-26000, prev_month_name || 'bonus greater ' || curr_month_name || 'bonus');
      END IF;

      prev_month_bonus := i.bonvalue;
      prev_month := i.month;
    END LOOP;

    EXCEPTION WHEN OTHERS THEN error_code := SQLCODE;
      error_message := SUBSTR(SQLERRM, 1, 100);
      INSERT INTO T_ERROR VALUES (error_code, error_message, SYSDATE);
END;