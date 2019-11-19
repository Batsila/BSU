--������������ ����������� � ����  Oracle. 
--���������� �����  FPMI-stud\SUBFACULTY\��� ���\��������\������������\EDU3.sql  � ������� C:\TEMP .
--��������� ���� � ����������� �� �������� �������� � ���������� ������ ��� ���������� ������������. ������� Bonus ����� �������������� ������� tax (�����) �� ���������� null.  
--��������� ������ EDU3.sql �� ����������.
--������� � ��� ������ ���� ���, ����� ������, �����. ��� �������� ������� ��������, ������ 3, ���� 4.      
--���� � ������� � ���������� ������������ �������� ���� ������� ��������, ��������� ���� �������� ����� ������� 1a), 1b), 1c), 2), 3), 4).
--���� ������ ��������� �������� ��������  � ���������� ������������, � ����������� .txt � ����������� � �������  fpmi-serv604\comman_stud\��������\���\��_.
--��� ���������� ������� ����� � ������������ ��� ���������� ������ �� ������� � ��������� ��� � ������� Tax �������������� ������ ������� Bonus.
--����� ����������� �� ���������� �������: 
--����� ����� 9% �� �����������  � ������ ������, ���� ��������� ������ � ������ ���� �� ����� ���������������� ������ �� ��������� 500;
--����� ����� 12% �� �����������  � ������ ������, ���� ��������� ������ � ������ ���� �� ����� ���������������� ������ ������ 500, �� �� ��������� 1 000;
--����� ����� 15% �� �����������  � ������ ������, ���� ��������� ������ � ������ ���� �� ����� ���������������� ������  ������ 1 000.

--1.	��������� � ���� �������������� ����� ��������� ���������� ������ � ������� ��� � ������� Bonus:
--a) � ������� �������� ����� (loop) � ��������, ��������� if �/��� �������� case;
declare
cursor cursorbonvalue is
    select
      bonuscopy.empno, bonuscopy.month, bonuscopy.year, sum(bonus.bonvalue) as sumbonvalue
    from
      bonus bonuscopy 
    join bonus on bonus.empno = bonuscopy.empno 
        and bonus.year = bonuscopy.year 
        and bonus.month <= bonuscopy.month
    group by
      bonuscopy.empno, bonuscopy.month, bonuscopy.year;

  i cursorbonvalue % ROWTYPE;

  factor real := 0;
begin
  open cursorbonvalue;
  loop
    fetch cursorbonvalue into i;
    exit when cursorbonvalue % NOTFOUND;
    
	if i.sumbonvalue <= 500 then
	  factor := 0.09;
	elsif i.sumbonvalue <= 1000 then
	  factor := 0.12;
	else
	  factor := 0.15;
	end if;

    update bonus 
    set tax = bonvalue * factor 
    where empno = i.empno 
        and year = i.year 
        and month = i.month;
  end loop;
  close cursorbonvalue;
end;


--b)   � ������� ���������� ����� FOR;
declare
  cursor cursorbonvalue is
    select
      bonuscopy.empno, bonuscopy.month, bonuscopy.year, sum(bonus.bonvalue) as sumbonvalue
    from
      bonus bonuscopy 
    join bonus on bonus.empno = bonuscopy.empno 
        and bonus.year = bonuscopy.year 
        and bonus.month <= bonuscopy.month
    group by
      bonuscopy.empno, bonuscopy.month, bonuscopy.year;

  factor real := 0;
  
begin
  for i in cursorbonvalue
  loop
    
    if i.sumbonvalue <= 500 then
      factor := 0.09;
    elsif i.sumbonvalue <= 1000 then
	  factor := 0.12;
	else
      factor := 0.15;
    end if;

    update bonus 
    set tax = bonvalue * factor 
    where empno = i.empno 
        and year = i.year 
        and month = i.month;
        
  end loop;
end;


