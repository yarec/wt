#!/usr/bin/perl

use strict;
BEGIN {
    $|  = 1;
    $^W = 1;
    $ENV{LIST_MOREUTILS_PP} = 1;
};

use Test::More;
require t::lib::Test;
require t::lib::WtTest;

plan tests => 11;

t::lib::Test->run;
t::lib::WtTest->run;
