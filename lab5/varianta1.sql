Create database t1;

create table clients (
    id int primary key identity(1, 1),
    name varchar(50) not null,
);

alter table clients
add constraint unique_name unique (name);

create table banks (
    id int primary key identity(1, 1),
);

create table clientWorksWithBank (
    clientName varchar(50) not null,
    bankId int not null,
    primary key (clientName, bankId),
    foreign key (clientName) references clients(name),
    foreign key (bankId) references banks(id),
);

create table bankingService(
    id int primary key identity(1, 1),
    bankId int not null,
    foreign key (bankId) references banks(id),
);

create table investService (
    id int primary key identity(1, 1),
    bankId int not null,
    foreign key (bankId) references banks(id),
);

create table clientBankService (
    clientId int not null,
    bankServiceId int not null,
    primary key (clientId, bankServiceId),
    foreign key (clientId) references clients(id),
    foreign key (bankServiceId) references bankingService(id),
);

alter table clientBankService
drop constraint PK__clientBa__CED5ADF136044A7D;

alter table clientBankService
add count int primary key identity (1,1);

create Table clientInvestService (
    clientName varchar(50) not null,
    investServiceId int not null,
    primary key (clientName, investServiceId),
    foreign key (clientName) references clients(name),
    foreign key (investServiceId) references investService(id),
);

alter table clientInvestService
drop constraint PK__clientIn__796F543A8EA335DE;

alter table clientInvestService
add count int primary key identity (1,1);

alter table banks
add name varchar(20);

alter table bankingService
add name varchar(20);

alter table investService
add name varchar(20);

create or alter procedure task2 (@clientName varchar(50), @bankId int, @bankServiceId int, @investServiceId int)
as
begin
    declare @clientId int;
    select @clientId = id from clients where name = @clientName;
    if @clientId is null
    begin
        raiserror('Client with name %s does not exist', 16, 1, @clientName);
        return;
    end
    if not exists (select * from banks where id = @bankId)
    begin
        raiserror('Bank with id %d does not exist', 16, 1, @bankId);
        return;
    end
    if @bankServiceId is not null
    begin
        if not exists (select * from bankingService bs inner join banks b on b.id = bs.bankId where b.id = @bankId and bs.id = @bankServiceId)
        begin
            raiserror('Banking service with id %d does not exist', 16, 1, @bankServiceId);
            return;
        end
        if exists (select * from clientBankService where clientId = @clientId and bankServiceId = @bankServiceId)
        begin
            raiserror('Client with id %d already has banking service with id %d', 16, 1, @clientId, @bankServiceId);
            return;
        end
        insert into clientBankService (clientId, bankServiceId) values (@clientId, @bankServiceId);
    end
    if @investServiceId is not null
    begin
        if not exists (select * from investService iis inner join banks b on b.id = iis.bankId where b.id = @bankId and iis.id = @investServiceId)
        begin
            raiserror('Invest service with id %d does not exist', 16, 1, @investServiceId);
            return;
        end
        if exists (select * from clientInvestService where clientName = @clientName and investServiceId = @investServiceId)
        begin
            raiserror('Client with name %s already has invest service with id %d', 16, 1, @clientName, @investServiceId);
            return;
        end
        insert into clientInvestService (clientName, investServiceId) values (@clientName, @investServiceId);
    end
end

create or alter view task3View as
    select c.id, c.name, bs.count as BankNumber, cIS.count as InvestNumber
    from clients c inner join clientBankService bs on c.id = bs.clientId inner join clientInvestService cIS on c.name = cIS.clientName;


create or alter function task4 ()
    returns @result table (name varchar(50), bankName varchar(50), serviceName varchar(20))
as
begin
    insert into @result
    select *
    from (select c.name name, b.name bname, bs.name sname
          from (select l.name name, cc.id id
                from clients cc
                    inner join (select al.clientName name
                                from clientWorksWithBank al
                                group by al.clientName
                                having count(distinct bankId) > 1) l
                        on l.name = cc.name) c
              inner join clientBankService cBS
                  on c.id = cBS.clientId
              inner join bankingService bs
                  on cBS.bankServiceId = bs.id
              inner join banks b
                  on b.id = bs.bankId
          union
         select c.name name, b.name bname, iis.name sname
         from (select al.clientName name
               from clientWorksWithBank al
               group by al.clientName
               having count(distinct bankId) > 1) c
             inner join clientInvestService cBS
                 on c.name = cBS.clientName
             inner join investService iis
                 on cBS.investServiceId = iis.id
             inner join banks b
                 on b.id = iis.bankId) k

    if @@rowcount = 0
    begin
        insert into @result
        values ('null', 'null', 'null')
    end
    return
end
go

select * from task4();

-- select *
--     from (select c.name name, b.name bname, bs.name sname
--           from (select l.name name, cc.id id
--                 from clients cc
--                     inner join (select al.clientName name
--                                 from clientWorksWithBank al
--                                 group by al.clientName
--                                 having count(distinct bankId) > 1) l
--                         on l.name = cc.name) c
--               inner join clientBankService cBS
--                   on c.id = cBS.clientId
--               inner join bankingService bs
--                   on cBS.bankServiceId = bs.id
--               inner join banks b
--                   on b.id = bs.bankId
--           union
--          select c.name name, b.name bname, iis.name sname
--          from (select al.clientName name
--                from clientWorksWithBank al
--                group by al.clientName
--                having count(distinct bankId) > 1) c
--              inner join clientInvestService cBS
--                  on c.name = cBS.clientName
--              inner join investService iis
--                  on cBS.investServiceId = iis.id
--              inner join banks b
--                  on b.id = iis.bankId) k;
--
-- select *
--           from (select l.name name, cc.id id
--                 from clients cc
--                     inner join (select al.clientName name
--                                 from clientWorksWithBank al
--                                 group by al.clientName
--                                 having count(distinct bankId) > 1) l
--                         on l.name = cc.name) c
--               inner join clientBankService cBS
--                   on c.id = cBS.clientId
--               inner join bankingService bs
--                   on cBS.bankServiceId = bs.id


