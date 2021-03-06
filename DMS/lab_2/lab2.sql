--�������� ���� Oracle ��� ���������� ������������. 
--���������� �����  FPMI-stud\SUBFACULTY\��� ���\��������\���2019\EDU2.sql � ������� C:\TEMP .
--��������� ���� � ����������� �� �������� �������� � ���������� ������ ��� ���������� ������������.
--��������� ������� EDU1.sql, EDU2.sql �� ����������.
--������� � ��� ������ ���� ���, ����� ������, �����. �������� ������� ��������, ������ 3, ���� 4.      
--���� � ������� � ���������� ������������ �������� ���� ������� ��������������� ����������� ����� ������ � ������� �������. 
--���� ������ ��������� �������� ��������  � ���������� ������������, � ����������� .txt � ����������� � ������� FPMI-serv604\Common-stud\��������\���\��_3\Anishchanka.txt.
--������ �������:

--1. ��������� ������ ������� ����������� ���������� ����� � ������� JOB �� 50 ������.
UPDATE job
SET minsalary = minsalary + 50;
rollback;

--2. ��������� ����������� �������� � ������� JOB �� 15%  ��� ���� ����������, ����������� �������� ��� ������� �� ��������� 1500 ������..	
UPDATE job
SET minsalary = minsalary * 1.15
WHERE minsalary <= 1500;
rollback;

--3. ��������� ����������� �������� � ������� JOB �� 10% ��� ��������� (Driver) � �������� ����������� �������� ��� �������������� ���������� (Executive Director) �� 10%  (����� ����������).
UPDATE job
SET minsalary = CASE
                    WHEN jobname = 'Driver' THEN minsalary * 1.1
                    WHEN jobname = 'Executive Director' THEN minsalary * 0.9
                    ELSE minsalary
                END
WHERE jobname = 'Driver' OR jobname = 'Executive Director';
rollback;

--4. ���������� ����������� �������� ������ (Clerk) ������ �������� �� ��������  ����������� ��������� ( Financial Director}.
UPDATE job
SET minsalary =
  (SELECT minsalary FROM job
    WHERE jobname = 'Financial Director' ) * 0.5
WHERE jobname = 'Clerk';
rollback;

--5. ��������� � ������� EMP ����� � ������� ��������, ����� ������� ���������� �� ����� 'D', �J� � �R�, ��������� � �������� ��������.
UPDATE emp
SET empname = upper(empname)
WHERE substr(empname, 1, 1) IN ('D', 'J', 'R');
rollback;

--6. ��������� � ������� EMP ����� � ������� ��������, ����� ������� ���������� �� ����� 'A', �D� � �O�, ��������� � ������� ��������.
UPDATE emp
SET empname = lower(empname)
WHERE substr(empname, 1, 1) IN ('A', 'D', 'O');
rollback;

--7. ��������� � ������� EMP ����� � ������� ��������, � ������� Jon,  Ivan , ��������� � ������� ��������.
UPDATE emp
SET empname = lower(empname)
WHERE substr(empname, 1, 4) = 'Jon ' OR substr(empname, 1, 5) = 'Ivan ';
rollback;

--8. ������� � ������� EMP ������ ������� ����������� (����� �������).
UPDATE emp
SET empname = substr(empname, instr(empname, ' ') + 1);
rollback;

--9. ���������� ����� ������ (Sales) �� ������ ������ � ����� C02. 
UPDATE dept
SET deptaddress =
  ( SELECT deptaddress
   FROM dept
   WHERE deptid = 'C02' )
WHERE deptname = 'Sales';
rollback;

--10. �������� ������ ���������� � ������� EMP. ��� ����� �����  900, ��� � ������� �Frank Hayes�, ���� �������� �12-09-1978�.	
INSERT INTO emp
VALUES(900, 'Frank Hayes', to_date('12-09-1978','dd-mm-yyyy'));

--11. ���������� ������ ���������� (��. ���������� �������) �� ������ � ���������������� ����� (Administration) � ������� 'USA, San-Diego', ������� � ������� ���� � ��������� �������� (Driver).
INSERT INTO emp
VALUES(900,
       'Frank Hayes',
       to_date('12-09-1978','dd-mm-yyyy'));
