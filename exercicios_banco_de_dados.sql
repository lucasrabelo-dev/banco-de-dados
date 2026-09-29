-- limpa tudo antes de começar
DROP DATABASE IF EXISTS dbVeterinaria;
DROP DATABASE IF EXISTS dbOficina;
DROP DATABASE IF EXISTS dbEscolaIdiomas;
DROP DATABASE IF EXISTS dbMateriais;
DROP DATABASE IF EXISTS dbAcademia;
DROP DATABASE IF EXISTS dbTreinamento;
DROP DATABASE IF EXISTS dbLocadoraTeste;

-- Exercício 01
CREATE DATABASE dbVeterinaria; 
CREATE DATABASE dbOficina;
CREATE DATABASE dbEscolaIdiomas;
CREATE DATABASE dbMateriais;
SHOW DATABASES;
USE dbOficina;

-- Exercício 02
CREATE DATABASE dbAcademia;
SHOW DATABASES;
USE dbAcademia;

-- Exercício 03
USE dbOficina;
CREATE TABLE veiculo (
    id_veiculo     INT AUTO_INCREMENT PRIMARY KEY,
    placa          VARCHAR(10) NOT NULL UNIQUE,
    modelo         VARCHAR(100) NOT NULL,
    ano            YEAR,
    valor_estimado DECIMAL(10,2),
    ativo          BOOLEAN DEFAULT TRUE
);
SHOW TABLES;
DESCRIBE veiculo;

-- Exercício 04
DESCRIBE veiculo;

-- Exercício 05
ALTER TABLE veiculo ADD marca VARCHAR(50) NOT NULL;
ALTER TABLE veiculo ADD cor VARCHAR(30);
ALTER TABLE veiculo MODIFY modelo VARCHAR(150) NOT NULL;
ALTER TABLE veiculo RENAME COLUMN valor_estimado TO valor_mercado;
DESCRIBE veiculo;

-- Exercício 06
DROP DATABASE IF EXISTS dbVeterinaria;
SHOW DATABASES;

-- Exercício 07
CREATE DATABASE dbOficinaHomologacao;
CREATE DATABASE dbEscolaHomologacao;
SHOW DATABASES;
USE dbOficinaHomologacao;
USE dbEscolaHomologacao;
DROP DATABASE IF EXISTS dbOficinaHomologacao;
DROP DATABASE IF EXISTS dbEscolaHomologacao;
SHOW DATABASES;

-- Exercício 08
SHOW DATABASES;
USE dbOficina;
SHOW TABLES;
DESCRIBE veiculo;
USE dbEscolaIdiomas;
SHOW TABLES;
USE dbOficina;

-- Exercício 09
USE dbEscolaIdiomas;
CREATE TABLE curso (
    id_curso      INT AUTO_INCREMENT PRIMARY KEY,
    nome          VARCHAR(100) NOT NULL UNIQUE,
    carga_horaria INT NOT NULL,
    valor         DECIMAL(10,2) NOT NULL CHECK (valor >= 0),
    ativo         BOOLEAN DEFAULT TRUE
);
CREATE TABLE professor (
    id_professor  INT AUTO_INCREMENT PRIMARY KEY,
    nome          VARCHAR(120) NOT NULL,
    email         VARCHAR(150) NOT NULL UNIQUE,
    data_admissao DATE NOT NULL,
    ativo         BOOLEAN DEFAULT TRUE
);
SHOW TABLES;
DESCRIBE curso;
DESCRIBE professor;

-- Exercício 10
CREATE TABLE turma (
    id_turma    INT AUTO_INCREMENT PRIMARY KEY,
    nome        VARCHAR(50) NOT NULL,
    data_inicio DATE NOT NULL,
    horario     TIME NOT NULL,
    id_curso    INT NOT NULL,
    FOREIGN KEY (id_curso) REFERENCES curso(id_curso)
);
DESCRIBE turma;

-- Exercício 11
ALTER TABLE turma ADD id_professor INT NOT NULL;                                      -- adiciona coluna obrigatória
ALTER TABLE turma ADD FOREIGN KEY (id_professor) REFERENCES professor(id_professor);  -- liga a turma ao professor
DESCRIBE turma;                                                                       -- mostra a estrutura

