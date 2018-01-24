use utf8;
package Nectar::Schema::CARDIODB::Result::GatksMsformat;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::GatksMsformat

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

=head1 TABLE: C<GATKsMSformat>

=cut

__PACKAGE__->table("GATKsMSformat");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 group_name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 gid

  data_type: 'integer'
  is_nullable: 0

=head2 sample_name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 gt

  data_type: 'enum'
  extra: {list => ["1/1","0/1","1/0","0/0"]}
  is_nullable: 1

=head2 ad

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 f_dp

  data_type: 'integer'
  is_nullable: 1

=head2 gq

  data_type: 'float'
  is_nullable: 1
  size: [5,2]

=head2 pl

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "group_name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "gid",
  { data_type => "integer", is_nullable => 0 },
  "sample_name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "gt",
  {
    data_type => "enum",
    extra => { list => ["1/1", "0/1", "1/0", "0/0"] },
    is_nullable => 1,
  },
  "ad",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "f_dp",
  { data_type => "integer", is_nullable => 1 },
  "gq",
  { data_type => "float", is_nullable => 1, size => [5, 2] },
  "pl",
  { data_type => "varchar", is_nullable => 1, size => 200 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:237Bimo+IKcNZKeSIAGb1g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
