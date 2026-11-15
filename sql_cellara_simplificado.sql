CREATE DATABASE cellara;
USE cellara;

CREATE TABLE empresa (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cnpj CHAR(14) UNIQUE NOT NULL,
    razao_social VARCHAR(100) NOT NULL,
    nome_fantasia VARCHAR(100) NOT NULL,
    dthr_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
	ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE usuario (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    dthr_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    cargo TINYINT NOT NULL,
	ativo BOOLEAN NOT NULL DEFAULT TRUE,
    fk_empresa INT NOT NULL,
    CONSTRAINT fk_usuario_empresa 
		FOREIGN KEY (fk_empresa)
			REFERENCES empresa(id)
);

CREATE TABLE codigo_ativacao (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    texto CHAR(8) UNIQUE NOT NULL,
    cargo TINYINT NULL,
    dthr_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    dthr_expiracao DATETIME NOT NULL,
    dthr_exclusao DATETIME,
    dthr_uso DATETIME,
    fk_empresa INT NOT NULL,
    CONSTRAINT fk_codigo_ativacao_empresa
        FOREIGN KEY (fk_empresa)
			REFERENCES empresa(id)
);

CREATE TABLE setor (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    situacao BOOLEAN NOT NULL DEFAULT TRUE,
    fk_empresa INT NOT NULL,
    CONSTRAINT fk_setor_empresa
        FOREIGN KEY (fk_empresa)
			REFERENCES empresa(id)
);

CREATE TABLE sensor (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    fk_setor INT NOT NULL,
    CONSTRAINT ck_fk_sensor_setor
        FOREIGN KEY (fk_setor)
			REFERENCES setor(id)
);

CREATE TABLE captura (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    dthr DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valor_ldr FLOAT NOT NULL,
    irradiancia_estimada FLOAT NOT NULL,
    fk_sensor INT NOT NULL,
    CONSTRAINT fk_captura_sensor
        FOREIGN KEY (fk_sensor)
			REFERENCES sensor(id)
);

INSERT INTO empresa (cnpj, razao_social, nome_fantasia)
VALUES
('12345678000190', 'Empresa Solar LTDA', 'SolarTech'),
('98765432000110', 'Energia Limpa LTDA', 'EcoEnergy');

INSERT INTO usuario (nome, email, senha, cargo, fk_empresa)
VALUES
('Carlos Silva', 'carlos@solartech.com', 'hash_senha_1', 1, 1),
('Mariana Souza', 'mariana@solartech.com', 'hash_senha_2', 2, 1),
('Pedro Santos', 'pedro@solartech.com', 'hash_senha_3', 3, 1),
('Ana Oliveira', 'ana@ecoenergy.com', 'hash_senha_4', 1, 2),
('Lucas Costa', 'lucas@ecoenergy.com', 'hash_senha_5', 3, 2);

INSERT INTO codigo_ativacao
(texto, cargo, dthr_expiracao, dthr_uso, fk_empresa)
VALUES
('SOL12345', 2, DATE_ADD(NOW(), INTERVAL 7 DAY), NULL, 1),
('SOL67890', 3, DATE_ADD(NOW(), INTERVAL 7 DAY), NOW(), 1),
('SOL11111', 3, DATE_SUB(NOW(), INTERVAL 1 DAY), NULL, 1),
('ECO12345', 2, DATE_ADD(NOW(), INTERVAL 7 DAY), NULL, 2),
('ECO67890', 3, DATE_ADD(NOW(), INTERVAL 7 DAY), NULL, 2);

-- Simulando código excluído
UPDATE codigo_ativacao
SET ativo = FALSE,
    dthr_exclusao = NOW()
WHERE texto = 'SOL11111';

INSERT INTO setor (nome, fk_empresa)
VALUES
('Setor A', 1),
('Setor B', 1),
('Setor C', 1),
('Setor A', 2),
('Setor B', 2);

-- Simulando setor inativo
UPDATE setor
SET situacao = FALSE
WHERE id = 3;

INSERT INTO sensor (fk_setor)
VALUES
(1),
(1),
(2),
(3),
(4),
(5);

-- Simulando sensores inativos
UPDATE sensor
SET ativo = FALSE
WHERE id IN (3, 6);

INSERT INTO captura (valor_ldr, irradiancia_estimada, fk_sensor)
VALUES
(850, 920.5, 1),
(900, 970.2, 1),
(780, 850.0, 1),
(650, 710.5, 2),
(700, 760.0, 2),
(500, 550.0, 3),
(950, 1020.0, 4),
(820, 890.0, 5),
(870, 940.0, 5);

-- Consultar usuários e suas respectivas empresas

SELECT
    e.id AS id_empresa,
    e.nome_fantasia,
    u.id AS id_usuario,
    u.nome,
    u.email,
    u.cargo,
    u.ativo
FROM empresa AS e
INNER JOIN usuario AS u
    ON u.fk_empresa = e.id
ORDER BY e.id, u.id;


-- Quantidade de usuários por empresa

SELECT
    e.id,
    e.nome_fantasia,
    COUNT(u.id) AS qtd_usuarios
FROM empresa AS e
LEFT JOIN usuario AS u
    ON u.fk_empresa = e.id
GROUP BY e.id, e.nome_fantasia;

-- Consultar situação dos códigos de ativação

SELECT
    id,
    texto,
    cargo,
    ativo,
    dthr_criacao,
    dthr_expiracao,
    dthr_exclusao,
    dthr_uso,
    CASE
        WHEN ativo = FALSE THEN 'INATIVO'
        WHEN dthr_exclusao IS NOT NULL THEN 'EXCLUIDO'
        WHEN dthr_uso IS NOT NULL THEN 'UTILIZADO'
        WHEN dthr_expiracao < NOW() THEN 'EXPIRADO'
        ELSE 'DISPONIVEL'
    END AS situacao
FROM codigo_ativacao;


-- Validar um código informado no cadastro

SELECT
    id,
    texto,
    cargo,
    fk_empresa
FROM codigo_ativacao
WHERE texto = 'SOL12345'
    AND ativo = TRUE
    AND dthr_uso IS NULL
    AND dthr_exclusao IS NULL
    AND dthr_expiracao > NOW();

-- Consultar setores e seus respectivos sensores

SELECT
    e.nome_fantasia,
    s.id AS id_setor,
    s.nome AS setor,
    s.situacao,
    se.id AS id_sensor,
    se.ativo AS sensor_ativo
FROM empresa AS e
INNER JOIN setor AS s
    ON s.fk_empresa = e.id
LEFT JOIN sensor AS se
    ON se.fk_setor = s.id
ORDER BY e.id, s.id, se.id;


-- Quantidade de sensores por setor

SELECT
    s.id,
    s.nome,
    e.nome_fantasia,
    COUNT(se.id) AS qtd_sensores,
    SUM(se.ativo = TRUE) AS sensores_ativos,
    SUM(se.ativo = FALSE) AS sensores_inativos
FROM setor AS s
INNER JOIN empresa AS e
    ON e.id = s.fk_empresa
LEFT JOIN sensor AS se
    ON se.fk_setor = s.id
GROUP BY s.id, s.nome, e.nome_fantasia;


-- Histórico de capturas com identificação da empresa,
-- setor e sensor responsável

SELECT
    e.nome_fantasia,
    s.nome AS setor,
    se.id AS id_sensor,
    c.id AS id_captura,
    c.dthr,
    c.valor_ldr,
    c.irradiancia_estimada
FROM captura AS c
INNER JOIN sensor AS se
    ON se.id = c.fk_sensor
INNER JOIN setor AS s
    ON s.id = se.fk_setor
INNER JOIN empresa AS e
    ON e.id = s.fk_empresa
ORDER BY c.dthr DESC;


-- Média, menor e maior irradiância por setor

SELECT
    e.nome_fantasia,
    s.nome AS setor,
    AVG(c.irradiancia_estimada) AS media_irradiancia,
    MIN(c.irradiancia_estimada) AS menor_irradiancia,
    MAX(c.irradiancia_estimada) AS maior_irradiancia,
    COUNT(c.id) AS qtd_capturas
FROM empresa AS e
INNER JOIN setor AS s
    ON s.fk_empresa = e.id
INNER JOIN sensor AS se
    ON se.fk_setor = s.id
INNER JOIN captura AS c
    ON c.fk_sensor = se.id
GROUP BY e.id, s.id;


-- Última captura de cada sensor

SELECT
    e.nome_fantasia,
    s.nome AS setor,
    se.id AS id_sensor,
    c.dthr,
    c.valor_ldr,
    c.irradiancia_estimada
FROM sensor AS se
INNER JOIN setor AS s
    ON s.id = se.fk_setor
INNER JOIN empresa AS e
    ON e.id = s.fk_empresa
LEFT JOIN captura AS c
    ON c.fk_sensor = se.id
    AND c.dthr = (
        SELECT MAX(c2.dthr)
        FROM captura AS c2
        WHERE c2.fk_sensor = se.id
    )
ORDER BY e.id, s.id, se.id;


-- Média de irradiância por empresa

SELECT
    e.id,
    e.nome_fantasia,
    AVG(c.irradiancia_estimada) AS media_irradiancia
FROM empresa AS e
INNER JOIN setor AS s
    ON s.fk_empresa = e.id
INNER JOIN sensor AS se
    ON se.fk_setor = s.id
INNER JOIN captura AS c
    ON c.fk_sensor = se.id
WHERE e.id = 1
GROUP BY e.id;


-- Média de irradiância por hora no dia atual

SELECT
    HOUR(c.dthr) AS hora,
    AVG(c.irradiancia_estimada) AS media_irradiancia
FROM captura AS c
INNER JOIN sensor AS se
    ON se.id = c.fk_sensor
INNER JOIN setor AS s
    ON s.id = se.fk_setor
WHERE s.fk_empresa = 1
    AND DATE(c.dthr) = CURDATE()
GROUP BY HOUR(c.dthr)
ORDER BY hora;


-- Consultar capturas de um setor específico

SELECT
    c.dthr,
    c.valor_ldr,
    c.irradiancia_estimada
FROM captura AS c
INNER JOIN sensor AS se
    ON se.id = c.fk_sensor
INNER JOIN setor AS s
    ON s.id = se.fk_setor
WHERE s.id = 1
ORDER BY c.dthr DESC;