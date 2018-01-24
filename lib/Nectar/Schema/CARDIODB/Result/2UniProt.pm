use utf8;
package Nectar::Schema::CARDIODB::Result::2UniProt;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::2UniProt

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

=head1 TABLE: C<2UniProts>

=cut

__PACKAGE__->table("2UniProts");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 uid

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 vid

  data_type: 'integer'
  is_nullable: 0

=head2 p_ref

  data_type: 'varchar'
  is_nullable: 1
  size: 500

=head2 p_mut

  data_type: 'varchar'
  is_nullable: 1
  size: 500

=head2 ft_id

  data_type: 'integer'
  is_nullable: 0

=head2 uniprot

  data_type: 'char'
  is_nullable: 0
  size: 6

=head2 res_num

  data_type: 'integer'
  is_nullable: 0

=head2 uniprot_res

  data_type: 'char'
  is_nullable: 0
  size: 1

=head2 annotation

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 des

  data_type: 'tinytext'
  is_nullable: 1

=head2 blosum62

  data_type: 'integer'
  is_nullable: 1

=head2 pam70

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "uid",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "vid",
  { data_type => "integer", is_nullable => 0 },
  "p_ref",
  { data_type => "varchar", is_nullable => 1, size => 500 },
  "p_mut",
  { data_type => "varchar", is_nullable => 1, size => 500 },
  "ft_id",
  { data_type => "integer", is_nullable => 0 },
  "uniprot",
  { data_type => "char", is_nullable => 0, size => 6 },
  "res_num",
  { data_type => "integer", is_nullable => 0 },
  "uniprot_res",
  { data_type => "char", is_nullable => 0, size => 1 },
  "annotation",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "des",
  { data_type => "tinytext", is_nullable => 1 },
  "blosum62",
  { data_type => "integer", is_nullable => 1 },
  "pam70",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<vid>

=over 4

=item * L</vid>

=item * L</ft_id>

=item * L</uniprot>

=item * L</res_num>

=back

=cut

__PACKAGE__->add_unique_constraint("vid", ["vid", "ft_id", "uniprot", "res_num"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:N34bWUfZaPYJOAIM0vQA/g

__PACKAGE__->belongs_to('V2Ensembls', 'Nectar::Schema::CARDIODB::Result::V2Ensembl', {'foreign.id'=>'self.vid'}); #belongs_to => join

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
