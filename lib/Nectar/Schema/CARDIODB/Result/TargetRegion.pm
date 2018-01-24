use utf8;
package Nectar::Schema::CARDIODB::Result::TargetRegion;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::TargetRegion

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

=head1 TABLE: C<TargetRegions>

=cut

__PACKAGE__->table("TargetRegions");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 target_id

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 chr

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 g_start

  data_type: 'integer'
  is_nullable: 0

=head2 g_end

  data_type: 'integer'
  is_nullable: 0

=head2 hgnc

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 ensg

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 strand

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "target_id",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "chr",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "g_start",
  { data_type => "integer", is_nullable => 0 },
  "g_end",
  { data_type => "integer", is_nullable => 0 },
  "hgnc",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "ensg",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "strand",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7SzN4jJES1Zeh157P8GjBA

__PACKAGE__->has_one('Targets', 'Nectar::Schema::CARDIODB::Result::Target', {'foreign.target_id'=>'self.target_id'}); # has_one => join

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
