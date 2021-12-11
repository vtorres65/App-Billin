create schema cliente;

create table cliente.authority(
     name varchar(50) not null,
     CONSTRAINT pk_authority PRIMARY KEY (name)
);

CREATE TABLE cliente.customer_user(
    id serial not null,
    login          varchar(50)  not null,
    password       varchar(60)  not null,
    email          varchar(254) NOT NULL,
    activated      int4         null,
    lang_key       varchar(6)   not null,
    image_url      varchar(256),
    activation_key varchar(20),
    reset_key      varchar(20),
    reset_date     timestamp,
    CONSTRAINT pk_customer_user PRIMARY KEY (id),
    CONSTRAINT uk_login UNIQUE (login),
    CONSTRAINT uk_email UNIQUE (email)
);

create table cliente.user_authority(
    name_rol varchar(50) not null,
    id_system_user INTEGER NOT NULL,
    login    varchar(50) not null,
    constraint pk_user_authority primary key (name_rol, id_system_user),
    constraint fk_authority foreign key (name_rol) references cliente.authority (name),
    constraint fk_customer_user foreign key (id_system_user) references cliente.customer_user (id)
);

CREATE TABLE cliente.tipo_documento(
    id serial NOT NULL,
    sigla VARCHAR(10) NOT NULL,
    nombre_documento VARCHAR(100) NOT NULL,
    estado VARCHAR(40) NOT NULL,
    CONSTRAINT pk_tipo_documento PRIMARY KEY (id),
    CONSTRAINT uk_sigla UNIQUE (sigla),
    CONSTRAINT uk_nombre_documento UNIQUE (nombre_documento)
);

CREATE TABLE cliente.cliente(
    id serial NOT NULL,
    id_tipo_documento int4 NOT NULL, 
    numero_documento VARCHAR(50) NOT NULL,
    primer_nombre  VARCHAR(50) NOT NULL,
    segundo_nombre VARCHAR(50),
    primer_apellido VARCHAR(50) NOT NULL,
    segundo_apellido VARCHAR(50),
    id_system_user int4 NOT NULL,
    CONSTRAINT pk_cliente PRIMARY KEY (id),
    CONSTRAINT fk_tido_clie FOREIGN KEY (id_tipo_documento) REFERENCES cliente.tipo_documento (id),
    CONSTRAINT fk_user_clien FOREIGN KEY (id_system_user) REFERENCES cliente.customer_user (id),
    CONSTRAINT uk_cliente UNIQUE (id_tipo_documento, numero_documento),
    CONSTRAINT uk_user UNIQUE (id_system_user)
);
ALTER TABLE cliente.cliente ADD CONSTRAINT fk_user_clien FOREIGN KEY (id_system_user) REFERENCES cliente.customer_user (id);

CREATE SCHEMA instructor;

CREATE TABLE instructor.instructor(
    id serial NOT NULL,
    id_cliente int4 NOT NULL,
    estado VARCHAR(40) NOT NULL,
    CONSTRAINT pk_instructor PRIMARY KEY (id),
    CONSTRAINT fk_cliente FOREIGN KEY (id_cliente) REFERENCES cliente.cliente (id),
    CONSTRAINT uk_instructor UNIQUE (id_cliente)
);

CREATE TABLE instructor.area(
    id serial NOT NULL,
    nombre_area VARCHAR (40) not NULL,
    estado VARCHAR (40) NOT NULL,
    url_logo VARCHAR (1000),

    constraint pk_area PRIMARY KEY (id),
    CONSTRAINT uk_area UNIQUE (nombre_area)
);

create table instructor.year(
    id serial NOT NULL,
    number_year INTEGER NOT NULL,
    estado VARCHAR (40) NOT NULL,
    constraint pk_year PRIMARY KEY (id),
    CONSTRAINT uk_year UNIQUE (number_year)
);


create table instructor.area_instructor(
    id serial NOT NULL,
    id_area int4 NOT NULL,
    id_instructor int4 NOT NULL,
    estado varchar (40) NOT NULL,
    constraint pk_area_instructor PRIMARY KEY (id),    
    constraint fk_area FOREIGN KEY (id_area) REFERENCES instructor.area (nombre_area),
    constraint fk_intr_esin FOREIGN KEY (id_instructor) REFERENCES instructor.instructor (id),
    CONSTRAINT uk_area_instructor UNIQUE (id_area, id_instructor)
);


