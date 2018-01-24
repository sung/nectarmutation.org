use utf8;
package Nectar::Schema::COSMIC::Result::CosmicLite;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::COSMIC::Result::CosmicLite

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

=head1 TABLE: C<CosmicLite>

=cut

__PACKAGE__->table("CosmicLite");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 mutation_id

  data_type: 'integer'
  is_nullable: 0

=head2 uniprot

  data_type: 'char'
  is_nullable: 0
  size: 6

=head2 position

  data_type: 'integer'
  is_nullable: 1

=head2 wt

  data_type: 'char'
  is_nullable: 1
  size: 1

=head2 mut

  data_type: 'char'
  is_nullable: 1
  size: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "mutation_id",
  { data_type => "integer", is_nullable => 0 },
  "uniprot",
  { data_type => "char", is_nullable => 0, size => 6 },
  "position",
  { data_type => "integer", is_nullable => 1 },
  "wt",
  { data_type => "char", is_nullable => 1, size => 1 },
  "mut",
  { data_type => "char", is_nullable => 1, size => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-02-20 17:01:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TrRrmvrVnmY+nCqIc3nSkg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
