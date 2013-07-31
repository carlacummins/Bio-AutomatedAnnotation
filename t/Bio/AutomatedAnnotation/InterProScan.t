#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use Cwd;
use File::Slurp;

BEGIN { unshift( @INC, './lib' ) }

BEGIN {
    use Test::Most;
    use_ok('Bio::AutomatedAnnotation::InterProScan');
}

my $obj;
my $cwd = getcwd();

ok($obj = Bio::AutomatedAnnotation::InterProScan->new(
  input_file   => $cwd.'/t/data/input_proteins.faa',
  exec             => $cwd.'/t/bin/dummy_interproscan',
),'Initialise object');
ok($obj->annotate, 'run a mocked interproscan');

ok($obj = Bio::AutomatedAnnotation::InterProScan->new(
  input_file   => $cwd.'/t/data/input_proteins.faa',
  exec             => $cwd.'/t/bin/dummy_interproscan',
  _protein_files_per_cpu => 2,
),'Initialise object creating 2 protein files per iteration');

ok(my $file_names = $obj->_create_a_number_of_protein_files(2), 'create files');
is(read_file($file_names->[0]),read_file('t/data/interpro.seq'), 'first protein the same');
is(read_file($file_names->[1]),read_file('t/data/interpro2.seq'), '2nd protein the same');
ok($file_names->[0] =~ /0.seq$/, 'file name as expected');
ok($file_names->[1] =~ /1.seq$/, 'file name as expected');

ok($file_names = $obj->_create_a_number_of_protein_files(2), 'create files');
is(read_file($file_names->[0]),read_file('t/data/interpro3.seq'), '3rd protein the same');
is(read_file($file_names->[1]),read_file('t/data/interpro4.seq'), '4th protein the same');
ok($file_names->[0] =~ /0.seq$/, 'file name as expected');
ok($file_names->[1] =~ /1.seq$/, 'file name as expected');

done_testing();
