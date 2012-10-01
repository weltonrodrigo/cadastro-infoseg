use v5.14;
use Infoseg::Cadastro;
use Encode;
use Mojo::Parameters;
use utf8;

my %params = (
  MotivoUsuario   => "Cadastro",
  perfilUsuario   => "Usuário",
  orgaoVinculado  => "Órgão X",
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

my $cadastro = new Infoseg::Cadastro(%params);

# Get captcha image.
my $captcha = $cadastro->get_captcha_image();

$captcha->move_to('captcha.jpg');

my $solution = '32323';

$cadastro->submit(captcha_solution => $solution);

die 'Wrong captcha'
	unless $cadastro->submit_ok;

my $form = $cadastro->get_form;
# The PDF form por printing.
$form->move_to('report.pdf');
