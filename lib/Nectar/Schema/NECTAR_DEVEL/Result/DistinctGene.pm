use utf8;
package Nectar::Schema::NECTAR_DEVEL::Result::DistinctGene;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::NECTAR_DEVEL::Result::DistinctGene - VIEW

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

=head1 TABLE: C<DistinctGenes>

=cut

__PACKAGE__->table("DistinctGenes");

=head1 ACCESSORS

=head2 hgnc

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 lrg

  data_type: 'varchar'
  is_nullable: 1
  size: 341

=cut

__PACKAGE__->add_columns(
  "hgnc",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "lrg",
  { data_type => "varchar", is_nullable => 1, size => 341 },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-10-28 11:14:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FzuvjgkhTmk3vxuZutwZ1w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
