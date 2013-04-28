package Snowcat::Schema::Result::Entity;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('Entity');
__PACKAGE__->add_columns(  qw/

 id      
 name
 status

/  );

__PACKAGE__->set_primary_key( 'id' );
__PACKAGE__->has_many(
         val => 'Snowcat::Schema::Result::Value',
        { 'foreign.entity_id' => 'self.id' }
);



1;

=for Table Schema

	desc Entity;
	+--------+------------------+------+-----+---------+----------------+
	| Field  | Type             | Null | Key | Default | Extra          |
	+--------+------------------+------+-----+---------+----------------+
	| id     | int(10) unsigned | NO   | PRI | NULL    | auto_increment |
	| name   | varchar(255)     | NO   | UNI | NULL    |                |
	| status | tinyint(4)       | NO   | MUL | 1       |                |
	+--------+------------------+------+-----+---------+----------------+

=cut
