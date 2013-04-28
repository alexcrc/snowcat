use strict;
use warnings;

use 5.14.2;

use Test::More;


use FindBin;

use lib $FindBin::Bin . "/../lib";

use_ok "Snowcat::Schema";
use_ok "Snowcat::EAV";


my $schema = Snowcat::Schema->schema;

ok $schema, "schema active";

my $ent = $schema->resultset('Entity')
    ->find_or_create( { name => "http://www.example.com" } );

ok $ent->id, "example entity";

my $attr
    = $schema->resultset('Attribute')->find_or_create( { name => "url" } );
my $attr2
    = $schema->resultset('Attribute')->find_or_create( { name => "random" } );

ok $attr->id, "example attr";

my $value_1 = $schema->resultset('Value')->update_or_create(
    {   entity_id    => $ent->id,
        attribute_id => $attr->id,
        value        => "http://www.example.com",
        timestamp    => \'now()'
    },
    { key => 'entity_attribute' }
);

my $value_2 = $schema->resultset('Value')->update_or_create(
    {   entity_id    => $ent->id,
        attribute_id => $attr2->id,
        value        => rand(1000)
    },
    { key => 'entity_attribute' }
);

ok $value_1, 'value saved';
ok $value_2, 'value saved';

my $value = $schema->resultset('Value')
    ->find( { entity_id => $ent->id, attribute_id => $attr->id } );
is $value_1->id,    $value->id,    "value id match";
is $value_1->value, $value->value, "value value match";
is $value->value, "http://www.example.com", "value value value";


my $eav= Snowcat::EAV->new( { entity => 'http://www.example.com', attribute => 'url' } );


ok $eav, "eav ok";
is $eav->value, "http://www.example.com", 'EAV value ok';

$eav->value('monogoog');

Snowcat::EAV->new( { entity => 'http://www.example.com', attribute => 'random', value => 'hue moe' } );

my @v= $schema->resultset('Value')->search( { id => { ">=" => 0 } } );


my @eav= $schema->resultset('view_values')->search({});

for my $v ( @eav ) {
	say sprintf "%s, %s, %s, %s", $v->entity, $v->attribute, $v->time, $v->value;

}

#for my $v ( @v ) {
#	say sprintf "%s, %s, %s, %s", $v->entity->name, $v->attribute->name, $v->timestamp, $v->value;
#
#}


done_testing;