-- Exercício 12
CREATE TABLE aluno (                                  -- cria a tabela
    id_aluno        INT AUTO_INCREMENT PRIMARY KEY,   -- chave primária automática
    nome            VARCHAR(150) NOT NULL,            -- texto obrigatório
    cpf             CHAR(11) NOT NULL UNIQUE,         -- texto fixo, obrigatório e não repete
    data_nascimento DATE,                             -- data opcional
    email           VARCHAR(150) UNIQUE,              -- não pode repetir
    data_cadastro   DATETIME,                         -- data e hora
    ativo           BOOLEAN DEFAULT TRUE              -- começa ativo
);
DESCRIBE aluno;                                       -- mostra a estrutura

-- Exercício 13
CREATE TABLE matricula (                                -- cria a tabela
    id_aluno       INT,                                 -- código do aluno
    id_turma       INT,                                 -- código da turma
    data_matricula DATE NOT NULL,                       -- data obrigatória
    situacao       VARCHAR(20) NOT NULL,                -- texto obrigatório
    PRIMARY KEY (id_aluno, id_turma),                   -- chave composta: aluno não repete na mesma turma
    FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno),  -- aluno precisa existir
    FOREIGN KEY (id_turma) REFERENCES turma(id_turma)   -- turma precisa existir
);
DESCRIBE matricula;                                     -- mostra a estrutura

-- Exercício 14
/*
Não precisamos de curso1, curso2 e curso3 porque a tabela matricula
já liga o aluno às turmas. Cada curso novo vira só uma nova linha,
sem limite de cursos.
*/
DESCRIBE aluno;       -- mostra a estrutura
DESCRIBE matricula;   -- mostra a estrutura

-- Exercício 15
CREATE DATABASE dbTreinamento;   -- cria o banco de treinamento
USE dbTreinamento;               -- seleciona o banco
CREATE TABLE cliente (           -- cria a tabela do jeito errado (como o desenvolvedor fez)
    id_cliente INT,
    nome VARCHAR(100),
    cpf CHAR(11),
    ativo BOOLEAN
);
ALTER TABLE cliente MODIFY id_cliente INT AUTO_INCREMENT PRIMARY KEY;  -- vira chave primária
ALTER TABLE cliente MODIFY nome VARCHAR(100) NOT NULL;                 -- vira obrigatório
ALTER TABLE cliente MODIFY cpf CHAR(11) NOT NULL UNIQUE;               -- obrigatório e não repete
ALTER TABLE cliente MODIFY ativo BOOLEAN DEFAULT TRUE;                 -- começa ativo
DESCRIBE cliente;                                                      -- mostra a estrutura

-- Exercício 16
CREATE DATABASE dbLocadoraTeste;                  -- cria o banco
USE dbLocadoraTeste;                              -- seleciona o banco

CREATE TABLE cliente (                            -- tabela de clientes
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,    -- chave primária automática
    nome       VARCHAR(150) NOT NULL,             -- texto obrigatório
    documento  VARCHAR(14) NOT NULL UNIQUE,       -- CPF ou CNPJ, não repete
    telefone   VARCHAR(20),                       -- opcional
    ativo      BOOLEAN DEFAULT TRUE               -- começa ativo
);

CREATE TABLE categoria (                          -- tabela de categorias
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,  -- chave primária automática
    nome         VARCHAR(80) NOT NULL UNIQUE      -- obrigatório e não repete
);

CREATE TABLE equipamento (                                         -- tabela de equipamentos
    id_equipamento INT AUTO_INCREMENT PRIMARY KEY,                 -- chave primária automática
    nome           VARCHAR(120) NOT NULL,                          -- texto obrigatório
    id_categoria   INT NOT NULL,                                   -- categoria obrigatória
    valor_diario   DECIMAL(10,2),                                  -- valor com centavos
    situacao       VARCHAR(20) DEFAULT 'DISPONIVEL',               -- começa disponível
    CONSTRAINT chk_valor_diario CHECK (valor_diario >= 0),         -- não aceita negativo
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)  -- categoria precisa existir
);

CREATE TABLE locacao (                                      -- tabela de locações
    id_locacao              INT AUTO_INCREMENT PRIMARY KEY, -- chave primária automática
    id_cliente              INT NOT NULL,                   -- cliente obrigatório
    data_retirada           DATETIME,                       -- data e hora da retirada
    data_prevista_devolucao DATE,                           -- data da devolução
    situacao                VARCHAR(20),                    -- situação da locação
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) -- cliente precisa existir
);

