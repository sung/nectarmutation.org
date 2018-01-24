use utf8;
package Nectar::Schema::NECTAR::Result::UnifiedCall;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::NECTAR::Result::UnifiedCall

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

=head1 TABLE: C<_UnifiedCalls>

=cut

__PACKAGE__->table("_UnifiedCalls");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 chr

  data_type: 'varchar'
  is_nullable: 0
  size: 5

=head2 v_start

  data_type: 'integer'
  is_nullable: 0

=head2 v_end

  data_type: 'integer'
  is_nullable: 0

=head2 reference

  data_type: 'varchar'
  is_nullable: 0
  size: 1000

=head2 genotype

  data_type: 'varchar'
  is_nullable: 0
  size: 1000

=head2 in_ensembl

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "chr",
  { data_type => "varchar", is_nullable => 0, size => 5 },
  "v_start",
  { data_type => "integer", is_nullable => 0 },
  "v_end",
  { data_type => "integer", is_nullable => 0 },
  "reference",
  { data_type => "varchar", is_nullable => 0, size => 1000 },
  "genotype",
  { data_type => "varchar", is_nullable => 0, size => 1000 },
  "in_ensembl",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<loci>

=over 4

=item * L</chr>

=item * L</v_start>

=item * L</v_end>

=item * L</reference>

=item * L</genotype>

=back

=cut

__PACKAGE__->add_unique_constraint("loci", ["chr", "v_start", "v_end", "reference", "genotype"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-12-17 14:00:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KuXolefKStJwmC02vOoC7A

 __PACKAGE__->has_many('inSilicoSNVs', 'Nectar::Schema::NECTAR::Result::InSilicoSnv', {'foreign.chr'=>'self.chr', 'foreign.v_start'=>'self.v_start', 'foreign.v_end'=>'self.v_end', 'foreign.reference'=>'self.reference', 'foreign.genotype'=>'self.genotype'}); # has_many => left join

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
