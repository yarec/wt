package wt;

use strict;
use warnings;

require Exporter;

use FindBin '$Bin';
use Log::Log4perl qw(:easy);
my $log;
BEGIN {
    my $log4perl_conf = "$Bin/log4perl.conf";
    $log4perl_conf = "/app/log4perl.conf" if ! -e $log4perl_conf;
    $log4perl_conf = "/etc/log4perl.conf" if ! -e $log4perl_conf;
    Log::Log4perl::init_and_watch($log4perl_conf,10);
    $log = Log::Log4perl->get_logger(); 
}

our @ISA = qw(Exporter);
our $VERSION = '0.102080';
our @EXPORT = qw(
    debug info warn error fatal ptln echo ptfile handle_file get_pid is_int strhashint
);

sub debug($){ $log->debug(shift); }
sub info($){ $log->info(shift); }
sub warn($){ $log->warn(shift); }
sub error($){ $log->error(shift); }
sub fatal($){ $log->fatal(shift); }

sub ptln($) { 
    my $s = shift; 
    $s="" if(!defined $s); 
    print $s."\n"; 
}

sub echo($){ print shift; }

sub ptfile {
    my ($file,$content, $o) = @_;
    $o = '>>' if !$o;
    open (MYFILE, "${o}$file");
    print MYFILE $content;
    close (MYFILE);
}

sub handle_file($$){
    my ($file, $handler) = @_;

    if( -e $file){
        open (F, $file) or error "$! $file";
        while(<F>){
            my $line = $_; 
            &$handler($line);
        }   
        close(F);
    }
    else{
        error "file not found : $file";
    }
}

sub inc_hash(){
    my ($hash, $key) = @_; 

    if($hash->{$key}){ $hash->{$key}++; }   
    else{ $hash->{$key}=1; }   
}

#usage: get_pid( "org.apache.catalina.startup.Bootstrap", "java" )."\n";
sub get_pid($$) {

    return -2 if($#_ < 1);

    my $ret = -1;
    my ( $grepstr, $keyword ) = @_;

    open (PIPE, "ps -ef|grep $grepstr|");
    my @result = <PIPE>;

    foreach (@result) {
        my @str = split(" ",$_);
        if($_ =~ m/.*$keyword.*/)  {
            $ret = $str[1];
        }
    }

    return $ret;
}

sub is_int($){
 my $n = shift;
 (~$n & $n)? 0 : 1;
} 

sub strhashint($$){

    use Digest::MD5 qw(md5_hex);
    my ($str, $range) = @_;

    no warnings;
    my @hash = split //, md5_hex $str;
    my $ret = $hash[0] | ($hash[1] <<8 ) | ($hash[2] <<16) | ($hash[3] <<24) | ($hash[4] <<32) | ($hash[5] <<40) | ($hash[6] <<48) | ($hash[7] <<56);
    $ret % $range;
} 

1;

=head1 NAME

wt.pm - Daily Tool

=head1 SYNOPSIS

    handle_file( "url.list", 
        sub{ 
            print shift;
        }
    );

    inc_hash( \%hash , $key );


 Examples:

 See also:
    Nothing Here!

=head1 DESCRIPTION

utils function for daily work

Some detail description

=head1 AUTHOR

Rentie <rwtest@gmail.com>
Maintained by myself.

=head1 COPYRIGHT

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
__END__
