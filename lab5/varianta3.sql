create database t3;

create table clients (
    id int not null primary key identity (1,1),
    name varchar(20)
)

create table brokers (
    id int not null primary key identity (1,1),
    name varchar(20)
)

create table clients_brokers(
    client_id int not null references clients(id),
    broker_id int not null references brokers(id),
)

alter table clients_brokers
add id int not null primary key identity (1,1);

create table stockExchange(
    id int not null primary key identity (1,1),
    name varchar(20)
)

create table broker_exchange(
    id int not null primary key identity (1,1),
    exchange_id int not null references stockExchange(id),
    broker_id int not null references brokers(id),
)

create table stock(
    contract_id int not null references clients_brokers(id),
    name varchar(20)
)

create table bond(
    contract_id int not null references clients_brokers(id),
    name varchar(20)
)

alter table bond
add exchange_id int not null references stockExchange(id);

create or alter procedure task1(@client_name varchar(20))
as
begin
    declare @client_id int = (select id from clients where name = @client_name)
    select *
    from (select bo.name name, b.name bname
            from clients_brokers cb inner join bond bo on cb.id = bo.contract_id
                                    inner join brokers b on b.id = cb.broker_id
            where cb.client_id = @client_id
        union
        select bo.name name, b.name bname
            from clients_brokers cb inner join stock bo on cb.id = bo.contract_id
                                    inner join brokers b on b.id = cb.broker_id
            where cb.client_id = @client_id) k
end
go


create or alter view task2 as
select b.name brokerName, cb.id, s.name stockName
from brokers b
    inner join clients_brokers cb
        on b.id = cb.broker_id
    inner join stock s
        on cb.id = s.contract_id

create or alter function task3()
    returns @result table (id int not null) as
begin
    insert into @result
    select k.cid
    from (select c.id cid, sE.id seid
        from clients c
        inner join clients_brokers cb
            on c.id = cb.client_id
        inner join bond b
            on cb.id = b.contract_id
        inner join stockExchange sE
            on b.name = sE.name
        union
        select c.id cid, sE.id seid
        from clients c
        inner join clients_brokers cb
            on c.id = cb.client_id
        inner join stock b
            on cb.id = b.contract_id
        inner join stockExchange sE
            on b.name = sE.name) k
    group by k.cid
    having count(distinct k.seid) > 1
    return;
end
go

select *
from task3()



