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

drop table if exists user_guild;
create table user_guild (
	user_sn int not null,
    guild_sn int not null default -1,    
    grade int not null default 0, /* 0: 미승인, 1: 일반, 2: 입력가능, 3: 마스터 */
    primary key(user_sn)
)DEFAULT CHARSET=utf8;

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
    field_group varchar(100),
    field_name varchar(100),
    boss_name varchar(50),
    term int default 180,
    type int not null default 1,
    primary key(sn)
) DEFAULT CHARSET=utf8;

insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '데커스화산', '돌먼지 폐광', '돌먼지 폐광', '피코', 1, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '데커스화산', '배반자의 소굴', '배반자의 소굴', '라빌린', 1, 250);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '데커스화산', '비명소리 웅덩이', '비명소리 웅덩이', '라파커스', 1, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '비텐고원', '달그림자 호수', '달그림자 호수', '바르트', 2, 300);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '비텐고원', '별자리 호수', '별자리 호수', '비아', 2, 300);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '비텐고원', '빼앗긴 경작지 ', '빼앗긴 경작지 ', '키벨레', 2, 180);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '비텐고원', '서리 폭풍 비탈', '서리 폭풍 비탈', '렌티', 1, 480);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '비텐고원', '서리 폭풍 비탈', '서리 폭풍 비탈', '바르돌', 1, 480);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '비텐고원', '서리폭풍 마루', '서리폭풍 마루', '베리네', 2, 300);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '비텐고원', '설움의 들판', '설움의 들판', '라비네스', 2, 180);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '비텐고원', '스톤드 고지대', '스톤드 고지대', '에르드', 1, 480);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '비텐고원', '스톤드 벌목장', '스톤드 벌목장', '에베소', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '비텐고원', '스톤드계곡상류', '스톤드계곡상류', '라드엘', 2, 180);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '비텐고원', '스톤드계곡하류', '스톤드계곡하류', '릴리스', 2, 180);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '비텐고원', '스톤드전투폐허', '스톤드전투폐허', '니콜라', 2, 180);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '비텐고원', '얼어붙은 벌판', '얼어붙은 벌판', '로시에', 2, 300);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '비텐고원', '얼어붙은 폐허', '얼어붙은 폐허', '리비에', 2, 480);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '비텐고원', '얼어붙은 호수마을', '얼어붙은 호수마을', '르두스', 2, 300);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '비텐고원', '얼음절벽 협곡', '얼음절벽 협곡', '크라머', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '비텐고원', '짓밟힌 농원', '짓밟힌 농원', '테라모', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '비텐고원', '파헤쳐진 설원', '파헤쳐진 설원', '드레느', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '비텐고원', '황량한 설원', '황량한 설원', '프랭거', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 가도', '파멸 가도', '벨프스', 1, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 분화구', '파멸 분화구', '이프리나', 1, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 폐광', '파멸 폐광', '트로이카', 1, 230);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 폐허', '파멸 폐허', '베네딕트', 1, 250);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '데커스화산', '파수꾼의 땅', '파수꾼의 땅', '베르키', 1, 230);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 계곡', '허상 계곡1', '트러스1', 2, 480);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 계곡', '허상 계곡2', '트러스2', 2, 480);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 계곡', '허상 계곡3', '트러스3', 2, 480);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 계곡', '허상 계곡4', '트러스4', 2, 480);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 마루', '허상 마루1', '차크만1', 2, 600);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 마루', '허상 마루2', '차크만2', 2, 600);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 마루', '허상 마루3', '차크만3', 2, 600);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 마루', '허상 마루4', '차크만4', 2, 600);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 물줄기', '허상 물줄기1', '아르타1', 2, 720);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 물줄기', '허상 물줄기2', '아르타2', 2, 720);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 물줄기', '허상 물줄기3', '아르타3', 2, 720);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 물줄기', '허상 물줄기4', '아르타4', 2, 720);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 성채', '허상 성채1', '커리허1', 2, 480);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 성채', '허상 성채2', '커리허2', 2, 480);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 성채', '허상 성채3', '커리허3', 2, 480);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 요새', '허상 요새1', '델파나1', 2, 720);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 장막', '허상 장막1', '유주라1', 2, 720);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 장막', '허상 장막2', '유주라2', 2, 720);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 장막', '허상 장막3', '유주라3', 2, 720);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 폐허', '허상 폐허1', '엘로디1', 2, 720);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 폐허', '허상 폐허2', '엘로디2', 2, 720);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 폐허', '허상 폐허3', '엘로디3', 2, 720);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 폐허', '허상 폐허4', '엘로디4', 2, 720);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 폐허', '허상 폐허5', '엘로디5', 2, 720);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 협곡', '허상 협곡1', '바돈1', 2, 600);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 협곡', '허상 협곡2', '바돈2', 2, 600);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 협곡', '허상 협곡3', '카이오3', 2, 720);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 협곡', '허상 협곡4', '카이오4', 2, 720);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 물줄기', '허상 물줄기', '마프르만', 1, 480);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 장막', '허상 장막', '셰르마', 1, 480);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 폐허', '허상 폐허', '라카탄', 1, 480);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상의언덕', '허상의언덕', '도그록', 1, 480);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상의 들판', '허상의 들판1', '허큘리오1', 2, 600);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상의 들판', '허상의 들판2', '허큘리오2', 2, 600);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상의 들판', '허상의 들판3', '브라마노3', 2, 480);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상의 들판', '허상의 들판4', '브라마노4', 2, 480);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상의 들판', '허상의 들판5', '브라마노5', 2, 480);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상의 언덕', '허상의 언덕1', '라이노1', 2, 600);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상의 언덕', '허상의 언덕2', '지로드2', 2, 480);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상의 언덕', '허상의 언덕3', '라이노3', 2, 600);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상의 언덕', '허상의 언덕4', '라이노4', 2, 600);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상의 언덕', '허상의 언덕5', '지로드5', 2, 480);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 범람지', '파멸의 범람지1', '카무나크1', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 범람지', '파멸의 범람지2', '카무나크2', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 범람지', '파멸의 범람지3', '카무나크3', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 범람지', '파멸의 범람지4', '카무나크4', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 범람지', '파멸의 범람지5', '카무나크5', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 범람지', '파멸의 범람지6', '카무나크6', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 범람지', '파멸의 범람지7', '카무나크7', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 범람지', '파멸의 범람지8', '카무나크8', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 범람지', '파멸의 범람지9', '카무나크9', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 범람지', '파멸의 범람지10', '카무나크10', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 범람지', '파멸의 범람지11', '카무나크11', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 범람지', '파멸의 범람지12', '카무나크12', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸폐광', '파멸폐광1', '트롤족장1', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸폐광', '파멸폐광2', '트롤족장2', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸폐광', '파멸폐광3', '트롤족장3', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸폐광', '파멸폐광4', '트롤족장4', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸폐광', '파멸폐광5', '트롤족장5', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸폐광', '파멸폐광6', '트롤족장6', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸폐광', '파멸폐광7', '트롤족장7', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸폐광', '파멸폐광8', '트롤족장8', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸폐광', '파멸폐광9', '트롤족장9', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸폐광', '파멸폐광10', '트롤족장10', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸폐광', '파멸폐광11', '트롤족장11', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸폐광', '파멸폐광12', '트롤족장12', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸폐광', '파멸폐광13', '트롤족장13', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸폐광', '파멸폐광14', '트롤족장14', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸폐광', '파멸폐광15', '트롤족장15', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 폭포', '파멸 폭포1', '우탄1', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 폭포', '파멸 폭포2', '우탄2', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 폭포', '파멸 폭포3', '우탄3', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 폭포', '파멸 폭포4', '우탄4', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 폭포', '파멸 폭포5', '우탄5', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 폭포', '파멸 폭포6', '우탄6', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 폭포', '파멸 폭포7', '우탄7', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 폭포', '파멸 폭포8', '우탄8', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 폭포', '파멸 폭포9', '우탄9', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 폭포', '파멸 폭포10', '우탄10', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 폭포', '파멸 폭포11', '우탄11', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 수렁', '파멸의 수렁1', '프리오1', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 수렁', '파멸의 수렁2', '프리오2', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 수렁', '파멸의 수렁3', '프리오3', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 수렁', '파멸의 수렁4', '프리오4', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 수렁', '파멸의 수렁5', '프리오5', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 수렁', '파멸의 수렁6', '프리오6', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 수렁', '파멸의 수렁7', '프리오7', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 수렁', '파멸의 수렁8', '프리오8', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 수렁', '파멸의 수렁9', '프리오9', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 수렁', '파멸의 수렁10', '프리오10', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 수렁', '파멸의 수렁11', '프리오11', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 수렁', '파멸의 수렁12', '프리오12', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 수렁', '파멸의 수렁13', '프리오13', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 수렁', '파멸의 수렁14', '프리오14', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 수렁', '파멸의 수렁15', '프리오15', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 수렁', '파멸의 수렁16', '프리오16', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸의 수렁', '파멸의 수렁17', '프리오17', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸요새', '파멸요새1', '기사단장1', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸요새', '파멸요새2', '기사단장2', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸요새', '파멸요새3', '기사단장3', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸요새', '파멸요새4', '기사단장4', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸요새', '파멸요새5', '기사단장5', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸요새', '파멸요새6', '기사단장6', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸요새', '파멸요새7', '기사단장7', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸요새', '파멸요새8', '기사단장8', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸요새', '파멸요새9', '기사단장9', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸요새', '파멸요새10', '기사단장10', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸요새', '파멸요새11', '기사단장11', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸요새', '파멸요새12', '기사단장12', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸요새', '파멸요새13', '기사단장13', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸요새', '파멸요새14', '기사단장14', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸요새', '파멸요새15', '기사단장15', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸요새', '파멸요새16', '기사단장16', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸요새', '파멸요새17', '기사단장17', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸요새', '파멸요새18', '기사단장18', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸요새', '파멸요새19', '기사단장19', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸요새', '파멸요새20', '기사단장20', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 웅덩이', '파멸 웅덩이1', '구우로크1', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 웅덩이', '파멸 웅덩이2', '구우로크2', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 웅덩이', '파멸 웅덩이3', '구우로크3', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 웅덩이', '파멸 웅덩이4', '구우로크4', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 웅덩이', '파멸 웅덩이5', '구우로크5', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 웅덩이', '파멸 웅덩이6', '구우로크6', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 웅덩이', '파멸 웅덩이7', '구우로크7', 2, 240);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 그루터기', '파멸 그루터기1', '킬라즈1', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 그루터기', '파멸 그루터기2', '킬라즈2', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 그루터기', '파멸 그루터기3', '킬라즈3', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 그루터기', '파멸 그루터기4', '킬라즈4', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 그루터기', '파멸 그루터기5', '킬라즈5', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 그루터기', '파멸 그루터기6', '킬라즈6', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 그루터기', '파멸 그루터기7', '킬라즈7', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 그루터기', '파멸 그루터기8', '킬라즈8', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 그루터기', '파멸 그루터기9', '킬라즈9', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 그루터기', '파멸 그루터기10', '킬라즈10', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 그루터기', '파멸 그루터기11', '킬라즈11', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 그루터기', '파멸 그루터기12', '킬라즈12', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 폐허', '파멸 폐허1', '예언자1', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 폐허', '파멸 폐허2', '예언자2', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 폐허', '파멸 폐허3', '예언자3', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 폐허', '파멸 폐허4', '예언자4', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 폐허', '파멸 폐허5', '예언자5', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 협로', '파멸 협로1', '파오판1', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 협로', '파멸 협로2', '파오판2', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 협로', '파멸 협로3', '파오판3', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 협로', '파멸 협로4', '파오판4', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 협로', '파멸 협로5', '파오판5', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 협로', '파멸 협로6', '파오판6', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 협로', '파멸 협로7', '파오판7', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 협로', '파멸 협로8', '파오판8', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 협로', '파멸 협로9', '파오판9', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 협로', '파멸 협로10', '파오판10', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 협로', '파멸 협로11', '파오판11', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 협로', '파멸 협로12', '파오판12', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 협로', '파멸 협로13', '파오판13', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 협로', '파멸 협로14', '파오판14', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 협로', '파멸 협로15', '파오판15', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 협로', '파멸 협로16', '파오판16', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 협로', '파멸 협로17', '파오판17', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 분화구', '파멸 분화구1', '이프리트1', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 분화구', '파멸 분화구2', '이프리트2', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 분화구', '파멸 분화구3', '이프리트3', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 분화구', '파멸 분화구4', '이프리트4', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 분화구', '파멸 분화구5', '이프리트5', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 분화구', '파멸 분화구6', '이프리트6', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 분화구', '파멸 분화구7', '이프리트7', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 분화구', '파멸 분화구8', '이프리트8', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 분화구', '파멸 분화구9', '이프리트9', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 분화구', '파멸 분화구10', '이프리트10', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 분화구', '파멸 분화구11', '이프리트11', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 분화구', '파멸 분화구12', '이프리트12', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 분화구', '파멸 분화구13', '이프리트13', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 분화구', '파멸 분화구14', '이프리트14', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 분화구', '파멸 분화구15', '이프리트15', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 분화구', '파멸 분화구16', '이프리트16', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '파멸의화산', '파멸 분화구', '파멸 분화구17', '이프리트17', 2, 270);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '데커스화산', '그을음 가도', '그을음 가도', '바라오트', 2, 180);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '데커스화산', '그을음간헐천', '그을음간헐천', '칼루카', 2, 180);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '데커스화산', '돌먼지 보급로', '돌먼지 보급로', '밀로케', 2, 180);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '데커스화산', '메마른 수령', '메마른 수령', '파라톤', 2, 180);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '데커스화산', '적막한 폭포', '적막한 폭포', '실라키오', 2, 180);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '데커스화산', '회색 지열지대', '회색 지열지대', '디볼', 2, 180);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '데커스화산', '회색 황무지', '회색 황무지', '자드갈', 2, 180);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '데커스화산', '비명소리 광산', '비명소리 광산', '비코', 2, 180);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '데커스화산', '태고 군락지', '태고 군락지', '체라트', 2, 180);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '데커스화산', '잿바람 수송로', '잿바람 수송로', '라오단', 2, 180);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '데커스화산', '침략자 소굴', '침략자 소굴', '비드레아', 2, 180);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '데커스화산', '용해 위험지대', '용해 위험지대', '파이우스', 2, 180);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('실루나스', '데커스화산', '데커스 용암지대', '데커스 용암지대', '호바른', 2, 180);
insert into boss ( dimention_name, area_name, field_group, field_name, boss_name, type, term ) values ('루나트라', '허상의고원', '허상 요새', '허상 요새', '페리라', 1, 0);

drop table if exists cuttime;
create table cuttime (
	guild_sn int not null,
    boss_sn int not null,
    cuttime datetime not null,
    gaptimemin int not null,
    index ix_guild(guild_sn),
    primary key (guild_sn, boss_sn)
) DEFAULT CHARSET=utf8;

alter table cuttime add column channel int default 1;
alter table cuttime add index ix_ch ( channel );

select b.*, ifnull(c.boss_sn, -1) boss_sn, ifnull(c.cuttime,0) cuttime, ifnull(c.gaptimemin, 0) gaptimemin from boss b left join (select * from cuttime where guild_sn = 1) c on b.sn = c.boss_sn;
  