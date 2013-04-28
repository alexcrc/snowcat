use strict;
use Mojolicious::Lite;
use Plack::Builder;

use FindBin;
use lib $FindBin::Bin. "/../lib";

use Snowcat::Schema;
use Snowcat::EAV;

my $schema = Snowcat::Schema->schema;

# Route leading to an action that renders a template
get '/' => sub {
  my $self = shift;

	my $data= { column_names => [  ],
		    rows => [ 
			      
                              
                              
	                      ],
		    title => 'Snowcat',
		    name  => 'Home',
		    links => [ 
				{ url => '/home', text=> 'Home', active => 1 }, 
				{ url => '/task',          text => 'Task',      active => 0 },
				{ url => '/entity', text=> 'Entity', active => 0 }, 
				{ url => '/attribute', text=> 'Attribute', active => 0 }, 

				],
                  };

  $self->stash( table_data => $data );
  $self->render('table');
};


get '/entity' =>  sub {
	my $self= shift;

	my ( $attr_id )= $self->param('attribute_id') || 0 =~m/^([0-9]+)$/;
	

	my $ent_rs;
	my $list_name= 'Entity View';
	my $rows= [];
	my $columns= [ qw/ ID NAME STATUS /  ];
	my $ent_link;
	if ( $attr_id ){
		my $attr= $schema->resultset('Attribute')->find( $attr_id );

		$ent_rs= $schema->resultset('Entity')->search( 
			{ -and => [ 
				'val.attribute_id' => $attr_id,
			] },
			{
				join =>  'val',
				group_by => [ 'val.entity_id', 'val.attribute_id' ],
				prefetch => { 'val' => 'history' },

			} 

		);
		$ent_link= 
		 {
			text      => $attr->name,
			action    => 'entity',
			arg_name  => 'attribute_id',
			arg_value => $attr->id
		    } ;

		
		$columns= [ qw/ ID ENTITY CURR_VALUE HISTORY /  ];
		while ( my $ent = $ent_rs->next ){
			my $v= ( $ent->val )[0];
			    my $vh_c= $v->history->count;
			    my $val_hist_link = {
				text      => $vh_c ,
				action    => 'value',
				arg_name  => 'value_id',
				arg_value => $v->id
			    } ;

			push @$rows, 
			    [ $ent->id,  $ent->name,  $v->value, $val_hist_link ]
			;

		}

	} else {
		$ent_rs= $schema->resultset('Entity')->search( 
			{ 
				status => { ">=" => 1 },
			},
			{ prefetch => 'val' }

		);
		while ( my $ent = $ent_rs->next ){
			my $attr_count = $ent->val->count( undef, { group_by => 'attribute_id' } );

			my $attr_link = {
			    text      => $attr_count,
			    action    => 'attribute',
			    arg_name  => 'entity_id',
			    arg_value => $ent->id
			} ;
			push @$rows, 
			    [ $ent->id, $ent->name, $ent->status, $attr_link ]
			;

		}
		$columns= [ qw/ ID NAME STATUS ATTRS /  ];

	};

	my $data= {
		column_names 	=> $columns,
		rows		=> $rows,
		name 		=> $list_name,
		title		=> 'Snowcat',
		( ( $ent_link ) ? ( attribute_link  => $ent_link
		   ) : () ),
		links		=> [
				{ url => '/', text=> 'Home', active => 0 }, 
				{ url => '/task',          text => 'Task',      active => 0 },
				{ url => '/entity', text=> 'Entity', active => 1 }, 
				{ url => '/attribute', text=> 'Attribute', active => 0 }, 

		],

	};

	
  $self->stash( table_data => $data );
  $self->render('table');



};

