package t::lib::WtTest;

use 5.00503;
use strict;
use Test::More;
use wt;

use Data::Dumper;

# Run all tests
sub run {
    test_fixhtml();
}

sub test_fixhtml(){
    my $html = <<EOF;
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <title>WtTest</title>
        meta
    </head>
    <body>
        body
        <div>
        <div>
        <span>
    </body>
EOF
    is fixhtml($html), '</span></div></div></html>';
}


1;
