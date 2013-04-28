package Snowcat::Schema;
use base qw /DBIx::Class::Schema/;

our $VERSION = '0.25';


sub c {
    my ( $this, $schema_code ) = @_;

    my $db_name = 'snowcat';


    my $config = {
        db_host    => 'localhost',
        db_name    => $db_name,
        db_port    => 3022,
        db_user    => 'snowcat',
        db_pass    => 'intothesnow',
    };

    __PACKAGE__->connect(
        "dbi:mysql:"
          . "host=$config->{ db_host };"
          . "port=$config->{ db_port };"
          . "database=$config->{ db_name };",
        $config->{db_user},
        $config->{db_pass},
    );
}

sub schema {
    shift;
    return __PACKAGE__->c(shift);
}

__PACKAGE__->load_namespaces();

1;
