use Mojo::UserAgent;
use Mojo::Parameters;
use Encode;
use Data::Dumper::Concise;
use utf8;
use v5.14;

use URI::Encode qw/uri_encode/;

my $string = 'Usuário';

say my $encoded = encode ('iso-8859-1', $string);
say uri_encode $encoded;

    my $p = new Mojo::Parameters();
    $p->charset('iso-8859-1');
    $p->append( string => 'Usuário' );
    say $p->to_string;
    # string=Usu%E1rio

my $c = new Mojo::Parameters();
$c->charset('utf8');
$c->append( string => 'Usuário' );
say $c->to_string;

my $c = new Mojo::Parameters();
#$c->charset('utf8');
$c->append( string => $string );
say $c->to_string;

my $tx = Mojo::UserAgent->new->build_form_tx(
  'w.g.com', 'iso-8859-1', { string => $string }
);

print Dumper $tx;
