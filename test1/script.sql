create database EuropeanCountries;

create table Cities
(
    cityId     int IDENTITY(1,1)
        primary key,
    name       varchar(25)    not null,
    population int            not null,
    countyId   int default -1 null
);

create index countyId
    on Cities (countyId);

create table ContinentalRegions
(
    continentalRegionId int IDENTITY(1,1)
        primary key,
    name                varchar(25) not null,
    population          int         null
);

create table Countries
(
    countryId    int IDENTITY(1,1)
        primary key,
    name         varchar(25)    not null,
    population   int            not null,
    foundingYear int            null,
    gdpTrillions decimal(10, 2) not null,
    capitalId    int            null,
    constraint Countries
        foreign key (capitalId) references Cities (cityId),
    constraint foundingYear
        check ((foundingYear < 2023) and (foundingYear > 0))
);

create table Counties
(
    countyId   int IDENTITY(1,1)
        primary key,
    name       varchar(35) not null,
    population int         not null,
    countryId  int         not null,
    constraint Counties
        foreign key (countryId) references Countries (countryId)
);

alter table Cities
    add constraint Cities
        foreign key (countyId) references Counties (countyId);

create index countryId
    on Counties (countryId);

create index capitalId
    on Countries (capitalId);

create table CountryPartOfRegion
(
    countryId           int not null,
    continentalRegionId int not null,
    primary key (countryId, continentalRegionId),
    constraint CountryPartOfRegion
        foreign key (countryId) references Countries (countryId),
    constraint CountryPartOfRegion
        foreign key (continentalRegionId) references ContinentalRegions (continentalRegionId)
);

create index continentalRegionId
    on CountryPartOfRegion (continentalRegionId);

create table CountryRegions
(
    countryRegionId int IDENTITY(1,1)
        primary key,
    name            varchar(35) not null,
    population      int         null,
    countryId       int         not null,
    constraint CountryRegions
        foreign key (countryId) references Countries (countryId)
);

create index countryId
    on CountryRegions (countryId);

create table CountyPartOfRegion
(
    countyId        int not null,
    countryRegionId int not null,
    primary key (countyId, countryRegionId),
    constraint CountyPartOfRegion
        foreign key (countyId) references Counties (countyId),
    constraint CountyPartOfRegion
        foreign key (countryRegionId) references CountryRegions (countryRegionId)
);

create index countryRegionId
    on CountyPartOfRegion (countryRegionId);

create table EuropeanInstitutions
(
    institutionId   int IDENTITY(1,1)
        primary key,
    name            varchar(25)  not null,
    description     varchar(100) not null,
    numberCountries int          null
);

create table CountryPartOfInstitution
(
    countryId     int not null,
    institutionId int not null,
    primary key (countryId, institutionId),
    constraint CountryPartOfInstitution
        foreign key (countryId) references Countries (countryId),
    constraint CountryPartOfInstitution
        foreign key (institutionId) references EuropeanInstitutions (institutionId)
);

create index institutionId
    on CountryPartOfInstitution (institutionId);

create table PoliticalParties
(
    partyId       int IDENTITY(1,1)
        primary key,
    fullName      varchar(40)  not null,
    abbreviation  varchar(10)  not null,
    description   varchar(100) null,
    alignment     varchar(15)  not null,
    numberMembers int          not null,
    countryId     int          not null,
    constraint PoliticalParties
        foreign key (countryId) references Countries (countryId)
);

create index countryId
    on PoliticalParties (countryId);


