use utf8;
package Nectar::Schema::NECTAR_DEVEL::Result::Alignment;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::NECTAR_DEVEL::Result::Alignment

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

=item * L<DBIx::Class::TimeStamp>

=item * L<DBIx::Class::PassphraseColumn>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "PassphraseColumn");

=head1 TABLE: C<Alignments>

=cut

__PACKAGE__->table("Alignments");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 query

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 q_index

  data_type: 'integer'
  is_nullable: 1

=head2 q_res

  data_type: 'char'
  is_nullable: 0
  size: 1

=head2 hit

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 h_index

  data_type: 'integer'
  is_nullable: 1

=head2 h_res

  data_type: 'char'
  is_nullable: 1
  size: 1

=head2 hsp_index

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "query",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "q_index",
  { data_type => "integer", is_nullable => 1 },
  "q_res",
  { data_type => "char", is_nullable => 0, size => 1 },
  "hit",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "h_index",
  { data_type => "integer", is_nullable => 1 },
  "h_res",
  { data_type => "char", is_nullable => 1, size => 1 },
  "hsp_index",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-10-28 11:14:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:23k99PNapWy5KpJ1cCEGZw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
