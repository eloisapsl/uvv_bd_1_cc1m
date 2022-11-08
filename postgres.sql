
CREATE TABLE hr.regioes (
                id_regiao INTEGER NOT NULL,
                nome VARCHAR(25) NOT NULL,
                CONSTRAINT id_regiao PRIMARY KEY (id_regiao)
);
COMMENT ON TABLE hr.regioes IS 'A tabela regiões contém os nomes e os números das regiões em que a empresa atua.';
COMMENT ON COLUMN hr.regioes.id_regiao IS 'Chave primária da tabela regiões.';
COMMENT ON COLUMN hr.regioes.nome IS 'Nome da região.';


CREATE UNIQUE INDEX regioes_idx
 ON hr.regioes
 ( nome );

CREATE TABLE hr.paises (
                id_pais INTEGER NOT NULL,
                nome  VARCHAR(50) NOT NULL,
                id_regiao INTEGER,
                CONSTRAINT id_pais PRIMARY KEY (id_pais)
);
COMMENT ON TABLE hr.paises IS 'A tabela países contém informações sobre os países em que a empresa atua.';
COMMENT ON COLUMN hr.paises.id_pais IS 'Chave primária da tabela países.';
COMMENT ON COLUMN hr.paises.nome  IS 'Nome do país.';
COMMENT ON COLUMN hr.paises.id_regiao IS 'Chave estrangeira que tem como referência a tabela regiões.';


CREATE UNIQUE INDEX paises_idx
 ON hr.paises
 ( nome  );

CREATE TABLE hr.localizacoes (
                id_localizacao INTEGER NOT NULL,
                endereco VARCHAR(50),
                cep VARCHAR(12) NOT NULL,
                cidade VARCHAR(50),
                uf  VARCHAR(25),
                id_pais INTEGER NOT NULL,
                CONSTRAINT id_localizacao PRIMARY KEY (id_localizacao)
);
COMMENT ON TABLE hr.localizacoes IS 'A tabela localizações contém os endereços dos escritórios da empresa e demais facilidades.';
COMMENT ON COLUMN hr.localizacoes.id_localizacao IS 'Chave primária da tabela localizações.';
COMMENT ON COLUMN hr.localizacoes.endereco IS 'Endereço (número, andar, logradouro) de alguma dependência da empresa.';
COMMENT ON COLUMN hr.localizacoes.cep IS 'CEP da localização de algum escritório ou facilidade da empresa.';
COMMENT ON COLUMN hr.localizacoes.cidade IS 'Cidade onde o escritório ou outra facilidade da empresa está localizado.';
COMMENT ON COLUMN hr.localizacoes.uf  IS 'Abreviação para Unidade Federal. Estado onde o escritório ou facilidade da empresa está localizado.';
COMMENT ON COLUMN hr.localizacoes.id_pais IS 'Chave estrangeira que referencia a tabela países.';


CREATE TABLE hr.cargos (
                id_cargo INTEGER NOT NULL,
                cargo VARCHAR(35) NOT NULL,
                salario_minimo NUMERIC(8,2),
                salario_maximo NUMERIC(8,2),
                CONSTRAINT id_cargo PRIMARY KEY (id_cargo)
);
COMMENT ON TABLE hr.cargos IS 'A tabela cargos armazena os cargos existentes na empresa e suas respectivas faixas salariais (mínimas e máximas).';
COMMENT ON COLUMN hr.cargos.id_cargo IS 'Chave primária da tabela ''cargos''.';
COMMENT ON COLUMN hr.cargos.cargo IS 'Nome do cargo.';
COMMENT ON COLUMN hr.cargos.salario_minimo IS 'O menor salário permitido para um cargo.';
COMMENT ON COLUMN hr.cargos.salario_maximo IS 'O maior salário permitido para um cargo.';


CREATE UNIQUE INDEX cargos_idx
 ON hr.cargos
 ( cargo );

CREATE SEQUENCE hr.empregados_email_seq;

CREATE TABLE hr.empregados (
                id_empregado INTEGER NOT NULL,
                nome VARCHAR(75) NOT NULL,
                email VARCHAR(35) NOT NULL DEFAULT nextval('hr.empregados_email_seq'),
                telefone VARCHAR(20),
                data_contratacao DATE NOT NULL,
                id_cargo INTEGER NOT NULL,
                salario NUMERIC(8,2),
                comissao NUMERIC(4,2),
                id_departamento INTEGER,
                id_supervisor INTEGER,
                CONSTRAINT id_empregado PRIMARY KEY (id_empregado)
);
COMMENT ON TABLE hr.empregados IS 'A tabela empregados armazena dados sobre os funcionários da empresa.';
COMMENT ON COLUMN hr.empregados.id_empregado IS 'Chave primária da tabela empregados.';
COMMENT ON COLUMN hr.empregados.nome IS 'Nome completo do empregado.';
COMMENT ON COLUMN hr.empregados.email IS 'Parte inicial do email do empregado (antes do @).';
COMMENT ON COLUMN hr.empregados.telefone IS 'Telefone do empregado. Há espaço para o código do país e estado.';
COMMENT ON COLUMN hr.empregados.data_contratacao IS 'Data em que o empregado iniciou no cargo atual.';
COMMENT ON COLUMN hr.empregados.id_cargo IS 'Chave estrangeira que tem como referência a tabela cargos. Indica o atual cargo do empregado.';
COMMENT ON COLUMN hr.empregados.salario IS 'Salário mensal atual do empregado.';
COMMENT ON COLUMN hr.empregados.comissao IS 'Porcentagem de comissão de um empregado. Apenas funcionários do departamento de vendas pode receber comissões.';
COMMENT ON COLUMN hr.empregados.id_departamento IS 'Chave estrangeira que tem como referência a tabela departamentos.';
COMMENT ON COLUMN hr.empregados.id_supervisor IS 'Chave estrangeira que tem como referência a própria tabela empregados através de um auto-relacionamento. Pode corresponder ou não ao id_gerente do departamento do empregado.';


