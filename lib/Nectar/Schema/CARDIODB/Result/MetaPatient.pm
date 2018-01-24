use utf8;
package Nectar::Schema::CARDIODB::Result::MetaPatient;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::MetaPatient

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

=head1 TABLE: C<MetaPatients>

=cut

__PACKAGE__->table("MetaPatients");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 bru_code

  data_type: 'char'
  is_nullable: 0
  size: 9

=head2 diag_code

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=head2 cnt_unique_gene

  data_type: 'integer'
  is_nullable: 0

=head2 cnt_unique_run

  data_type: 'integer'
  is_nullable: 0

=head2 cnt_unique_sample

  data_type: 'integer'
  is_nullable: 0

=head2 cnt_unique_call

  data_type: 'integer'
  is_nullable: 0

=head2 cnt_call

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "bru_code",
  { data_type => "char", is_nullable => 0, size => 9 },
  "diag_code",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "cnt_unique_gene",
  { data_type => "integer", is_nullable => 0 },
  "cnt_unique_run",
  { data_type => "integer", is_nullable => 0 },
  "cnt_unique_sample",
  { data_type => "integer", is_nullable => 0 },
  "cnt_unique_call",
  { data_type => "integer", is_nullable => 0 },
  "cnt_call",
  { data_type => "integer", is_nullable => 0 },
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

=item * L</diag_code>

=back

=cut

__PACKAGE__->add_unique_constraint("bru_code", ["bru_code", "diag_code"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:yPclaDfTAohqxIt6HcUdng

__PACKAGE__->has_many('Samples', 'Nectar::Schema::CARDIODB::Result::Sample', {'foreign.bru_code'=>'self.bru_code'}); # has_many => left join
__PACKAGE__->belongs_to('Diseases', 'Nectar::Schema::CARDIODB::Result::Disease', {'foreign.diag_code'=>'self.diag_code'}); # belongs_to => join

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
