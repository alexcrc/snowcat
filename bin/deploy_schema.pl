use strict;
use warnings;

use FindBin;

use lib $FindBin::Bin . "/../lib";

use Snowcat::Schema;

my $schema= Snowcat::Schema->schema;

$schema->deploy;


1;
