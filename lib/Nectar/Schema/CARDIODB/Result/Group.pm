use utf8;
package Nectar::Schema::CARDIODB::Result::Group;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::Group

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

=head1 TABLE: C<Groups>

=cut

__PACKAGE__->table("Groups");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 group_name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 sample_name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 bru_code

  data_type: 'char'
  is_nullable: 0
  size: 9

=head2 is_family

  data_type: 'enum'
  extra: {list => [0,1]}
  is_nullable: 1

=head2 comment

  data_type: 'tinytext'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "group_name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "sample_name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "bru_code",
  { data_type => "char", is_nullable => 0, size => 9 },
  "is_family",
  { data_type => "enum", extra => { list => [0, 1] }, is_nullable => 1 },
  "comment",
  { data_type => "tinytext", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<group_name>

=over 4

=item * L</group_name>

=item * L</sample_name>

=back

=cut

__PACKAGE__->add_unique_constraint("group_name", ["group_name", "sample_name"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:x5h7xrMMoNvtkbexf0Acyw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
