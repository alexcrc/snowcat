use strict;
use warnings;

use FindBin;

use lib $FindBin::Bin . "/../lib";

use Snowcat::Schema;

my $schema= Snowcat::Schema->schema;

my $task= $ARGV[0];
my $file = $ARGV[1];

die 'please provide task and file' unless $task and $file;;



	open my $fh, '<:encoding(UTF-8)', $file
		or die 'cant read input file ' . $!;


while ( <$fh> ){
	chomp;
	my ($target)= $_;
	$_=~s/^\s+//g;
	$_=~s/\s+$//g;
	next unless $target;

	print "$task $target \n";	
	$schema->resultset('TaskQueue')->new( { task => $task, target=> $target } )->insert;


}

1;