--c)   � ������� ������� � ����������, ��������� ����� ����������, ��� �������� ���������� ��������� �����. 
create or replace procedure Bonus_cour(employee in integer) is
  cursor cursorbonvalue (employee integer) is
    select
      bonuscopy.empno, bonuscopy.month, bonuscopy.year, sum(bonus.bonvalue) as sumbonvalue
    from
      bonus bonuscopy 
      join bonus on bonus.empno = bonuscopy.empno 
        and bonus.year = bonuscopy.year 
        and bonus.month <= bonuscopy.month
    where
      bonuscopy.empno = employee
    group by
      bonuscopy.empno, bonuscopy.month, bonuscopy.year;

  i cursorbonvalue % ROWTYPE;

  factor real := 0;
begin
  open cursorbonvalue(employee);
  loop
    fetch cursorbonvalue into i;
    exit when cursorbonvalue % NOTFOUND;
    
    if i.sumbonvalue <= 500 then
      factor := 0.09;
    elsif i.sumbonvalue <= 1000 then
	  factor := 0.12;
	else
      factor := 0.15;
    end if;

    update bonus 
    set tax = bonvalue * factor 
    where empno = i.empno 
        and year = i.year 
        and month = i.month;
        
  end loop;
  close cursorbonvalue;
end Bonus_cour;

  
--2.   �������� ������������ ��������� � ���� �������� Bonus_loop_if, Bonus_loop_case, Bonus_for, Bonus_cour(emp_par).
--a)
create or replace procedure Bonus_loop_if is
  cursor cursorbonvalue is
    select
      bonuscopy.empno, bonuscopy.month, bonuscopy.year, sum(bonus.bonvalue) as sumbonvalue
    from
      bonus bonuscopy 
    join bonus on bonus.empno = bonuscopy.empno 
        and bonus.year = bonuscopy.year 
        and bonus.month <= bonuscopy.month
    group by
      bonuscopy.empno, bonuscopy.month, bonuscopy.year;

  i cursorbonvalue % ROWTYPE;

  factor real := 0;
begin
  open cursorbonvalue;
  loop
    fetch cursorbonvalue into i;
    exit when cursorbonvalue % NOTFOUND;
    
	if i.sumbonvalue <= 500 then
	  factor := 0.09;
	elsif i.sumbonvalue <= 1000 then
	  factor := 0.12;
	else
	  factor := 0.15;
	end if;

    update bonus 
    set tax = bonvalue * factor 
    where empno = i.empno 
        and year = i.year 
        and month = i.month;
  end loop;
  close cursorbonvalue;
end Bonus_loop_if;

--b)
create or replace procedure Bonus_for is
  cursor cursorbonvalue is
    select
      bonuscopy.empno, bonuscopy.month, bonuscopy.year, sum(bonus.bonvalue) as sumbonvalue
    from
      bonus bonuscopy 
    join bonus on bonus.empno = bonuscopy.empno 
        and bonus.year = bonuscopy.year 
        and bonus.month <= bonuscopy.month
    group by
      bonuscopy.empno, bonuscopy.month, bonuscopy.year;

  factor real := 0;
  
begin
  for i in cursorbonvalue
  loop
    
    if i.sumbonvalue <= 500 then
      factor := 0.09;
    elsif i.sumbonvalue <= 1000 then
	  factor := 0.12;
	else
      factor := 0.15;
    end if;

    update bonus 
    set tax = bonvalue * factor 
    where empno = i.empno 
        and year = i.year 
        and month = i.month;
        
  end loop;
end Bonus_for;


--c)
create or replace procedure Bonus_cour(employee in integer) is
  cursor cursorbonvalue (employee integer) is
    select
      bonuscopy.empno, bonuscopy.month, bonuscopy.year, sum(bonus.bonvalue) as sumbonvalue
    from
      bonus bonuscopy 
      join bonus on bonus.empno = bonuscopy.empno 
        and bonus.year = bonuscopy.year 
        and bonus.month <= bonuscopy.month
    where
      bonuscopy.empno = employee
    group by
      bonuscopy.empno, bonuscopy.month, bonuscopy.year;

  i cursorbonvalue % ROWTYPE;

  factor real := 0;
