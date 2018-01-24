use utf8;
package Nectar::Schema::CARDIODB::Result::EnMsa;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::EnMsa

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

=head1 TABLE: C<EnMSAs>

=cut

__PACKAGE__->table("EnMSAs");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 fam_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 mem_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 res

  data_type: 'enum'
  extra: {list => ["A","C","D","E","F","G","H","I","J","K","L","M","N","P","Q","R","S","T","V","W","Y","X","*","-"]}
  is_nullable: 1

=head2 aln_pos

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 res_num

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "fam_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "mem_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "res",
  {
    data_type => "enum",
    extra => {
      list => ["A", "C" .. "N", "P" .. "T", "V", "W", "Y", "X", "*", "-"],
    },
    is_nullable => 1,
  },
  "aln_pos",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "res_num",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<mem_id>

=over 4

=item * L</mem_id>

=item * L</aln_pos>

=back

=cut

__PACKAGE__->add_unique_constraint("mem_id", ["mem_id", "aln_pos"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:roEjx69B4vl9LL+7sVRy2g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
