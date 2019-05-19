DO
$do$
DECLARE
BEGIN

create schema condominium;

--INDEPENTEND TABLES
create table if not exists condominium.skill
(
    id serial PRIMARY KEY,
    ds_name varchar(32) unique
);

create table if not exists condominium.shared_area
(
    id serial PRIMARY KEY,
    ds_name varchar(32) unique
);

create table if not exists condominium.role
(
    id serial PRIMARY KEY,
    ds_name varchar(32) unique,
    nu_level integer
);

create type gender as Enum ('Male', 'Female');

create table if not exists condominium.person
(
    id serial PRIMARY KEY,
    ds_fullname varchar(32) not null,
    ds_email varchar(32),
    ds_fone varchar (16),
    gender gender,
    dt_birth date,
    dt_creation date default now()
);

create table if not exists condominium.user
(
    id serial PRIMARY KEY,
    ds_login varchar(32) unique,
    ds_password varchar(32),
    id_person int references condominium.person(id),
    dt_creation date default now()
);

create table if not exists condominium.person_skill
(
    id serial primary key,
    id_person int references condominium.person(id),
    id_skill int references condominium.skill(id)
);

create table if not exists condominium.user_role
(
    id serial primary key,
    id_user int references condominium.user(id),
    id_role int references condominium.role(id)
);

create table if not exists condominium.shared_area_schedule
(
    id serial primary key,
    id_shared_area int references condominium.shared_area(id),
    id_user int references condominium.user(id),
    dt_begin date not null,
    dt_end date not null
);
comment on table condominium.shared_area_schedule is 'dt_begin and dt_end should have time';

create table if not exists condominium.communication
(
    id serial primary key,
    id_user_origin int references condominium.user(id) not null,
    id_user_destiny int references condominium.user(id),
    ds_text text,
    dt_creation date default now(),
    nu_days int
);
comment on column condominium.communication.nu_days is 'How many days this will be available';

raise exception 'dont remove that line until tests are finished';
END
$do$


INSERT INTO condominium.person (ds_fullname, ds_email, ds_fone, gender, dt_birth)
VALUES
('Tony Moraes', 'tonylds1@byui.edu', '5583999648036',  'Male', '1982-08-16'),
('Wellington Sindico', 'wellington@gmail.com', '5583999644950',  'Male', '1990-07-15'),
('Dora Winner', 'dora@hotmail.com', '5583999646061',  'Female', '2000-07-09'),
('Joseph Silve', 'joseph@gmail.com', '5583999647980',  'Male', '2000-08-10')
;

INSERT INTO condominium."user" (ds_login, ds_password, id_person)
VALUES
( 'tonylds1', '123abc', (select id from condominium.person where ds_email = 'tonylds1@byui.edu')),
( 'wellington', '123abc', (select id from condominium.person where ds_email = 'wellington@gmail.com')),
( 'dora', '123abc', (select id from condominium.person where ds_email = 'dora@hotmail.com')),
( 'joseph', '123abc', (select id from condominium.person where ds_email = 'joseph@gmail.com'))
;

INSERT INTO condominium.shared_area (ds_name)
VALUES
('pool'),
('barbecue grill 01'),
('barbecue grill 02'),
('basketball court'),
('futsal court'),
('football field'),
('reception 01'),
('playroom'),
('playground')
;

INSERT INTO condominium.role (ds_name, nu_level)
VALUES
('syndicate', 15),
('syndicate assistent', 10),
('treasurer', 5),
('user', 0)
;

INSERT INTO condominium.skill (ds_name)
VALUES
('PHP Coder'),
('Eletrical Professional'),
('plumber'),
('accountant')
;

INSERT INTO condominium.person_skill (id_person, id_skill)
VALUES
((select id_person from condominium.user where ds_login = 'tonylds1'), (select id from condominium.skill where ds_name = 'PHP Coder')),
((select id_person from condominium.user where ds_login = 'dora'), (select id from condominium.skill where ds_name = 'accountant')),
((select id_person from condominium.user where ds_login = 'joseph'), (select id from condominium.skill where ds_name = 'plumber'))
;

INSERT INTO condominium.user_role (id_user, id_role)
VALUES
((select id from condominium.user where ds_login = 'wellington'), (select id from condominium.role where ds_name = 'syndicate')),
((select id from condominium.user where ds_login = 'tonylds1'), (select id from condominium.role where ds_name = 'treasurer')),
((select id from condominium.user where ds_login = 'dora'), (select id from condominium.role where ds_name = 'syndicate assistent')),
((select id from condominium.user where ds_login = 'joseph'), (select id from condominium.role where ds_name = 'user'))
;

select * from condominium.person p
join condominium.user u on u.id_person = p.id
join condominium.person_skill ps on ps.id_person = p.id
join condominium.skill s on s.id = ps.id_skill

