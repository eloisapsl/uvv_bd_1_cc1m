
CREATE TABLE HR.regioes (
                id_regiao INTEGER NOT NULL,
                nome VARCHAR(25) NOT NULL,
                CONSTRAINT id_regiao PRIMARY KEY (id_regiao)
);
COMMENT ON TABLE HR.regioes IS 'A tabela regiões contém os nomes e os números das regiões em que a empresa atua.';
COMMENT ON COLUMN HR.regioes.id_regiao IS 'Chave primária da tabela regiões.';
COMMENT ON COLUMN HR.regioes.nome IS 'Nome da região.';


CREATE UNIQUE INDEX regioes_idx
 ON HR.regioes
 ( nome );

CREATE TABLE HR.paises (
                id_pais INTEGER NOT NULL,
                nome  VARCHAR(50) NOT NULL,
                id_regiao INTEGER,
                CONSTRAINT id_pais PRIMARY KEY (id_pais)
);
COMMENT ON TABLE HR.paises IS 'A tabela países contém informações sobre os países em que a empresa atua.';
COMMENT ON COLUMN HR.paises.id_pais IS 'Chave primária da tabela países.';
COMMENT ON COLUMN HR.paises.nome  IS 'Nome do país.';
COMMENT ON COLUMN HR.paises.id_regiao IS 'Chave estrangeira que tem como referência a tabela regiões.';


CREATE UNIQUE INDEX paises_idx
 ON HR.paises
 ( nome  );

CREATE TABLE HR.localizacoes (
                id_localizacao INTEGER NOT NULL,
                endereco VARCHAR(50),
                cep VARCHAR(12) NOT NULL,
                cidade VARCHAR(50),
                uf  VARCHAR(25),
                id_pais INTEGER NOT NULL,
                CONSTRAINT id_localizacao PRIMARY KEY (id_localizacao)
);
COMMENT ON TABLE HR.localizacoes IS 'A tabela localizações contém os endereços dos escritórios da empresa e demais facilidades.';
COMMENT ON COLUMN HR.localizacoes.id_localizacao IS 'Chave primária da tabela localizações.';
COMMENT ON COLUMN HR.localizacoes.endereco IS 'Endereço (número, andar, logradouro) de alguma dependência da empresa.';
COMMENT ON COLUMN HR.localizacoes.cep IS 'CEP da localização de algum escritório ou facilidade da empresa.';
COMMENT ON COLUMN HR.localizacoes.cidade IS 'Cidade onde o escritório ou outra facilidade da empresa está localizado.';
COMMENT ON COLUMN HR.localizacoes.uf  IS 'Abreviação para Unidade Federal. Estado onde o escritório ou facilidade da empresa está localizado.';
COMMENT ON COLUMN HR.localizacoes.id_pais IS 'Chave estrangeira que referencia a tabela países.';


CREATE TABLE HR.cargos (
                id_cargo INTEGER NOT NULL,
                cargo VARCHAR(35) NOT NULL,
                salario_minimo NUMERIC(8,2),
                salario_maximo NUMERIC(8,2),
                CONSTRAINT id_cargo PRIMARY KEY (id_cargo)
);
COMMENT ON TABLE HR.cargos IS 'A tabela cargos armazena os cargos existentes na empresa e suas respectivas faixas salariais (mínimas e máximas).';
COMMENT ON COLUMN HR.cargos.id_cargo IS 'Chave primária da tabela ''cargos''.';
COMMENT ON COLUMN HR.cargos.cargo IS 'Nome do cargo.';
COMMENT ON COLUMN HR.cargos.salario_minimo IS 'O menor salário permitido para um cargo.';
COMMENT ON COLUMN HR.cargos.salario_maximo IS 'O maior salário permitido para um cargo.';


CREATE UNIQUE INDEX cargos_idx
 ON HR.cargos
 ( cargo );

CREATE SEQUENCE HR.empregados_email_seq;

CREATE TABLE HR.empregados (
                id_empregado INTEGER NOT NULL,
                nome VARCHAR(75) NOT NULL,
                email VARCHAR(35) NOT NULL DEFAULT nextval('HR.empregados_email_seq'),
                telefone VARCHAR(20),
                data_contratacao DATE NOT NULL,
                id_cargo INTEGER NOT NULL,
                salario NUMERIC(8,2),
                comissao NUMERIC(4,2),
                id_departamento INTEGER,
                id_supervisor INTEGER,
                CONSTRAINT id_empregado PRIMARY KEY (id_empregado)
);
COMMENT ON TABLE HR.empregados IS 'A tabela empregados armazena dados sobre os funcionários da empresa.';
COMMENT ON COLUMN HR.empregados.id_empregado IS 'Chave primária da tabela empregados.';
COMMENT ON COLUMN HR.empregados.nome IS 'Nome completo do empregado.';
COMMENT ON COLUMN HR.empregados.email IS 'Parte inicial do email do empregado (antes do @).';
COMMENT ON COLUMN HR.empregados.telefone IS 'Telefone do empregado. Há espaço para o código do país e estado.';
COMMENT ON COLUMN HR.empregados.data_contratacao IS 'Data em que o empregado iniciou no cargo atual.';
COMMENT ON COLUMN HR.empregados.id_cargo IS 'Chave estrangeira que tem como referência a tabela cargos. Indica o atual cargo do empregado.';
COMMENT ON COLUMN HR.empregados.salario IS 'Salário mensal atual do empregado.';
COMMENT ON COLUMN HR.empregados.comissao IS 'Porcentagem de comissão de um empregado. Apenas funcionários do departamento de vendas pode receber comissões.';
COMMENT ON COLUMN HR.empregados.id_departamento IS 'Chave estrangeira que tem como referência a tabela departamentos.';
COMMENT ON COLUMN HR.empregados.id_supervisor IS 'Chave estrangeira que tem como referência a própria tabela empregados através de um auto-relacionamento. Pode corresponder ou não ao id_gerente do departamento do empregado.';