rollback;

--12. ������� ��� ������ �� ������� TMP_EMP. �������� � ��� ���������� � �����������, ������� �������� ���������� (Engineer) ��� �������������� (Programmer) � ��������� ������.
DELETEFROM tmp_emp;
INSERT INTO tmp_emp (empno, empname, birthdate)
  ( SELECT emp.empno,
           emp.empname,
           emp.birthdate
   FROM emp
   JOIN ( career
         JOIN job ON career.jobno = job.jobno ) ON emp.empno = career.empno
   WHERE career.enddate IS NULL
     AND (job.jobname = 'Engineer'
          OR job.jobname = 'Programmer') );
rollback;

--13. �������� � ������� TMP_EMP ���������� � ��� �����������, ������� �����������, �� ����� ����� ����������� �� ������ � �������� �� ����������� � ��������� ������.
INSERT INTO tmp_emp (empno, empname, birthdate)
  (SELECT empno,empname,birthdate FROM emp
   WHERE empno IN (
                     (SELECT empno FROM career
                      WHERE enddate IS NULL) INTERSECT
                     (SELECT empno FROM career
                      WHERE enddate IS NOT NULL))
     AND empno NOT IN
       (SELECT empno FROM tmp_emp));
rollback;

--14. �������� � ������� TMP_EMP ���������� � ��� �����������, ������� ���� ������� � �� �������� �� ����������� � ��������� ������.
INSERT INTO tmp_emp (empno, empname, birthdate)
  (SELECT empno,empname,birthdate FROM emp
   WHERE empno NOT IN (
                         (SELECT empno FROM career
                          WHERE career.enddate IS NULL) INTERSECT
                         (SELECT empno FROM tmp_emp)));
rollback;

--15. ������� ��� ������ �� ������� TMP_JOB � �������� � ��� ���������� �� ��� ����������, �� ������� �������� ����� ��� ��������  �  ��������� ������.
DELETE FROM tmp_emp;
INSERT INTO tmp_job (jobno, jobname, minsalary)
  (SELECT job.jobno,jobname,minsalary FROM job
   JOIN career ON job.jobno = career.jobno
   WHERE career.enddate IS NULL
   GROUP BY job.jobno,jobname,minsalary
   HAVING count(DISTINCT career.empno) = 2);
rollback;

--16. ������� ��� ���������� � ����������� ������ �����������, ������� � ��������� ������ ��� �� �������� �� �����������.
DELETE FROM bonus
WHERE empno NOT IN
    (SELECT empno FROM career
        WHERE enddate IS NULL);
rollback;

--17. ��������� ������ � ������� 20% ������������ ������������ ������ ���� �����������, ���������� �� �����������. 
--�������� ��������� �� ���������, ���������� ����������� � ��������� ������ � ������� �� �� ������� �����.
INSERT INTO bonus
  (SELECT career.empno, extract(MONTH FROM CURRENT_DATE), extract(YEAR FROM CURRENT_DATE), job.minsalary * 0.2 FROM career
   JOIN job ON career.jobno = job.jobno
   WHERE enddate IS NULL);
rollback;

--18. ������� ������ � �������  �� ��� ���� �� 2015 ������������.	
DELETE FROM bonus
    WHERE YEAR <= 2015;
rollback;

--19. ������� ���������� � ������� ������� ��� �����������, ������� � ��������� ������  �������� �� �����������.
DELETE FROM career
WHERE enddate IS NOT NULL
  AND empno IN
    (SELECT empno FROM career
        WHERE enddate IS NULL);
rollback;

--20. ������� ������ �� ������� EMP ��� ��� �����������, ������� �� �������� �� ����������� � ��������� ������.
DELETE FROM career
WHERE empno NOT IN
    (SELECT DISTINCT empno FROM career
        WHERE enddate IS NULL);
DELETE FROM bonus
WHERE empno NOT IN
    (SELECT DISTINCT empno FROM career 
        WHERE enddate IS NULL);
DELETE FROM emp
WHERE empno NOT IN
    (SELECT DISTINCT empno FROM career
        WHERE enddate IS NULL);
rollback;