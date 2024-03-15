create database t4;


create table clients (
    id int primary key identity (1,1),
    name varchar(20),
    project varchar(20)
)

alter table clients
drop column project;

create table project(
    client_id int references clients(id),
    department int references department(id),
    name varchar(20),
)

create table company(
    id int primary key identity (1,1),
    name varchar(20)
)

create table clients_company(
    client_id int references clients(id),
    company_id int references company(id)
)

create table department(
    id int primary key identity (1,1),
    name varchar(20),
    type varchar(20),
    company_id int references company(id)
)

create table employee(
    id int primary key identity (1,1),
    name varchar(20),
    title varchar(20),
    department_id int references department(id)
)

create or alter procedure task1 (@client_name varchar(20)) as
begin
    declare @client_id int = (select id from clients where name = @client_name)
    select p.name, com.name, em.name, em.title
    from project p inner join department d on d.id = p.department
        inner join company com on com.id = d.company_id
        inner join employee em on d.id = em.department_id
    where p.client_id = @client_id
end;

create or alter view task2 as
    select com.name comName, c.name cliName, d2.name depName
    from company com
        inner join clients_company cc on com.id = cc.company_id
        inner join clients c on c.id = cc.client_id
        inner join project p2 on c.id = p2.client_id
        inner join department d2 on d2.id = p2.department;

create or alter function task3 ()
    returns @result table (cname varchar(20), emname varchar(20))
as
begin
    insert into @result
    select c.name cname, em.name emname
    from clients c
        inner join project p3 on c.id = p3.client_id
        inner join department d3 on d3.id = p3.department
        inner join employee em on d3.id = em.department_id
    where c.id in (select c1.client_id
                   from clients_company c1
                   group by c1.client_id
                   having count(distinct c1.company_id) > 1)
    return
end
go
