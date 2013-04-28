package Snowcat::Worker::Task;

use 5.14.2;

use Moose;


use Snowcat::Worker::Task::DomainGet;
use Snowcat::Schema;

use Data::Dumper;


use constant TASK_EXECUTION_FAILED => 4;


has task => (
	isa => 'CodeRef',
	is => 'rw',
	lazy => 1,
	default => sub {
		my $self= shift;

		$self->all_tasks->{ $self->task_name };
		

	}


);

has task_name => (
	isa => 'Str',
	is => 'rw',
	required => 1,  

);


has all_tasks => (
    isa     => 'HashRef',
    is      => 'ro',
    lazy    => 1,
    default => sub {
		my $schema= Snowcat::Schema->schema;
		my @tasks= $schema->resultset('Task')->search({ status => 1 });
		my $tasks= {};
		for my $task ( @tasks ){
			my $package= $task->package;
			my $sub= $task->subroutine;
			$tasks->{ $task->name } = $package->$sub();
		}
		return $tasks;
        }

);

sub run {
	my $class = shift;
	my $workload= shift;




	my $result= {};
	eval {
		my $self= $class->new( { task_name => $workload->{ task } } );
		$result = $self->task->( $workload );
		1;
	} or do { 
		my $error = $@;
		warn "workload failed: ( $error ) " . Dumper( $workload );
		$result= {  id => $workload->{ id }, status => TASK_EXECUTION_FAILED, result => [] }

	};

	say Dumper( $result );
	return $result;
	


}




1;
