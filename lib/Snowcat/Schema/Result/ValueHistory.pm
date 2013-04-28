package Snowcat::Schema::Result::ValueHistory;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('ValueHistory');
__PACKAGE__->add_columns(  qw/

 id      
 value_id
 value
 timestamp

/  );

__PACKAGE__->set_primary_key( 'id' );
__PACKAGE__->add_unique_constraint( value_id_timestamp => [ qw/ value_id timestamp / ] );
__PACKAGE__->belongs_to(
         ea_value => 'Snowcat::Schema::Result::Value',
        { 'foreign.id' => 'self.value_id' }
);



1;

=for Table Schema

	desc ValueHistory;
	+-----------+------------------+------+-----+-------------------+-----------------------------+
	| Field     | Type             | Null | Key | Default           | Extra                       |
	+-----------+------------------+------+-----+-------------------+-----------------------------+
	| id        | int(10) unsigned | NO   | PRI | NULL              | auto_increment              |
	| value_id  | int(10) unsigned | NO   | MUL | NULL              |                             |
	| timestamp | timestamp        | NO   | MUL | CURRENT_TIMESTAMP | on update CURRENT_TIMESTAMP |
	| value     | longtext         | NO   |     | NULL              |                             |
	+-----------+------------------+------+-----+-------------------+-----------------------------+


=cut
