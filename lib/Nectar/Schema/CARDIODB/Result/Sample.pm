use utf8;
package Nectar::Schema::CARDIODB::Result::Sample;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::Sample

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

=head1 TABLE: C<Samples>

=cut

__PACKAGE__->table("Samples");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 run_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 run_name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 pool_name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 sample_name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 bru_code

  data_type: 'char'
  is_nullable: 0
  size: 9

=head2 target_id

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 diag_code

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 barcode

  data_type: 'varchar'
  default_value: 1
  is_nullable: 0
  size: 50

=head2 old_sample_name

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "run_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "run_name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "pool_name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "sample_name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "bru_code",
  { data_type => "char", is_nullable => 0, size => 9 },
  "target_id",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "diag_code",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "barcode",
  { data_type => "varchar", default_value => 1, is_nullable => 0, size => 50 },
  "old_sample_name",
  { data_type => "varchar", is_nullable => 1, size => 100 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<barcode>

=over 4

=item * L</run_name>

=item * L</pool_name>

=item * L</barcode>

=back

=cut

__PACKAGE__->add_unique_constraint("barcode", ["run_name", "pool_name", "barcode"]);

=head2 C<run_name>

=over 4

=item * L</run_name>

=item * L</sample_name>

=back

=cut

__PACKAGE__->add_unique_constraint("run_name", ["run_name", "sample_name", "target_id"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:S8B4EYmcm4eK13MEL1YMIw

__PACKAGE__->might_have('MetaSamples', 'Nectar::Schema::CARDIODB::Result::MetaSample', {'foreign.sample_id'=>'self.id'}); # might_have => left join
__PACKAGE__->might_have('MergedSamples', 'Nectar::Schema::CARDIODB::Result::MergedSample', {'foreign.sid'=>'self.id'}); # might_have => left join
__PACKAGE__->has_one('EnrichmentReports', 'Nectar::Schema::CARDIODB::Result::EnrichmentReport', {'foreign.sample_id'=>'self.id'}); # has_one => join
__PACKAGE__->has_many('MetaEnsembls', 'Nectar::Schema::CARDIODB::Result::MetaEnsembl', {'foreign.sample_id'=>'self.id'}); # has_many => left join
__PACKAGE__->has_many('TargetGenes', 'Nectar::Schema::CARDIODB::Result::TargetGene', {'foreign.target_id'=>'self.target_id'});
__PACKAGE__->belongs_to('Runs', 'Nectar::Schema::CARDIODB::Result::Run', {'foreign.id'=>'self.run_id'}); # belongs_to => join
__PACKAGE__->belongs_to('Targets', 'Nectar::Schema::CARDIODB::Result::Target', {'foreign.target_id'=>'self.target_id'});
__PACKAGE__->has_many('Diseases', 'Nectar::Schema::CARDIODB::Result::Disease', {'foreign.diag_code'=>'self.diag_code'});  # coerce left-join this to display 'NULL' diag_code

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
