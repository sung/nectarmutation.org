use utf8;
package Nectar::Schema::CARDIODB::Result::MetaSample;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::MetaSample

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

=head1 TABLE: C<MetaSamples>

=cut

__PACKAGE__->table("MetaSamples");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 sample_id

  data_type: 'integer'
  is_nullable: 0

=head2 cnt_unique_call

  data_type: 'integer'
  is_nullable: 0

=head2 dibayes

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 indels

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 gatks

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 samtools

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 cg

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "sample_id",
  { data_type => "integer", is_nullable => 0 },
  "cnt_unique_call",
  { data_type => "integer", is_nullable => 0 },
  "dibayes",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "indels",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "gatks",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "samtools",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "cg",
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

=back

=cut

__PACKAGE__->add_unique_constraint("sample_id", ["sample_id"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NCatXZCUTtADadpeB0VTPg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
