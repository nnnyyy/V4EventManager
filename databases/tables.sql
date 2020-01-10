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
) DEFAULT CHARSET=utf8;

insert into account (nick, pw) values ('왕야옹', password('1234'));

drop table if exists user_guild;
create table user_guild (
	user_sn int not null,
    guild_sn int not null default -1,    
    grade int not null default 0, /* 0: 미승인, 1: 일반, 2: 입력가능, 3: 마스터 */
    primary key(user_sn)
)DEFAULT CHARSET=utf8;

insert into user_guild (user_sn, guild_sn, grade) values (1,1,3);

drop table if exists guild;
create table guild (
	sn int auto_increment,
    master_sn int not null,
    guildname varchar(100) not null,
    regdate datetime not null default now(),
    primary key(sn)
)DEFAULT CHARSET=utf8;

insert into guild (master_sn, guildname) values ( 1, '야옹야옹');

drop table if exists guildlog;
create table guildlog (
	sn int auto_increment,
    guild_sn int not null,
    user_sn int not null,
    msg varchar(300) not null,
    regdate datetime not null default now(),
    index ix_guild( guild_sn ),
    index ix_user( user_sn ),
    primary key(sn)
)DEFAULT CHARSET=utf8;

drop table if exists boss;
create table boss (
	sn int auto_increment,
    dimention_name varchar(100),
    area_name varchar(100),
    field_name varchar(100),
    boss_name varchar(50),
    type int not null default 1,
    primary key(sn)
) DEFAULT CHARSET=utf8;

insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '데커스화산', '돌먼지 폐광', '피코', 1);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '데커스화산', '배반자의 소굴', '라빌린', 1);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '데커스화산', '비명소리 웅덩이', '라파커스', 1);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '비텐고원', '달그림자 호수', '바르트', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '비텐고account원', '별자리 호수', '비아', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '비텐고원', '빼앗긴 경작지 ', '키벨레', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '비텐고원', '서리 폭풍 비탈', '렌티', 1);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '비텐고원', '서리 폭풍 비탈', '바르돌', 1);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '비텐고원', '서리폭풍 마루', '베리네', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '비텐고원', '설움의 들판', '라비네스', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '비텐고원', '스톤드 고지대', '에르드', 1);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '비텐고원', '스톤드 벌목장', '에베소', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '비텐고원', '스톤드계곡상류', '라드엘', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '비텐고원', '스톤드계곡하류', '릴리스', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '비텐고원', '스톤드전투폐허', '니콜라', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '비텐고원', '얼어붙은 벌판', '로시에', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '비텐고원', '얼어붙은 폐허', '리비에', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '비텐고원', '얼어붙은 호수마을', '르두스', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '비텐고원', '얼음절벽 협곡', '크라머', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '비텐고원', '짓밟힌 농원', '테라모', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '비텐고원', '파헤쳐진 설원', '드레느', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '비텐고원', '황량한 설원', '프랭거', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 가도', '벨프스', 1);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 분화구', '이프리나', 1);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 폐광', '트로이카', 1);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 폐허', '베네딕트', 1);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '데커스화산', '파수꾼의 땅', '베르키', 1);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 계곡1', '트러스', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 계곡2', '트러스', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 계곡3', '트러스', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 계곡4', '트러스', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 마루1', '차크만', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 마루2', '차크만', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 마루3', '차크만', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 마루4', '차크만', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 물줄기1', '아르타', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 물줄기2', '아르타', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 물줄기3', '아르타', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 물줄기4', '아르타', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 성채1', '커리허', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 성채2', '커리허', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 성채3', '커리허', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 요새1', '델파나', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 장막1', '유주라', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 장막2', '유주라', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 장막3', '유주라', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 폐허1', '엘로디', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 폐허2', '엘로디', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 폐허3', '엘로디', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 폐허4', '엘로디', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 폐허5', '엘로디', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 협곡1', '바돈', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 협곡2', '바돈', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 협곡3', '카이오', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 협곡4', '카이오', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 물줄기', '마프르만', 1);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 장막', '셰르마', 1);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 폐허', '라카탄', 1);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상의언덕', '도그록', 1);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상의 들판1', '허큘리오', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상의 들판2', '허큘리오', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상의 들판3', '브라마노', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상의 들판4', '브라마노', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상의 들판5', '브라마노', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상의 언덕1', '라이노', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상의 언덕2', '지로드', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상의 언덕3', '라이노', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상의 언덕4', '라이노', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상의 언덕5', '지로드', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 범람지', '카무나크1', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 범람지', '카무나크2', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 범람지', '카무나크3', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 범람지', '카무나크4', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 범람지', '카무나크5', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 범람지', '카무나크6', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 범람지', '카무나크7', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 범람지', '카무나크8', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 범람지', '카무나크9', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 범람지', '카무나크10', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 범람지', '카무나크11', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 범람지', '카무나크12', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸폐광', '트롤족장1', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸폐광', '트롤족장2', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸폐광', '트롤족장3', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸폐광', '트롤족장4', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸폐광', '트롤족장5', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸폐광', '트롤족장6', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸폐광', '트롤족장7', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸폐광', '트롤족장8', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸폐광', '트롤족장9', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸폐광', '트롤족장10', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸폐광', '트롤족장11', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸폐광', '트롤족장12', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸폐광', '트롤족장13', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸폐광', '트롤족장14', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸폐광', '트롤족장15', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 폭포', '우탄1', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 폭포', '우탄2', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 폭포', '우탄3', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 폭포', '우탄4', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 폭포', '우탄5', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 폭포', '우탄6', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 폭포', '우탄7', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 폭포', '우탄8', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 폭포', '우탄9', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 폭포', '우탄10', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 폭포', '우탄11', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 수렁', '프리오1', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 수렁', '프리오2', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 수렁', '프리오3', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 수렁', '프리오4', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 수렁', '프리오5', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 수렁', '프리오6', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 수렁', '프리오7', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 수렁', '프리오8', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 수렁', '프리오9', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 수렁', '프리오10', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 수렁', '프리오11', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 수렁', '프리오12', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 수렁', '프리오13', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 수렁', '프리오14', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 수렁', '프리오15', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 수렁', '프리오16', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸의 수렁', '프리오17', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸요새', '기사단장1', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸요새', '기사단장2', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸요새', '기사단장3', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸요새', '기사단장4', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸요새', '기사단장5', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸요새', '기사단장6', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸요새', '기사단장7', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸요새', '기사단장8', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸요새', '기사단장9', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸요새', '기사단장10', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸요새', '기사단장11', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸요새', '기사단장12', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸요새', '기사단장13', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸요새', '기사단장14', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸요새', '기사단장15', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸요새', '기사단장16', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸요새', '기사단장17', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸요새', '기사단장18', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸요새', '기사단장19', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸요새', '기사단장20', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 웅덩이', '구우로크1', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 웅덩이', '구우로크2', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 웅덩이', '구우로크3', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 웅덩이', '구우로크4', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 웅덩이', '구우로크5', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 웅덩이', '구우로크6', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 웅덩이', '구우로크7', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 웅덩이', '킬라즈1', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 웅덩이', '킬라즈2', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 웅덩이', '킬라즈3', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 웅덩이', '킬라즈4', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 웅덩이', '킬라즈5', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 웅덩이', '킬라즈6', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 웅덩이', '킬라즈7', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 웅덩이', '킬라즈8', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 웅덩이', '킬라즈9', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 웅덩이', '킬라즈10', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 웅덩이', '킬라즈11', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 그루터기', '킬라즈12', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 그루터기', '예언자1', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 그루터기', '예언자2', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 그루터기', '예언자3', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 그루터기', '예언자4', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 폐허', '예언자5', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 협로', '파오판1', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 협로', '파오판2', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 협로', '파오판3', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 협로', '파오판4', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 협로', '파오판5', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 협로', '파오판6', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 협로', '파오판7', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 협로', '파오판8', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 협로', '파오판9', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 협로', '파오판10', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 협로', '파오판11', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 협로', '파오판12', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 협로', '파오판13', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 협로', '파오판14', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 협로', '파오판15', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 협로', '파오판16', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 협로', '파오판17', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 분화구', '이프리트1', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 분화구', '이프리트2', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 분화구', '이프리트3', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 분화구', '이프리트4', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 분화구', '이프리트5', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 분화구', '이프리트6', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 분화구', '이프리트7', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 분화구', '이프리트8', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 분화구', '이프리트9', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 분화구', '이프리트10', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 분화구', '이프리트11', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 분화구', '이프리트12', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 분화구', '이프리트13', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 분화구', '이프리트14', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 분화구', '이프리트15', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 분화구', '이프리트16', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '파멸의화산', '파멸 분화구', '이프리트17', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '데커스화산', '그을음 가도', '바라오트', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '데커스화산', '그을음간헐천', '칼루카', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '데커스화산', '돌먼지 보급로', '밀로케', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '데커스화산', '메마른 수령', '파라톤', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '데커스화산', '적막한 폭포', '실라키오', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '데커스화산', '회색 지열지대', '디볼', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '데커스화산', '회색 황무지', '자드갈', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '데커스화산', '비명소리 광산', '비코', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '데커스화산', '태고 군락지', '체라트', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '데커스화산', '잿바람 수송로', '라오단', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '데커스화산', '침략자 소굴', '비드레아', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '데커스화산', '용해 위험지대', '파이우스', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('실루나스', '데커스화산', '데커스 용암지대', '호바른', 2);
insert into boss ( dimention_name, area_name, field_name, boss_name, type ) values ('루나트라', '허상의고원', '허상 요새', '페리라', 1);

drop table if exists cuttime;
create table cuttime (
	guild_sn int not null,
    boss_sn int not null,
    cuttime datetime not null,
    gaptimemin int not null,
    index ix_guild(guild_sn),
    primary key (guild_sn, boss_sn)
) DEFAULT CHARSET=utf8;

select b.*, ifnull(c.boss_sn, -1) boss_sn, ifnull(c.cuttime,0) cuttime, ifnull(c.gaptimemin, 0) gaptimemin from boss b left join (select * from cuttime where guild_sn = 1) c on b.sn = c.boss_sn;
  