create table instructor.vinculacion(
    id serial NOT NULL,
    tipo_vinculacion VARCHAR(40) NOT NULL,
    horas INTEGER not NULL,
    estado VARCHAR(40) not NULL,
    constraint pk_vinculacion PRIMARY KEY (id),
    CONSTRAINT uk_vinculacion UNIQUE (tipo_vinculacion)
);

create table instructor.jornada_instructor(
    id serial NOT NULL,
    nombre_jornada VARCHAR (80) NOT NULL,
    descripcion VARCHAR (200) not null,
    estado VARCHAR (40) not null,
    constraint pk_jornada_instructor PRIMARY KEY (id),
    CONSTRAINT uk_nombre_jornada UNIQUE (nombre_jornada)
);

create table instructor.dia_jornada(
    id serial NOT NULL,
    id_jornada_instructores int4 NOT NULL,
    id_dia int4 NOT NULL,
    hora_inicio integer not null,
    hora_fin INTEGER not NULL,
    constraint pk_dia_jornada PRIMARY KEY (id),
    constraint fk_jorn_inst FOREIGN key (id_jornada_instructores) REFERENCES instructor.jornada_instructor (id),
    constraint fk_dia_jorn FOREIGN key (id_dia) REFERENCES horarios.dia (id),
    CONSTRAINT uk_dia_jornada UNIQUE (id_jornada_instructores, id_dia, hora_inicio, hora_fin)
);


create table instructor.vinculacion_instructor(
    id serial NOT NULL,
    id_year int4 NOT NULL,
    fecha_inicio date not null,
    fecha_fin date not NULL,
    id_vinculacion int4 NOT NULL,
    id_instructor int4 NOT NULL,
    constraint pk_vinculacion_instructor PRIMARY KEY (id),
    constraint fk_year FOREIGN key (id_year) REFERENCES instructor.year (id),
    constraint fk_vinculacion FOREIGN key (id_vinculacion) REFERENCES instructor.instructor (id),
    constraint fk_instructor FOREIGN key (id_instructor) REFERENCES instructor.vinculacion (id),
    CONSTRAINT uk_vinculacion_instructor UNIQUE (id_year, fecha_inicio, fecha_fin, id_vinculacion, id_instructor)
);

create table instructor.disponibilidad_competencias(
    id serial NOT NULL,
    id_competencia int4 NOT NULL,
    id_vinculacion_instructor int4 NOT NULL,
    constraint pk_disponibilidad_competencias PRIMARY KEY (id),
    constraint fk_dicom_vinst FOREIGN key (id_vinculacion_instructor) REFERENCES instructor.vinculacion_instructor (id),
    constraint fk_dicom_program FOREIGN key (id_competencia) REFERENCES programa.competenca (id),
    CONSTRAINT uk_disponibilidad_competencias UNIQUE (id_competencia, id_vinculacion_instructor)
);

create table instructor.disponibilidad_horaria(
    id serial NOT NULL,
    id_jornada_instructor int4 NOT NULL,
    id_vinculacion_instructor int4 NOT NULL,
    constraint pk_disponibilidad_horaria PRIMARY KEY (id),
    constraint fk_dihor_vinst FOREIGN key (id_jornada_instructor) REFERENCES instructor.vinculacion_instructor (id),
    constraint fk_jorn_disp FOREIGN key (id_vinculacion_instructor) REFERENCES instructor.jornada_instructor (id),
    CONSTRAINT uk_disponibilidad_horaria UNIQUE (id_jornada_instructor, id_vinculacion_instructor)
);

CREATE SCHEMA horarios; 

CREATE TABLE horarios.dia(
    id serial NOT NULL,
    nombre_dia VARCHAR (40) NOT NULL,
    estado VARCHAR (40) NOT NULL,
    constraint pk_dia PRIMARY KEY (id),
    CONSTRAINT uk_dia UNIQUE (nombre_dia)
);

create table horarios.modalidad(
    id serial NOT NULL,
    nombre_modalidad VARCHAR (40) NOT NULL ,
    color varchar (50) NOT NULL ,
    estado VARCHAR (40) NOT NULL,
    constraint pk_modalidad PRIMARY KEY (id),
    CONSTRAINT uk_modalidad UNIQUE (nombre_modalidad)
);

