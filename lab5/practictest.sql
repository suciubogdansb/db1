create database practictest;

create table countries (
    id int primary key identity (1,1),
    name varchar(10)
)

insert into countries (name) values ('romania'), ('us'), ('uk'), ('espana');

create table movie(
    id int primary key identity (1,1),
    title varchar(10),
    durationMin int,
    premiereDate date,
    originId int references countries(id)
)

insert into movie (title, durationMin, premiereDate, originId) values
('nacho', 67, '1-1-2021', 1),
('seu', 69, '1-2-2021', 1),
('avengar', 96, '1-1-2009', 2),
('titan', 180, '10-4-1983', 2),
('init', 30, '3-3-2012', 3),
('el gato', 3, '4-6-2023', 4);

create table genres(
     id int primary key identity (1,1),
     name varchar(10)
)
insert into genres(name) values ('action'), ('drama'), ('comedy'), ('horror')

create table movie_genre
(
    movie_id int references movie(id),
    genre_id int references genres(id)
)

alter table genres
add unique (name);

insert into movie_genre(movie_id, genre_id) values
(7,3), (7,4), (8,3),(9, 1), (9, 3), (10, 2), (11, 2), (11, 3), (12,4);

create table actor(
     id int primary key identity (1,1),
     name varchar(10),
     date date,
     countryId int references countries(id),
)

insert into actor values ('leo', '4-5-1962', 2), ('brad', '3-7-1959', 2), ('gigel', '1-1-2000', 1), ('peter', '3-2-1996', 3), ('jose', '2-5-1982', 4);

create table movie_actor (
    movie_id int references movie(id)
    ,
    actor_id int references actor(id)
)

insert into movie_actor values (7, 1), (7,3), (8, 3), (9, 2), (9,4), (9, 5), (10, 1), (11, 4), (12, 3), (12, 5);

create table award (
     id int primary key identity (1,1),
     name varchar(10),
     category varchar(10),
)
insert into award values ('oscar', 'movie'), ('globes', 'actor'), ('choice', 'script'), ('mtv', 'perform')

create table nominee(
    award_id int references award(id),
    movie_id int references movie(id),
    actor_id int references actor(id),
    winner int
)

insert into nominee values
(1, 10, null, 1), (1, 12, null, 0), (2, null, 1, 1), (2, null, 3, 1),
(2, null, 4, 0), (3, 7, null, 0), (3, 8, null, 0), (3, 10, null, 1),
(4, null, 5, 0), (4, null,2, 1);

insert into nominee values (3, 12, null, 1);


create or alter procedure task1 (@awardname varchar(10), @nomineename varchar(10)) as
begin
    declare @awardid int = (select id from award where name = @awardname)
    if @awardid is null
    begin
        print 'no award'
        return
    end
    declare @nomineeid int = -1
    if @nomineename in (select name from actor)
    begin
        if (select count(actor_id) from nominee where award_id = @awardid) = 0
        begin
                print 'this is movie award'
                return
        end
        select @nomineeid = id from actor where name = @nomineename;
        if @nomineeid not in (select actor_id from nominee where award_id = @awardid)
        begin
            insert into nominee (award_id, movie_id, actor_id, winner)
                values (@awardid, null, @nomineeid, 0)
            print 'nominee added'
        end
        else
        begin
            print 'already nominated'
        end
    end
    else if @nomineename in (select title from movie)
    begin
        if (select count(movie_id) from nominee where award_id = @awardid) = 0
        begin
                print 'this is acotr award'
                return
        end
        select @nomineeid = id from movie where title = @nomineename;
        if @nomineeid not in (select movie_id from nominee where award_id = @awardid)
        begin
            insert into nominee (award_id, movie_id, actor_id, winner)
                values (@awardid, @nomineeid, null, 0)
            print 'nominee added'
        end
        else
        begin
            print 'already nominated'
        end
    end
    else
    begin
        print 'no such film/actor'
    end
end
go

create or alter view task2
    as
select distinct a.name
from nominee n
    inner join movie m
        on m.id = n.movie_id
    inner join movie_actor ma on m.id = ma.movie_id
    inner join actor a on a.id = ma.actor_id

go

-- delete from nominee where award_id is null;

create or alter function task3 (@n int) returns int as
begin
    declare @count int = 0;
    select @count = count(*)
    from (select k.id
          from (select c.id, a.name wname
                from nominee n inner join actor a on a.id = n.actor_id
                    inner join countries c on c.id = a.countryId
                where n.winner > 0
                    UNION
                select c.id, m.title wname
                from nominee n inner join movie m on m.id = n.movie_id
                    inner join countries c on c.id = m.originId
                where n.winner > 0) k
          group by k.id
          having count(distinct k.wname) >= @n) j
    return @count
end
go

exec task1 @awardname = 'choice', @nomineename = 'peter';

select * from task2

print dbo.task3(10);




