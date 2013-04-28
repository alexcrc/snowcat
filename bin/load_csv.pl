use strict;
use warnings;

use FindBin;

use lib $FindBin::Bin . "/../lib";

use Snowcat::Schema;

my $schema= Snowcat::Schema->schema;

#$schema->resultset('TaskQueue')->new( { task => 'get_text' } )->insert;




	open my $fh, '<:encoding(UTF-8)', $FindBin::Bin. "/../data/top-1m.csv"
		or die 'cant read input file ' . $!;


while ( <$fh> ){
	chomp;
	my ($pos, $domain)= split /,/, $_;
	next unless $domain;
	next if $pos < 432057;

	
	$schema->resultset('TaskQueue')->new( { task => 'dget_01', target=> $domain } )->insert;


}

1;
