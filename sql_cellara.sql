CREATE DATABASE cellara;
USE cellara;

CREATE TABLE empresa (
	id INT PRIMARY KEY AUTO_INCREMENT,
	cnpj CHAR(14) NOT NULL UNIQUE,
	nome VARCHAR(100) NOT NULL,
	codigo_ativacao VARCHAR(45) NOT NULL UNIQUE
);

CREATE TABLE usuario (
	id INT PRIMARY KEY AUTO_INCREMENT,
	nome_completo VARCHAR(255) NOT NULL,
	cpf CHAR(11) NOT NULL UNIQUE,
	email VARCHAR(150) NOT NULL UNIQUE,
	senha VARCHAR(80) NOT NULL,
	fk_empresa INT NOT NULL,
	CONSTRAINT cfk_empresa_usuario
		FOREIGN KEY (fk_empresa) REFERENCES empresa(id)
);

CREATE TABLE setor (
	id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL UNIQUE,
		fk_empresa INT NOT NULL,
	CONSTRAINT cfk_empresa_setor
		FOREIGN KEY (fk_empresa) REFERENCES empresa(id)
);

CREATE TABLE sensor (
	id INT PRIMARY KEY AUTO_INCREMENT,
	status_sensor TINYINT NOT NULL DEFAULT 1,
	fk_setor INT NOT NULL,
	CONSTRAINT cfk_setor
		FOREIGN KEY (fk_setor) REFERENCES setor(id)
);

CREATE TABLE captura_sensor (
	id INT PRIMARY KEY AUTO_INCREMENT,
    irradiancia FLOAT NOT NULL,
	dt_captura DATETIME DEFAULT CURRENT_TIMESTAMP,
	fk_sensor INT NOT NULL,
	CONSTRAINT cfk_sensor
		FOREIGN KEY (fk_sensor) REFERENCES sensor(id)
);

/*CREATE USER 'insert_cellara'@'%' IDENTIFIED BY 'urubu100';
GRANT INSERT ON cellara.captura_sensor TO 'insert_cellara'@'%';
SHOW GRANTS for 'insert_cellara'@'%';
*/

INSERT INTO empresa (cnpj, nome, codigo_ativacao) VALUES 
('01928393837263', 'Carrefour', 'A1');

INSERT INTO setor (nome, qtd_painel, fk_empresa) VALUES
('A', 5, 1);

INSERT INTO sensor (status_sensor, fk_setor) VALUES
(1, 1);

SELECT * FROM captura_sensor ORDER BY id DESC;

SELECT User FROM mysql.user;

GRANT INSERT ON cellara.captura_sensor TO 'insert_cellara'@'%';

