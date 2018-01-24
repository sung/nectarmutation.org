use utf8;
package Nectar::Schema::UNIPROT::Result::DistinctDisease;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::UNIPROT::Result::DistinctDisease - VIEW

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=item * L<DBIx::Class::TimeStamp>

=item * L<DBIx::Class::PassphraseColumn>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "PassphraseColumn");

=head1 TABLE: C<DistinctDiseases>

=cut

__PACKAGE__->table("DistinctDiseases");

=head1 ACCESSORS

=head2 gene

  data_type: 'varchar'
  is_nullable: 0 
  size: 50

=head2 lrg 

  data_type: 'varchar'
  is_nullable: 1 
  size: 50

=cut

__PACKAGE__->add_columns(
  "disease",
  { data_type => "tinytext", is_nullable => 0},
  "disease_abr",
  { data_type => "varchar", is_nullable => 1, size => 300 },
);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-12-17 14:00:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:CXmFsUardeqOcv/d19vlQA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
