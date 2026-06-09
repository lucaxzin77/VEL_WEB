DROP DATABASE IF EXISTS vel_web_api_db;
CREATE DATABASE vel_web_api_db;
USE vel_web_api_db;

-- =========================
-- PADRÕES GERAIS
-- =========================
SET NAMES utf8mb4;
SET time_zone = '+00:00';

-- =========================
-- PERFIS (RBAC)
-- =========================
CREATE TABLE perfis (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao VARCHAR(255),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL
);



-- =========================
-- ENDPOINTS (RBAC)
-- =========================
CREATE TABLE endpoints (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    codigo VARCHAR(100) NOT NULL,
    recurso VARCHAR(20) NOT NULL,
    metodo VARCHAR(10) NOT NULL,
    rota VARCHAR(150) NOT NULL,

    descricao VARCHAR(255),

    UNIQUE (rota, metodo)
);

-- =========================
-- PERFIL x ENDPOINT (RBAC)
-- =========================
CREATE TABLE perfil_endpoints (
    perfil_id INT UNSIGNED,
    endpoint_id INT UNSIGNED,

    PRIMARY KEY (perfil_id, endpoint_id),

    FOREIGN KEY (perfil_id) REFERENCES perfis(id)
        ON DELETE CASCADE,

    FOREIGN KEY (endpoint_id) REFERENCES endpoints(id)
        ON DELETE CASCADE
);

-- =========================
-- USUARIOS
-- =========================
CREATE TABLE usuarios (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    perfil_id INT UNSIGNED,

    email VARCHAR(150) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    nome VARCHAR(150) NOT NULL,
    whatsapp VARCHAR(20),
    avatar VARCHAR(255),

    endereco JSON,
    

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,

    FOREIGN KEY (perfil_id) REFERENCES perfis(id)
);

CREATE INDEX idx_usuario_deleted ON usuarios(deleted_at);

-- =========================
-- FABRICANTES
-- =========================
CREATE TABLE fabricantes (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    nome VARCHAR(100) NOT NULL UNIQUE,
    logo VARCHAR(255),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL
);

-- =========================
-- CATEGORIAS
-- =========================
CREATE TABLE categorias (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    nome VARCHAR(100) NOT NULL UNIQUE,
    icone VARCHAR(255),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL
);

-- =========================
-- VEICULOS
-- =========================
CREATE TABLE veiculos (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    fabricante_id INT UNSIGNED NOT NULL,
    usuario_id INT UNSIGNED NOT NULL,

    modelo VARCHAR(150) NOT NULL,
    ano SMALLINT UNSIGNED NOT NULL,
    ano_modelo SMALLINT UNSIGNED,
    cor VARCHAR(50),

    descricao TEXT,

    dados_tecnicos JSON,
    fotos JSON,

    preco DECIMAL(12,2) UNSIGNED,

    coordenadas POINT NOT NULL SRID 4326,
    SPATIAL INDEX (coordenadas),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,

    FOREIGN KEY (fabricante_id) REFERENCES fabricantes(id)
        ON DELETE RESTRICT,

    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
        ON DELETE CASCADE
);

CREATE INDEX idx_veiculos_deleted ON veiculos(deleted_at);
CREATE INDEX idx_veiculos_preco ON veiculos(preco);

-- =========================
-- VEICULOS x CATEGORIAS
-- =========================
CREATE TABLE veiculo_categorias (
    veiculo_id INT UNSIGNED,
    categoria_id INT UNSIGNED,

    PRIMARY KEY (veiculo_id, categoria_id),

    FOREIGN KEY (veiculo_id) REFERENCES veiculos(id)
        ON DELETE CASCADE,

    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
        ON DELETE CASCADE
);