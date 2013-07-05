package wt::dbiutil;

use strict;
use warnings;
use wt;
use DBI;

require Exporter;

our @ISA = qw(Exporter);
our $VERSION = '0.102080';
our @EXPORT = qw(
    connect do_sql show get_db_int get_sth release_sth release_dbh desc_table
);

sub get_db_int($$){
    my ( $dbh, $sql ) = @_; 
    my $sth = &get_sth( $dbh, $sql );
    my @data = $sth->fetchrow_array();
    &release_sth($sth);

    my $db_int = $data[0];
}

sub get_sth($$){
    my ( $dbh, $sql ) = @_; 
    my $sth = $dbh->prepare($sql);
    $sth->execute() or die "无法执行SQL语句:$DBI::errstr";
    return $sth;
}

sub show($$){
    my ( $dbh, $sql ) = @_; 
    my $sth = &get_sth($dbh, $sql);
    while (my @data = $sth->fetchrow_array()) {
        ptln join(", ", @data);
    }
    &release_sth($sth);
}

sub do_sql($$){
    my ( $dbh, $sql ) = @_; 
    $dbh->do($sql) or ptln "无法执行SQL语句:$DBI::errstr";
}

sub connect($$$$$){
    my ( $host, $port, $db_name, $db_user, $db_pass ) = @_; 

    my $database = "DBI:mysql:$db_name:$host:$port";
    my $dbh = DBI->connect($database, $db_user, $db_pass);
    if ( !defined $dbh ) { 
        print "connect Error: $DBI::errstr\n"; 
    }   
    else{ 
        $dbh->do("SET NAMES UTF8");
        return $dbh;
    }   
}

sub release_dbh($){
    my ( $dbh ) = @_; 
    $dbh->disconnect() if($dbh);
}
sub release_sth($){
    my ( $sth ) = @_; 
    $sth->finish();
}

sub desc_table($$$){
    my ($dbh, $table, @ig_cols) = @_;
    my $sth = get_sth($dbh, "desc $table");

    my %ret;
    while (my @data = $sth->fetchrow_array()) {
        if ( grep { $_ eq $data[0]} @ig_cols){
            next;
        }
        if($data[1] =~ /int/){
            $ret{$data[0]} = 0;
        }
        elsif($data[1] =~ /datetime/) {
            $ret{$data[0]} = 2;
        }
        else{
            $ret{$data[0]} = 1;
        }
    }
    &release_sth($sth);
    return \%ret;
}


1;
=head1 NAME

dbiutil.pm - dbi util

=head1 SYNOPSIS

    use wt;
    use wt::dbiutil;
    use Data::Dumper;

    my $s_sql = "select 1, 'a' union select 2, 'b' ";
    my $dbh = connect '192.168.1.100', '3306', 'test', 'root', '123456'; 

    my $sth = get_sth $dbh, $s_sql;
    while (my @data = $sth->fetchrow_array()) {
        ptln join(", ", @data);
    }
    release_sth $sth;

    show $dbh, $s_sql;

    do_sql $dbh, $s_sql;

    ptln get_db_int $dbh, 'select 123';

    ptln Dumper(desc_table $dbh, 'admin', 0);

    release_dbh $dbh;


 Examples:

 See also:
    Nothing Here!

=head1 DESCRIPTION

utils function for operate db

Some detail description

=head1 AUTHOR

Rentie <rwtest@gmail.com>
Maintained by myself.

=head1 COPYRIGHT

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
__END__
