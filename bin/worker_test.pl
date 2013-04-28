#!/usr/bin/perl

use strict;
use warnings;
use 5.14.2;


use FindBin;
use lib $FindBin::Bin . "/../lib";



use Snowcat::Worker::Task;
Snowcat::Worker::Task->run({ task => $ARGV[0], target => $ARGV[1]})

