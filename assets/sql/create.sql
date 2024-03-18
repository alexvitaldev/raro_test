CREATE TABLE vagas(id INTEGER PRIMARY KEY, description TEXT, idVeiculo INTEGER);
CREATE TABLE veiculos(id INTEGER PRIMARY KEY, placa TEXT, entrada TEXT, saida TEXT);
CREATE TABLE historicos(id INTEGER PRIMARY KEY, descricaoVaga TEXT, placaVeiculo TEXT, entrada TEXT, saida TEXT);
