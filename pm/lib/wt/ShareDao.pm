package wt::ShareDao;

use Moose;
use Data::Dumper;
extends 'wt::MDBBase';

our $VERSION = '0.102080';

sub BUILD {
    my $this = shift;
    $this->cls( $this->db->get_collection( 'share' ) );
    $this->seq('seq_share');
}

sub save {
    my ( $this, $nt, $force_ins ) = @_;
    my $tags= $$nt{tags}?$$nt{tags}+0:0;
    my $id = $$nt{id};
    my $_id = 0;

    if($force_ins){
        $_id = $this->cls->insert($nt);
    }
    elsif( $id ){
        $id = $id + 0;
        delete $$nt{_id};
        delete $$nt{id};
        $_id = $this->cls->update({"id" => $id}, {'$set' => $nt});
    }
    else{
        $_id = $this->cls->insert({
                "id" => $this->nextval,
                'gplusid'=>$$nt{gplusid},
                "imgurl" => $$nt{imgurl},
                "fullimgurl" => $$nt{fullimgurl},
                "annotation" => $$nt{annotation},
                "title" => $$nt{title},
                "content" => $$nt{content},
                "url" => $$nt{url},
                "tags" => $tags
            });
    }

    $this->getId( $_id );
}



no Moose;
__PACKAGE__->meta->make_immutable;

1;

=head1 NAME

MongodbForNote.pm - DAO for note on mongodb

=head1 SYNOPSIS


my $newnt = {name=>'测试tmp', pid=>141};
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
    ptln $$_{name};
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
