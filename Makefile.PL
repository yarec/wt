#!/usr/bin/perl

use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'              => 'wt',
    'VERSION_FROM'      => 'pl/wt.pl', # finds $VERSION
    'PREREQ_PM'         => {
		    'YAML' =>'',
		    'LWP::UserAgent' =>'',
		    'Log::Log4perl'=>'',
		    'DBI' =>'',
		    'JSON::Tiny' =>'',
		    'Expect' =>'',
		    'IO::Stty' =>'',
		    'Getopt::Long::Descriptive' =>'',
    },
);
