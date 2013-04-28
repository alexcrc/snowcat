package Snowcat::Schema::Result::Attribute;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('Attribute');
__PACKAGE__->add_columns(  qw/

 id      
 name
 type
 status

/  );

__PACKAGE__->set_primary_key( 'id' );
__PACKAGE__->has_many(
         val => 'Snowcat::Schema::Result::Value',
        { 'foreign.attribute_id' => 'self.id' }
);



1;

=for Table Schema

	desc Attribute;
	+--------+------------------+------+-----+---------+----------------+
	| Field  | Type             | Null | Key | Default | Extra          |
	+--------+------------------+------+-----+---------+----------------+
	| id     | int(10) unsigned | NO   | PRI | NULL    | auto_increment |
	| type   | varchar(255)     | NO   | MUL | 0       |                |
	| name   | varchar(255)     | NO   | UNI | NULL    |                |
	| status | tinyint(4)       | NO   | MUL | 1       |                |
	+--------+------------------+------+-----+---------+----------------+

=cut
