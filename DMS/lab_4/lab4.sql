--Лабораторная выполняется в СУБД  Oracle. 
--Cкопируйте файл  FPMI-stud\SUBFACULTY\каф ИСУ\Исаченко\Лабораторные2019\EDU4.sql  в каталог C:\TEMP .
--Раскройте файл и ознакомтесь со скриптом создания и заполнения таблиц для выполнения лабораторной. 
--Таблица Emp имеет дополнительные столбцы mstat (семейное положение), Nchild (количество несовершеннолетних детей).  
--Произведите запуск Oracle.  Запустите скрипты EDU4.sql на выполнение.
--Вставте в эту строку Ваши ФИО, номер группы, курса. ФИО Анищенко Арсений Игоревич, группа 3, курс 4.      
--Файл с отчётом о выполнении лабораторной создаётся путём вставки скриптов, созданных Вами программ после пункта 1.
--Файл отчёта именуется фамилией студента  в английской транскрипции, с расширением .txt и сохраняется в каталог  fpmi-serv604\comman_stud\исаченко\Лаб\Гр_                   .

--1. Создайте пакет PackLab, включающий в свой состав процедуру ProcChild и функцию FuncEmpChild. Процедура должна вычислять ежегодную добавку к 
--зарплате сотрудников на детей за 2017 год и заносить её в виде дополнительной премии в последнем месяце (декабре)  2017
--года в поле Bonvalue таблицы Bonus. 
--В качестве параметров процедуре передаются проценты в зависимости от количества детей (см. правило начисления добавки).
--Функция должна вычислять ежегодную добавку за 2016 год на детей к  зарплате конкретного сотрудника (номер сотрудника - параметр передаваемый функции) без занесения в таблицу.

--ПРАВИЛО ВЫЧИСЛЕНИЯ ДОБАВКИ

--Добавка к заработной плате на детей  вычисляется только для работавших в декабре (хотя бы один день) 2016 году сотрудников по следующему правилу: 
--добавка равна X% от суммы должностного месячного оклада (поле minsalary таблицы job) по занимаемой в декабре 2016 года должности и всех начисленных за 2016 год премий (поле bonvalue таблицы bonus), где:
--X% равны X1% , если сотрудник имеет одного ребёнка;
--X% равны X2% , если сотрудник имеет двух детей;
--X% равны X3% , если сотрудник имеет трёх и более детей.
--X1%<X2%<X3%  являются передаваемыми процедуре и функции параметрами . Кроме этого, функции в качестве параметра передаётся номер сотрудника (empno). 

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