get '/attribute' => sub {
    my $self = shift;

    my ($ent_id) = $self->param('entity_id') || 0 =~ m/^([0-9]+)$/;

    my $rs;
    my $rows = [];
    my $page_name= 'Attribute View';
    my $columns = [qw/ ID NAME TYPE STATUS ENTITIES /];
    my $ent_link;
    if ($ent_id) {
        my $ent = $schema->resultset('Entity')->find($ent_id);
        $rs = $schema->resultset('Attribute')->search(
            {   -and =>
                    [ status => { ">=" => 1 }, 'val.entity_id' => $ent_id ]
            },
            {   join     => 'val',
                group_by => [ 'val.entity_id', 'val.attribute_id' ],
                prefetch => { 'val' => 'history' }
            }
        );
	$ent_link= 
	 {
		text      => $ent->name,
		action    => 'attribute',
		arg_name  => 'entity_id',
		arg_value => $ent->id
	    } ;

        $columns = [qw/ ID ATTRIBUTE CURR_VALUE HISTORY /];
        while ( my $attr = $rs->next ) {
            my $v    = ( $attr->val )[0];
            my $vh_c = $v->history->count;

            my $val_hist_link = {
                text      => $vh_c,
                action    => 'value',
                arg_name  => 'value_id',
                arg_value => $v->id
            };

            push @$rows,
                [ $attr->id, $attr->name, $v->value, $val_hist_link ];
        }
    }
    else {
        $rs = $schema->resultset('Attribute')
            ->search( { status => { ">=" => 1 } }, { prefetch => 'val' }  );

        while ( my $attr = $rs->next ) {
            my $ent_count = $attr->val->count( undef, { group_by => 'entity_id' } );

            my $ent_link = {
                text      => $ent_count,
                action    => 'entity',
                arg_name  => 'attribute_id',
                arg_value => $attr->id
            };

            push @$rows,
                [
                $attr->id,     $attr->name, $attr->type,
                $attr->status, $ent_link
                ];
        }
    }

    my $data = {
        column_names => $columns,
        rows         => $rows,
        title        => 'Snowcat',
        name         => $page_name,
		( ( $ent_link ) ? ( entity_link  => $ent_link
		   ) : () ),
        links        => [
            { url => '/',          text => 'Home',      active => 0 },
            { url => '/task',          text => 'Task',      active => 0 },
            { url => '/entity',    text => 'Entity',    active => 0 },
            { url => '/attribute', text => 'Attribute', active => 1 },

        ],

    };

    $self->stash( table_data => $data );
    $self->render('table');

};

get '/value' => sub {
    my $self = shift;

    my ($val_id) = $self->param('value_id') || 0 =~ m/^([0-9]+)$/;

    my $rs;
    my $rows = [];
    my $page_name;
    my $columns = [qw/ ID TIME VALUE /];
    my $val     = $schema->resultset('Value')->find( $val_id );
    my $history=  $schema->resultset('ValueHistory')->search( { value_id => $val_id } );


    while ( my $vh = $history->next ) {

        push @$rows,
            [
		    $vh->id,
		    $vh->timestamp,
		    $vh->value
            ];
    }
    $page_name
        = 'Value History';
    

    my $data = {
        column_names => $columns,
        rows         => $rows,
        title        => 'Snowcat',
        name         => $page_name,
	entity_link  => ,
            {
                text      => $val->entity->name,
                action    => 'attribute',
                arg_name  => 'entity_id',
                arg_value => $val->entity->id
            },
	attribute_link => 
            {
                text      => $val->attribute->name,
                action    => 'entity',
                arg_name  => 'attribute_id',
                arg_value => $val->attribute->id
            },
        links        => [
            { url => '/',          text => 'Home',      active => 0 },
            { url => '/task',          text => 'Task',      active => 0 },
            { url => '/entity',    text => 'Entity',    active => 0 },
            { url => '/attribute', text => 'Attribute', active => 1 },

        ],

    };

    $self->stash( table_data => $data );
    $self->render('table');

};

