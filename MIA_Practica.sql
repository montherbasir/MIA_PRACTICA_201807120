
--1) Generacion de tablas

CREATE TABLE PROFESION(
    cod_prof INTEGER NOT NULL PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE PAIS(
    cod_pais INTEGER NOT NULL PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE PUESTO(
    cod_puesto INTEGER NOT NULL PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE DEPARTAMENTO(
    cod_depto INTEGER NOT NULL PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE MIEMBRO(
    cod_miembro INTEGER NOT NULL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    edad INTEGER NOT NULL,
    telefono INTEGER,
    residencia VARCHAR(100),
    PAIS_cod_pais INTEGER NOT NULL,
    PROFESION_cod_prof INTEGER NOT NULL,

    FOREIGN KEY (PAIS_cod_pais) REFERENCES PAIS(cod_pais) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (PROFESION_cod_prof) REFERENCES PROFESION(cod_prof) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE PUESTO_MIEMBRO(
    MIEMBRO_cod_miembro INTEGER NOT NULL,
    PUESTO_cod_puesto INTEGER NOT NULL,
    DEPARTAMENTO_cod_depto INTEGER NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,

    PRIMARY KEY (MIEMBRO_cod_miembro, PUESTO_cod_puesto, DEPARTAMENTO_cod_depto),
    FOREIGN KEY (MIEMBRO_cod_miembro) REFERENCES MIEMBRO(cod_miembro) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (PUESTO_cod_puesto) REFERENCES PUESTO(cod_puesto) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (DEPARTAMENTO_cod_depto) REFERENCES DEPARTAMENTO(cod_depto) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE TIPO_MEDALLA(
    cod_tipo INTEGER NOT NULL PRIMARY KEY,
    medalla VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE MEDALLERO(
    PAIS_cod_pais INTEGER NOT NULL,
    cantidad_medallas INTEGER NOT NULL,
    TIPO_MEDALLA_cod_tipo INTEGER NOT NULL,

    PRIMARY KEY (PAIS_cod_pais, TIPO_MEDALLA_cod_tipo),
    FOREIGN KEY (PAIS_cod_pais) REFERENCES PAIS(cod_pais) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (TIPO_MEDALLA_cod_tipo) REFERENCES TIPO_MEDALLA(cod_tipo) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DISCIPLINA(
    cod_disciplina INTEGER NOT NULL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(150)
);

CREATE TABLE ATLETA(
    cod_atleta INTEGER NOT NULL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    edad INTEGER NOT NULL,
    Participaciones VARCHAR(100) NOT NULL,
    DISCIPLINA_cod_disciplina INTEGER NOT NULL,
    PAIS_cod_pais INTEGER NOT NULL,

    FOREIGN KEY (PAIS_cod_pais) REFERENCES PAIS(cod_pais) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (DISCIPLINA_cod_disciplina) REFERENCES DISCIPLINA(cod_disciplina) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE CATEGORIA(
    cod_categoria INTEGER NOT NULL PRIMARY KEY,
    categoria VARCHAR(50) NOT NULL
);

CREATE TABLE TIPO_PARTICIPACION(
    cod_participacion INTEGER NOT NULL PRIMARY KEY,
    tipo_participacion VARCHAR(100) NOT NULL
);

CREATE TABLE EVENTO(
    cod_evento INTEGER NOT NULL PRIMARY KEY,
    fecha DATE NOT NULL,
    ubicacion VARCHAR(50) NOT NULL,
    hora DATE NOT NULL,
    DISCIPLINA_cod_disciplina INTEGER NOT NULL,
    TIPO_PARTICIPACION_cod_participacion INTEGER NOT NULL,
    CATEGORIA_cod_categoria INTEGER NOT NULL,

    FOREIGN KEY (DISCIPLINA_cod_disciplina) REFERENCES DISCIPLINA(cod_disciplina) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (TIPO_PARTICIPACION_cod_participacion) REFERENCES TIPO_PARTICIPACION(cod_participacion) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (CATEGORIA_cod_categoria) REFERENCES CATEGORIA(cod_categoria) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE EVENTO_ATLETA(
    ATLETA_cod_atleta INTEGER NOT NULL,
    EVENTO_cod_evento INTEGER NOT NULL,

    PRIMARY KEY (ATLETA_cod_atleta, EVENTO_cod_evento),
    FOREIGN KEY (ATLETA_cod_atleta) REFERENCES ATLETA(cod_atleta) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (EVENTO_cod_evento) REFERENCES EVENTO(cod_evento) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE TELEVISORA(
    cod_televisora INTEGER NOT NULL PRIMARY KEY,
    nombre VARCHAR(50)
);

CREATE TABLE COSTO_EVENTO(
    EVENTO_cod_evento INTEGER NOT NULL,
    TELEVISORA_cod_televisora INTEGER NOT NULL,
    Tarifa NUMERIC NOT NULL,

    PRIMARY KEY (EVENTO_cod_evento, TELEVISORA_cod_televisora),
    FOREIGN KEY (EVENTO_cod_evento) REFERENCES EVENTO(cod_evento) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (TELEVISORA_cod_televisora) REFERENCES TELEVISORA(cod_televisora) ON DELETE CASCADE ON UPDATE CASCADE
);

--2) Eliminar columnas fecha y hora
ALTER TABLE EVENTO DROP fecha;
ALTER TABLE EVENTO DROP hora;

--2) Crear columna fecha_hora
ALTER TABLE EVENTO ADD fecha_hora TIMESTAMP;


--3) Script que solo permite registrar eventos entre 
--	 el 24 de julio del 2020 a las 9:00:00 y el 9 de agosto de 2020 a las 20:00:00
ALTER TABLE EVENTO 
	ADD CONSTRAINT event_date
		CHECK (fecha_hora BETWEEN '2020-07-24 9:00:00' AND '2020-08-09 20:00:00');

--4a) Crear tabla sede
CREATE TABLE SEDE(
    cod_sede INTEGER NOT NULL PRIMARY KEY,
    sede VARCHAR(50) NOT NULL
);

--4b) Cambiar el tipo de dato de la columna ubicacion por un entero
ALTER TABLE EVENTO 
	ALTER COLUMN ubicacion TYPE INTEGER USING ubicacion::INTEGER,
	ALTER COLUMN ubicacion SET NOT NULL;

--4c) Crear una llave foránea en la columna ubicación de la tabla Evento y referenciarla a la columna código de la tabla Sede        
ALTER TABLE EVENTO 
	ADD FOREIGN KEY (ubicacion) REFERENCES SEDE(cod_sede) ON DELETE CASCADE ON UPDATE CASCADE;   


--5) Default 0 para numeros de telefono
ALTER TABLE MIEMBRO
    ALTER COLUMN telefono SET DEFAULT 0;  	
--Actualiza los campos vacios anteriores
UPDATE MIEMBRO SET telefono = DEFAULT
	WHERE telefono = NULL;     


--6) Script de insercion

--Insercion a PAIS
INSERT INTO PAIS (cod_pais, nombre) VALUES
	(1, 'Guatemala'),
	(2, 'Francia'),
	(3, 'Argentina'),
	(4, 'Alemania'),
	(5, 'Italia'),
	(6, 'Brasil'),
	(7, 'Estados Unidos')
;

--Insercion a PROFESION
INSERT INTO PROFESION (cod_prof, nombre) VALUES
	(1, 'Medico'),
	(2, 'Arquitecto'),
	(3, 'Ingeniero'),
	(4, 'Secretaria'),
	(5, 'Auditor')
;

--Insercion a MIEMBRO
INSERT INTO MIEMBRO (cod_miembro, nombre, apellido, edad, telefono, residencia, PAIS_cod_pais, PROFESION_cod_prof) 
	VALUES
		(1, 'Scott', 'Mitchell', 32, NULL, '1092 Highland Drive Manitowoc, WI 54220', 7, 3),
		(2, 'Fanette', 'Poulin', 25, 25075853, '49, boulevard Aristide Briand 76120 LE GRAND-QUEVILLY', 2, 4),
		(3, 'Laura', 'Cunha Silva', 55, NULL, 'Rua Onze, 86 UberabaMG ', 6, 5),
		(4, 'Juan José', 'López', 38, 36985247, '26 calle 4-10 zona 11', 1, 2),
		(5, 'Arcangela', 'Panicucci', 39, 391664921, 'Via Santa Teresa, 114 90010-Geraci Siculo PA', 5, 1),
		(6, 'Jeuel', 'Villalpando', 31, NULL, 'Acuña de Figeroa 6106 80101 Playa Pascual', 3, 5)
;

--Insercion a DISCIPLINA
INSERT INTO DISCIPLINA (cod_disciplina, nombre, descripcion)
	VALUES
		(1, 'Atletismo', 'Saltos de longitud y triples, de altura y con pértiga o garrocha; las pruebas de lanzamiento de martillo, jabalina y disco.'),
		(2, 'Bádminton', NULL),
		(3, 'Ciclismo', NULL),
		(4, 'Judo', 'Es un arte marcial que se originó en Japón alrededor de 1880'),
		(5, 'Lucha', NULL),
		(6, 'Tenis de Mesa', NULL),
		(7, 'Boxeo', NULL),
		(8, 'Natación', 'Está presente como deporte en los Juegos desde la primera edición de la era moderna, en Atenas, Grecia, en 1896, donde se disputo en aguas abiertas.'),
		(9, 'Esgrima', NULL),
		(10, 'Vela', NULL)
;

--Insercion a TIPO_MEDALLA
INSERT INTO TIPO_MEDALLA (cod_tipo, medalla) VALUES
	(1, 'Oro'),
	(2, 'Plata'),
	(3, 'Bronce'),
	(4, 'Platino')
;

--Insercion a CATEGORIA
INSERT INTO CATEGORIA (cod_categoria, categoria) VALUES
	(1, 'Clasificatorio'),
	(2, 'Eliminatorio'),
	(3, 'Final')
;

--Insercion a TIPO_PARTICIPACION
INSERT INTO TIPO_PARTICIPACION (cod_participacion, tipo_participacion) VALUES
	(1, 'Individual'),
	(2, 'Parejas'),
	(3, 'Equipos')
;

--Insercion a MEDALLERO
INSERT INTO MEDALLERO (PAIS_cod_pais, cantidad_medallas, TIPO_MEDALLA_cod_tipo) VALUES
	(5, 3, 1),
	(2, 5, 1),
	(6, 4, 3),
	(4, 3, 4),
	(7, 10, 3),
	(3, 8, 2),
	(1, 2, 1),
	(1, 5, 4),
	(5, 7, 2)
;

--Insercion a SEDE
INSERT INTO SEDE (cod_sede, sede) VALUES
	(1, 'Gimnasio Metropolitano de Tokio'),
	(2, 'Jardín del Palacio Imperial de Tokio'),
	(3, 'Gimnasio Nacional Yoyogi'),
	(4, 'Nippon Budokan'),
	(5, 'Estadio Olímpico')
;

--Insercion a EVENTO
INSERT INTO EVENTO (cod_evento, fecha_hora, ubicacion, DISCIPLINA_cod_disciplina, TIPO_PARTICIPACION_cod_participacion, CATEGORIA_cod_categoria) 
	VALUES 
		(1, '2020-07-24 11:00:00', 3, 2, 2, 1),
		(2, '2020-07-26 10:30:00', 1, 6, 1, 3),
		(3, '2020-07-30 18:45:00', 5, 7, 1, 2),
		(4, '2020-08-01 12:15:00', 2, 1, 1, 1),
		(5, '2020-08-08 19:35:00', 4, 10, 3, 1)
;


--7) Script para eliminar restricciones unique
ALTER TABLE PAIS DROP CONSTRAINT PAIS_nombre_key;

ALTER TABLE TIPO_MEDALLA DROP CONSTRAINT TIPO_MEDALLA_medalla_key;

ALTER TABLE DEPARTAMENTO DROP CONSTRAINT DEPARTAMENTO_nombre_key;


--8a) Script que elimina la llave foránea de cod_disciplina
ALTER TABLE ATLETA DROP CONSTRAINT ATLETA_disciplina_fkey;
-- Elimina la columna
ALTER TABLE ATLETA DROP COLUMN DISCIPLINA_cod_disciplina;

--8b) Script que crea la tabla Disciplina_Atleta
CREATE TABLE DISCIPLINA_ATLETA(
    ATLETA_cod_atleta INTEGER NOT NULL,
    DISCIPLINA_cod_disciplina INTEGER NOT NULL,

    PRIMARY KEY (ATLETA_cod_atleta, DISCIPLINA_cod_disciplina),
    FOREIGN KEY (ATLETA_cod_atleta) REFERENCES ATLETA(cod_atleta) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (DISCIPLINA_cod_disciplina) REFERENCES DISCIPLINA(cod_disciplina) ON DELETE CASCADE ON UPDATE CASCADE
);


