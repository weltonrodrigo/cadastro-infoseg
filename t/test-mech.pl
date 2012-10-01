use v5.14;
use lib 'C:\Users\Rodrigo\Documents\GitHub\cadastro-infoseg';
use Infoseg::Cadastro;


my $cadastro = new Infoseg::Cadastro(
  MotivoUsuario =>            "Cadastro",
  perfilUsuario =>            "Usuário",
  orgaoVinculado =>           "Órgão X",
  unidadeLotacao =>           "Unidade XY",
  nome =>                     "fulano de tal",
  cpf =>                      "61482583828",
  cargo =>                    "Cargo de Exemplo",
  matricula =>                "122345",
  emailOrgao =>               'fulano@orgao.gov.br',
  emailIndividual =>          'fulano@hotmail.com',
  telefoneCelular =>          "11981112323",
  dataNascimento =>           "12/12/1980"
);

# Get captcha image.
my $captcha = $cadastro->get_captcha_image();

$captcha->move_to('C:\users\rodrigo\desktop\captcha_file.jpg');

my $solution = '32323';

# Solve captcha by whatever means (Amazon Mechanical Turk?)
# (...)
$cadastro->submit(captcha_solution => $solution);

die 'Wrong captcha'
	unless $cadastro->submit_ok;

my $form = $cadastro->get_form;
# The PDF form por printing.
$form->move_to('c:\users\rodrigo\desktop\form_file.pdf');
