use utf8;
package Nectar::Schema::NECTAR_DEVEL::Result::Hpmdalign;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::NECTAR_DEVEL::Result::Hpmdalign

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

=head1 TABLE: C<HPMDAligns>

=cut

__PACKAGE__->table("HPMDAligns");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 align_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 hpmd_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 hsp_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "align_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "hpmd_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "hsp_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<align_id>

=over 4

=item * L</align_id>

=item * L</hpmd_id>

=item * L</hsp_id>

=back

=cut

__PACKAGE__->add_unique_constraint("align_id", ["align_id", "hpmd_id", "hsp_id"]);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-10-28 11:14:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0K0OyGMp5ayD/WZh4XQKlg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