get '/task' => sub {
    my $self = shift;

    my $rows = [];
    my $page_name;
    my $columns = [qw/ ID NAME STATUS /];
    my $tasks=  $schema->resultset('Task');


    while ( my $t = $tasks->next ) {

        push @$rows,
            [
		    $t->id,
		    $t->name,
		    $t->status
            ];
    }
    $page_name
        = 'Tasks';
    

    my $data = {
        column_names => $columns,
        rows         => $rows,
        title        => 'Snowcat',
        name         => $page_name,

        links        => [
            { url => '/',          text => 'Home',      active => 0 },
            { url => '/task',          text => 'Task',      active => 1 },
            { url => '/entity',    text => 'Entity',    active => 0 },
            { url => '/attribute', text => 'Attribute', active => 0 },

        ],

    };

    $self->stash( table_data => $data );
    $self->render('table');

};
builder {
	enable "Plack::Middleware::Static",
	  path => '/static', root => './../';
	  app->start;
};

__DATA__

@@ table.html.ep
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title><%= $table_data->{ title } %></title>
		<link rel="stylesheet" type="text/css" href="/static/bootstrap/css/geo/bootstrap.css">
		<link rel="stylesheet" type="text/css" href="/static/DT_bootstrap.css">
		<script type="text/javascript" charset="utf-8" language="javascript" src="http://datatables.net/release-datatables/media/js/jquery.js"></script>
		<script type="text/javascript" charset="utf-8" language="javascript" src="http://datatables.net/release-datatables/media/js/jquery.dataTables.js"></script>
		<script type="text/javascript" charset="utf-8" language="javascript" src="/static/DT_bootstrap.js"></script>
		<script type="text/javascript" charset="utf-8" language="javascript" src="/static/bootstrap/js/bootstrap.js"></script>
    <style>
      body {
        padding-top: 60px; /* 60px to make the container go all the way to the bottom of the topbar */
      }
    </style>

	</head>
	<body>
    <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="brand" href="#"><%= $table_data->{ title }%></a>
          <div class="nav-collapse collapse">
            <ul class="nav">
		% for my $link ( @{ $table_data->{ links } || [] } ){
			% my $class= "";
			% $class= " class='active' " if $link->{ active };
			<li <%== $class %> ><a href="<%= $link->{ url } %>"><%= $link->{ text } %></a></li>
		% }
            % # <li class="active"><a href="#">Home</a></li>
            % # <li><a href="#about">About</a></li>
            % # <li><a href="#contact">Contact</a></li>
            </ul>
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>


		<div class="container" style="margin-top: 10px">
<h1><%= $table_data->{ name }%></h1>

% if ( $table_data->{ entity_link }  or $table_data->{ attribute_link }  ){
	<dl class="dl-horizontal">
		% if ( $table_data->{ entity_link } ) {
    		<dt>Entity</dt>
		<dd><a href='/<%= "$table_data->{ entity_link }->{ action }?$table_data->{ entity_link }->{ arg_name }=$table_data->{ entity_link }->{ arg_value }" %>'><%= $table_data->{ entity_link }->{ text }%></a></dd>
		% }
		% if (  $table_data->{ attribute_link }  ){
    		<dt>Attribute</dt>
		<dd><a href='/<%= "$table_data->{ attribute_link }->{ action }?$table_data->{ attribute_link }->{ arg_name }=$table_data->{ attribute_link }->{ arg_value }" %>'><%= $table_data->{ attribute_link }->{ text }%></a></dd>
		% }
    	</dl>
% }
			
<table cellpadding="0" cellspacing="0" border="0" class="table table-striped table-bordered" id="example">
	<thead>
		<tr>
			% for my $col ( @{ $table_data->{ column_names } } ){
				<th><u><%= $col %></u></th>
			% }
		</tr>
	</thead>
	<tbody>
		% my $count= 0;
		% for my $row ( @{ $table_data->{ rows } } ){ 
			% my $parity= 'even';
			% $parity= 'odd' if ( $count++ ) % 2;
			<tr class="<%= $parity %>">
				% for my $item ( @$row ){
				%	if ( ref $item eq 'HASH' ){
						<td><a href='/<%= "$item->{ action }?$item->{ arg_name }=$item->{ arg_value }" %>'><%= $item->{ text }%></a></td>
				%	} else {
						<td><%= $item %></td>
				%	}
				% }
			</tr>
		% }
	</tbody>
</table>
			
		</div>
	</body>
</html>
