create table if not exists project
(
	id integer generated always as identity,
	registered_time timestamp,
	type varchar(100),
	status varchar(100)
);

alter table project owner to ybigta;

create table if not exists job_call
(
	id integer generated always as identity,
	project_id integer,
	request_time timestamp,
	create_date_time timestamp,
	type varchar(100),
	status varchar(100),
	data varchar(1000000)
);

alter table job_call owner to ybigta;

create table if not exists job_text
(
	id integer generated always as identity,
	project_id integer,
	request_time timestamp,
	create_date_time timestamp,
	type varchar(100),
	status varchar(100),
	content varchar(10000)
);

alter table job_text owner to ybigta;

create table if not exists job_photo
(
	id integer generated always as identity,
	project_id integer,
	request_time timestamp,
	create_date_time timestamp,
	type varchar(100),
	status varchar(100),
	img_url varchar(10000)
);

alter table job_photo owner to ybigta;

create table if not exists result_photo
(
	id integer generated always as identity,
	project_id integer,
	job_id integer,
	result_time timestamp,
	create_date_time timestamp,
	type varchar(100),
	face boolean,
	model_result json
);

alter table result_photo owner to ybigta;

create table if not exists result_text
(
	id integer generated always as identity,
	project_id integer,
	job_id integer,
	result_time timestamp,
	create_date_time timestamp,
	type varchar(100),
	model_result json,
	word_count json,
	sentence_count integer
);

alter table result_text owner to ybigta;

create table if not exists result_call
(
	id integer generated always as identity,
	project_id integer,
	job_id integer,
	result_time timestamp,
	create_date_time timestamp,
	type varchar(100),
	model_result json
);

alter table result_call owner to ybigta;