create table horarios.trimestre_vigente(
    id serial NOT NULL,
    id_year INTEGER NOT NULL,
    trimestre_programado INTEGER NOT NULL ,
    fecha_inicio date NOT NULL,
    fecha_fin date NOT NULL,
    estado VARCHAR(40) NOT NULL,
    constraint pk_trimestre_vigente PRIMARY KEY (id),
    CONSTRAINT fk_year_trim_vige FOREIGN key (id_year) REFERENCES instructor.year (id),
    CONSTRAINT uk_trimestre_vigente UNIQUE (id_year, trimestre_programado)
);

create table horarios.version_horario(
    id serial NOT NULL,
    numero_version VARCHAR(40) NOT NULL ,
    id_trimestre_vigente int4 NOT NULL,
    estado VARCHAR(40) NOT NULL,
    constraint pk_version_horario PRIMARY KEY (id),
    CONSTRAINT fk_trvi_veho FOREIGN key (id_trimestre_vigente) REFERENCES horarios.trimestre_vigente (id),
    CONSTRAINT uk_version_horario UNIQUE (numero_version, id_trimestre_vigente)
);

create table horarios.horario(
    id serial NOT NULL,
    hora_inicio TIME NOT NULL ,
    id_ficha_has_trimestre int4 NOT NULL,
    id_instructor int4 NOT NULL,
    id_dia int4 NOT NULL,
    id_ambiente int4 NOT NULL,
    id_version_horario int4 NOT NULL,
    hora_fin TIME NOT NULL,
    id_modalidad int4 NOT NULL,
    constraint pk_horario PRIMARY KEY (id),
    CONSTRAINT fk_fitr_hora FOREIGN key (id_ficha_has_trimestre) REFERENCES ficha.ficha_has_trimestre (id),
    CONSTRAINT fk_amb_hora FOREIGN key (id_ambiente) REFERENCES sede.ambiente (id),
    CONSTRAINT fk_inst_hora FOREIGN key (id_instructor) REFERENCES instructor.instructor (id),
    CONSTRAINT fk_dia_hora FOREIGN key (id_dia) REFERENCES horarios.dia (id),
    CONSTRAINT fk_veho_hora FOREIGN key (id_version_horario) REFERENCES horarios.version_horario (id),
    CONSTRAINT fk_moda_hora FOREIGN key (id_modalidad) REFERENCES horarios.modalidad (id),
    CONSTRAINT uk_horario UNIQUE (hora_inicio, id_ficha_has_trimestre, id_instructor, id_dia, id_ambiente, id_version_horario,  hora_fin )
);

CREATE SCHEMA programa;

create table programa.competencia(
     id serial NOT NULL,
     id_programa INTEGER NOT NULL,
     codigo_competencia VARCHAR (50) NOT NULL,
     denominacion VARCHAR (1000) NOT NULL,
     constraint pk_competencia PRIMARY KEY (id),
     CONSTRAINT uk_competencia UNIQUE (id_programa, codigo_competencia)
);

create table programa.nivel_formacion(
     id serial NOT NULL,
     nivel VARCHAR(40) NOT NULL,
     estado VARCHAR (40) NOT NULL,
     constraint pk_nivel_formacion PRIMARY KEY (id),
     CONSTRAINT uk_nivel UNIQUE (nivel)
);

create table programa.programa(
     id serial NOT NULL,
     codigo VARCHAR(50) NOT NULL,
     version VARCHAR (50) NOT NULL,
     nombre VARCHAR (500) NOT NULL,
     sigla VARCHAR (40) NOT NULL,
     estado VARCHAR (40) NOT NULL,
     id_nivel_formacion INTEGER not NULL,
     constraint pk_programa PRIMARY KEY (id),
     CONSTRAINT fk_nifo_prog FOREIGN KEY (id_nivel_formacion) REFERENCES programa.nivel_formacion (id),
     CONSTRAINT uk_programa UNIQUE (codigo)
);

create table programa.planeacion(
     id serial NOT NULL,
     codigo VARCHAR(40) NOT NULL,
     fecha date NOT NULL,
     estado VARCHAR (40) NOT NULL,
     constraint pk_planeacion PRIMARY KEY (id),
     CONSTRAINT uk_codigo UNIQUE (codigo)
);

