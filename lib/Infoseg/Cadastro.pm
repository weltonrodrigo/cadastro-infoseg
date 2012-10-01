package Infoseg::Cadastro;

use Mojo::UserAgent;
use Carp;
use URI;
use v5.14;

our $BASE = 'https://www2.infoseg.gov.br/infoseg/do/Logon/Solicitacao/Cadastro';
our $CADASTRO =
  'https://www2.infoseg.gov.br/infoseg/do/relatorio/solicitacaoCadastro';
our $CAPTCHA = 'https://www2.infoseg.gov.br/infoseg/captcha/captcha.jpg';

our %QUERIES = (
    telaInicial => { meth => 'GET',  url => $BASE . '?method=telaInicial' },
    captcha     => { meth => 'GET',  url => $CAPTCHA },
    confirmar   => { meth => 'POST', url => $BASE . '?method=confirma' },
    inserir     => { meth => 'POST', url => $BASE . '?method=inserir' },
    cadastro    => { meth => 'GET',  url => $CADASTRO },
);

=head1 NAME

Infoseg::Cadastro - A representação da operação de cadastro no Infoseg.

=head1 SYNOPSIS

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
      emailOrgao =>               "fulano@orgao.gov.br",
      emailIndividual =>          "fulano@hotmail.com",
      telefoneCelular =>          "11981112323",
      dataNascimento =>           "12/12/1980",
    );

    # Get captcha image.
    my $captcha = $cadastro->get_captcha_image();

    $captcha->move_to('captcha_file.jpg');

    # Solve captcha by whatever means (Amazon Mechanical Turk?)
    # (...)
    $cadastro->submit(captcha_solution => '422142');

    die 'Wrong captcha'
        unless $cadastro->submit_ok;

    my $form = $cadastro->get_form;
    # The PDF form por printing.
    $form->move_to('form_file.pdf');

=head1 Methods

=head2 C<Infoseg::Cadastro-E<gt>new(%fields)>

=cut

sub new {
    my $class  = shift;
    my %fields = @_;

    my $self = {
        fields  => \%fields,
        ua      => new Mojo::UserAgent(),
        captcha => {},
        form    => {a => 'a', b => 'b'},
        report  => {},
    };

    #TODO Preencher os demais campos do post com os dados do usuário.
    #emailOrgaoConfirma,  por exemplo.
    $self->{fields}->{emailOrgaoConfirma} = $fields{emailOrgao};
    $self->{fields}->{emailIndividualConfirma} = $fields{emailIndividual};

    return bless $self, $class;
}

sub ua{
    return shift->{ua};
}

sub _request {
    my $self  = shift;
    my $query = shift;
    my $data  = shift;
    my $tx;

    given ($query->{meth}){
        when (/POST/) {
            $tx = $self->ua->post_form( $query->{url} => $data );
        };
        when (/GET/ ) {
            $tx = $self->ua->get( $query->{url} );
        };
    }
    
    if ( my $res = $tx->success ) {
        return $res;
    }
    else {
        my ( $err, $code ) = $tx->error;
        croak $code ? "$code response: $err" : "Connection error: $err";
    }

}

=head2 C<$cadastro-E<gt>get_captcha_image()>
    Returns a C<Infoseg::Cadastro::Asset> containing the image.
=cut
sub get_captcha_image {
    my $self = shift;

    my $res = $self->_request( $QUERIES{telaInicial} );
    
    # get captcha
    $DB::Single;
    my $img = $self->_request($QUERIES{captcha});
    
    return $self->{captcha} = Infoseg::Cadastro::Asset->new($img);

}

=head2 C<$cadastro-E<gt>submit(captcha_solution => "String")>
=cut

sub submit {
    my $self     = shift;
    my $solution = {@_}->{captcha_solution};

    unless ($solution) croak "You must provide catpcha solution.";

    $self->{fields}->{captcha} = $solution;

    my $res = $self->_request( $QUERIES{inserir} , $self->{fields});

    # TODO CSS selector magic.
    $self->fields->{numFormulario} = $res->dom();

    $self->_request( $QUERIES{confirma} );

    $res = $self->_request( $QUERIES{cadastro} );

    $self->submit_ok = 1;

    $self->report = new Infoseg::Cadastro::Asset($res);

    return $self;
}

=head2 C<$cadastro-E<gt>get_form()>
=cut

sub get_form {
    my $self = shift;
    return $self->form;
}

BEGIN {

    package Infoseg::Cadastro::Asset;

    sub new {
        my $class = shift;
        my $res   = shift;

        return bless { res => $res }, $class;
    }

    sub move_to {
        my $self = shift;
        $self->{res}->content->asset->move_to(shift);
    }
}

1;
