create schema DATABASEAPP;

create table DATABASEAPP.Usuario (
	Id serial not null,
    Tipo_Documento varchar (15) not null,
    Documento_Usuario Int4 null,
    Nombres_Usuario varchar (30) not null,
    Apellidos_Usuario varchar (30) not null,
    Telefono_Usuario varchar (30) not null,
    Email_Usuario varchar (50) not null,
    Contraseña_Usuario varchar (8) not null,
    Rol_Usuario varchar (15) not null,
	
	CONSTRAINT PK_Usuario PRIMARY KEY (id),
	CONSTRAINT UK_Tipo_Documento UNIQUE (Tipo_Documento),
	CONSTRAINT UK_Contraseña_Usuario UNIQUE (Contraseña_Usuario)
	);
    
    
create table DATABASEAPP.ROL(
	Id serial not null,
    Id_Usuario int4 null,
    Nombre_Rol varchar (15) not null,
    Descripcion_Rol varchar (15) not null,
    Estado varchar (10) not null,
	
	CONSTRAINT PK_ROL PRIMARY KEY (Id),
	CONSTRAINT FK_ROL FOREIGN KEY (Nombre_Rol) REFERENCES DATABASEAPP.Usuario(Contraseña_Usuario)
	);
    
create table DATABASEAPP.UsuarioRol (
	Id serial not null,
	Id_Rol int4 null,
    Id_Usuario int4 not null,
    
    CONSTRAINT PK_UsuarioRol PRIMARY KEY (Id),
	constraint fk_UsuarioRol foreign key (Id_Usuario)references DATABASEAPP.UsuarioRol (Id),
    constraint fk_Rol foreign key (Id_Rol)References DATABASEAPP.Rol (Id)
     );
    

    
create table  DATABASEAPP.Cliente (
	Id serial not null,
	Id_Cliente int4 null,
    Id_Usuario int4 not null,
    RazonSocial varchar (50) not null,
    ContactoCliente varchar (30) not null,
    EmailCliente varchar (50) not null,
    TelefonoCliente varchar (30) not null,
    EstadoCliente varchar (10) not null,
    
	CONSTRAINT PK_Cliente PRIMARY KEY (Id),
    constraint fk_Cliente foreign key (Id_Cliente)references DATABASEAPP.Cliente (Id)
    );
    
    


create table DATABASEAPP.Contrato (
	id serial not null,
	Id_Contrato int4 null,
	Id_Cliente int4 not null,
    ObjetoContrato varchar (200) not null,
    FechaInicio date,
    FechaFin date,
    PlazoContrato int4 not null,
    ValorContrato decimal (20,2) not null,
    
	CONSTRAINT PK_Contrato PRIMARY KEY (Id),
    constraint fk_Cliente_Contrato foreign key (Id_Contrato) references DATABASEAPP.Contrato (Id)
    );
    
    create table DATABASEAPP.Factura (
		id serial not null,
		Id_Factura int4 null,
        Id_Cliente int4 not null,
        fecha_Factura date,
        Nombre_Cliente varchar (50) not null,
        Direccion varchar (50) not null,
        Telefono int4 not null,
        Direccion_eb varchar (30) not null,
        Codigo_Servicio int4 not null,
        Descripcion_Servicio varchar (50) not null,
        Precio_Unidad decimal (10,2) not null,
        Cantidad decimal (3,2) not null,
        Descuentos decimal (3,2) not null,
        Total_Factura decimal (10,2) not null,
        Iva decimal (2,1) not null,
        Otros_Descuentos decimal (10,2) not null,
        Neto_Factura decimal (10,2) not null,
        
		CONSTRAINT PK_Factura PRIMARY KEY (Id),
        constraint fk_Factura_Cliente foreign key (Id_Factura)references DATABASEAPP.Factura (Id)
        );
        
        select  * from factura where TotalFactura >='10000'