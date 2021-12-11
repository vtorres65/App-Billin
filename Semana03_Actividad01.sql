-- Database: Semana03_Actividad01

-- DROP DATABASE "Semana03_Actividad01";

CREATE DATABASE "Semana03_Actividad01"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
	
	create schema cliente;

create table cliente.rol
(
    name varchar(50) not NULL,
    constraint pk_rol primary key (name)
);

create table cliente.customer_user
(
    login          varchar(50)  not null,
    password       varchar(60)  not null,
    email          varchar(254) NOT NULL,
    activated      int4         not null,
    lang_key       varchar(6)   not null,
    image_url      varchar(256),
    activation_key varchar(20),
    reset_key      varchar(20),
    reset_date     timestamp,
    constraint pk_customer_user primary key (login),
    constraint uk_email unique (email)
);

create table cliente.tipo_documento
(
    sigla            varchar(10)  not NULL,
    nombre_documento varchar(100) not null,
    estado           varchar(40)  not null,
    constraint pk_tipo_documento primary key (sigla),
    constraint uk_nombre_documento unique (nombre_documento)
);

create table cliente.user_authority
(
    name_rol varchar(50) not null,
    login    varchar(50) not null,
    constraint pk_user_authority primary key (name_rol, login),
    constraint fk_rol foreign key (name_rol) references cliente.rol (name)ON UPDATE CASCADE ON DELETE CASCADE,
    constraint fk_customer_user foreign key (login) references cliente.customer_user (login)ON UPDATE CASCADE ON DELETE RESTRICT
);

create table cliente.cliente
(
    numero_documento varchar(50) NOT NULL ,
    primer_nombre    varchar(50) not null,
    segundo_nombre   varchar(50),
    primer_apellido  varchar(50) not null,
    segundo_apellido varchar(50),
    sigla            varchar(10) not null,
    login            varchar(50) not null,
    constraint pk_cliente primary key (numero_documento, sigla),
    constraint fk_customer_user foreign key (login) references cliente.customer_user (login)ON UPDATE CASCADE ON DELETE RESTRICT,
    constraint fk_tipo_documento foreign key (sigla) references cliente.tipo_documento (sigla)ON UPDATE CASCADE ON DELETE RESTRICT,
    constraint uk_login unique (login)
);


CREATE schema logs;

CREATE table logs.log_errores(
    id serial,
    nivel VARCHAR (400) NOT NULL,
    log_name VARCHAR (400) NOT NULL,
    mensaje VARCHAR (400) not NULL,
    fecha date not null,
    numero_documento VARCHAR (50) not null,
    sigla VARCHAR (10) NOT NULL ,

    constraint pk_log_erro PRIMARY KEY (id),
    constraint fk_log_erro_cliente FOREIGN key (numero_documento,sigla) REFERENCES cliente.cliente(numero_documento,sigla)ON UPDATE CASCADE ON DELETE RESTRICT
);

create table logs.log_auditoria(
	id int ,
	nivel varchar(400) not null,
	log_name varchar(400) not null,
	mensaje varchar(400) not  null,
	fecha date not null,
	numero_documento varchar(50) not null,
	sigla varchar(10) not null ,
	
	constraint pk_log_audi primary key (id),
	constraint fk_log_audi_clie FOREIGN key (numero_documento,sigla) REFERENCES cliente.cliente(numero_documento,sigla)ON UPDATE CASCADE ON DELETE RESTRICT
);

create schema horarios;

create table horarios.dia(
    nombre_dia VARCHAR (40) NOT NULL ,
    estado VARCHAR (40) NOT NULL ,

    constraint pk_hora_dia PRIMARY KEY (nombre_dia)
);

create table horarios.modalidad(
    nombre_modalidad VARCHAR (40) NOT NULL ,
    color varchar (50) NOT NULL ,
    estado VARCHAR (40) NOT NULL,

    constraint pk_moda_nomb PRIMARY KEY (nombre_modalidad)
);

create schema centro;

create table centro.intructor
(
    estado           varchar(40) not null,
    numero_documento varchar(50) not null,
    sigla            varchar(10) not null,
    constraint pk_instructor primary key (numero_documento, sigla)
);

CREATE TABLE centro.area(
    nombre_area VARCHAR (40) not NULL,
    estado VARCHAR (40) NOT NULL,
    url_logo VARCHAR (1000),

    constraint pk_area PRIMARY KEY (nombre_area)
);

create table centro.year(
    number_year INTEGER ,
    estado VARCHAR (40) NOT NULL,

    constraint pk_year PRIMARY KEY (number_year) 
);

