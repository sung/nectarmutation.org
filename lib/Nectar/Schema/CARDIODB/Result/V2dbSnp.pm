use utf8;
package Nectar::Schema::CARDIODB::Result::V2dbSnp;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::V2dbSnp

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

=head1 TABLE: C<V2dbSNPs>

=cut

__PACKAGE__->table("V2dbSNPs");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 uid

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 rs_id

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 allele_string

  data_type: 'mediumtext'
  is_nullable: 1

=head2 ambi_code

  data_type: 'char'
  is_nullable: 1
  size: 1

=head2 minor_allele

  data_type: 'char'
  is_nullable: 1
  size: 1

=head2 ancestral_allele

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 mac

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 maf

  data_type: 'float'
  is_nullable: 1

=head2 validation

  data_type: 'tinytext'
  is_nullable: 1

=head2 clinical_significance

  data_type: 'varchar'
  is_nullable: 1
  size: 500

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "uid",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "rs_id",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "allele_string",
  { data_type => "mediumtext", is_nullable => 1 },
  "ambi_code",
  { data_type => "char", is_nullable => 1, size => 1 },
  "minor_allele",
  { data_type => "char", is_nullable => 1, size => 1 },
  "ancestral_allele",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "mac",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "maf",
  { data_type => "float", is_nullable => 1 },
  "validation",
  { data_type => "tinytext", is_nullable => 1 },
  "clinical_significance",
  { data_type => "varchar", is_nullable => 1, size => 500 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<uid>

=over 4

=item * L</uid>

=item * L</rs_id>

=back

=cut

__PACKAGE__->add_unique_constraint("uid", ["uid", "rs_id"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:kmHPHFQWTBv5KbwXKecv7w

__PACKAGE__->has_many('V2Phens', 'Nectar::Schema::CARDIODB::Result::V2Phen', {'foreign.rs_id'=>'self.rs_id', 'foreign.uid'=>'self.uid'});

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