CREATE TABLE item_locacao (                                                   -- tabela associativa (N:N)
    id_locacao             INT,                                               -- código da locação
    id_equipamento         INT,                                               -- código do equipamento
    valor_diario_utilizado DECIMAL(10,2) CHECK (valor_diario_utilizado >= 0), -- não aceita negativo
    PRIMARY KEY (id_locacao, id_equipamento),                                 -- equipamento não repete na mesma locação
    FOREIGN KEY (id_locacao) REFERENCES locacao(id_locacao),                  -- locação precisa existir
    FOREIGN KEY (id_equipamento) REFERENCES equipamento(id_equipamento)       -- equipamento precisa existir
);

SHOW DATABASES;          -- mostra os bancos
SHOW TABLES;             -- mostra as tabelas
DESCRIBE cliente;        -- mostra a estrutura
DESCRIBE categoria;      -- mostra a estrutura
DESCRIBE equipamento;    -- mostra a estrutura
DESCRIBE locacao;        -- mostra a estrutura
DESCRIBE item_locacao;   -- mostra a estrutura

-- Exercício 17
ALTER TABLE equipamento MODIFY nome VARCHAR(180) NOT NULL;                             -- nome com até 180 caracteres
ALTER TABLE equipamento ADD marca VARCHAR(80) NOT NULL;                                -- nova coluna obrigatória
ALTER TABLE cliente DROP COLUMN telefone;                                              -- remove o telefone
ALTER TABLE equipamento DROP CHECK chk_valor_diario;                                   -- tira a regra para poder renomear
ALTER TABLE equipamento RENAME COLUMN valor_diario TO valor_locacao;                   -- renomeia a coluna
ALTER TABLE equipamento ADD CONSTRAINT chk_valor_locacao CHECK (valor_locacao >= 0);   -- coloca a regra de volta
RENAME TABLE categoria TO tipo_equipamento;                                            -- renomeia a tabela
SHOW TABLES;                   -- mostra as tabelas
DESCRIBE equipamento;          -- mostra a estrutura
DESCRIBE cliente;              -- mostra a estrutura
DESCRIBE tipo_equipamento;     -- mostra a estrutura

-- Exercício 18
CREATE TABLE equipamento_importacao (   -- cria a tabela
    codigo     INT,                     -- número inteiro
    descricao  VARCHAR(150),            -- texto
    quantidade INT                      -- número inteiro
);
TRUNCATE TABLE equipamento_importacao;        -- Situação A: apaga os dados e mantém a tabela
DROP TABLE IF EXISTS equipamento_importacao;  -- Situação B: apaga a tabela inteira

-- Exercício 19
SHOW DATABASES;                                 -- mostra os bancos
DROP DATABASE IF EXISTS dbTreinamento;          -- apaga o banco se existir
DROP DATABASE IF EXISTS dbLocadoraTeste;        -- apaga o banco se existir
DROP DATABASE IF EXISTS dbOficinaHomologacao;   -- apaga o banco se existir
DROP DATABASE IF EXISTS dbEscolaHomologacao;    -- apaga o banco se existir
DROP DATABASE IF EXISTS dbVeterinaria;          -- apaga o banco se existir
SHOW DATABASES;

-- exercicio 21

/* relacionamento 1:N viram chave estrangeira do lado N
relacionamentos N:N viram tabelas associativas
produto_fornecedor e item_pedido
produto e estoque é 1:! (um produto por estoque)
o modelo esta normalizado e pronto para implemetar*/


-- exercicio 22
create database dbHorizonte;
show databases;
use dbHorizonte;

-- exercicio 23
create table Estado(
id_Estado int auto_increment primary key,
Sigla char(2) not null unique,
Nome varchar(50) unique
);
create table Cidade(
id_Cidade int auto_increment primary key,
nome varchar(100) not null,
id_Estado  int not null,
foreign key (id_Estado) references estado (id_estado)
);
show tables;
describe Estado;
describe Cidade;

-- exercicio 24
create table cliente(
id_cliente int auto_increment primary key,
nome varchar(150) not null,
documento varchar (14) not null unique,
tipo_pessoa char(1) not null
             check (tipo_pessoa in ("f", "j")),
telefone varchar (20),
email varchar (150),
data_nascimento date,
data_cadrasto datetime,
ativo boolean default true
);
create table endereco(
id_endereço int auto_increment primary key,
id_cliente int not null,
logadouro varchar(150) not null,
numero varchar(10) not null,
complemeto varchar(100),
cep char (8) not null,
id_cidade int not null,
foreign key(id_cliente) references cliente (id_cliente),
foreign key(id_cidade) references cidade (id_cidade)
);
describe cliente;
describe cidade;

-- exercicio 25



