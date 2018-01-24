use utf8;
package Nectar::Schema::CARDIODB::Result::Cgsample;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::Cgsample

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

=head1 TABLE: C<CGSamples>

=cut

__PACKAGE__->table("CGSamples");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 cg_sample_name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 bru_code

  data_type: 'char'
  is_nullable: 0
  size: 9

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "cg_sample_name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "bru_code",
  { data_type => "char", is_nullable => 0, size => 9 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<bru_code>

=over 4

=item * L</bru_code>

=back

=cut

__PACKAGE__->add_unique_constraint("bru_code", ["bru_code"]);

=head2 C<cg_sample_name>

=over 4

=item * L</cg_sample_name>

=back

=cut

__PACKAGE__->add_unique_constraint("cg_sample_name", ["cg_sample_name"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:tePMMNEYqtap/WJyQTw3tQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