ALTER SEQUENCE hr.empregados_email_seq OWNED BY hr.empregados.email;

CREATE UNIQUE INDEX email
 ON hr.empregados
 ( email );

CREATE TABLE hr.departamentos (
                id_departamento INTEGER NOT NULL,
                id_localizacao INTEGER NOT NULL,
                nome VARCHAR(50),
                id_gerente INTEGER,
                CONSTRAINT id_departamento PRIMARY KEY (id_departamento)
);
COMMENT ON TABLE hr.departamentos IS 'A tabela departamentos armazena os nomes dos departamentos da empresa e suas respectivas informações.';
COMMENT ON COLUMN hr.departamentos.id_departamento IS 'Chave primária da tabela departamentos.';
COMMENT ON COLUMN hr.departamentos.id_localizacao IS 'Chave estrangeira que tem como referência a tabela de localizações.';
COMMENT ON COLUMN hr.departamentos.nome IS 'Nome do departamento.';
COMMENT ON COLUMN hr.departamentos.id_gerente IS 'Chave estrangeira que tem como referência a tabela empregados. Representa qual empregado, se houver, é o gerente deste departamento.';


CREATE UNIQUE INDEX departamentos_idx
 ON hr.departamentos
 ( nome );

CREATE TABLE hr.historico_cargos (
                id_empregado INTEGER NOT NULL,
                data_inicial DATE NOT NULL,
                data_final DATE NOT NULL,
                id_departamento INTEGER,
                id_cargo INTEGER NOT NULL,
                CONSTRAINT id_empregado PRIMARY KEY (id_empregado, data_inicial)
);
COMMENT ON TABLE hr.historico_cargos IS 'A tabela armazena o histórico de cargos de um empregado. Caso ele mude de cargo dentro de um departamento ou mude de departamento dentro de um cargo, essas informações devem ser registradas na tabela.';
COMMENT ON COLUMN hr.historico_cargos.id_empregado IS 'Junto a primary key data_inicial, forma a chave primária composta da tabela. Também é uma chave estrangeira que tem como referência a tabela empregados.';
COMMENT ON COLUMN hr.historico_cargos.data_inicial IS 'Junto a primary key id_empregados, forma a chave primária composta da tabela. Indica a data de inicio de um empregado em um novo cargo. Deve ser menor que a data_final.';
COMMENT ON COLUMN hr.historico_cargos.data_final IS 'Ultimo dia do empregado no cargo. Deve ser maior que a data_inicial.';
COMMENT ON COLUMN hr.historico_cargos.id_departamento IS 'Chave estrangeira que referencia a tabela departamentos. Corresponde ao antigo departamento em que o empregado trabalhava.';
COMMENT ON COLUMN hr.historico_cargos.id_cargo IS 'Chave estrangeira que tem como referência a tabela cargos. Corresponde ao cargo em que o empregado estava trabalhando no passado.';


ALTER TABLE hr.paises ADD CONSTRAINT regioes_paises_fk
FOREIGN KEY (id_regiao)
REFERENCES hr.regioes (id_regiao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.localizacoes ADD CONSTRAINT paises_localizacoes_fk
FOREIGN KEY (id_pais)
REFERENCES hr.paises (id_pais)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.departamentos ADD CONSTRAINT localizacoes_departamentos_fk
FOREIGN KEY (id_localizacao)
REFERENCES hr.localizacoes (id_localizacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.historico_cargos ADD CONSTRAINT cargos_historico_cargos_fk
FOREIGN KEY (id_cargo)
REFERENCES hr.cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.empregados ADD CONSTRAINT cargos_empregados_fk
FOREIGN KEY (id_cargo)
REFERENCES hr.cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.historico_cargos ADD CONSTRAINT empregados_historico_cargos_fk
FOREIGN KEY (id_empregado)
REFERENCES hr.empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.departamentos ADD CONSTRAINT empregados_departamentos_fk
FOREIGN KEY (id_gerente)
REFERENCES hr.empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.empregados ADD CONSTRAINT empregados_empregados_fk
FOREIGN KEY (id_supervisor)
REFERENCES hr.empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.empregados ADD CONSTRAINT departamentos_empregados_fk
FOREIGN KEY (id_departamento)
REFERENCES hr.departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.historico_cargos ADD CONSTRAINT departamentos_historico_cargos_fk
FOREIGN KEY (id_departamento)
REFERENCES hr.departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
