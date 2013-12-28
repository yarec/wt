package t::lib::Test;

use 5.00503;
use strict;
use Test::More;
use wt::NtDao;
use wt;

use Data::Dumper;

my $ntdao;

# Run all tests
sub run {
    $ntdao = new wt::NtDao( "db"=>"test");
    test_count();
    test_nextval();
    test_set_seq();
    test_saveNt();
    test_getNt();
    test_rmNt();
    test_getAllNt();
    test_getRootNts();
    test_getSubs();
    test_rmSubs();
}

sub test_count(){
    ok( $ntdao->count >= 0 );
}

sub test_set_seq(){
    $ntdao->set_seq(100);
    is $ntdao->nextval() , 101;
}

sub test_nextval(){
    ok $ntdao->nextval('seq_nt') > 0 ;
}

my $saveid;
my $newnt = {ntname=>'测试tmp', pid=>141};

sub test_saveNt(){
    $saveid = $ntdao->save( $newnt );
    ok $saveid > 0;
}

sub test_getNt {
    my $nt = $ntdao->get( $saveid );

    is $$nt{pid}, $$newnt{pid} ;
    #is($$nt{ntname}, $$newnt{ntname});
}

sub test_rmNt {
     $ntdao->rm( $saveid );
     is $ntdao->get( $saveid ) , 0;
}

sub test_getAllNt {
    foreach(1..10){
        $ntdao->save( $newnt );
    }
    my @nts = $ntdao->getAll( 0, 10 );
    my $count = @nts;

    is $count, 10;
    #is($$nt{ntname}, $$newnt{ntname});
}

my $rootnt = {ntname=>'测试tmp', pid=>-100};
sub test_getRootNts{
    $ntdao->save( $rootnt );

    is $ntdao->getRoots(), 1;
}

sub test_getSubs {
    is $ntdao->getSubs(-100), 1;
}

sub test_rmSubs {
    $ntdao->rmSubs(-100);
    is $ntdao->getSubs(-100), 0;
}

sub isCountSubs(){
    my ($pid, $exp) = @_;
    my @nts = $ntdao->getSubs($pid);
    my $count = @nts;
    is $count, $exp;
}

sub test_getall(){
    ok $ntdao->count gt 0 ;
}

1;
