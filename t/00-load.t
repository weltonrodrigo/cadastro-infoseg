#!/bin/perl -T
use Test::More tests => 2;

my %params = (
  MotivoUsuario   => "Cadastro",
  perfilUsuario   => "Usuario",
  orgaoVinculado  => "Orgao X",
  unidadeLotacao  => "Unidade XY",
  nome            => "fulano de tal",
  cpf             => "61482583828",
  cargo           => "Cargo de Exemplo",
  matricula       => "122345",
  emailOrgao      => 'fulano@orgao.gov.br',
  emailIndividual => 'fulano@hotmail.com',
  telefoneCelular => "11981112323",
  dataNascimento  => "12/12/1980",
);

BEGIN{
  use_ok('Infoseg::Cadastro');
};

isa_ok(new Infoseg::Cadastro(%params), 'Infoseg::Cadastro');
