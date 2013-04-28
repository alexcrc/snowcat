package Snowcat::EAV;

use Moose;
use Snowcat::Schema;

my $schema= Snowcat::Schema::schema();



has entity => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has attribute => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has _ent_do => (
    is      => 'rw',
    isa     => 'Snowcat::Schema::Result::Entity',
    lazy    => 1,
    default => sub {
        $schema->resultset('Entity')
            ->find_or_create( { name => shift->entity } );
    }
);

has _attr_do => (
    is      => 'rw',
    isa     => 'Snowcat::Schema::Result::Attribute',
    lazy    => 1,
    default => sub {
        $schema->resultset('Attribute')
            ->find_or_create( { name => shift->attribute } );
    }
);

has value => (
	is => 'rw',
	isa => 'Str',
	lazy => 1,
	default => sub { shift->_val_do->value },
	trigger => sub {  
		my ( $self, $new_value, $old_value ) =@_;
		my $v= $self->_val_do;
		$v->value( $new_value ); 
		$v->insert_or_update;

		eval { $schema->resultset('ValueHistory')
			->create( { value_id => $self->_val_do->id, 
					value => $new_value } ) };

	}


);

has _val_do => (
    is      => 'rw',
    isa     => 'Snowcat::Schema::Result::Value',
    lazy    => 1,
    default => sub {
		my $self= shift;
		$schema->resultset('Value')
			->find_or_create( { entity_id => $self->_ent_do->id, attribute_id => $self->_attr_do->id }, 
						{ key => 'entity_attribute'}  )  
    }
);


has history => (
	is => 'rw',
	isa => 'ArrayRef',
	lazy => 1,
	default => sub {
		my $self= shift;
		my @v= $schema->resultset('ValueHistory')->search( { value_id => $self->_val_do->id }, { order_by => 'timestamp' } );
		[  map { +{ timestamp => $_->timestamp, value => $_->value } } @v ]

	},


);


1;