begin
  open cursorbonvalue(employee);
  loop
    fetch cursorbonvalue into i;
    exit when cursorbonvalue % NOTFOUND;
    
    if i.sumbonvalue <= 500 then
      factor := 0.09;
    elsif i.sumbonvalue <= 1000 then
	  factor := 0.12;
	else
      factor := 0.15;
    end if;

    update bonus 
    set tax = bonvalue * factor 
    where empno = i.empno 
        and year = i.year 
        and month = i.month;
        
  end loop;
  close cursorbonvalue;
end Bonus_cour;


--3.   �������� ��������� Bonus_emp(perc1, perc2, perc3, emp_par), ���������� ������ � ������� ��� � ������� Bonus �� �� ����� ���������� ��� ����������� ����������. 
--� �������� ���������� �������� �������� ������ (�� 500, �� 501 �� 1000, ���� 1000), ����� ����������.
create or replace procedure Bonus_emp(perc1 in real, perc2 in real, perc3 in real, emp_par in integer) is
  cursor cursorbonvalue (emp_par integer) is
    select
      bonuscopy.empno, bonuscopy.month, bonuscopy.year, sum(bonus.bonvalue) as sumbonvalue
    from
      bonus bonuscopy 
    join bonus on bonus.empno = bonuscopy.empno 
        and bonus.year = bonuscopy.year 
        and bonus.month <= bonuscopy.month
    where
      bonuscopy.empno = emp_par
    group by
      bonuscopy.empno, bonuscopy.month, bonuscopy.year;

  i cursorbonvalue % ROWTYPE;

  perc real := 0;
begin
  open cursorbonvalue(emp_par);
  loop
    fetch cursorbonvalue into i;
    exit when cursorbonvalue % NOTFOUND;
    if i.sumbonvalue <= 500 then
	  perc := perc1;
    elsif i.sumbonvalue <= 1000 then
	  perc := perc2;
	else
	  perc := perc3;
	end if;

    update bonus 
    set tax = bonvalue * perc 
    where empno = i.empno 
        and year = i.year 
        and month = i.month;
  end loop;
  close cursorbonvalue;
end Bonus_emp;


--4.   �������� ������� Bonus_summ(perc1, perc2, perc3, emp_par), ����������� ��������� ����� �� ������ ���������� �� �� ����� ����������. 
--� �������� ���������� �������� ������� ������ (�� 500, �� 501 �� 100 , ���� 1000), ����� ����������.
-- ������������ �������� � ��������� �����.
create or replace function Bonus_summ (perc1 in real, perc2 in real, perc3 in real, emp_par in integer) return real is
  cursor cursorbonvalue (emp_par integer) is
    select
      bonuscopy.empno, bonuscopy.month, bonuscopy.year, sum(bonus.bonvalue) as sumbonvalue, avg(bonus.bonvalue) as avgbonvalue
    from
      bonus bonuscopy 
      join bonus on bonus.empno = bonuscopy.empno 
        and bonus.year = bonuscopy.year 
        and bonus.month <= bonuscopy.month
    where
      bonuscopy.empno = emp_par
    group by
      bonuscopy.empno, bonuscopy.month, bonuscopy.year;

  i cursorbonvalue % ROWTYPE;
  perc real := 0;
  bonus_sum real := 0;
begin
  open cursorbonvalue (emp_par);
  loop
    fetch cursorbonvalue into i;
    exit when cursorbonvalue % NOTFOUND;
	
    if i.sumbonvalue <= 500 then
	  perc := perc1;
    elsif i.sumbonvalue <= 1000 then
	  perc := perc2;
	else
	  perc := perc3;
	end if;
	bonus_sum := bonus_sum + i.avgbonvalue * perc;
  end loop;
  close cursorbonvalue;
  return bonus_sum;
end Bonus_summ;
 


  
    