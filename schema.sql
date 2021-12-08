drop table if exists DEFIProtocols cascade;
drop table if exists GovernanaceTokens cascade;
drop table if exists DAOs cascade;
drop table if exists Developers cascade;
drop table if exists work_in cascade;
drop table if exists HackedEvents cascade;
drop table if exists Hackers cascade;
drop table if exists involve cascade;
drop table if exists Auditors cascade;
drop table if exists audited_by cascade;
drop table if exists Chains cascade;
drop table if exists deployed_on cascade;


create table DAOs(
  name varchar(32) primary key
);
create table DEFIProtocols (
	name varchar(32) primary key,
	totalValueLocked decimal,
	category varchar(32),
	DAO varchar(32) not null,
	foreign key (DAO) references DAOs(name)
);

create table GovernanaceTokens (
	address varchar(64),
	chain varchar(10),
	name varchar(32),
	decimal Integer,
	DAO varchar(32) not null,
	primary key (address, chain),
	foreign key (DAO) references DAOs(name)
);

create table Developers(
	discordHandle varchar(32) primary key
);

create table work_in(
	DAO varchar(32),
	developer varchar(32),
	primary key(DAO, developer),
	foreign key(DAO) references DAOs(name),
	foreign key(developer) references Developers(discordHandle)
);

create table HackedEvents(
	DEFIProtocol varchar(32),
	hackedTime date,
  chain varchar(32),
	valueLost decimal,
	valueReturned decimal,
	reason varchar(32),
	primary key(hackedTime, DEFIProtocol, chain),
	foreign key(DEFIProtocol) references DEFIProtocols(name) on delete cascade
);

create table Hackers(
	address varchar(64) primary key,
	contractAddress varchar(64)
);

create table involve(
  DEFIProtocol varchar(32),
  hackedTime date,
	hackerAddress varchar(64),
  chain varchar(32),
	foreign key(hackedTime, DEFIProtocol, chain) references HackedEvents(hackedTime, DEFIProtocol, chain),
	foreign key(hackerAddress) references Hackers(address),
	primary key(hackedTime, DEFIProtocol, hackerAddress)
);

create table Auditors (
	name varchar(32) primary key,
	foundYear integer
);

create table audited_by (
	DEFIProtocol varchar(32),
	auditor varchar(32),
	auditTime date,
	primary key (DEFIProtocol, auditor, auditTime),
  foreign key (DEFIProtocol) references DEFIProtocols(name),
	foreign key (auditor) references Auditors(name)
);

create table Chains (
  name varchar(32) primary key,
	nativeToken varchar(32),
  chainId varchar(10),
	organization varchar(32)
);

create table deployed_on (
	DEFIProtocol varchar(32),
	chain varchar(32),
	primary key (DEFIProtocol, chain),
	foreign key(DEFIProtocol) references DEFIProtocols(name),
	foreign key(chain) references Chains(name)
);
