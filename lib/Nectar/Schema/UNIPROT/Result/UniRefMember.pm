use utf8;
package Nectar::Schema::UNIPROT::Result::UniRefMember;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::UNIPROT::Result::UniRefMember

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

=head1 TABLE: C<uniRefMember>

=cut

__PACKAGE__->table("uniRefMember");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 uniref_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 member_acc

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 uniprot_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 is_rep

  data_type: 'integer'
  is_nullable: 0

=head2 is_up

  data_type: 'integer'
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
  "uniref_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "member_acc",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "uniprot_acc",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "is_rep",
  { data_type => "integer", is_nullable => 0 },
  "is_up",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<member_acc>

=over 4

=item * L</member_acc>

=back

=cut

__PACKAGE__->add_unique_constraint("member_acc", ["member_acc"]);

=head2 C<uniref_id>

=over 4

=item * L</uniref_id>

=item * L</is_rep>

=back

=cut

__PACKAGE__->add_unique_constraint("uniref_id", ["uniref_id", "is_rep"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-07-20 16:20:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JmzJk58xX/AXtXzVQPDJ+w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
