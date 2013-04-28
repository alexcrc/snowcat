package Snowcat::Schema::Result::Task;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('Task');
__PACKAGE__->add_columns(  qw/
	id
	name
	package
	subroutine
	status
	timestamp
	

/  );

__PACKAGE__->set_primary_key( 'id' );



1;

=for Table Schema

    desc Task;
    +------------+---------------------+------+-----+-------------------+-----------------------------+
    | Field      | Type                | Null | Key | Default           | Extra                       |
    +------------+---------------------+------+-----+-------------------+-----------------------------+
    | id         | int(10) unsigned    | NO   | PRI | NULL              | auto_increment              |
    | name       | varchar(255)        | NO   | UNI | NULL              |                             |
    | package    | varchar(1024)       | NO   | MUL | NULL              |                             |
    | subroutine | varchar(1024)       | NO   | MUL | NULL              |                             |
    | status     | tinyint(3) unsigned | NO   |     | 1                 |                             |
    | timestamp  | timestamp           | NO   | MUL | CURRENT_TIMESTAMP | on update CURRENT_TIMESTAMP |
    +------------+---------------------+------+-----+-------------------+-----------------------------+
    6 rows in set (0.00 sec)

=cut
