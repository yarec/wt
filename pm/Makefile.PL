#!/usr/bin/perl

use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'              => 'wt',
    'VERSION_FROM'      => 'lib/wt.pm', # finds $VERSION
);