create table centro.area_instructor(
    numero_documento VARCHAR (50) not NULL,
    sigla VARCHAR (10) NOT NULL,
    nombre_area VARCHAR (40) NOT NULL ,
    estado varchar (40) NOT NULL ,

    constraint pk_area_instructor PRIMARY KEY (numero_documento,sigla,nombre_area),    
    constraint fk_intr_esin FOREIGN KEY (numero_documento,sigla) REFERENCES centro.intructor(numero_documento,sigla)ON UPDATE CASCADE ON DELETE RESTRICT,
    constraint fk_area_esin FOREIGN KEY (nombre_area) REFERENCES centro.area (nombre_area)ON UPDATE CASCADE ON DELETE CASCADE
);

create table centro.vinculacion (
    tipo_vinculacion VARCHAR (40) NOT NULL ,
    horas INTEGER not NULL ,
    estado VARCHAR (40) not NULL,

    constraint pk_centro_vinculación PRIMARY KEY (tipo_vinculacion)
);

create table centro.jornada_instructor(
    nombre_jornada VARCHAR (80) NOT NULL,
    descripcion VARCHAR (200) not null,
    estado VARCHAR (40) not null,

    constraint pk_jornada_instructor PRIMARY KEY (nombre_jornada)
);

create table centro.dia_jornada(
    hora_inicio integer not null,
    hora_fin INTEGER not NULL,
    nombre_jornada varchar(80) not null,
    nombre_dia varchar (40) not null,

    constraint pk_dia_jornada PRIMARY KEY (hora_inicio,hora_fin,nombre_jornada,nombre_dia),
    constraint fk_jorn_dia_inst FOREIGN key (nombre_jornada) REFERENCES centro.jornada_instructor (nombre_jornada)ON UPDATE CASCADE ON DELETE CASCADE,
    constraint fk_dia_jorn_hora FOREIGN KEY (nombre_dia) REFERENCES horarios.dia (nombre_dia)ON UPDATE CASCADE ON DELETE CASCADE
);

create schema programa;

create table programa.planeacion(
    codigo varchar (40) not null,
    estado varchar (40) not null,
    fecha date not null,

    constraint pk_planeacion PRIMARY KEY (codigo)
);

create table programa.nivel_formacion(
    nivel VARCHAR (40) not NULL,
    estado varchar (40) not null,

    constraint pk_nivel_formacion PRIMARY KEY (nivel)
);

create schema ficha;

create table ficha.estado_formacion(
    nombre_estado VARCHAR (40) not null,
    estado varchar (40) not  NULL,

    constraint pk_estado_formacion PRIMARY KEY (nombre_estado)
);

create table ficha.estado_ficha(
    nombre_estado VARCHAR (40) not null,
    estado varchar (40) not  NULL,

    constraint pk_estado_ficha PRIMARY KEY (nombre_estado)
);

create table ficha.jornada(
    sigla_jornada varchar(20) not null,
    nombre_jornada VARCHAR (40) NOT NULL,
    descrpcion VARCHAR (100) not null,
    imagen_url VARCHAR (1000),
    estado varchar (40) not null,

    constraint pk_jornada PRIMARY KEY (sigla_jornada),
    constraint nombre_jornada UNIQUE (nombre_jornada)
);

create Table ficha.trimestre(
    nombre_trimestre integer NOT NULL,
    nivel VARCHAR (40) not NULL,
    sigla_jornada VARCHAR (20) not null,
    estado VARCHAR (40) not null,

    constraint pk_trimestre PRIMARY KEY (nombre_trimestre,nivel,sigla_jornada),
    constraint fk_jorn_trim FOREIGN KEY (sigla_jornada) REFERENCES ficha.jornada (sigla_jornada)ON UPDATE CASCADE ON DELETE CASCADE,
    constraint fk_nifo_trim FOREIGN KEY (nivel) REFERENCES programa.nivel_formacion (nivel)ON UPDATE CASCADE ON DELETE CASCADE
);

create schema sede;

create table sede.sede (
    nombre_sede varchar (50) not NULL,
    direccion VARCHAR (400) not null,
    estado varchar(40) not null,

    constraint pk_sede PRIMARY key (nombre_Sede)
);

create table sede.tipo_ambiente(
    tipo VARCHAR (50) not null,
    descripcion varchar(100) not null,
    estado varchar(40) not null,

    constraint pk_tipo_ambiente PRIMARY KEY (tipo)
);

