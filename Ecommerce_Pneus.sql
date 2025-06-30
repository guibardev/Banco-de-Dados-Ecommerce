-- PARTE 1: CRIAÇÃO DO BANCO DE DADOS E TABELAS --
-- 1.1. CRIAR O BANCO DE DADOS
CREATE DATABASE IF NOT EXISTS ecommerce_pneus
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;
USE ecommerce_pneus;

-- 1.2. CRIAR TABELA CLIENTES --
CREATE TABLE Clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    endereco VARCHAR(255),
    numero VARCHAR(10),
    cep CHAR(9),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    uf CHAR(2),
    tipo_cliente ENUM('PF', 'PJ') NOT NULL
);

-- 1.3. CRIAR TABELA CLIENTES_PF --
CREATE TABLE Clientes_PF (
    id_cliente INT PRIMARY KEY,
    cpf CHAR(14) UNIQUE NOT NULL,
    data_nascimento DATE,
    rg CHAR(15) UNIQUE,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente) ON DELETE CASCADE
);

-- 1.4. CRIAR TABELA CLIENTES_PJ --
CREATE TABLE Clientes_PJ (
    id_cliente INT PRIMARY KEY,
    cnpj CHAR(18) UNIQUE NOT NULL,
    razao_social VARCHAR(100) UNIQUE NOT NULL,
    nome_fantasia VARCHAR(100),
    inscricao_estadual VARCHAR(20) UNIQUE,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente) ON DELETE CASCADE
);

-- 1.5. CRIAR TABELA MARCAS --
CREATE TABLE Marcas (
    id_marca INT AUTO_INCREMENT PRIMARY KEY,
    nome_marca VARCHAR(100) UNIQUE NOT NULL
);

-- 1.6. CRIAR TABELA PRODUTOS --
CREATE TABLE Produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    id_marca INT NOT NULL,
    nome_pneu VARCHAR(255) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    quantidade_estoque INT NOT NULL DEFAULT 0,
    aro VARCHAR(10),
    sku VARCHAR(50) UNIQUE NOT NULL,
    largura VARCHAR(10),
    descricao TEXT,
    indice_carga VARCHAR(10),
    imagem_url VARCHAR(255),
    indice_velocidade VARCHAR(10),
    FOREIGN KEY (id_marca) REFERENCES Marcas(id_marca)
);

-- 1.7. CRIAR TABELA PEDIDOS --
CREATE TABLE Pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10,2) NOT NULL,
    status_pedido ENUM('PENDENTE', 'ENVIADO', 'PAGO', 'ENTREGUE', 'CANCELADO') NOT NULL DEFAULT 'PENDENTE',
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

-- 1.8. CRIAR TABELA ITENS_PEDIDO --
CREATE TABLE Itens_Pedido (
    id_item_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);

-- PARTE 2: INSERIR DADOS DE EXEMPLO --
-- 2.1. INSERIR CLIENTES
INSERT INTO Clientes (nome, email, endereco, numero, cep, bairro, cidade, uf, tipo_cliente) VALUES
('Ana Clara', 'ana.clara@email.com', 'Rua das Flores', '123', '80000-000', 'Centro', 'Curitiba', 'PR', 'PF'),
('Tecno Pneus Ltda.', 'contato@tecnopneus.com.br', 'Avenida Principal', '1000', '10000-000', 'Industrial', 'São Paulo', 'SP', 'PJ'),
('Bruno Silva', 'bruno.silva@email.com', 'Rua Nova', '789', '90000-000', 'Vila Feliz', 'Porto Alegre', 'RS', 'PF');

-- 2.2. INSERIR CLIENTES_PF --
INSERT INTO Clientes_PF (id_cliente, cpf, data_nascimento, rg) VALUES
(1, '111.222.333-44', '1990-05-15', '12.345.678-9'),
(3, '555.666.777-88', '1985-11-20', '98.765.432-1');

-- 2.3. INSERIR CLIENTES_PJ --
INSERT INTO Clientes_PJ (id_cliente, cnpj, razao_social, nome_fantasia, inscricao_estadual) VALUES
(2, '11.222.333/0001-44', 'Tecnologia em Pneus Ltda.', 'Tecno Pneus', 'ISENTO');

