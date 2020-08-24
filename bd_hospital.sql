CREATE DATABASE bd_hospital;
GO
USE bd_hospital;
GO
//* pilas en la misma carpeta hay una version de esta base dedatos mas actualizada que incluye procedimientos almacenados para cadauna*/
CREATE TABLE tipoSeguro(
	idTipoSeguro int identity(1,1),
	tipo varchar(15),
constraint pk_tipoSeg primary key (idTipoSeguro)
);

CREATE TABLE seguro(
	idSeguro int,
	nombre varchar(15),
	idTipo int,
constraint pk_seguro primary key (idSeguro),
constraint fk_tipo_seg foreign key (idTipo) references tipoSeguro (idTipoSeguro)
);

CREATE TABLE paciente(
	idPaciente int,
	nombre varchar(30) not null,
	apellido varchar(30) not null,
	sexo varchar(10) not null,
	direccion varchar(50),
	telefono varchar(15),
	fechaNacimiento date not null,
	idSeguro int,
constraint pk_paciente primary key (idPaciente),
constraint fk_seg_pac foreign key (idSeguro) references seguro (idSeguro)
);

GO
CREATE PROC ingresarActualizar_Pac(
	@idPaciente int,
	@nombre varchar(30),
	@apellido varchar(30),
	@sexo varchar(10),
	@direccion varchar(50),
	@telefono varchar(15),
	@fechaNacimiento date,
	@idSeguro int
)
as
if not exists (select idPaciente from paciente where idPaciente=@idPaciente)
insert into paciente(idPaciente, nombre, apellido, sexo, direccion, telefono, fechaNacimiento, idSeguro)
values (@idPaciente, @nombre, @apellido, @sexo, @direccion, @telefono, @fechaNacimiento, @idSeguro)
else
update paciente set nombre=@nombre, apellido=@apellido, sexo=@sexo, direccion=@direccion,
					telefono=@telefono, fechaNacimiento=@fechaNacimiento, idSeguro=@idSeguro
where idPaciente=@idPaciente

CREATE TABLE especialidad(
	idEspecialidad int,
	nombre varchar(20) not null,
	descripcion text,
constraint pk_espec primary key (idEspecialidad)
);

CREATE TABLE medico(
	idMedico int,
	nombre varchar(30) not null,
	apellido varchar(30) not null,
	sexo varchar(10) not null,
	direccion varchar(50),
	telefono varchar(15),
	registroMedico varchar(15) not null,
	idEspecialidad int,
constraint pk_medico primary key (idMedico),
constraint fk_espec_med foreign key (idEspecialidad) references especialidad (idEspecialidad)
);

CREATE TABLE enfermero(
	idEnfermero int,
	nombre varchar(30) not null,
	apellido varchar(30) not null,
	sexo varchar(10) not null,
	direccion varchar(50),
	telefono varchar(15),
	cargo varchar(20),
	registro varchar(15) not null,
constraint pk_enfermero primary key (idEnfermero)
);

CREATE TABLE sistema(
	idSistema int,
	nombre varchar(30),
constraint pk_sist primary key (idSistema)
);

CREATE TABLE clasifDiagnostico(
	idClasificacion char(3),
	nombre varchar(50),
	idSistema int,
constraint pk_clasDiagn primary key (idClasificacion),
constraint fk_sist_clasf foreign key (idSistema) references sistema (idSistema)
);

CREATE TABLE diagnostico(
	codDiagnostico char(4),
	nombre varchar(50),
	idClasificacion char(3),
constraint pk_diagn primary key (codDiagnostico),
constraint fk_clasif_diagn foreign key (idClasificacion) references clasifDiagnostico (idClasificacion)
);

CREATE TABLE planta(
	idPlanta char(2),
	nombre varchar(20) not null,
constraint pk_planta primary key (idPlanta)
);

CREATE TABLE cama(
	idCama int,
	idPlanta char(2),
constraint pk_cama primary key (idcama),
constraint fk_planta_cama foreign key (idPlanta) references planta(idPlanta)
);

--INSERT INTO cama (idCama, idPlanta) VALUES (101, 'A'), (102, 'A'), (103, 'A'), (104, 'A'), (201, 'B'), (202, 'B'), (203, 'B'),
--										   (204, 'B'), (205, 'B'), (206, 'B'), (301, 'C'), (302, 'C'), (303, 'C'), (304, 'C');

CREATE TABLE servicio(
	codServicio int,
	nombre varchar(20),
constraint pk_servicio primary key (codServicio)
);

CREATE TABLE ingreso(
	codIngreso int identity(1,1),
	fechaIngreso datetime not null,
	motivo text not null,
	idPaciente int not null,
	idEnfermero int not null,
	idMedico int not null,
	codServicio int,
constraint pk_ingreso primary key (codIngreso),
constraint fk_pac_ingreso foreign key (idPaciente) references paciente (IdPaciente),
constraint fk_enf_ingreso foreign key (idEnfermero) references enfermero (idEnfermero),
constraint fk_med_ingreso foreign key (idMedico) references medico (idMedico),
constraint fk_serv_ingreso foreign key (codServicio) references servicio (codServicio),
);

CREATE TABLE alta(
	codAlta int identity(1,1),
	fechaAlta datetime not null,
	motivo text not null,
	valorPagar money,
	idPaciente int not null,
	idMedico int not null,
	idEnfermero int not null,
constraint pk_alta primary key (codAlta),
constraint fk_pac_alta foreign key (idPaciente) references paciente (IdPaciente),
constraint fk_enf_alta foreign key (idEnfermero) references enfermero (idEnfermero),
constraint fk_med_alta foreign key (idMedico) references medico (idMedico),
);

CREATE TABLE procedimiento(
	codProcedimiento int identity(10,1),
	nombre varchar(20) not null,
	descripción text,
constraint pk_proc primary key (codProcedimiento),
);

CREATE TABLE tratamiento(
	codTratamiento int identity(100,1),
	idProcedimiento int not null,
	idPaciente int not null,
constraint pk_tto primary key (codTratamiento),
constraint fk_proc_tto foreign key (idProcedimiento) references procedimiento (codProcedimiento),
constraint fk_pac_tto foreign key (idPaciente) references paciente (IdPaciente),
);


CREATE TABLE historiaClinica (
  idHistoria int not null,
  idPaciente int not null,
  codDiagnostico char(4) not null,
constraint pk_hc primary key (idHistoria),
constraint fk_pac_hc foreign key (idPaciente) references paciente (IdPaciente),
constraint fk_diagn_hc foreign key (codDiagnostico) references diagnostico (codDiagnostico),
);

create table pacienteCama
(
	idPacienteCama int identity,
	fechaAsignacion datetime,
	fechaSalida datetime,
	idCama int,
	idHistoria int,
constraint pk_pacCama primary key (idPacienteCama),
constraint fk_cama_pacCama foreign key (idCama) references cama(idCama),
constraint fk_hc_pacCama foreign key (idHistoria) references historiaClinica(idHistoria)
);

CREATE TABLE revisionMedica(
	idRevision int,
	fechaRevision datetime not null,
	idHistoria int not null,
	observaciones text,
constraint pk_revision primary key (idREvision),
constraint fk_hc_revision foreign key (idHistoria) references historiaClinica(idHistoria)
);