create table programa.resultado_aprendizaje(
     id serial NOT NULL,
     codigo_resultado VARCHAR(40) NOT NULL,
     id_competencia int4 NOT NULL,
     denominacion VARCHAR (1000) NOT NULL,
     constraint pk_resultado_aprendizaje PRIMARY KEY (id),
     CONSTRAINT fk_comp_reap FOREIGN KEY (id_competencia) REFERENCES programa.competencia (id),
     CONSTRAINT uk_resultado_aprendizaje UNIQUE (codigo_resultado, id_competencia)
);

create table programa.programacion_trimestre(
     id serial NOT NULL,
     id_resultado_aprendizaje int4 NOT NULL,
     id_trimestre int4 NOT NULL,
     id_planeacion int4 NOT NULL,
     constraint pk_programacion_trimestre PRIMARY KEY (id),
     CONSTRAINT fk_reap_pltr FOREIGN KEY (id_resultado_aprendizaje) REFERENCES programa.resultado_aprendizaje (id),
     CONSTRAINT fk_trim_plane FOREIGN KEY (id_trimestre) REFERENCES programa.planeacion (id),
     CONSTRAINT fk_trim_pltr FOREIGN KEY (id_planeacion) REFERENCES ficha.trimestre (id),
     CONSTRAINT uk_programacion_trimestre UNIQUE (id_resultado_aprendizaje, id_trimestre, id_planeacion)
);

create table programa.actividad_planeacion(
     id serial NOT NULL,
     id_actividad_proyecto int4 NOT NULL,
     id_programacion_trimestre int4 NOT NULL,
     constraint pk_actividad_planeacion PRIMARY KEY (id),
     CONSTRAINT fk_programacion FOREIGN KEY (id_programacion_trimestre) REFERENCES programa.programacion_trimestre (id),
     CONSTRAINT fk_acti_acpl FOREIGN KEY (id_actividad_proyecto) REFERENCES proyectos.actividad_proyecto (id),
     CONSTRAINT uk_actividad_planeacion UNIQUE (id_actividad_proyecto, id_programacion_trimestre)
);


CREATE schema sede;

CREATE TABLE sede.sede(
     id serial NOT NULL,
     nombre_sede VARCHAR (50) NOT NULL,
     direccion VARCHAR (400) NOT NULL,
     estado VARCHAR(40) NOT NULL,
     constraint pk_sede PRIMARY KEY (id),
     CONSTRAINT uk_sede UNIQUE (nombre_sede)
);

CREATE TABLE sede.tipo_ambiente(
     id serial NOT NULL,
     tipo VARCHAR (50) NOT NULL,
     descripcion VARCHAR (100) NOT NULL,
     estado VARCHAR(40) NOT NULL,
     constraint pk_tipo_ambiente PRIMARY KEY (id),
     CONSTRAINT uk_tipo_ambiente UNIQUE (tipo)
);

CREATE TABLE sede.ambiente(
     id serial NOT NULL,
     id_sede INTEGER NOT NULL,
     numero_ambiente VARCHAR (50) NOT NULL,
     descripcion VARCHAR (1000) NOT NULL,
     estado VARCHAR(40) NOT NULL,
     limitacion VARCHAR(40) NOT NULL,
     id_tipo_ambiente INTEGER not NULL,
     constraint pk_ambiente PRIMARY KEY (id),
     constraint fk_sede_ambi FOREIGN KEY (id_sede) REFERENCES sede.sede (id),
     constraint fk_tiam_ambi FOREIGN KEY (id_tipo_ambiente) REFERENCES sede.tipo_ambiente (id),
     CONSTRAINT uk_ambiente UNIQUE (id_sede, numero_ambiente)
);

CREATE TABLE sede.limitacion_ambiente(
     id serial NOT NULL,
     id_resultado_aprendizaje INTEGER NOT NULL,
     id_ambiente int4 NOT NULL,
     constraint pk_limitacion_ambiente PRIMARY KEY (id),
     constraint fk_ambi_liam FOREIGN KEY (id_ambiente) REFERENCES sede.ambiente (id),
     constraint fk_reap_liam FOREIGN KEY (id_resultado_aprendizaje) REFERENCES programa.resultado_aprendizaje (id),
     CONSTRAINT uk_limitacion_ambiente UNIQUE (id_resultado_aprendizaje, id_ambiente)
);

CREATE SCHEMA ficha; 

create table ficha.estado_formacion(
    id serial NOT NULL,
    nombre_estado VARCHAR (40) not null,
    estado varchar (40) not  NULL,
    constraint pk_estado_formacion PRIMARY KEY (id),
    CONSTRAINT uk_nombre_estado UNIQUE (nombre_estado)
);

