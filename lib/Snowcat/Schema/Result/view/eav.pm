package Snowcat::Schema::Result::view::eav;

use base qw/ DBIx::Class::Core /;


__PACKAGE__->table_class('DBIx::Class::ResultSource::View');
__PACKAGE__->table('eav');
__PACKAGE__->result_source_instance->is_virtual( 1 );
__PACKAGE__->result_source_instance->view_definition( <<'    SQL'
	   select 
		  e.name as entity, 
		  a.name as attribute, 
		  v.timestamp as time, 
		  v.value 
	     from 
		  Entity e, 
		  Attribute a, 
		  Value v 
	    where 
	  	  v.attribute_id = a.id 
	      and    v.entity_id = e.id
    SQL

);

__PACKAGE__->add_columns( qw/entity attribute time value/ );

1;
