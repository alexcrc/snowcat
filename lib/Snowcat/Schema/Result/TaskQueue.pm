package Snowcat::Schema::Result::TaskQueue;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('TaskQueue');
__PACKAGE__->add_columns(  qw/
 id                  
 last_change         
 task                
 status              
 target              
 timestamp_issued    
 timestamp_finalized 
 result_id           

/  );

__PACKAGE__->set_primary_key( 'id' );

__PACKAGE__->might_have(
	 result => 'Snowcat::Schema::Result::ResultIndex',
	{ 'foreign.id' => 'self.result_id' }

);

1;

=for Table Schema

  mysql> desc TaskQueue;
  +---------------------+------------------+------+-----+---------------------+-----------------------------+
  | Field               | Type             | Null | Key | Default             | Extra                       |
  +---------------------+------------------+------+-----+---------------------+-----------------------------+
  | id                  | int(10) unsigned | NO   | PRI | NULL                | auto_increment              |
  | last_change         | timestamp        | NO   | MUL | CURRENT_TIMESTAMP   | on update CURRENT_TIMESTAMP |
  | task                | varchar(255)     | NO   |     | NULL                |                             |
  | status              | tinyint(4)       | NO   | MUL | NULL                |                             |
  | target              | varchar(4000)    | YES  | MUL | NULL                |                             |
  | timestamp_issued    | timestamp        | NO   | MUL | 0000-00-00 00:00:00 |                             |
  | timestamp_finalized | timestamp        | YES  | MUL | NULL                |                             |
  | result_id           | int(10) unsigned | YES  | UNI | NULL                |                             |
  +---------------------+------------------+------+-----+---------------------+-----------------------------+
  8 rows in set (0.01 sec)


=cut
