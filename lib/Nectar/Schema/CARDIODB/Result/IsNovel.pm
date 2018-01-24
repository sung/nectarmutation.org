use utf8;
package Nectar::Schema::CARDIODB::Result::IsNovel;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::IsNovel

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

=head1 TABLE: C<IsNovels>

=cut

__PACKAGE__->table("IsNovels");

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

=head2 acc_num

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=head2 tag

  data_type: 'enum'
  extra: {list => ["DP","FP","DFP","DM","FTV"]}
  is_nullable: 1

=head2 rs_id

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 mut_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 humsavar

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=head2 var_type

  data_type: 'enum'
  extra: {list => ["Disease","Polymorphism","Unclassified"]}
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
  "uid",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "acc_num",
  { data_type => "varchar", is_nullable => 1, size => 10 },
  "tag",
  {
    data_type => "enum",
    extra => { list => ["DP", "FP", "DFP", "DM", "FTV"] },
    is_nullable => 1,
  },
  "rs_id",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "mut_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "humsavar",
  { data_type => "varchar", is_nullable => 1, size => 10 },
  "var_type",
  {
    data_type => "enum",
    extra => { list => ["Disease", "Polymorphism", "Unclassified"] },
    is_nullable => 1,
  },
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

=item * L</acc_num>

=item * L</rs_id>

=item * L</mut_id>

=item * L</humsavar>

=back

=cut

__PACKAGE__->add_unique_constraint("uid", ["uid", "acc_num", "rs_id", "mut_id", "humsavar"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:77ziKL5lEQruqLsfXWwQtg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
