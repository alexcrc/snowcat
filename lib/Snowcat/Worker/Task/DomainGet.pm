package Snowcat::Worker::Task::DomainGet;


use strict;
use warnings;
use 5.14.2;

use Mojo::UserAgent;
use HTML::Strip;
use HTML::FormatText;





sub dget_02 {

	return sub {

		my $workload= shift;

		my $ua = Mojo::UserAgent->new;
		$ua->max_redirects( 4 );


                my $title = $ua->get( $workload->{ target } )->res->dom->html->head->title->text  ;

                my $result= { id => $workload->{ id }, status => 5, result => [ [ 'page_title' , $title ] ] } ;

		return $result;




	};


}

sub dget_01 {
    return sub {

        my $workload = shift;
        my $hs       = HTML::Strip->new();
        my @urls     = map { Mojo::URL->new($_) } ( $workload->{target}, );

        my $max_depth = 4;
        my $max_pages = 30;
        my $max_redir = 5;

        my $ua = Mojo::UserAgent->new( max_redirects => $max_redir )
            ->detect_proxy;

        my $active   = 0;
        my $got_urls = 0;

        my $eavs = [];

        my $parse_html = sub {
            my ( $url, $tx ) = @_;

            my $link_count = 0;
            for my $e ( $tx->res->dom('a[href]')->each ) {
                my $link = Mojo::URL->new( $e->{href} );
                next if 'Mojo::URL' ne ref $link;
                $link = $link->to_abs( $tx->req->url )->fragment(undef);
                next unless grep { $link->protocol eq $_ } qw(http https);
                next if @{ $link->path->parts } > $max_depth;
                state $uniq = {};
                ++$uniq->{ $url->to_string };
                next if ++$uniq->{ $link->to_string } > 1;
                next if $link->host ne $url->host;
                push @urls, $link;
                $link_count++;
            }

            push @$eavs, [ "$url", 'link_count', $link_count ];
            push @$eavs,
                [
                "$url", 'page_title',
                $tx->res->dom->at('html title')->text
                ];
            push @$eavs,
                [
                "$url", 'page_text',
                $hs->parse( $tx->res->dom->at('html body')->to_xml )
                ];
            $hs->eof;

            return;
        };

        my $get_callback = sub {
            my ($tx) = @_;

            --$active;
            my $url = $tx->req->url;
            push @$eavs, [ "$url", 'http_response_code', $tx->res->code ];
            say $tx->res->code() . " " . $url . " >> $got_urls [ $$ ] ";

            return
                if not $tx->res->is_status_class(200)
                    or $tx->res->headers->content_type !~ m{^text/html\b}ix;

            $parse_html->( $url, $tx );
            $got_urls++;

            return;
        };

        while ( my $url = shift @urls and $got_urls < $max_pages ) {
            ++$active;
            $get_callback->( $ua->get($url) );
        }

        say " *** DONE $workload->{ target }";
        my $result = $workload;
        $result->{result} = $eavs;
        $result->{status} = @$eavs ? 5 : 0;
        return $result;
        }
}





1;
