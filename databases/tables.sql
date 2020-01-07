create database v4eventmanager;

use v4eventmanager;

/* 유저 정보 테이블 */
drop table if exists account;

create table account (
	sn int auto_increment,
    nick varchar(50) not null,
    pw varchar(300) not null,
    regdate datetime not null default now(),
    primary key(sn)
);

drop table if exists guild;
create table guild (
	sn int auto_increment,
    master_sn int not null,
    guildname varchar(100) not null,
    entrance_key text,
    regdate datetime not null default now(),
    primary key(sn)
);

drop table if exists guildlog;
create table guildlog (
	sn int auto_increment,
    guild_sn int not null,
    user_sn int not null,
    msg varchar(300) not null,
    index ix_guild( guild_sn ),
    index ix_user( user_sn ),
    primary key(sn)
);

drop table if exists area;
create table area (
	sn int auto_increment,
    name varchar(100) not null
);

drop table if exists field;
create table field (
	sn int auto_increment,
    name varchar(100) not null
);