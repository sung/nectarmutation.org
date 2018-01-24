use utf8;
package Nectar::Schema::CARDIODB::Result::ClassifiedCall;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::ClassifiedCall

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

=head1 TABLE: C<ClassifiedCalls>

=cut

__PACKAGE__->table("ClassifiedCalls");

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

=head2 vid

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 which_level

  data_type: 'enum'
  extra: {list => ["a","b","c","d"]}
  is_nullable: 0

=head2 is_c1

  data_type: 'integer'
  is_nullable: 0

=head2 is_c2

  data_type: 'integer'
  is_nullable: 0

=head2 is_c3

  data_type: 'integer'
  is_nullable: 0

=head2 category

  data_type: 'char'
  is_nullable: 0
  size: 2

=head2 is_novel

  data_type: 'integer'
  is_nullable: 0

=head2 class

  data_type: 'char'
  is_nullable: 0
  size: 3

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
  "vid",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "which_level",
  {
    data_type => "enum",
    extra => { list => ["a" .. "d"] },
    is_nullable => 0,
  },
  "is_c1",
  { data_type => "integer", is_nullable => 0 },
  "is_c2",
  { data_type => "integer", is_nullable => 0 },
  "is_c3",
  { data_type => "integer", is_nullable => 0 },
  "category",
  { data_type => "char", is_nullable => 0, size => 2 },
  "is_novel",
  { data_type => "integer", is_nullable => 0 },
  "class",
  { data_type => "char", is_nullable => 0, size => 3 },
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

=item * L</vid>

=back

=cut

__PACKAGE__->add_unique_constraint("uid", ["uid", "vid"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:eyqk/txFieq6redA3dthSQ

 __PACKAGE__->belongs_to('V2Ensembls', 'Nectar::Schema::CARDIODB::Result::V2Ensembl', {'foreign.id'=>'self.vid'}); # has_many => left join

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
