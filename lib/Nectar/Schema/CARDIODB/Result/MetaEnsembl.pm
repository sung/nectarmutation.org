use utf8;
package Nectar::Schema::CARDIODB::Result::MetaEnsembl;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::MetaEnsembl

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

=head1 TABLE: C<MetaEnsembls>

=cut

__PACKAGE__->table("MetaEnsembls");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 sample_id

  data_type: 'integer'
  is_nullable: 0

=head2 source

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=head2 snp_type

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 num

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 unique_variant

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "sample_id",
  { data_type => "integer", is_nullable => 0 },
  "source",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "snp_type",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "num",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "unique_variant",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
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

=item * L</source>

=item * L</snp_type>

=back

=cut

__PACKAGE__->add_unique_constraint("sample_id", ["sample_id", "source", "snp_type"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:VD47OFIOvkQLdBABrY2u0w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
