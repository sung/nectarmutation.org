use utf8;
package Nectar::Schema::NECTAR::Result::Source;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::NECTAR::Result::Source

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

=head1 TABLE: C<Sources>

=cut

__PACKAGE__->table("Sources");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 source 

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 ver

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 updated

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "source",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "ver",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "updated",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head2 C<ver>

=over 4

=item * L</caller>

=item * L</ver>

=back

=cut

__PACKAGE__->add_unique_constraint("ver", ["source", "ver"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:42GmvyV78Ga/Ep4eXVSYlg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
