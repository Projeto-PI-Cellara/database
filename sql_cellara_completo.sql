CREATE DATABASE cellara;
USE cellara;

-- Versão completa

CREATE TABLE pessoa (
	id INT PRIMARY KEY AUTO_INCREMENT,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    nome VARCHAR(255) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE
);

CREATE TABLE empresa (
	id INT PRIMARY KEY AUTO_INCREMENT,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
	cnpj CHAR(14) NOT NULL UNIQUE,
	razao_social VARCHAR(100) NOT NULL,
    nome_fantasia VARCHAR(100) NOT NULL,
    dthr_criacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fk_admin INT NOT NULL,
    CONSTRAINT fk_empresa_admin
		FOREIGN KEY (fk_admin) REFERENCES pessoa(id)
);

CREATE TABLE usuario (
	fk_empresa INT,
    fk_pessoa INT,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
	FOREIGN KEY (fk_empresa) REFERENCES empresa(id),
    FOREIGN KEY (fk_pessoa) REFERENCES pessoa(id),
    PRIMARY KEY (fk_empresa, fk_pessoa)
);

CREATE TABLE codigo_ativacao (
	id INT PRIMARY KEY AUTO_INCREMENT,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    valor CHAR(16) NOT NULL UNIQUE,
    dthr_criacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    duracao INT NOT NULL,
    dthr_exclusao DATETIME NULL,
    dthr_uso DATETIME NULL,
    fk_empresa INT NOT NULL,
    fk_criador INT NOT NULL,
    fk_usuario INT NULL UNIQUE,
    CONSTRAINT fk_codigo_ativacao_admin
		FOREIGN KEY (fk_empresa, fk_criador) REFERENCES usuario(fk_empresa, fk_pessoa),
	CONSTRAINT fk_codigo_ativacao_usuario
		FOREIGN KEY (fk_empresa, fk_usuario) REFERENCES usuario(fk_empresa, fk_pessoa)
);

CREATE TABLE setor (
	id INT PRIMARY KEY AUTO_INCREMENT,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    nome VARCHAR(100) NOT NULL,
	fk_empresa INT NOT NULL,
	CONSTRAINT fk_setor_empresa
		FOREIGN KEY (fk_empresa) REFERENCES empresa(id)
);

CREATE TABLE sensor (
	id INT PRIMARY KEY AUTO_INCREMENT,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
	fk_setor INT NOT NULL UNIQUE,
	CONSTRAINT fk_sensor_setor
		FOREIGN KEY (fk_setor) REFERENCES setor(id)
);

CREATE TABLE captura (
	id BIGINT PRIMARY KEY AUTO_INCREMENT,
    dthr DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valor_ldr FLOAT NOT NULL,
    irradiancia_estimada FLOAT NOT NULL,
	fk_sensor INT NOT NULL,
	CONSTRAINT fk_captura
		FOREIGN KEY (fk_sensor) REFERENCES sensor(id)
);

INSERT INTO pessoa (nome, cpf) VALUES
	('Brayan Laines Carvalho', '12345678901'),
    ('Gabriel Cavalcante Santos', '12345678902'),
    ('Arthur de Brito Carvalho', '12345678903'),
    ('Henrique Silva Albuquerque', '12345678904');
    
INSERT INTO empresa (cnpj, razao_social, nome_fantasia, fk_admin) VALUES
	('12345678901234', 'Luz do Sol Placas Solares Ltda.', 'Luz do Sol', 1),
    ('12345678901235', 'Photomais Placas Solares Ltda.', 'Photomais', 3);
    
INSERT INTO usuario (fk_empresa, fk_pessoa, email, senha) VALUES
	(1, 1, 'brayan.carvalho@luzdosol.com', 'brayan1234'),
    (1, 2, 'gabriel.santos@luzdosol.com', 'gabriel1234'),
    (2, 3, 'arthur.carvalho@photomais.com', 'arthur1234'),
    (2, 4, 'henrique.albuquerque', 'henrique1234');
    
INSERT INTO codigo_ativacao (valor, duracao, fk_empresa, fk_criador) VALUES
	('ABCDEFGH', 600000, 1, 1),
    ('12345678', 600000, 2, 3);

INSERT INTO setor (nome, fk_empresa) VALUES
	('A', 1),
	('B', 1),
	('C', 1),
	('D', 1),
	('E', 1),
	('A', 2),
	('B', 2),
	('C', 2),
	('D', 2);

INSERT INTO sensor (fk_setor) VALUES
	(1),
	(2),
	(3),
	(4),
	(5),
	(6),
	(7),
	(8),
	(9);

SELECT * FROM captura ORDER BY id DESC;

/* Selecionando últimas 20 capturas do sensor do setor 'A' da empresa
'Luz do Sol Placas Solares Ltda.' */
SELECT
	captura.id, 
	empresa.razao_social AS 'Empresa',
	setor.nome AS 'Setor', 
	CONCAT(captura.irradiancia_estimada, ' W/m²') AS 'Irradiância medida',
	DATE_FORMAT(captura.dthr, '%d/%m/%Y') AS 'Data da captura', 
	DATE_FORMAT(captura.dthr, '%H:%i:%s') AS 'Hora da captura'
FROM captura
	JOIN sensor 
		ON captura.fk_sensor = sensor.id
	JOIN setor 
		ON sensor.fk_setor = setor.id
	JOIN empresa 
		ON setor.fk_empresa = empresa.id
WHERE setor.id = 1
ORDER BY captura.id DESC LIMIT 20;