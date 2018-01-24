use utf8;
package Nectar::Schema::CARDIODB::Result::V2Freq;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::V2Freq

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

=head1 TABLE: C<V2Freqs>

=cut

__PACKAGE__->table("V2Freqs");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 uid

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 rs_id

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 allele

  data_type: 'mediumtext'
  is_nullable: 1

=head2 frequency

  data_type: 'float'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 count

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 pop_id

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
  "uid",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "rs_id",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "allele",
  { data_type => "mediumtext", is_nullable => 1 },
  "frequency",
  { data_type => "float", extra => { unsigned => 1 }, is_nullable => 1 },
  "count",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "pop_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<uid>

=over 4

=item * L</uid>

=item * L</rs_id>

=item * L</allele>

=item * L</pop_id>

=back

=cut

__PACKAGE__->add_unique_constraint("uid", ["uid", "rs_id", "allele", "pop_id"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:C+R+SKHhhx2XgIYLaokpWg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
