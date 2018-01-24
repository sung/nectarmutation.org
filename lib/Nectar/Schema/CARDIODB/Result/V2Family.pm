use utf8;
package Nectar::Schema::CARDIODB::Result::V2Family;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::V2Family

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

=head1 TABLE: C<V2Families>

=cut

__PACKAGE__->table("V2Families");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 vid

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 mem_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 fam_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

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
  "vid",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "mem_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "fam_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
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

=head2 C<v2fam>

=over 4

=item * L</vid>

=item * L</fam_id>

=item * L</aln_pos>

=back

=cut

__PACKAGE__->add_unique_constraint("v2fam", ["vid", "fam_id", "aln_pos"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0GyBUj9SOUgNc0U31rTyZw

__PACKAGE__->belongs_to('EnFamilies', 'Nectar::Schema::CARDIODB::Result::EnFamily', {'foreign.id'=>'self.fam_id'});
__PACKAGE__->belongs_to('EnMembers', 'Nectar::Schema::CARDIODB::Result::EnMember', {'foreign.id'=>'self.mem_id'});
__PACKAGE__->belongs_to('EnEntropies', 'Nectar::Schema::CARDIODB::Result::EnEntropy', {'foreign.fam_id'=>'self.fam_id', 'foreign.aln_pos'=>'self.aln_pos'});

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