create table sede.ambiente(
    numero_ambiente VARCHAR (50) not null,
    nombre_sede varchar (50) not null,
    descripcion VARCHAR (1000) not null,
    estado varchar (40) not null,
    limitacion VARCHAR (40) not null,
    tipo varchar (50) not null,

    constraint pk_ambiente PRIMARY KEY (numero_ambiente,nombre_sede),
    constraint fk_sede_ambi FOREIGN key (nombre_sede) REFERENCES sede.sede (nombre_Sede)ON UPDATE CASCADE ON DELETE CASCADE,
    constraint fk_tiam_ambi FOREIGN KEY (tipo) REFERENCES sede.tipo_ambiente(tipo)ON UPDATE CASCADE ON DELETE CASCADE
);

create table programa.programa (
    codigo varchar(50) not null,
    version varchar (40) not null,
    nombre varchar(500) not  null,
    sigla  VARCHAR (40) not null,
    estado varchar(40) not null,
    nivel varchar (40) not null,

    constraint pk_programa PRIMARY KEY (codigo,version),
    constraint fk_nifo_prog FOREIGN KEY (nivel) REFERENCES programa.nivel_formacion(nivel)ON UPDATE CASCADE ON DELETE CASCADE
);

create table programa.competencia(
    codigo_competencia VARCHAR (50) not null,
    denominacion varchar(1000) not NULL,
    codigo_programa VARCHAR (50) NOT NULL,
    version_programa VARCHAR (40) not NULL,

    constraint pk_competencia PRIMARY KEY (codigo_competencia,codigo_programa,version_programa),
    constraint fk_prog_comp FOREIGN KEY (codigo_programa,version_programa) REFERENCES programa.programa(codigo,version)ON UPDATE CASCADE ON DELETE RESTRICT
);

create table programa.resultado_aprendizaje(
    codigo_resultado VARCHAR (40) not null,
    denominacion varchar(1000) not null,
    codigo_competencia VARCHAR (50) not NULL,
    codigo_programa VARCHAR (50) not null,
    version_programa varchar (40) not null,

    constraint pk_resultado_aprendizaje PRIMARY KEY (codigo_resultado,codigo_competencia,codigo_programa,version_programa),
    constraint fk_comp_reap FOREIGN KEY (codigo_competencia,codigo_programa,version_programa) REFERENCES programa.competencia(codigo_competencia,codigo_programa,version_programa)ON UPDATE CASCADE ON DELETE RESTRICT
);

create table programa.planeacion_trimestre(
    codigo_resultado VARCHAR (40) not null,
    codigo_competencia VARCHAR (50) not null,
    codigo_programa VARCHAR (50) not NULL ,
    version_programa VARCHAR (40) not null,
    sigla_jornada varchar (20) not null,
    nivel VARCHAR (40) not NULL,
    nombre_trimestre INTEGER not null,
    codigo_planeacion varchar(40) NOT NULL,

    constraint pk_planeacion_trimestre PRIMARY KEY (codigo_resultado, codigo_competencia,codigo_programa,version_programa,sigla_jornada,nivel,nombre_trimestre,codigo_planeacion),
    constraint fk_reap_pltr FOREIGN KEY (codigo_resultado,codigo_competencia,codigo_programa,version_programa) REFERENCES programa.resultado_aprendizaje(codigo_resultado,codigo_competencia,codigo_programa,version_programa)ON UPDATE CASCADE ON DELETE RESTRICT,
    constraint fk_plan_pltr FOREIGN KEY (codigo_planeacion) REFERENCES programa.planeacion (codigo)ON DELETE CASCADE ON UPDATE CASCADE,
    constraint fk_trim_pltr FOREIGN KEY (nombre_trimestre,nivel,sigla_jornada) REFERENCES ficha.trimestre (nombre_trimestre,nivel,sigla_jornada)ON UPDATE CASCADE ON DELETE RESTRICT
);

create schema proyectos;

create table proyectos.proyecto(
    codigo VARCHAR (40) not NULL,
    nombre VARCHAR (500) not NULL,
    estado VARCHAR (40) not null,
    codigo_programa VARCHAR (50) not NULL,
    version_programa VARCHAR (40) NOT NULL,

    constraint pk_proyecto PRIMARY KEY (codigo),
    constraint fk_prog_proy FOREIGN KEY (codigo_programa,version_programa) REFERENCES programa.programa(codigo,version)ON UPDATE CASCADE ON DELETE RESTRICT
);