ALTER SEQUENCE HR.empregados_email_seq OWNED BY HR.empregados.email;

CREATE UNIQUE INDEX email
 ON HR.empregados
 ( email );

CREATE TABLE HR.departamentos (
                id_departamento INTEGER NOT NULL,
                id_localizacao INTEGER NOT NULL,
                nome VARCHAR(50),
                id_gerente INTEGER,
                CONSTRAINT id_departamento PRIMARY KEY (id_departamento)
);
COMMENT ON TABLE HR.departamentos IS 'A tabela departamentos armazena os nomes dos departamentos da empresa e suas respectivas informações.';
COMMENT ON COLUMN HR.departamentos.id_departamento IS 'Chave primária da tabela departamentos.';
COMMENT ON COLUMN HR.departamentos.id_localizacao IS 'Chave estrangeira que tem como referência a tabela de localizações.';
COMMENT ON COLUMN HR.departamentos.nome IS 'Nome do departamento.';
COMMENT ON COLUMN HR.departamentos.id_gerente IS 'Chave estrangeira que tem como referência a tabela empregados. Representa qual empregado, se houver, é o gerente deste departamento.';


CREATE UNIQUE INDEX departamentos_idx
 ON HR.departamentos
 ( nome );

CREATE TABLE HR.historico_cargos (
                id_empregado INTEGER NOT NULL,
                data_inicial DATE NOT NULL,
                data_final DATE DEFAULT > data_inicial  NOT NULL,
                id_departamento INTEGER,
                id_cargo INTEGER NOT NULL,
                CONSTRAINT id_empregado PRIMARY KEY (id_empregado, data_inicial)
);
COMMENT ON TABLE HR.historico_cargos IS 'A tabela armazena o histórico de cargos de um empregado. Caso ele mude de cargo dentro de um departamento ou mude de departamento dentro de um cargo, essas informações devem ser registradas na tabela.';
COMMENT ON COLUMN HR.historico_cargos.id_empregado IS 'Junto a primary key data_inicial, forma a chave primária composta da tabela. Também é uma chave estrangeira que tem como referência a tabela empregados.';
COMMENT ON COLUMN HR.historico_cargos.data_inicial IS 'Junto a primary key id_empregados, forma a chave primária composta da tabela. Indica a data de inicio de um empregado em um novo cargo. Deve ser menor que a data_final.';
COMMENT ON COLUMN HR.historico_cargos.data_final IS 'Ultimo dia do empregado no cargo. Deve ser maior que a data_inicial.';
COMMENT ON COLUMN HR.historico_cargos.id_departamento IS 'Chave estrangeira que referencia a tabela departamentos. Corresponde ao antigo departamento em que o empregado trabalhava.';
COMMENT ON COLUMN HR.historico_cargos.id_cargo IS 'Chave estrangeira que tem como referência a tabela cargos. Corresponde ao cargo em que o empregado estava trabalhando no passado.';


ALTER TABLE HR.paises ADD CONSTRAINT regioes_paises_fk
FOREIGN KEY (id_regiao)
REFERENCES HR.regioes (id_regiao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE HR.localizacoes ADD CONSTRAINT paises_localizacoes_fk
FOREIGN KEY (id_pais)
REFERENCES HR.paises (id_pais)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE HR.departamentos ADD CONSTRAINT localizacoes_departamentos_fk
FOREIGN KEY (id_localizacao)
REFERENCES HR.localizacoes (id_localizacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE HR.historico_cargos ADD CONSTRAINT cargos_historico_cargos_fk
FOREIGN KEY (id_cargo)
REFERENCES HR.cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE HR.empregados ADD CONSTRAINT cargos_empregados_fk
FOREIGN KEY (id_cargo)
REFERENCES HR.cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE HR.historico_cargos ADD CONSTRAINT empregados_historico_cargos_fk
FOREIGN KEY (id_empregado)
REFERENCES HR.empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE HR.departamentos ADD CONSTRAINT empregados_departamentos_fk
FOREIGN KEY (id_gerente)
REFERENCES HR.empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE HR.empregados ADD CONSTRAINT empregados_empregados_fk
FOREIGN KEY (id_supervisor)
REFERENCES HR.empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE HR.empregados ADD CONSTRAINT departamentos_empregados_fk
FOREIGN KEY (id_departamento)
REFERENCES HR.departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE HR.historico_cargos ADD CONSTRAINT departamentos_historico_cargos_fk
FOREIGN KEY (id_departamento)
REFERENCES HR.departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
