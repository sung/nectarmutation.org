use utf8;
package Nectar::Schema::CARDIODB::Result::Cgmastervar;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::Cgmastervar

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

=head1 TABLE: C<CGmastervars>

=cut

__PACKAGE__->table("CGmastervars");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 sample_id

  data_type: 'integer'
  is_nullable: 0

=head2 locus

  data_type: 'integer'
  is_nullable: 0

=head2 zygosity

  data_type: 'char'
  is_nullable: 0
  size: 10

=head2 var_type

  data_type: 'char'
  is_nullable: 0
  size: 10

=head2 reference

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 genotype1

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 genotype2

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 allele1_dp

  data_type: 'integer'
  is_nullable: 1

=head2 allele2_dp

  data_type: 'integer'
  is_nullable: 1

=head2 total_dp

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "sample_id",
  { data_type => "integer", is_nullable => 0 },
  "locus",
  { data_type => "integer", is_nullable => 0 },
  "zygosity",
  { data_type => "char", is_nullable => 0, size => 10 },
  "var_type",
  { data_type => "char", is_nullable => 0, size => 10 },
  "reference",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "genotype1",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "genotype2",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "allele1_dp",
  { data_type => "integer", is_nullable => 1 },
  "allele2_dp",
  { data_type => "integer", is_nullable => 1 },
  "total_dp",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<sample_id>

=over 4

=item * L</sample_id>

=item * L</locus>

=back

=cut

__PACKAGE__->add_unique_constraint("sample_id", ["sample_id", "locus"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6PTcAxNGe3TWmjGXeOyY8w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
