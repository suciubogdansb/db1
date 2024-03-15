create database t2;

create table clients (
    id int not null primary key identity (1,1),
    name varchar(50) not null,
);

create table projects (
    id int not null primary key identity (1,1),
    name varchar(50) not null,
    client_id int not null references clients(id)
);

create table companies (
    id int not null primary key identity (1,1),
    name varchar(50) not null,
);

create table company_clients (
    id int not null primary key identity (1,1),
    company_id int not null references companies(id),
    client_id int not null references clients(id)
);

create table departments (
    id int not null primary key identity (1,1),
    type varchar(50) not null,
    company_id int not null references companies(id)
);

create table client_project_department
(
    id            int not null primary key identity (1,1),
    client_id     int not null references clients (id),
    project_id    int not null references projects (id),
    department_id int not null references departments (id),
);

create table employee
(
    id int not null primary key identity(1,1),
    name varchar(50) not null,
    title varchar(10) not null,
    department_id int not null references departments(id)
);

create or alter procedure task1 (@client_name varchar(50))
as
begin
    declare @client_id int = (select id from clients where name = @client_name);
    select p.name, com.name, em.name, em.title
    from client_project_department cpd
        inner join projects p on cpd.project_id = p.id
        inner join departments d on cpd.department_id = d.id
        inner join companies com on d.company_id = com.id
        inner join employee em on d.id = em.department_id
    where cpd.client_id = @client_id;
end

create or alter view task2
as
select department_id
from client_project_department
group by department_id
having count(distinct project_id) = (select max(t.nrproj)
                                     from (select count(distinct project_id) as nrproj
                                           from client_project_department
                                           group by department_id) as t);

create or alter function task3 (@r int, @n int)
returns int
as
begin
    declare @result int = 0;
    select @result = count(distinct k.client_id)
    from (select c.id as client_id, count(distinct cpd2.project_id) as nrproj, count(distinct cc.company_id) as nrcom
          from clients c
                inner join company_clients cc on c.id = cc.client_id
                inner join client_project_department cpd2 on c.id = cpd2.client_id
          group by c.id
        ) as k
    where k.nrproj = @n and k.nrcom > @r;
    return @result;
end

