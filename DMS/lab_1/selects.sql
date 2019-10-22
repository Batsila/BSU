--�������� ���� Oracle ��� ���������� ������������. 
--C��������� ����  FPMI-stud\SUBFACULTY\������\��������\�������II\EDU1.sql � ������� C:\TEMP.
--��������� ���� � ����������� �� �������� �������� � ���������� ������ ��� ���������� ������������.
-- ����������� ������ SQLPlus. ��� PLSQLDeveloper. ��� ������� �������������� Oracle b ����������� � ��. ��������� ������ EDU.sql �� ����������.
--������� � ��� ������ ���� ���, ����� ������, �����. ��� �������� ������� ��������, ������ 3, ���� 4.      
--���� � ������� � ���������� ������������ �������� ���� ������� ��������������� select-����������� ����� ������ � ������� �������. 
--���� ������ ��������� �������� ��������  � ���������� ������������, � ����������� .txt � ����������� � ������� fpmi-serv604\common-stud\��������\���1\��_3\Anishchanka.txt.
--������ �������:

--1.	������ ���������� �� ������ ������ ������ (Sales) ��������.
SELECT deptaddress FROM dept
WHERE deptname = 'Sales';
	
--2.	������ ���������� ��� ���� ����������, ���������� �� ����� 1 ������ 1985 ����.
SELECT * FROM emp
WHERE birthdate >= to_date('01-01-1985', 'dd-mm-yyyy');

--3.	����� ����������� �����, ��������������� ��� ��������  (Driver).
SELECT minsalary FROM job
WHERE jobname = 'Driver';

--4.	���������� ����� ����������, ���������� � �������� �����  31 ��� 2017 ���� ���� �� ���� ���� (31 ��� 2017 ���� �� ����������).
SELECT count(DISTINCT empno)
FROM career
WHERE (startdate > to_date('31-05-2017','dd-mm-yyyy')
       AND (startdate < enddate or enddate IS NULL));

--5.	����� ����������� ������, ����������� � 2014, 2015, 2016, 2017 ����� (������� ��� � �����������. ������ � ��������������� �������). 	
SELECT YEAR,min(bonvalue) FROM bonus
WHERE (YEAR > 2013 AND YEAR < 2018)
GROUP BY YEAR
ORDER BY YEAR;

--6.	������ ���������� � ����� ���� ����������,  �� ������� �������� �������� Nina Tihanovich. ���� Nina Tihanovich �������� � ��������� ����� - ��������� ����� ���������� � ������� ������.
SELECT DISTINCT career.jobno
FROM career
INNER JOIN emp ON emp.empno = career.empno
WHERE (emp.empname = 'Nina Tihanovich');

--7.	������ ���������� � ��������� ����������,  �� ������� �������� ��������� Richard Martin � Jon Martin. ���� ���� �� ��� ��� ���  �������� � ��������� ����� - ��������� ����� ���������� � ������� ������. ��������� ������� ������ � ��� (empname) ���������.
SELECT DISTINCT career.jobno,job.jobname,emp.empname FROM career
INNER JOIN emp ON emp.empno = career.empno
INNER JOIN job ON job.jobno = career.jobno
INNER JOIN emp ON emp.empno = career.empno
WHERE (emp.empname = 'Richard Martin' or emp.empname = 'Jon Martin');

--8.	����� �������, ���� ���������� � ������� ������ (���� ������ � ���� ����������) ��� ���� ������� (Clerk) � ��������� (Driver), ���������� ��� ���������� � ��������. ��� ���������� ���� ���������� ��� ������� ������������ � ��� ������ ���� ����������, ���� ������������ ��� Null.
SELECT emp.empname,job.jobno,career.startdate,career.enddate FROM career
INNER JOIN emp ON emp.empno = career.empno
INNER JOIN job ON job.jobno = career.jobno
WHERE (job.jobname = 'Clerk' or job.jobname = 'Driver');

--9.	����� �������, �������� ���������� � ������� ������ (���� ������ � ���� ����������) ��� ����������� (Accountant) � �������������� ���������� (Executive Director),  ���������� ��� ���������� � ��������. ��� ���������� ���� ���������� ��� ������� ������������ � ��� ������ ���� ����������, ���� ������������ ��� Null.
SELECT emp.empname,job.jobname,career.startdate,career.enddate FROM career
INNER JOIN emp ON emp.empno = career.empno
INNER JOIN job ON job.jobno = career.jobno
WHERE (job.jobname = 'Accountant' or job.jobname = 'Executive Director');

-- 10.	����� ���������� ��������� ����������, ���������� � ������ B02 � ������ � 01.01.2014 �� 31.12.2017 ���� �� ���� ����. 
SELECT count(DISTINCT empno)
FROM career
WHERE deptid = 'B02'
    AND startdate >= to_date('01.01.2014','dd.mm.yyyy')
    AND enddate <= to_date('31.12.2017','dd.mm.yyyy');

