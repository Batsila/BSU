--лабораторная выполняется в СУБД  Oracle. 
--Скопируйте файлы  FPMI-stud\SUBFACULTY\каф ИСУ\Исаченко\Лабораторные\EDU3.sql  в каталог C:\TEMP .
--Раскройте файл и ознакомтесь со скриптом создания и заполнения таблиц для выполнения лабораторной. Таблица Bonus имеет дополнительный столбец tax (налог) со значениями null.  
--Запустите скрипт EDU3.sql на выполнение.
--Вставте в эту строку Ваши ФИО, номер группы, курса. ФИО Анищенко Арсений Игоревич, группа 3, курс 4.      
--Файл с отчётом о выполнении лабораторной создаётся путём вставки скриптов, созданных Вами программ после пунктов 1a), 1b), 1c), 2), 3), 4).
--Файл отчёта именуется фамилией студента  в английской транскрипции, с расширением .txt и сохраняется в каталог  fpmi-serv604\comman_stud\исаченко\Лаб\Гр_.
--Вам необходимо создать блоки и подпрограммы для начисления налога на прибыль и занесения его в столюец Tax соответсвующуй записи таблицы Bonus.
--Налог вычисляется по следующему правилу: 
--налог равен 9% от начисленной  в месяце премии, если суммарная премия с начала года до конца рассматриваемого месяца не превышает 500;
--налог равен 12% от начисленной  в месяце премии, если суммарная премия с начала года до конца рассматриваемого месяца больше 500, но не превышает 1 000;
--налог равен 15% от начисленной  в месяце премии, если суммарная премия с начала года до конца рассматриваемого месяца  больше 1 000.

--1.	Составьте в виде неименованного блока программу вычисления налога и вставки его в таблицу Bonus:
--a) с помощью простого цикла (loop) с курсором, оператора if и/или опретора case;
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


--b)   с помощью курсорного цикла FOR;
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


--c)   с помощью курсора с параметром, передавая номер сотрудника, для которого необходимо посчитать налог. 
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

  
--2.   Оформите составленные программы в виде процедур Bonus_loop_if, Bonus_loop_case, Bonus_for, Bonus_cour(emp_par).
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


--3.   Создайте процедуру Bonus_emp(perc1, perc2, perc3, emp_par), вычисления налога и вставки его в таблицу Bonus за всё время начислений для конкретного сотрудника. 
--В качестве параметров передать проценты налога (до 500, от 501 до 1000, выше 1000), номер сотрудника.
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


--4.   Создайте функцию Bonus_summ(perc1, perc2, perc3, emp_par), вычисляющую суммарный налог на премию сотрудника за всё время начислений. 
--В качестве параметров передать процент налога (до 500, от 501 до 100 , выше 1000), номер сотрудника.
-- Возвращаемое значение – суммарный налог.
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
 


  
    