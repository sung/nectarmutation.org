use utf8;
package Nectar::Schema::CARDIODB::Result::Caller;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::Caller

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

=head1 TABLE: C<Callers>

=cut

__PACKAGE__->table("Callers");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 caller

  data_type: 'enum'
  extra: {list => ["Ensembl","GATK","LifeScope","Samtools","TorrentSuite"]}
  is_nullable: 0

=head2 ver

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 is_current

  data_type: 'integer'
  is_nullable: 0

=head2 config

  data_type: 'text'
  is_nullable: 1

=head2 updated

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "caller",
  {
    data_type => "enum",
    extra => {
      list => ["Ensembl", "GATK", "LifeScope", "Samtools", "TorrentSuite", "cgatools", "UniProt", "COSMIC", "HGMD"],
    },
    is_nullable => 0,
  },
  "ver",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "is_current",
  { data_type => "integer", is_nullable => 0 },
  "config",
  { data_type => "text", is_nullable => 1 },
  "updated",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<current>

=over 4

=item * L</caller>

=item * L</ver>

=item * L</is_current>

=back

=cut

__PACKAGE__->add_unique_constraint("current", ["caller", "ver", "is_current"]);

=head2 C<ver>

=over 4

=item * L</caller>

=item * L</ver>

=back

=cut

__PACKAGE__->add_unique_constraint("ver", ["caller", "ver"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:42GmvyV78Ga/Ep4eXVSYlg

__PACKAGE__->has_many('Sample2Callers', 'Nectar::Schema::CARDIODB::Result::Sample2Caller', {'foreign.caller_id'=>'self.id'});

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