create table ficha.estado_ficha(
    id serial NOT NULL,
    nombre_estado VARCHAR(20) not null,
    estado int2 not  NULL,
    constraint pk_estado_ficha PRIMARY KEY (id),
    CONSTRAINT uk_nombre_estados UNIQUE (nombre_estado)
);

create table ficha.jornada(
    id serial NOT NULL,
    sigla_jornada varchar(20) not null,
    nombre_jornada VARCHAR (40) NOT NULL,
    descripcion VARCHAR (100) not null,
    imagen_url VARCHAR (1000),
    estado varchar (40) not null,
    constraint pk_jornada PRIMARY KEY (id),
    constraint uk_sigla_jornada UNIQUE (sigla_jornada),
    constraint uk_nombre_sigla UNIQUE (nombre_jornada)
);

create Table ficha.trimestre(
    id serial NOT NULL,
    nombre_trimestre integer NOT NULL,
    id_jornada INTEGER not NULL,
    id_nivel_formacion int4 not null,
    estado VARCHAR (40) not null,
    constraint pk_trimestre PRIMARY KEY (id),
    constraint fk_jorn_trim FOREIGN KEY (id_jornada) REFERENCES ficha.jornada (id),
    constraint fk_nifo_trim FOREIGN KEY (id_nivel_formacion) REFERENCES programa.nivel_formacion (id),
    CONSTRAINT uk_trimestre UNIQUE (nombre_trimestre, id_jornada, id_nivel_formacion)
);

create Table ficha.ficha(
    id serial NOT NULL,
    id_programa INTEGER NOT null,
    numero_ficha VARCHAR(100) NOT NULL,
    fecha_inicio date not NULL,
    fecha_fin date not NULL,
    ruta VARCHAR (40) not null,
    id_estado_ficha int4 not null,
    id_jornada int4 not null,
    constraint pk_ficha PRIMARY KEY (id),
    constraint fk_prog_fich FOREIGN KEY (id_programa) REFERENCES programa.programa (id),
    constraint fk_exfi_fich FOREIGN KEY (id_estado_ficha) REFERENCES ficha.estado_ficha (id),
    constraint fk_jorn_fich FOREIGN KEY (id_jornada) REFERENCES ficha.jornada (id),
    CONSTRAINT uk_ficha UNIQUE (numero_ficha)
);

create Table ficha.ficha_has_trimestre(
    id serial NOT NULL,
    id_ficha INTEGER not NULL,
    id_trimestre int4 not null,
    constraint pk_ficha_has_trimestre PRIMARY KEY (id),
    constraint fk_ficha FOREIGN KEY (id_ficha) REFERENCES ficha.ficha (id),
    constraint fk_trim_fitr FOREIGN KEY (id_trimestre) REFERENCES ficha.trimestre (id),
    CONSTRAINT uk_ficha_has_trimestre UNIQUE (id_ficha, id_trimestre)
);

CREATE TABLE ficha.resultados_vistos(
    id serial NOT NULL,
    id_resultado_aprendizaje INTEGER not NULL,
    id_ficha_has_trimestre int4 not null,
    id_planeacion int4 not null,
    constraint pk_resultados_vistos PRIMARY KEY (id),
    constraint fk_nifo_prog FOREIGN KEY (id_planeacion) REFERENCES programa.planeacion (id),
    constraint fk_reap_revi FOREIGN KEY (id_resultado_aprendizaje) REFERENCES programa.resultado_aprendizaje (id),
    constraint fk_fitr_revi FOREIGN KEY (id_ficha_has_trimestre) REFERENCES ficha.ficha_has_trimestre (id),
    CONSTRAINT uk_resultados_vistos UNIQUE (id_planeacion, id_resultado_aprendizaje, id_ficha_has_trimestre)
);

CREATE TABLE ficha.aprendiz(
    id serial NOT NULL,
    id_cliente INTEGER not NULL,
    id_ficha int4 not null,
    id_estado_formacion int4 not null,
    constraint pk_aprendiz PRIMARY KEY (id),
    constraint fk_clie_apre FOREIGN KEY (id_cliente) REFERENCES cliente.cliente (id),
    constraint fk_esta_apre FOREIGN KEY (id_estado_formacion) REFERENCES ficha.estado_formacion (id),
    constraint fk_fich_apre FOREIGN KEY (id_ficha) REFERENCES ficha.ficha (id),
    CONSTRAINT uk_aprendiz UNIQUE (id_cliente, id_ficha)
);

