package wt::NDao;

use Moose;
extends 'wt::MDBBase';

use HTML::Entities;
use MongoDB::Timestamp;
use Date::Format;
use wt;
use Data::Dumper;

our $VERSION = '0.102080';

sub BUILD {
    my $this = shift;
    $this->cls( $this->db->get_collection( 'notes' ) );
    $this->seq('seq_note');
}
sub save {
    my ( $this, $note, $force_ins ) = @_;
    my $tid = $$note{tid}?$$note{tid}:-100;
    my $id = $$note{id};
    my $_id = 0;

    my @tids;
    foreach(split(/,/, $tid)){
        push @tids, $_+0;
    }
    $$note{tid} = \@tids;
    $$note{dateline} = MongoDB::Timestamp->new("sec" => time, "inc" => 1);

    if($force_ins){
        $_id = $this->cls->insert($note);
    }
    elsif( $id ){
        $id = $id + 0;
        delete $$note{_id};
        delete $$note{id};
        delete $$note{notedate};
        $_id = $this->cls->update({"id" => $id}, {'$set' => $note});
    }
    else{
        $$note{id} = $this->nextval;
        $$note{notedate} = MongoDB::Timestamp->new("sec" => time, "inc" => 1);
        $_id = $this->cls->insert($note);
    }

    $this->getId( $_id );
}

sub getN {
    my ($self, $id) = @_;
    my $record = $self->get($id);
    return $self->adjustNote($record);
}

sub getSubIds {
    my ( $this, $pid) = @_;
    my @records = $this->cls->find({ 'tid'=> $pid })->fields({id=>1})->all;

    my @ret;
    foreach(@records){
        my $record = $_;
        push  @ret, $record->{id};
    }
    return @ret;
}
sub getAllNotes{

    my ($this, $skip, $limit) = @_;
    $skip = 0 if(! $skip);
    $limit = 0 if(! $limit);

    my $records = $this->cls->find->sort({ 'id'=>-1 })->fields( {
            id=>1,
            name=>1,
            tid=>1,
            notedate=>1,
            format=>1,
        })->sort({ 'id'=>-1 })->limit($limit)->skip($skip);

    $this->to_arr( $records );
}
sub getByTid {

    my ($this, $tid, $skip, $limit) = @_;
    $skip = 0 if(! $skip);
    $limit = 0 if(! $limit);

    my $records = $this->cls->find( { 'tid'=>  $tid+0 } )->fields( {
            id=>1,
            name=>1,
            tid=>1,
            notedate=>1,
            dateline=>1,
            format=>1,
        })->sort({ 'id'=>-1 })->limit($limit)->skip($skip);

    $this->to_arr( $records );
}
sub getByTids {

    my ($this, $tids, $skip, $limit) = @_;
    $skip = 0 if(! $skip);
    $limit = 0 if(! $limit);

    my $records = $this->cls->find( { 'tid'=> {'$in'=> $tids} } )->sort({ 'id'=>-1 })->limit($limit)->skip($skip);

    $this->to_arr( $records );
}

sub getShortByTids {

    my ($this, $tids, $skip, $limit) = @_;
    $skip = 0 if(! $skip);
    $limit = 0 if(! $limit);

    my $records = $this->cls->find( { 'tid'=> {'$in'=> $tids} } )->
        sort({ 'id'=>-1 })->limit($limit)->skip($skip)->fields(
        {'id'=>1, 'name'=>1, 'desc'=>1,'format'=>1, 'dateline'=>1, 'notedate'=>1} 
    );

    $this->to_arr( $records );
#    my @ret = ();
#    while (my $entry = $records->next) {
#        push @ret, $entry;
#    }
#    return @ret;
}

sub countByTids {
    my ($this, $tids) = @_;
    return $this->cls->find( { 'tid'=> {'$in'=> $tids} } )->count();
}

sub to_arr {
    my ($this, $records) = @_;
    my @ret;
    foreach($records->all){
        my $record = $_;
        delete $$record{_id};
        push  @ret, $this->adjustNote($record);
    }
    return @ret;
}

sub adjustNote {
    my ($this, $record) = @_;
    $$record{notedate} = $$record{notedate}?time2str("%Y-%m-%d",$$record{notedate}->sec):time;
    $$record{dateline} = $$record{dateline}?time2str("%Y-%m-%d",$$record{dateline}->sec):time;
    if(! $$record{format} && $$record{value}){
        $$record{value} =~ s/&ampn;/\\n/g;
    }
    #$$record{value} = encode_entities($$record{value});
    return $record;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

=head1 NAME

MongodbForNote.pm - DAO for note on mongodb

=head1 SYNOPSIS




 Examples:

 See also:
    Nothing Here!

=head1 DESCRIPTION

utils function for daily work

Some detail description

=head1 AUTHOR

Renoteie <rwtest@gmail.com>
Mainoteained by myself.

=head1 COPYRIGHT

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
__END__
