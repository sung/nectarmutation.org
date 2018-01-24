use utf8;
package Nectar::Schema::NECTAR_DEVEL::Result::Stat;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::NECTAR_DEVEL::Result::Stat

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

=head1 TABLE: C<Stats>

=cut

__PACKAGE__->table("Stats");

=head1 ACCESSORS

=head2 fid

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 cnt_gene

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 cnt_sap

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 cnt_nectar_sap

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 cnt_nectar_var

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "fid",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "cnt_gene",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "cnt_sap",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "cnt_nectar_sap",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "cnt_nectar_var",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</fid>

=back

=cut

__PACKAGE__->set_primary_key("fid");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-10-28 11:14:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:gD03ZAScUl2jbqdgaHh/3g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
