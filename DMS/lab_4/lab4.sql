--������������ ����������� � ����  Oracle. 
--C��������� ����  FPMI-stud\SUBFACULTY\��� ���\��������\������������2019\EDU4.sql  � ������� C:\TEMP .
--��������� ���� � ����������� �� �������� �������� � ���������� ������ ��� ���������� ������������. 
--������� Emp ����� �������������� ������� mstat (�������� ���������), Nchild (���������� ������������������ �����).  
--����������� ������ Oracle.  ��������� ������� EDU4.sql �� ����������.
--������� � ��� ������ ���� ���, ����� ������, �����. ��� �������� ������� ��������, ������ 3, ���� 4.      
--���� � ������� � ���������� ������������ �������� ���� ������� ��������, ��������� ���� �������� ����� ������ 1.
--���� ������ ��������� �������� ��������  � ���������� ������������, � ����������� .txt � ����������� � �������  fpmi-serv604\comman_stud\��������\���\��_                   .

--1. �������� ����� PackLab, ���������� � ���� ������ ��������� ProcChild � ������� FuncEmpChild. ��������� ������ ��������� ��������� ������� � 
--�������� ����������� �� ����� �� 2017 ��� � �������� � � ���� �������������� ������ � ��������� ������ (�������)  2017
--���� � ���� Bonvalue ������� Bonus. 
--� �������� ���������� ��������� ���������� �������� � ����������� �� ���������� ����� (��. ������� ���������� �������).
--������� ������ ��������� ��������� ������� �� 2016 ��� �� ����� �  �������� ����������� ���������� (����� ���������� - �������� ������������ �������) ��� ��������� � �������.

--������� ���������� �������

--������� � ���������� ����� �� �����  ����������� ������ ��� ���������� � ������� (���� �� ���� ����) 2016 ���� ����������� �� ���������� �������: 
--������� ����� X% �� ����� ������������ ��������� ������ (���� minsalary ������� job) �� ���������� � ������� 2016 ���� ��������� � ���� ����������� �� 2016 ��� ������ (���� bonvalue ������� bonus), ���:
--X% ����� X1% , ���� ��������� ����� ������ ������;
--X% ����� X2% , ���� ��������� ����� ���� �����;
--X% ����� X3% , ���� ��������� ����� ��� � ����� �����.
--X1%<X2%<X3%  �������� ������������� ��������� � ������� ����������� . ����� �����, ������� � �������� ��������� ��������� ����� ���������� (empno). 

create or replace package PackLab as
  function FuncEmpChild(employee in integer, x1 in real, x2 in real, x3 in real) return real;
  procedure ProcChild(x1 in real, x2 in real, x3 in real);
end PackLab;
/
create or replace package body PackLab as
  function FuncEmpChild(employee in integer, x1 in real, x2 in real, x3 in real) return real is
    bonusearnings real := 0;
    salaryearnings real := 0;
    totalearnings real := 0;
    children integer := 0;
    childBonvalue real := 0;
  begin
    begin
      select
        nvl(sum(nvl(bonvalue, 0)), 0)
      into
        bonusearnings
      from
        bonus
      where
          empno = employee
        and
          bonus.year = 2016
      group by
        empno;
    exception when no_data_found then
      bonusearnings := 0;
    end;

    begin
      select
        nvl(sum(nvl(minsalary, 0)), 0)
      into
        salaryearnings
      from
        career join job on job.jobno = career.jobno
      where
        (
          career.empno = employee
        ) and (
          extract(year from career.startdate) <= 2016
        ) and (
          (
            career.enddate is null
          ) or (
            (
              extract(year from career.enddate) = 2016
            ) and (
              extract(month from career.enddate) = 12
            )
          ) or (
            extract(year from career.enddate) > 2016
          )
        )
      group by
        career.empno;
    exception when no_data_found then
      salaryearnings := 0;
    end;
    
    begin
      select nchild into children from emp where empno = employee;
    exception when no_data_found then
      children := 0;
    end;
    
    totalearnings := bonusearnings + salaryearnings;
    
    if children = 1 then
      childBonvalue := totalearnings * x1 / 100;
    elsif children = 2 then
      childBonvalue := totalearnings * x2 / 100;
    elsif children > 2 then
      childBonvalue := totalearnings * x3 / 100;
    end if;

    return childBonvalue;
  end FuncEmpChild;

  procedure ProcChild(x1 in real, x2 in real, x3 in real) is
    cursor cusrorChildBonvalue is
      select
        salaryempno,
        nvl(salaryearnings, 0) + nvl(bonusearnings, 0)
      from
        (
          select
            career.empno as salaryempno,
            nvl(sum(nvl(minsalary, 0)), 0) as salaryearnings
          from
            career join job on job.jobno = career.jobno
          where
            (
              extract(year from career.startdate) <= 2016
            ) and (
              (
                career.enddate is null
              ) or (
                (
                  extract(year from career.enddate) = 2016
                ) and (
                  extract(month from career.enddate) = 12
                )
              ) or (
                extract(year from career.enddate) > 2016
              )
            )
          group by
            career.empno
        ) left outer join (
          select
            empno as bonusempno,
            nvl(sum(nvl(bonvalue, 0)), 0) as bonusearnings
          from
            bonus
          where
            bonus.year = 2017
          group by
            empno
        ) on salaryempno = bonusempno;

    employee integer := 0;
    earnings real := 0;
    children integer := 0;
    childBonvalue real := 0;
  begin
    open cusrorChildBonvalue;
    loop
      fetch cusrorChildBonvalue into employee, earnings;
      exit when cusrorChildBonvalue % notfound;
      select nchild into children from emp where empno = employee;
      
      if (children > 0) then
          if children = 1 then
          childBonvalue := earnings * x1 / 100;
        elsif children = 2 then
          childBonvalue := earnings * x2 / 100;
        elsif children > 2 then
          childBonvalue := earnings * x3 / 100;
        end if;

        insert into bonus values (employee, 12, 2017, childBonvalue, null);
      end if;
      end loop;
    close cusrorChildBonvalue;
  end ProcChild;
end PackLab;
/
begin
    PackLab.ProcChild(0.3, 0.4, 0.5);
end;
/
begin
    declare test real;
    begin
        test := PackLab.FuncEmpChild(101, 0.3, 0.4, 0.5); 
        dbms_output.put_line(test);
    end;
end;



