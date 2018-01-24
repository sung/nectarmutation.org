use utf8;
package Nectar::Schema::CARDIODB::Result::EnEntropy;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::EnEntropy

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

=head1 TABLE: C<EnEntropies>

=cut

__PACKAGE__->table("EnEntropies");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 fam_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 aln_pos

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 gap_freq

  data_type: 'float'
  is_nullable: 0
  size: [4,3]

=head2 entropy

  data_type: 'float'
  is_nullable: 0
  size: [4,3]

=head2 rel_entropy

  data_type: 'float'
  is_nullable: 0
  size: [4,3]

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "fam_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "aln_pos",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "gap_freq",
  { data_type => "float", is_nullable => 0, size => [4, 3] },
  "entropy",
  { data_type => "float", is_nullable => 0, size => [4, 3] },
  "rel_entropy",
  { data_type => "float", is_nullable => 0, size => [4, 3] },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<fam_id>

=over 4

=item * L</fam_id>

=item * L</aln_pos>

=back

=cut

__PACKAGE__->add_unique_constraint("fam_id", ["fam_id", "aln_pos"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:CBzun7NTFftcc6rBYy8xlQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
