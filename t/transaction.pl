use Mojo::Transaction::HTTP;
use v5.14;
 
# Client

my $tx = Mojo::Transaction::HTTP->new;
$tx->req->method('GET');
$tx->req->url->parse('http://mojolicio.us');
#$tx->req->headers->accept('text/html');
say $tx->res->code;
say $tx->res->headers->content_type;
say $tx->res->body;
say $tx->remote_address;