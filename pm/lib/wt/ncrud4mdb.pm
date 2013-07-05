package wt::ncrud4mdb;

use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);
our $VERSION = '0.102080';
our @EXPORT = qw(
    count
    get_all
    get_nt 
    get_root_nts 
    get_nts 
    get_nts_by_name
    topid
    save_nt 
    delete_nt
    delete_nt_by_name
    test
);


use MongoDB;
use MongoDB::OID;

use wt;
use Data::Dumper;

use utf8;
binmode(STDIN, ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');

my $conn = MongoDB::Connection->new();
my $db = $conn->dbnote;
my $seq= $db->seq;
my $notetypes= $db->notetypes;

sub to_arr;
sub nextval;
sub delete_nt_base;
sub get_nts_base;

sub count(){
    $notetypes->count;
}

sub get_all($$){
    my ($skip, $limit) = @_;
    my $nts = $notetypes->find->limit($limit)->skip($skip);
    to_arr $nts;
}

sub get_nt($) {
    my $id = shift;
    my $nts = $notetypes->find({ id=> $id+0 });
    my $nt = $nts->next;
    delete $$nt{_id};
    return $nt;
}

sub get_nts($) {
    my $pid = shift;
    get_nts_base 'pid', $pid+0;
}

sub get_nts_by_name($) {
    my $ntname= shift;
    get_nts_base 'ntname', $ntname;
}

sub topid(){
    my $nts = $notetypes->find->sort({ 'id'=>-1 })->limit(1);
    my $lastnt = $nts->next;
    ptln $$lastnt{id};
}

sub get_nts_base($$) {
    my ($key, $val) = @_;
    my $nts = $notetypes->find({ $key=>$val });
    to_arr $nts;
}

sub get_root_nts() {
    my $nts = $notetypes->find({ pid=> { '$in'=>[ -100, -200] } });
    to_arr $nts;
}

sub save_nt($){
    my $nt = shift;
    my $pid = $$nt{pid}?$$nt{pid}+0:-100;
    my $id = $$nt{id};

    if( $id ){
        $id = $id + 0;
        delete $$nt{_id};
        delete $$nt{id};
        $notetypes->update({"id" => $id}, {'$set' => $nt});
    }
    else{
        $notetypes->insert({
                "id" => nextval($db, 'seq_nt'),
                "ntname" => $$nt{ntname},
                "pid" => $pid
                });
    }
}
sub delete_nt($){
    my $id= shift;
    delete_nt_base 'id', $id+0;
}
sub delete_nt_by_name($){
    my $ntname = shift;
    delete_nt_base 'ntname', $ntname;
}
sub delete_nt_base($$){
    my ($key, $val) = @_;
    $notetypes->remove({ $key=>$val }) if ($key and $val);
}

sub clean_nts(){
    $notetypes->remove;
}

sub test(){
    set_seq ($db, 'seq_nt', 9999);
}

sub to_arr($){
    my $result = shift;
    my @ret;
    foreach($result->all){
        my $nt = $_;
        delete $$nt{_id};
        $$nt{caption} = $$nt{ntname};
        $$nt{sub} = 1;
        push  @ret, $nt;
    }
    return @ret;
}

sub set_seq($$$){
    my ($db, $seq, $val)=@_;
    $db->seq->update({'seq'=>$seq}, {'$set'=>{id=>$val}});
}

sub nextval($$){
    my ($db, $seq)=@_;
    my $ret = $db->run_command( {
            findAndModify => 'seq', 
            query=> { seq=>$seq }, 
            update=> { '$inc'=>{ id=>1 } }, 
            new=>1, 
            upsert=>1
        });
    $$ret{value}{id};
}

1;

=head1 NAME

MongodbForNote.pm - DAO for note on mongodb

=head1 SYNOPSIS


my $newnt = {ntname=>'测试tmp', pid=>141};
save_nt $newnt;

delete_nt_by_name '测试tmp';
delete_nt 9999;

my $nt = get_nt 141;
my @root_nts = get_root_nts;
my @nts = get_nts 141;
my @test_nts = get_nts_by_name '测试';

my @name_nts = get_nts_by_name '测试';
$name_nts[0]{a} = 1;
$name_nts[0]{b} = 2;
$name_nts[0]{pid} = 2;
save_nt $name_nts[0];

topid;

my @all = get_all 2, 5;
foreach(@all){
    ptln $$_{ntname};
}


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