CREATE TABLE ficha.ficha_planeacion(
    id serial NOT NULL,
    id_ficha int4 not null,
    id_planeacion int4 not null,
    estado VARCHAR(40) not null,
    constraint pk_ficha_planeacion PRIMARY KEY (id),
    constraint fk_ficha FOREIGN KEY (id_ficha) REFERENCES ficha.ficha (id),
    constraint fk_jorn_fich FOREIGN KEY (id_planeacion) REFERENCES programa.planeacion (id),
    CONSTRAINT uk_ficha_planeacion UNIQUE (id_ficha, id_planeacion)
);

CREATE SCHEMA proyectos; 

CREATE TABLE proyectos.proyecto(
    id serial NOT NULL,
    codigo VARCHAR (40) not NULL,
    nombre VARCHAR (500) not NULL,
    estado VARCHAR (40) not null,
    id_programa INTEGER not NULL,
    constraint pk_proyecto PRIMARY KEY (id),
    constraint fk_prog_proy FOREIGN KEY (id_programa) REFERENCES programa.programa(id),
    CONSTRAINT uk_programa UNIQUE (codigo)
);

create table proyectos.fase (
    id serial NOT NULL,
    id_proyecto INTEGER not null,
    nombre VARCHAR (40) not null,
    estado VARCHAR (40) not null,
    constraint pk_fase PRIMARY KEY (id),
    constraint fk_proy_fase FOREIGN key (id_proyecto) REFERENCES proyectos.proyecto(id),
    CONSTRAINT uk_fase UNIQUE (id_proyecto, nombre)
);

create table proyectos.actividad_proyecto (
    id serial NOT NULL,
    id_fase INTEGER not null,
    numero_actividad INTEGER NOT null,
    descripcion_actividad VARCHAR (400) not null,
    estado VARCHAR (40) NOT NULL,
    constraint pk_actividad_proyecto PRIMARY KEY (id),
    constraint fk_fase_acti FOREIGN KEY (id_fase) REFERENCES proyectos.fase (id),
    CONSTRAINT uk_actividad_proyecto UNIQUE (id_fase, numero_actividad)
);

CREATE SCHEMA logs;

CREATE table logs.log_errores(
    id serial NOT NULL,
    nivel VARCHAR (400) NOT NULL,
    log_name VARCHAR (400) NOT NULL,
    mensaje VARCHAR (400) not NULL,
    fecha date not null,
    id_cliente INTEGER NOT NULL,
    constraint pk_log_errores PRIMARY KEY (id),
    constraint fk_clie_log_erro FOREIGN key (id_cliente) REFERENCES cliente.cliente(id)
);

create table logs.log_auditoria(
	id serial NOT NULL,
	nivel varchar(400) not null,
	log_name varchar(400) not null,
	mensaje varchar(400) not  null,
	fecha date not null,
	id_cliente INTEGER NOT NULL,
	constraint pk_log_auditoria primary key (id),
	constraint fk_clie_log_audi FOREIGN key (id_cliente) REFERENCES cliente.cliente(id)
);

CREATE SCHEMA package; 

create table package.grupo_proyecto(
    id serial NOT NULL,
    id_ficha integer NOT NULL,
    numero_grupo serial not null,
    nombre_proyecto varchar (300) not NULL,
    estado_grupo_proyecto VARCHAR (40) NOT NULL,
    constraint pk_grupo_proyecto PRIMARY KEY (id),
    constraint fk_fich_grup_proy FOREIGN KEY (id_ficha) REFERENCES ficha.ficha (id),
    CONSTRAINT uk_grupo_proyecto UNIQUE (id_ficha, numero_grupo)
);

create table package.integrantes_grupo(
    id serial NOT NULL,
    id_aprendiz int4 NOT NULL,
    id_grupo_proyecto int4 NOT NULL,
    constraint pk_integrantes_grupo PRIMARY KEY (id),
    constraint fk_apre_ingr FOREIGN KEY (id_aprendiz) REFERENCES ficha.aprendiz (id),
    constraint fk_grpr_ingr FOREIGN KEY (id_grupo_proyecto) REFERENCES package.integrantes_grupo (id),
    CONSTRAINT uk_integrantes_grupo UNIQUE (id_aprendiz, id_grupo_proyecto)
);

