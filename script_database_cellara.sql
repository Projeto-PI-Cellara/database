CREATE DATABASE cellara;
USE cellara;


CREATE TABLE empresa (
id INT PRIMARY KEY AUTO_INCREMENT,
cnpj CHAR(14),
nome VARCHAR(100),
codigo_ativacao VARCHAR(45)
);

CREATE TABLE usuario (
id INT PRIMARY KEY AUTO_INCREMENT,
nome_completo VARCHAR(255) NOT NULL,
cpf CHAR(11) NOT NULL UNIQUE,
email VARCHAR(150) NOT NULL UNIQUE,
senha VARCHAR(80) NOT NULL,
fk_empresa INT NOT NULL,
CONSTRAINT cfk_empresa_usuario FOREIGN KEY (fk_empresa) REFERENCES empresa(id)
);

CREATE TABLE setor (
id INT PRIMARY KEY AUTO_INCREMENT,
qtd_painel INT,
fk_empresa INT NOT NULL,
CONSTRAINT cfk_empresa_setor FOREIGN KEY (fk_empresa) REFERENCES empresa(id)
);

CREATE TABLE sensor (
id INT PRIMARY KEY AUTO_INCREMENT,
status_sensor BOOLEAN NOT NULL DEFAULT 1,
fk_setor INT NOT NULL,
CONSTRAINT cfk_setor FOREIGN KEY (fk_setor) REFERENCES setor(id)
);

CREATE TABLE captura_sensor (
id INT PRIMARY KEY AUTO_INCREMENT,
valor FLOAT,
dt_captura DATETIME DEFAULT CURRENT_TIMESTAMP,
fk_sensor INT NOT NULL,
CONSTRAINT cfk_sensor FOREIGN KEY (fk_sensor) REFERENCES sensor(id)
);




CREATE USER 'insert_cellara'@'localhost' IDENTIFIED BY 'Urubu100';
GRANT INSERT ON cellara_.captura_sensor TO 'insert_cellara'@'localhost';

SELECT * FROM captura_sensor;
GRANT SELECT ON cellara_.captura_sensor TO 'aluno'@'localhost';
SELECT * FROM usuario;








	