--9) Cambiar la columna tarifa a decimal con dos cifras
ALTER TABLE COSTO_EVENTO ALTER COLUMN Tarifa TYPE DECIMAL(25, 2);


--10) Script que borra la mdedalla platino
DELETE FROM TIPO_MEDALLA WHERE cod_tipo = 4;


--11) Elimina las tablas televisoras y costo evento
DROP TABLE COSTO_EVENTO;

DROP TABLE TELEVISORA;


--12) Elimina todos los registros de disciplina
DELETE FROM DISCIPLINA;


--13) Actualizar los numeros de telefono
UPDATE MIEMBRO
    SET telefono = 55464601
        WHERE nombre='Laura'
        AND apellido='Cunha Silva';

UPDATE MIEMBRO
    SET telefono = 91514243
        WHERE nombre='Jeuel'
        AND apellido='Villalpando';

UPDATE MIEMBRO
    SET telefono = 920686670
        WHERE nombre='Scott'
        AND apellido='Mitchell';


--14) Agregar columna Fotografia
/*
La forma mas comun de guardar imagense es como un archivo binario.
PostgreSQL ofrece dos formas de guardar datos binarios
Se pueden guardar en la tabla usando bytea o usando un Large Object, que almacena los datos  
en una tabla separada en un formato especial y crea una referencia a esta tabla en la tabla original.

Las dos formas tienen sus limitaciones 
el tipo bytea no esta disenado para guardar grandes cantidades de datos. 
Por el otro lado un Large Object puede almacenar grandes cantidades de datos, pero tiene sus limitaciones. 
Una de ellas es que cuando se elimina el dato solo se borra la referencia y para eliminar el Large Object hay que
realizar otra operacion. Ademas los Large Object tienen problemas de seguridad, ya que cualquiera conectado
a la base de datos puede ver y modificar los Large Object aunque no tenga permisos para la tabla original.

Debido a que solo es una foto de perfil, no es necesario tener una foto de muy alta calidad, bytea es mucho mas conveniente
en este caso.
*/
ALTER TABLE ATLETA
    ADD Fotografia BYTEA;


--15) Los atletas deben ser menores a 25
ALTER TABLE ATLETA
    ADD CONSTRAINT check_edad CHECK (edad < 25);