use v5.14;
use Mojo::UserAgent;

our $a = new Mojo::UserAgent;

our $tx = $a->build_tx(GET => q/www.google.com/);

say $tx->res->body;

1;