create table proyectos.fase (
    nombre VARCHAR (40) not null,
    estado VARCHAR (40) not null,
    codigo_proyecto VARCHAR (40) not NULL,

    constraint pk_fase PRIMARY KEY (nombre,codigo_proyecto),
    constraint fk_proy_fase FOREIGN key (codigo_proyecto) REFERENCES proyectos.proyecto(codigo)ON UPDATE CASCADE ON DELETE RESTRICT
);

create table proyectos.actividad_proyecto (
    numero_actividad INTEGER NOT null,
    descripcion_actividad VARCHAR (400) not null,
    estado VARCHAR (40) NOT NULL,
    nombre_fase VARCHAR (40) not NULL,
    codigo_proyecto VARCHAR (40) NOT NULL,

    constraint pk_actividad_proyecto PRIMARY KEY (numero_actividad,nombre_fase,codigo_proyecto),
    constraint fk_fase_acti FOREIGN KEY (nombre_fase,codigo_proyecto) REFERENCES proyectos.fase (nombre,codigo_proyecto)ON UPDATE CASCADE ON DELETE RESTRICT
);

create table programa.actividad_planeacion(
    codigo_resultado VARCHAR(40) not null,
    codigo_competencia VARCHAR(50) not null,
    codigo_programa VARCHAR(50) not null,
    version_programa VARCHAR(40) not null,
    sigla_jornada VARCHAR(20) not null,
    nivel VARCHAR(40) not null,
    nombre_trimestre INTEGER not null,
    nombre_fase VARCHAR(40) not null,
    codigo_proyecto VARCHAR(40) not null,
    numero_actividad INTEGER not null,
    codigo_planeacion VARCHAR(40) not null,

    constraint pk_actividad_planeacacion PRIMARY key (codigo_resultado,codigo_competencia,codigo_programa,version_programa,sigla_jornada,nivel,nombre_trimestre,nombre_fase,numero_actividad,codigo_planeacion),
    constraint fk_pltr_acpl FOREIGN key (codigo_resultado,codigo_competencia,codigo_programa,version_programa,sigla_jornada,nivel,nombre_trimestre,codigo_planeacion) REFERENCES programa.planeacion_trimestre(codigo_resultado,codigo_competencia,codigo_programa,version_programa,sigla_jornada,nivel,nombre_trimestre,codigo_planeacion)ON UPDATE CASCADE ON DELETE RESTRICT,
    constraint fk_acti_acpl FOREIGN key (nombre_fase,numero_actividad,codigo_proyecto) REFERENCES proyectos.actividad_proyecto(nombre_fase,numero_actividad,codigo_proyecto)ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE centro.vinculacion_instructor(
    fecha_inicio date not null,
    fecha_fin date NOT NULL,
    numero_documento VARCHAR (50) NOT NULL,
    sigla VARCHAR (10)not NULL,
    number_year INTEGER NOT NULL,
    tipo_vinculacion VARCHAR (40) not null,

    constraint pk_vinculacion_instructor PRIMARY KEY (fecha_inicio,numero_documento,sigla,number_year,tipo_vinculacion),
    constraint fk_year_viin FOREIGN KEY (number_year) REFERENCES centro.year (number_year)ON UPDATE CASCADE ON DELETE CASCADE,
    constraint fk_inst_viin FOREIGN KEY (numero_documento,sigla) REFERENCES centro.intructor (numero_documento,sigla)ON UPDATE CASCADE ON DELETE RESTRICT,
    constraint fk_vinc_viin FOREIGN KEY (tipo_vinculacion) REFERENCES centro.vinculacion(tipo_vinculacion)ON UPDATE CASCADE ON DELETE CASCADE
);

create table centro.disponibilidad_competencias(
    codigo_competencia VARCHAR (50) not null,
    codigo_programa VARCHAR (50) not null,
    version_programa VARCHAR (40) not NULl,
    numero_documento VARCHAR (50) not NULL,
    sigla VARCHAR (10) NOT NULL,
    number_year INTEGER NOT NULL,
    tipo_vinculacion varchar (40) not NULL,
    fecha_inicio date not null,

    constraint pk_disponibilidad_competencias PRIMARY KEY (fecha_inicio,numero_documento,sigla,number_year,tipo_vinculacion,codigo_competencia,codigo_programa,version_programa),
    constraint fk_viin_dico FOREIGN KEY (fecha_inicio,numero_documento,sigla,number_year,tipo_vinculacion) REFERENCES centro.vinculacion_instructor (fecha_inicio,numero_documento,sigla,number_year,tipo_vinculacion)ON UPDATE CASCADE ON DELETE RESTRICT,
    constraint fk_comp_dico FOREIGN KEY (codigo_competencia,codigo_programa,version_programa) REFERENCES programa.competencia(codigo_competencia,codigo_programa,version_programa)ON UPDATE CASCADE ON DELETE RESTRICT
);

create table centro.disponibilidad_horaria(
    numero_documento VARCHAR (50) not NULL,
    sigla VARCHAR (10) NOT NULL,
    number_year INTEGER NOT NULL,
    tipo_vinculacion VARCHAR (40) not NULL,
    fecha_inicio date not NULL,
    nombre_jornada VARCHAR (80) not NULL,

    constraint pk_disponibilidad_horaria PRIMARY KEY (numero_documento,sigla,number_year,tipo_vinculacion,fecha_inicio,nombre_jornada),
    constraint fk_inst_hora FOREIGN KEY (fecha_inicio,numero_documento,sigla,number_year,tipo_vinculacion) REFERENCES centro.vinculacion_instructor (fecha_inicio,numero_documento,sigla,number_year,tipo_vinculacion)ON UPDATE CASCADE ON DELETE RESTRICT,
    constraint fk_join_hora FOREIGN KEY (nombre_jornada) REFERENCES centro.jornada_instructor (nombre_jornada) ON UPDATE CASCADE ON DELETE CASCADE
);

create table sede.limitacion_ambiente(
    numero_ambiente VARCHAR (50) not NULL,
    nombre_sede VARCHAR (50)NOT NULL,
    codigo_resultado VARCHAR (40) not null,
    codigo_competencia VARCHAR (50) NOT NULL,
    codigo_programa VARCHAR (50) NOT NULL,
    version_programa VARCHAR (40) NOT NULL,

    constraint pk_limitacion_ambiente PRIMARY KEY (numero_ambiente,nombre_sede,codigo_resultado,codigo_competencia,codigo_programa,version_programa),
    constraint fk_ambi_liam FOREIGN KEY (numero_ambiente,nombre_sede) REFERENCES sede.ambiente (numero_ambiente,nombre_sede)ON UPDATE CASCADE ON DELETE CASCADE,
    constraint fk_reap_liam FOREIGN KEY (codigo_resultado,codigo_competencia,codigo_programa,version_programa) REFERENCES programa.resultado_aprendizaje (codigo_resultado,codigo_competencia,codigo_programa,version_programa)ON UPDATE CASCADE ON DELETE RESTRICT
);

create schema sustentacion;

create table sustentacion.valoracion(
    tipo_valoracion VARCHAR (50) NOT NULL,
    estado VARCHAR (40) NOT NULL,

    constraint pk_valoracion PRIMARY KEY (tipo_valoracion)
);

create table horarios.trimestre_vigente(
    trimestre_programado serial NOT NULL,
    fecha_inicio date not null,
    fecha_fin date NOT NULL,
    number_year INTEGER NOT NULL,

    constraint pk_trimestre_vigente PRIMARY KEY (trimestre_programado,number_year),
    constraint fk_year_vige FOREIGN KEY (number_year) REFERENCES centro.year (number_year) ON UPDATE CASCADE ON DELETE CASCADE
);

create table horarios.version_horario(
    numero_version VARCHAR (40) NOT NULL,
    estado VARCHAR (40) not NULL,
    trimestre_programado INTEGER NOT NULL,
    number_year INTEGER NOT NULL,

    constraint pk_version_horario PRIMARY KEY (numero_version,trimestre_programado,number_year),
    constraint fk_trvi_veho FOREIGN KEY (trimestre_programado,number_year) REFERENCES horarios.trimestre_vigente (trimestre_programado,number_year)ON UPDATE CASCADE ON DELETE CASCADE
);

create table ficha.ficha_has_trimestre(
    numero_ficha VARCHAR (100) not NULL,
    sigla_jornada VARCHAR (20) NOT NULL,
    nivel VARCHAR (40) NOT NULL,
    nombre_trimestre INTEGER NOT NULL,
    
    constraint pk_has_trimestre PRIMARY KEY (numero_ficha,sigla_jornada,nivel,nombre_trimestre),
    constraint fk_trim_fitr FOREIGN KEY (sigla_jornada,nivel,nombre_trimestre) REFERENCES ficha.trimestre (sigla_jornada,nivel,nombre_trimestre)ON UPDATE CASCADE ON DELETE RESTRICT
);

create table horarios.horario(
    hora_inicio time NOT NULL,
    hora_fin time NOT NULL,
    numero_documento VARCHAR (50) NOT NULL,
    sigla VARCHAR (10) not NULL,
    numero_ambiente VARCHAR (50) NOT NULL,
    nombre_sede VARCHAR (50) NOT NULL,
    numero_ficha VARCHAR (100) NOT NULL,
    sigla_jornada VARCHAR (20) NOT NULL,
    nivel VARCHAR (40) NOT NULL,
    nombre_trimestre INTEGER NOT NULL,
    nombre_dia VARCHAR (40) NOT NULL,
    nombre_modalidad VARCHAR (40) NOT NULL,
    numero_version VARCHAR (40) NOT NULL,
    number_year INTEGER NOT NULL,
    trimestre_programado INTEGER not NULL,

    constraint pk_horario PRIMARY KEY (hora_inicio,numero_documento,sigla,numero_ambiente,nombre_sede,numero_ficha,sigla_jornada,nivel,nombre_trimestre,nombre_dia,numero_version,number_year,trimestre_programado),
    constraint fk_dia_hora FOREIGN KEY (nombre_dia) REFERENCES horarios.dia (nombre_dia)ON UPDATE CASCADE ON DELETE CASCADE,
    constraint fk_moda_hora FOREIGN KEY (nombre_modalidad) REFERENCES horarios.modalidad (nombre_modalidad)ON UPDATE CASCADE ON DELETE CASCADE,
    constraint fk_ambi_hora FOREIGN KEY (numero_ambiente,nombre_sede) REFERENCES sede.ambiente (numero_ambiente,nombre_sede)ON UPDATE CASCADE ON DELETE CASCADE,
    constraint fk_fitr_hora FOREIGN KEY (numero_ficha,sigla_jornada,nivel,nombre_trimestre) REFERENCES ficha.ficha_has_trimestre (numero_ficha,sigla_jornada,nivel,nombre_trimestre)ON UPDATE CASCADE ON DELETE RESTRICT,
    constraint fk_veho_hora FOREIGN KEY (numero_version,number_year,trimestre_programado) REFERENCES horarios.version_horario (numero_version,number_year,trimestre_programado)ON UPDATE CASCADE ON DELETE CASCADE,
    constraint fk_inst_hora FOREIGN KEY (sigla,numero_documento) REFERENCES centro.intructor (sigla,numero_documento)ON UPDATE CASCADE ON DELETE RESTRICT
);

create table ficha.ficha(
    numero_ficha VARCHAR (100) not NULL,
    fecha_inicio date not NULL,
    fecha_fin date not NULL,
    ruta VARCHAR (40) not NULL,
    codigo VARCHAR (50) NOT NULL,
    version VARCHAR (40) NOT NULL,
    nombre_estado VARCHAR (20) NOT NULL,
    sigla_jornada VARCHAR (20) NOT NULL,

    constraint pk_ficha PRIMARY KEY (numero_ficha),
    constraint fk_exfi_fich FOREIGN KEY (nombre_Estado) REFERENCES ficha.estado_ficha (nombre_estado)ON UPDATE CASCADE ON DELETE CASCADE,
    constraint fk_jorn_fich FOREIGN KEY (sigla_jornada) REFERENCES ficha.jornada (sigla_jornada)ON UPDATE CASCADE ON DELETE RESTRICT,
    constraint fk_prog_fich FOREIGN KEY (codigo,version) REFERENCES programa.programa (codigo,version)ON UPDATE CASCADE ON DELETE RESTRICT
);

alter table ficha.ficha_has_trimestre add constraint fk_fich_fitr FOREIGN KEY (numero_ficha) REFERENCES ficha.ficha (numero_ficha);

create table ficha.ficha_planeacion(
    numero_ficha VARCHAR (100) NOT NULL,
    codigo_planeacion VARCHAR (40) NOT NULL,
    estado VARCHAR (40) NOT NULL,

    constraint pk_ficha_planeacion PRIMARY KEY (numero_ficha,codigo_planeacion),
    constraint fk_fich_plan FOREIGN KEY (numero_ficha) references ficha.ficha (numero_ficha)ON DELETE CASCADE ON UPDATE CASCADE,
    constraint fk_plan_plan FOREIGN KEY (codigo_planeacion) REFERENCES programa.planeacion (codigo)ON DELETE CASCADE ON UPDATE CASCADE
);

create table ficha.resultados_vistos(
    codigo_resultado VARCHAR (40) NOT NULL,
    codigo_competencia VARCHAR (50) NOT NULL,
    codigo_programa VARCHAR (50) NOT NULL,
    version_programa VARCHAR (40) NOT NULL,
    numero_ficha VARCHAR (100) NOT NULL,
    sigla_jornada VARCHAR (20) NOT NULL,
    nivel VARCHAR (40) NOT NULL,
    nombre_trimestre INTEGER not NULL,
    codigo_planeacion VARCHAR (40) NOT NULL,

    constraint pk_resultado_vistos PRIMARY KEY (nombre_trimestre,codigo_planeacion,codigo_resultado,codigo_competencia,codigo_programa,version_programa,numero_ficha,sigla_jornada,nivel),
    constraint fk_fitr_revi FOREIGN KEY (numero_ficha,sigla_jornada,nivel,nombre_trimestre) REFERENCES ficha.ficha_has_trimestre(numero_ficha,sigla_jornada,nivel,nombre_trimestre)ON DELETE CASCADE ON UPDATE CASCADE,
    constraint fk_reap_revi FOREIGN KEY (codigo_resultado,codigo_competencia,codigo_programa,version_programa) REFERENCES programa.resultado_aprendizaje (codigo_resultado,codigo_competencia,codigo_programa,version_programa)ON DELETE CASCADE ON UPDATE CASCADE,
    constraint fk_plan_revi FOREIGN KEY (codigo_planeacion) REFERENCES programa.planeacion (codigo)ON DELETE CASCADE ON UPDATE CASCADE
);

create table ficha.aprendiz(
    numero_documento VARCHAR (50) NOT NULL,
    sigla varchar(10) NOT NULL,
    numero_ficha VARCHAR (100) NOT NULL,
    nombre_estado VARCHAR (40) not null,

    constraint pk_aprendiz PRIMARY KEY (numero_documento,sigla,numero_ficha),
    constraint fk_esta_apre FOREIGN KEY (nombre_estado) REFERENCES ficha.estado_formacion (nombre_estado)ON DELETE CASCADE ON UPDATE CASCADE,
    constraint fk_fich_apre FOREIGN KEY (numero_ficha) REFERENCES ficha.ficha (numero_ficha)ON DELETE CASCADE ON UPDATE CASCADE,
    constraint fk_clie_apre FOREIGN KEY (numero_documento,sigla) REFERENCES cliente.cliente (numero_documento,sigla)ON DELETE CASCADE ON UPDATE CASCADE
);

create table sustentacion.grupo_proyecto(
    numero_grupo serial not null,
    nombre_proyecto varchar (300) not NULL,
    estado VARCHAR (40) NOT NULL,
    numero_ficha VARCHAR (100) not NULL,

    constraint pk_grupo_proyecto PRIMARY KEY (numero_grupo,numero_ficha),
    constraint fk_fich_grpr FOREIGN KEY (numero_ficha) REFERENCES ficha.ficha (numero_ficha)ON DELETE CASCADE ON UPDATE CASCADE
);

create table sustentacion.integrantes_grupo(
    numero_documento VARCHAR (50) NOT NULL,
    sigla VARCHAR (10) NOT NULL,
    numero_ficha VARCHAR (100) NOT NULL,
    numero_grupo integer not NULL,
    numero_ficha2 VARCHAR (100) NOT NULL,

    constraint pk_integrantes_grupo PRIMARY KEY (numero_documento,sigla,numero_ficha,numero_grupo,numero_ficha2),
    constraint fk_grpr_ingr FOREIGN KEY (numero_grupo,numero_ficha2) REFERENCES sustentacion.grupo_proyecto (numero_grupo,numero_ficha)ON DELETE CASCADE ON UPDATE CASCADE,
    constraint fk_apre_ingr FOREIGN KEY (numero_documento,sigla,numero_ficha) REFERENCES ficha.aprendiz (numero_documento,sigla,numero_ficha)ON DELETE CASCADE ON UPDATE CASCADE
);

create table sustentacion.obsevacion_general(
    numero serial not null,
    observacion VARCHAR(500)not null,
    jurado VARCHAR(500) not null,
    fecha TIME not null,
    numero_documento VARCHAR(50),
    sigla VARCHAR(10),
    numero_grupo INTEGER not null,
    numero_ficha VARCHAR(100),

    constraint pk_obsevacion_general PRIMARY key (numero,numero_grupo,numero_ficha),
    constraint fk_grpr_obge FOREIGN key (numero_ficha,numero_grupo) REFERENCES sustentacion.grupo_proyecto(numero_ficha,numero_grupo)ON DELETE CASCADE ON UPDATE CASCADE,
    constraint fk_dccl_sicl FOREIGN KEY (numero_documento,sigla) REFERENCES cliente.cliente(numero_documento,sigla)ON DELETE CASCADE ON UPDATE CASCADE

);

create table sustentacion.lista_chequeo(
    lista VARCHAR(50) not NULL,
    estado INTEGER not null,
    codigo VARCHAR(50) not null,
    version VARCHAR(40) not null,
    constraint pk_lista_chequeo PRIMARY key (lista),
    constraint fk_prog_linch FOREIGN key (codigo,version) REFERENCES programa.programa(codigo,version)ON UPDATE CASCADE ON DELETE RESTRICT
);

create TABLE sustentacion.item_lista (
    lista VARCHAR (50) NOT NULL,
    numero_item INTEGER NOT NULL,
    pregunta VARCHAR (1000) NOT NULL,
    id_resultado_aprendizaje INTEGER NOT NULL,
    codigo_resultado VARCHAR (40) NOT NULL,
    codigo_competencia VARCHAR (50) NOT NULL,
    codigo_programa VARCHAR (50) NOT NULL,
    version_programa VARCHAR (40) NOT NULL,

    constraint pk_item_lista PRIMARY KEY (lista,numero_item),
    constraint fk_lich_itli FOREIGN KEY (lista) REFERENCES sustentacion.lista_chequeo (lista) ON UPDATE CASCADE ON DELETE CASCADE,
    constraint fk_reap_itli FOREIGN KEY (codigo_resultado,codigo_competencia,codigo_programa,version_programa) REFERENCES programa.resultado_aprendizaje (codigo_resultado,codigo_competencia,codigo_programa,version_programa)ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE sustentacion.respuesta_grupo(
    fecha DATE NOT NULL,
    tipo_valoracion VARCHAR (50),
    numero_grupo INTEGER NOT NULL,
    numero_ficha VARCHAR (100) NOT NULL,
    lista VARCHAR (50) NOT NULL,
    numero_item INTEGER NOT NULL,

    constraint pk_respuesta_grupo PRIMARY KEY (numero_grupo,numero_ficha,lista,numero_item),
    constraint fk_itli_regr FOREIGN KEY (lista,numero_item) REFERENCES sustentacion.item_lista (lista,numero_item) ON UPDATE CASCADE ON DELETE CASCADE,
    constraint fk_valo_regr FOREIGN KEY (tipo_valoracion) REFERENCES sustentacion.valoracion (tipo_valoracion) ON UPDATE CASCADE ON DELETE CASCADE,
    constraint fk_grpr_regr FOREIGN KEY (numero_grupo,numero_ficha) REFERENCES sustentacion.grupo_proyecto (numero_grupo,numero_ficha) ON UPDATE CASCADE ON DELETE CASCADE
);
create table sustentacion.observacion_respuesta(
    numero_observacion INTEGER NOT NULL,
    observacion VARCHAR (400) NOT NULL,
    jurados VARCHAR (400) NOT NULL,
    fecha DATE NOT NULL,
    numero_documento VARCHAR (50),
    sigla VARCHAR (10),
    numero_grupo INTEGER NOT NULL,
    numero_ficha VARCHAR (100) NOT NULL,
    lista VARCHAR (50) NOT NULL,
    numero_item INTEGER NOT NULL,

    constraint pk_observacion_respuesta PRIMARY KEY (numero_observacion,numero_grupo,numero_ficha,lista,numero_item),
    constraint fk_regr_obre FOREIGN KEY (numero_grupo,numero_ficha,lista,numero_item) REFERENCES sustentacion.respuesta_grupo(numero_grupo,numero_ficha,lista,numero_item) ON UPDATE CASCADE ON DELETE CASCADE,
    constraint fk_clie_obre FOREIGN KEY (numero_documento,sigla) REFERENCES cliente.cliente (numero_documento,sigla) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE sustentacion.lista_ficha(
    numero_ficha VARCHAR (100) NOT NULL,
    lista VARCHAR (50) NOT NULL ,

    constraint pk_lista_ficha PRIMARY KEY (numero_ficha),
    constraint lista UNIQUE (lista),
    constraint fk_fich_lifi FOREIGN KEY (numero_ficha) REFERENCES ficha.ficha (numero_ficha) ON UPDATE CASCADE ON DELETE CASCADE,
    constraint fk_lich_lifi FOREIGN KEY (lista) REFERENCES sustentacion.lista_chequeo (lista) ON UPDATE CASCADE ON DELETE CASCADE
)