use utf8;
package Nectar::Schema::CARDIODB::Result::Target;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::Target

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

=head1 TABLE: C<Targets>

=cut

__PACKAGE__->table("Targets");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 target_id

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 target_name

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 designer

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 bed_file

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 des

  data_type: 'varchar'
  is_nullable: 1
  size: 1000

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "target_id",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "target_name",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "designer",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "bed_file",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "des",
  { data_type => "varchar", is_nullable => 1, size => 1000 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<elid>

=over 4

=item * L</target_id>

=back

=cut

__PACKAGE__->add_unique_constraint("elid", ["target_id"]);

=head2 C<target>

=over 4

=item * L</target_name>

=back

=cut

__PACKAGE__->add_unique_constraint("target", ["target_name"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:h4HVZFS6HrSfU6YBs7f/iQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
