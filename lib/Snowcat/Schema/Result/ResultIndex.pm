package Snowcat::Schema::Result::ResultIndex;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('ResultIndex');
__PACKAGE__->add_columns(  qw/

 id          
 last_change 
 task        
 item_id     
 store       
 status      
 resource    

/  );

__PACKAGE__->set_primary_key( 'id' );
__PACKAGE__->might_have(
         task_queue_item => 'Snowcat::Schema::Result::TaskQueue',
        { 'foreign.result_id' => 'self.id' }

);



1;

=for Table Schema

	mysql> desc ResultIndex
	    -> ;
	+-------------+------------------+------+-----+-------------------+-----------------------------+
	| Field       | Type             | Null | Key | Default           | Extra                       |
	+-------------+------------------+------+-----+-------------------+-----------------------------+
	| id          | int(10) unsigned | NO   | PRI | NULL              | auto_increment              |
	| last_change | timestamp        | NO   | MUL | CURRENT_TIMESTAMP | on update CURRENT_TIMESTAMP |
	| task        | varchar(255)     | NO   | MUL | NULL              |                             |
	| item_id     | int(10)          | NO   |     | NULL              |                             |
	| store       | varchar(255)     | NO   | MUL | mongo             |                             |
	| status      | tinyint(4)       | NO   | MUL | NULL              |                             |
	| resource    | varchar(255)     | NO   | MUL | NULL              |                             |
	+-------------+------------------+------+-----+-------------------+-----------------------------+
	7 rows in set (0.00 sec)



=cut