create table package.observacion_general(
    id serial NOT NULL,
    numero INTEGER not null,
    id_grupo_proyecto INTEGER not null,
    observacion VARCHAR(500)not null,
    jurado VARCHAR(500) not null,
    fecha TIMESTAMP not null,
    id_cliente INTEGER not null,
    constraint pk_obsevacion_general PRIMARY key (id),
    constraint fk_grpr_obge FOREIGN key (id_grupo_proyecto) REFERENCES package.grupo_proyecto(id),
    constraint fk_dccl_sicl FOREIGN KEY (id_cliente) REFERENCES cliente.cliente(id),
    CONSTRAINT uk_observacion_general UNIQUE (numero, id_grupo_proyecto)   
);

create table package.lista_chequeo(
    id serial NOT NULL,
    id_programa INTEGER not null,
    lista VARCHAR(50) not NULL,
    estado INTEGER not null,
    constraint pk_lista_chequeo PRIMARY key (id),
    constraint fk_prog_linch FOREIGN key (id_programa) REFERENCES programa.programa(id),
    CONSTRAINT uk_lista UNIQUE (lista)
);

create TABLE package.item_lista (
    id serial NOT NULL,
    id_lista_chequeo integer NOT NULL,
    numero_item int4 not null,
    pregunta VARCHAR(1000),
    id_resultado_aprendizaje integer NOT NULL,
    constraint pk_item_lista PRIMARY KEY (id),
    constraint fk_lich_itli FOREIGN KEY (id_lista_chequeo) REFERENCES package.lista_chequeo (id),
    constraint fk_reap_itli FOREIGN KEY (id_resultado_aprendizaje) REFERENCES programa.resultado_aprendizaje (id),
    CONSTRAINT uk_item_lista UNIQUE (id_lista_chequeo, numero_item)
);

CREATE TABLE package.valoracion(
    id serial NOT NULL,
    tipo_valoracion VARCHAR(50) NOT NULL,
    estado VARCHAR(40) NOT NULL,
    constraint pk_valoracion PRIMARY KEY (id),
    CONSTRAINT uk_valoracion UNIQUE (tipo_valoracion)
);

CREATE TABLE package.respuesta_grupo(
    id serial NOT NULL,
    id_item_lista int4 NOT NULL,
    id_grupo_proyecto int4 NOT NULL,
    id_valoracion int4 NOT NULL,
    fecha TIMESTAMP NOT NULL,
    constraint pk_respuesta_grupo PRIMARY KEY (id),
    constraint fk_itli_regr FOREIGN KEY (id_item_lista) REFERENCES package.item_lista (id),
    constraint fk_valo_regr FOREIGN KEY (id_valoracion) REFERENCES package.valoracion (id),
    constraint fk_grpr_regr FOREIGN KEY (id_grupo_proyecto) REFERENCES package.grupo_proyecto (id),
    CONSTRAINT uk_respuesta_grupo UNIQUE (id_item_lista, id_grupo_proyecto)
);

create table package.observacion_respuesta(
    id serial NOT NULL,
    numero_observacion INTEGER NOT NULL,
    id_respuesta_grupo INTEGER NOT NULL,
    observacion VARCHAR (400) NOT NULL,
    jurados VARCHAR (400) NOT NULL,
    fecha TIMESTAMP NOT NULL,
    id_cliente INTEGER not null, 
    constraint pk_observacion_respuesta PRIMARY KEY (id),
    constraint fk_regr_obre FOREIGN KEY (id_respuesta_grupo) REFERENCES package.respuesta_grupo(id),
    constraint fk_clie_obre FOREIGN KEY (id_cliente) REFERENCES cliente.cliente (id),
     CONSTRAINT uk_observacion_respuesta UNIQUE (numero_observacion, id_respuesta_grupo)
);

CREATE TABLE package.lista_ficha(
    id serial NOT NULL,
    id_ficha INTEGER NOT NULL,
    id_lista_chequeo INTEGER NOT NULL,
    estado VARCHAR(40) NOT NULL ,
    constraint pk_lista_ficha PRIMARY KEY (id),
    constraint fk_fich_lifi FOREIGN KEY (id_ficha) REFERENCES ficha.ficha (id),
    constraint fk_lich_lifi FOREIGN KEY (id_lista_chequeo) REFERENCES package.lista_chequeo (id) 
);