-- 2.4. INSERIR MARCAS
INSERT INTO Marcas (nome_marca) VALUES
('Michelin'),
('Pirelli'),
('Goodyear');

-- 2.5. INSERIR PRODUTOS --
INSERT INTO Produtos (id_marca, nome_pneu, preco, quantidade_estoque, aro, sku, largura, descricao, indice_carga, imagem_url, indice_velocidade) VALUES
(1, 'Pneu Michelin Primacy 4', 550.00, 50, '16', 'PNEU-MICHELIN-P4', '205', 'Excelente para carros de passeio, alta durabilidade e segurança.', '91', 'url_pneu1.jpg', 'V'),
(1, 'Pneu Michelin Pilot Sport 4', 780.00, 30, '17', 'PNEU-MICHELIN-PS4', '225', 'Pneu de alta performance para carros esportivos.', '94', 'url_pneu2.jpg', 'Y'),
(2, 'Pneu Pirelli Cinturato P7', 620.00, 45, '17', 'PNEU-PIRELLI-CINT-P7', '215', 'Otimizado para economia de combustível e baixo ruído.', '94', 'url_pneu3.jpg', 'V'),
(3, 'Pneu Goodyear Eagle Sport', 420.00, 60, '15', 'PNEU-GOODYEAR-EG-SP', '185', 'Bom desempenho em piso seco e molhado, durabilidade.', '88', 'url_pneu4.jpg', 'H');

-- 2.6. INSERIR PEDIDOS --
INSERT INTO Pedidos (id_cliente, data_pedido, valor_total, status_pedido) VALUES
(1, '2025-06-28 10:30:00', 1100.00, 'PENDENTE'), -- PEDIDO DA ANA CLARA (PF)
(2, '2025-06-28 11:00:00', 3580.00, 'PAGO'), -- PEDIDO DA TECNO PNEUS (PJ)
(3, '2025-06-28 14:00:00', 840.00, 'ENTREGUE'); -- PEDIDO DO BRUNO SILVA (PF)

-- 2.7. INSERIR ITENS_PEDIDO --
INSERT INTO Itens_Pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(4, 1, 2, 550.00), -- 2 PNEUS MICHELIN PRIMACY 4 PARA O PEDIDO 4 (ANA CLARA)
(5, 2, 3, 780.00), -- 3 PNEUS MICHELIN PILOT SPORT 4 PARA O PEDIDO 5 (TECNO PNEUS)
(5, 3, 2, 620.00), -- 2 PNEUS PIRELLI CINTURATO P7 PARA O PEDIDO 5 (TECNO PNEUS)
(6, 4, 2, 420.00); -- 2 PNEUS GOODYEAR EAGLE SPORT PARA O PEDIDO 6 (BRUNO SILVA)

-- PARTE 3: EXEMPLOS DE CONSULTAS(SELECT)--
-- SELECIONAR TODOS OS CLIENTES --
SELECT * FROM Clientes;

-- SELECIONAR TODOS OS CLIENTES PESSOA FÍSICA COM SEUS DADOS COMPLETOS --
SELECT C.nome, C.email, C.endereco, C.cidade, C.uf, CPF.cpf, CPF.data_nascimento, CPF.rg
FROM Clientes C
JOIN Clientes_PF CPF ON C.id_cliente = CPF.id_cliente;

-- SELECIONAR TODOS OS CLIENTES PESSOA JURÍDICA COM SEUS DADOS COMPLETOS --
SELECT C.nome, C.email, C.endereco, C.cidade, C.uf, PJ.cnpj, PJ.razao_social, PJ.nome_fantasia
FROM Clientes C
JOIN Clientes_PJ PJ ON C.id_cliente = PJ.id_cliente;

-- SELECIONAR UM PEDIDO ESPECÍFICO, MOSTRANDO O NOME DO CLIENTE E SEU DOCUMENTO --
SELECT P.id_pedido, P.data_pedido, P.valor_total, P.status_pedido,
       C.nome AS nome_cliente, C.tipo_cliente,
       COALESCE(CPF.cpf, PJ.cnpj) AS documento -- USA COALESCE PARA PEGAR CPF OU CNPJ DEPENDENDO DO TIPO --
