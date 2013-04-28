package Snowcat::Schema::Result::Value;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('Value');
__PACKAGE__->add_columns(  qw/

 id      
 entity_id
 attribute_id
 value
 timestamp

/  );

__PACKAGE__->set_primary_key( 'id' );
__PACKAGE__->add_unique_constraint( entity_attribute => [ qw/ entity_id attribute_id / ] );
__PACKAGE__->belongs_to(
         entity => 'Snowcat::Schema::Result::Entity',
        { 'foreign.id' => 'self.entity_id' }
);

__PACKAGE__->belongs_to(
         attribute => 'Snowcat::Schema::Result::Attribute',
        { 'foreign.id' => 'self.attribute_id' }
);

__PACKAGE__->has_many(
         history => 'Snowcat::Schema::Result::ValueHistory',
        { 'foreign.value_id' => 'self.id' }
);



1;

=for Table Schema

	 desc Value;
	+--------------+------------------+------+-----+---------+----------------+
	| Field        | Type             | Null | Key | Default | Extra          |
	+--------------+------------------+------+-----+---------+----------------+
	| id           | int(10) unsigned | NO   | PRI | NULL    | auto_increment |
	| entity_id    | int(10) unsigned | NO   | MUL | NULL    |                |
	| attribute_id | int(10) unsigned | NO   |     | NULL    |                |
	| value        | text             | NO   |     | NULL    |                |
	+--------------+------------------+------+-----+---------+----------------+

=cut
