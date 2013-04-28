#!/usr/bin/perl

use strict;
use warnings;
use 5.14.2;


use Mango;
use Data::Dumper;

use FindBin;
use lib $FindBin::Bin . "/../lib";
use Snowcat::Schema;



my $task = $ARGV[0];
my $target = $ARGV[1];

die 'please provide task and target' unless $task and $target;


my $mango = Mango->new('mongodb://localhost:27017');
my $schema = Snowcat::Schema->schema();



my $item= $schema->resultset('TaskQueue')->search( { task=> $task, target => $target })->first;

exit unless $item and $item->status == 5;

say $item->result->resource if $item->result;
my $oid = Mango::BSON::ObjectID->new( $item->result->resource );
my $mng = $mango->db('snowcat')->collection( $item->task )->find_one( $oid  );

say Dumper  ( $mng->{ $item->id } );