--11.	����� ������� ���� ����������.
SELECT DISTINCT emp.empname
FROM emp
INNER JOIN career ON emp.empno = career.empno
WHERE deptid = 'B02'
    AND startdate >= to_date('01.01.2014','dd.mm.yyyy')
    AND enddate <= to_date('31.12.2017','dd.mm.yyyy');

--12.	����� ������ � �������� �������, � ������� �� ���� �� ������ ��������� � ������ � 01.01.2015 �� 31.12.2015.
SELECT DISTINCT dept.deptid, dept.deptname FROM dept
INNER JOIN career ON career.deptid = dept.deptid
WHERE( SELECT count(*) FROM career
        WHERE (career.deptid = dept.deptid
            AND career.startdate >= to_date('01.01.2015','dd-mm-yyyy')
            AND career.enddate <= to_date('31.12.2015','dd-mm-yyyy'))) = 0;

--13.	����� ���������� � ���������� (�����, �������), ��� ������� ��� ���������� ������ � ������ � 01.01. 2014 ��  31.12.2015.
SELECT DISTINCT emp.empno,
                emp.empname
FROM emp
LEFT OUTER JOIN bonus ON bonus.empno = emp.empno
WHERE
    ( SELECT count(*)
     FROM bonus
     WHERE bonus.empno = emp.empno
       AND bonus.year BETWEEN 2013 AND 2014 ) = 0;

--14.	����� ���������� ����������, ������� �� ���������� �� � ����������������� (Research) ������, �� � ������ ��������� (Support). 
SELECT count(DISTINCT emp.empno) FROM emp
LEFT OUTER JOIN career ON career.empno = emp.empno
INNER JOIN dept ON dept.deptid = career.deptid
WHERE ( SELECT count(*) FROM career
            WHERE career.empno = emp.empno
            AND (dept.deptname = 'Research'
            OR dept.deptname = 'Support') ) = 0;

--15.	����� ���� � ������� ����������, ���������� � ���� � ����� �������. ���� �������� �������� � ��������� �����, �� ����� ����� �����������.
SELECT DISTINCT emp.empno, emp.empname FROM emp
INNER JOIN career ON career.empno = emp.empno
WHERE (SELECT count(DISTINCT deptid) FROM career
           WHERE career.empno = emp.empno ) >= 2;

--16.	����� ���� � ������� ����������, ���������� �� ���� � ����� ����������. ���� �������� �������� � ��������� �����, �� ��������� ����� �����������.
SELECT DISTINCT emp.empno, emp.empname FROM emp
INNER JOIN career ON career.empno = emp.empno
WHERE (SELECT count(DISTINCT jobno) FROM career
          WHERE career.empno = emp.empno ) >= 2;

--17.	����� ����  � ������� ����������, ��������� ���� ������ ������� � �������� �� ����� 4 ���.
SELECT emp.empno, empname FROM emp
JOIN career ON emp.empno = career.empno
GROUP BY emp.empno, empname
HAVING sum(MONTHS_BETWEEN(NVL(enddate, current_date), startdate)) >= 4 * 12;

--18.	����� ���� ���������� (���� � �������), ������������� ���� �� ���� ���.
SELECT DISTINCT emp.empno,emp.empname FROM emp
INNER JOIN career ON career.empno = emp.empno
WHERE (SELECT count(*) FROM career 
           WHERE career.empno = emp.empno
           AND enddate IS NOT NULL ) > 0;

--19.	����� ������� ������, ����������� �� ������ � ��� 2014, 2015 ����, � �� ������ � ��� 2015, 2016 ����, � ������� ���������� (�.�. ��� ����������, ������� ���������� ���� �� � ����� ������ ������������ �������). ������� id, ��� � ������� ���������, ������, ������� ������.
SELECT avg(bonvalue), '2014, 2015' as years FROM bonus
WHERE year IN (2014, 2015) 
UNION
(SELECT avg(bonvalue), '2015, 2016' AS years
    FROM bonus
    WHERE year IN (2015, 2016));

--20.	����� ������ (id, ��������, �����), � ������� ���� ���������� ������ � ������� 2017 ����.
SELECT dept.deptid, deptname, deptaddress FROM dept
JOIN (career JOIN bonus ON career.empno = bonus.empno) ON dept.deptid = career.deptid
WHERE bonus.month = 2
  AND bonus.year = 2017
  AND startdate <= to_date('01-02-2017','dd-mm-yyyy')
  AND (enddate >= to_date('28-02-2017','dd-mm-yyyy') OR enddate IS NULL);