FROM Pedidos P
JOIN Clientes C ON P.id_cliente = C.id_cliente
LEFT JOIN Clientes_PF CPF ON C.id_cliente = CPF.id_cliente AND C.tipo_cliente = 'PF'
LEFT JOIN Clientes_PJ PJ ON C.id_cliente = PJ.id_cliente AND C.tipo_cliente = 'PJ'
WHERE P.id_pedido = 1;

-- SELECIONAR TODOS OS PEDIDOS E OS DADOS COMPLETOS DO CLIENTE (PF OU PJ) QUE FEZ O PEDIDO --
SELECT
    P.id_pedido, P.data_pedido, P.valor_total, P.status_pedido,
    C.nome AS nome_cliente, C.email, C.endereco, C.numero, C.cep, C.bairro, C.cidade, C.uf,
    C.tipo_cliente,
    CPF.cpf, CPF.data_nascimento, CPF.rg,
    PJ.cnpj, PJ.razao_social, PJ.nome_fantasia, PJ.inscricao_estadual
FROM Pedidos P
JOIN Clientes C ON P.id_cliente = C.id_cliente
LEFT JOIN Clientes_PF CPF ON C.id_cliente = CPF.id_cliente
LEFT JOIN Clientes_PJ PJ ON C.id_cliente = PJ.id_cliente;

-- SELECIONAR PRODUTOS DA MARCA PIRELLI --
SELECT P.nome_pneu, P.preco, M.nome_marca
FROM Produtos P
JOIN Marcas M ON P.id_marca = M.id_marca
WHERE M.nome_marca = 'Pirelli';

-- PARTE 4: EXEMPLOS DE ATUALIZAÇÃO DE DADOS (UPDATE)--
-- ATUALIZAR O STATUS DE UM PEDIDO --
UPDATE Pedidos
SET status_pedido = 'ENTREGUE'
WHERE id_pedido = 1;

-- DIMINUIR O ESTOQUE DE UM PRODUTO APÓS UMA VENDA --
UPDATE Produtos
SET quantidade_estoque = quantidade_estoque - 1
WHERE sku = 'PNEU-MICHELIN-P4';

-- ATUALIZAR O ENDEREÇO DE UM CLIENTE (NA TABELA CLIENTES PRINCIPAL) --
UPDATE Clientes
SET endereco = 'Nova Rua do Centro', numero = '500'
WHERE id_cliente = 1;

-- ATUALIZAR A RAZÃO SOCIAL DE UM CLIENTE PJ --
UPDATE Clientes_PJ
SET razao_social = 'Tecnologia em Pneus S.A.'
WHERE id_cliente = 2;

-- PARTE 6: EXEMPLOS DE ALTERAÇÃO DE TABELAS (ALTER TABELE)--
ALTER TABLE Pedidos
MODIFY COLUMN status_pedido ENUM('PENDENTE', 'ENVIADO', 'PAGO', 'ENTREGUE', 'CANCELADO','SEPARAÇÃO') NOT NULL DEFAULT 'PENDENTE';

-- PARTE 7: EXEMPLOS DE DELETAR DADOS (DELETE)--

-- EXEMPLO: DELETAR UM CLIENTE PF E SEUS DADOS ESPECÍFICOS. --
-- DEVIDO AO ON DELETE CASCADE, DELETAR DE 'CLIENTES' TAMBÉM REMOVERÁ DA TABELA 'CLIENTES_PF' OU 'CLIENTES_PJ'. --
-- DELETE FROM Clientes WHERE id_cliente = 3; --

-- PARA FINS DE DEMONSTRAÇÃO ACADÊMICA E TESTES: --
/*
DROP TABLE IF EXISTS Itens_Pedido;
DROP TABLE IF EXISTS Pedidos;
DROP TABLE IF EXISTS Produtos;
DROP TABLE IF EXISTS Marcas;
DROP TABLE IF EXISTS Clientes_PF;
DROP TABLE IF EXISTS Clientes_PJ;
DROP TABLE IF EXISTS Clientes;
DROP DATABASE IF EXISTS ecommerce_pneus;
*/
