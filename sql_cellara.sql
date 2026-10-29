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
    nome VARCHAR(100) NOT NULL,
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


INSERT INTO empresa (cnpj, nome, codigo_ativacao) VALUES 
('01928393837263', 'SPTech Consulting', 'A1B2C3'),
('01829383928392', 'Avanade', 'A2B3C5'),
('01928393847557', 'Safra', 'B1F67K');

INSERT INTO setor (nome, fk_empresa) VALUES
('A', 1),
('B', 1),
('C', 1),
('A', 2),
('B', 2),
('C', 2),
('A', 3),
('B', 3),
('C', 3);

INSERT INTO sensor (status_sensor, fk_setor) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 9);

SELECT * FROM captura_sensor ORDER BY id DESC;

/* Selecionando últimas 20 capturas do sensor do setor 'A' da empresa
'GreenEnergy' */
SELECT captura_sensor.id, 
empresa.nome AS 'Empresa',
setor.nome AS 'Setor', 
CONCAT(captura_sensor.irradiancia, ' W/m²') AS 'Irradiância medida',
DATE_FORMAT(captura_sensor.dt_captura, '%d/%m/%Y') AS 'Data da captura', 
DATE_FORMAT(captura_sensor.dt_captura, '%H:%i:%s') AS 'Hora da captura'
FROM captura_sensor
	JOIN sensor 
		ON captura_sensor.fk_sensor = sensor.id
	JOIN setor 
		ON sensor.fk_setor = setor.id
	JOIN empresa 
		ON setor.fk_empresa = empresa.id
WHERE setor.id = 1
ORDER BY captura_sensor.id DESC LIMIT 20;