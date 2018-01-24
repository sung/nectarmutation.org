use utf8;
package Nectar::Schema::CARDIODB::Result::MetaSite;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::MetaSite

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

=head1 TABLE: C<MetaSites>

=cut

__PACKAGE__->table("MetaSites");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 site_name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 cnt_unique_run

  data_type: 'integer'
  is_nullable: 0

=head2 cnt_unique_sample

  data_type: 'integer'
  is_nullable: 0

=head2 cnt_unique_bru

  data_type: 'integer'
  is_nullable: 0

=head2 cnt_unique_call

  data_type: 'integer'
  is_nullable: 0

=head2 cnt_call

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "site_name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "cnt_unique_run",
  { data_type => "integer", is_nullable => 0 },
  "cnt_unique_sample",
  { data_type => "integer", is_nullable => 0 },
  "cnt_unique_bru",
  { data_type => "integer", is_nullable => 0 },
  "cnt_unique_call",
  { data_type => "integer", is_nullable => 0 },
  "cnt_call",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<site_name>

=over 4

=item * L</site_name>

=back

=cut

__PACKAGE__->add_unique_constraint("site_name", ["site_name"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XXKKE33P10KRhnX4ZjpXkQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
