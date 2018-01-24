use utf8;
package Nectar::Schema::CARDIODB::Result::EnFamily;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::EnFamily

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

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<EnFamilies>

=cut

__PACKAGE__->table("EnFamilies");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 fam_name

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=head2 des

  data_type: 'tinytext'
  is_nullable: 1

=head2 des_score

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 mem_cnt

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "fam_name",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "des",
  { data_type => "tinytext", is_nullable => 1 },
  "des_score",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "mem_cnt",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<fam_name>

=over 4

=item * L</fam_name>

=back

=cut

__PACKAGE__->add_unique_constraint("fam_name", ["fam_name"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:M2nTrEw4hKVr6kYmh28paQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
