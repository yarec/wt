package wt::MDBBase;

use Moose;

use MongoDB;
use MongoDB::OID;

use wt;
use Data::Dumper;

use utf8;
binmode(STDIN, ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');

has cfg => ( is => 'rw' ); 
has conn => ( is => 'rw' ); 
has db => ( is => 'rw' ); 
has cls=> ( is => 'rw' ); 
has seq => ( is => 'rw' ); 

sub BUILD {
    my $this = shift;
    my $args = shift;

    if($this->cfg){
        $this->conn( MongoDB::Connection->new( $this->cfg ) );
    }
    elsif($this->conn){
        $this->conn( $this->conn );
    }
    else{
        $this->conn( MongoDB::Connection->new() );
    }

    my $db = eval('$this->conn->get_database("'.$this->db.'")');
    $this->db( $db );
}

sub count {
    my ( $this, $k, $v) = @_;
    if($k && $v ){
        $this->cls->find({$k => $v})->count;
    }
    else{
        $this->cls->count();
    }
}

sub get {
    my ( $this, $id) = @_;
    my $records = $this->cls->find({ id=> $id+0 });

    if(my $record = $records->next){
        delete $$record{_id};
        return $record;
    }
    else{
        return 0;
    }
}

sub rm {
    my ( $this, $id) = @_;
    $this->rmByKV( 'id', $id+0 );
}

sub getAll {
    my ($this, $skip, $limit) = @_;
    my $records = $this->cls->find->sort({ 'id'=>-1 })->limit($limit)->skip($skip);
    $this->to_arr( $records );
}

sub getRoots {
    my $this = shift;
    my $records = $this->cls->find({ pid=> { '$in'=>[ -100, -200] } });
    $this->to_arr( $records );
}

sub getSubs {
    my ( $this, $pid) = @_;
    $this->getByKV( 'pid', $pid+0 );
}

sub rmSubs {
    my ( $this, $pid) = @_;
    $this->rmByKV( 'pid', $pid+0 );
}

sub getId {
    my ( $this, $_id) = @_;
    my $records = $this->cls->find({ _id=> $_id });
    my $rec = $records->next;
    my $ret = 0;
    if($rec){
        $ret = $$rec{id};
    }
    return $ret;
}

sub getByKV {

    my ($this, $key, $val, $skip, $limit) = @_;
    $skip = 0 if(! $skip);
    $limit = 0 if(! $limit);

    my $records = $this->cls->find({ $key=>$val })->sort({ 'id'=>-1 })->limit($limit)->skip($skip);

    $this->to_arr( $records );
}

sub rmByKV {
    my ($this, $key, $val) = @_;
    $this->cls->remove({ $key=>$val }) if ($key and $val);
}


sub to_arr {
    my ($this, $records) = @_;
    my @ret;
    foreach($records->all){
        my $record = $_;
        delete $$record{_id};
        push  @ret, $record;
    }
    return @ret;
}

sub topid(){
    my ($this) = @_;
    my $nts = $this->cls->find->sort({ 'id'=>-1 })->limit(1);
    my $lastnt = $nts->next;
    return $$lastnt{id};
}

sub set_seq {
    my ($this, $val) = @_;
    my $count = $this->db->seq->find({'seq'=>$this->seq})->count;
    if($count){
        $this->db->seq->update({'seq'=>$this->seq}, {'$set'=>{id=>$val}});
    }
    else{
        $this->db->seq->insert({'seq'=>$this->seq, 'id'=>$val});
    }
}

sub nextval {
    my ($this, $seq)=@_;
    my $ret = $this->db->run_command( {
            findAndModify => 'seq', 
            query=> { seq=>$this->seq }, 
            update=> { '$inc'=>{ id=>1 } }, 
            new=>1, 
            upsert=>1
        });
    $$ret{value}{id};
}

__PACKAGE__->meta->make_immutable;

1;
