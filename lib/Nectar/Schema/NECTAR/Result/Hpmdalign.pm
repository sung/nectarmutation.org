use utf8;
package Nectar::Schema::NECTAR::Result::Hpmdalign;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::NECTAR::Result::Hpmdalign

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

=head1 TABLE: C<HPMDAligns>

=cut

__PACKAGE__->table("HPMDAligns");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 align_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 hpmd_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 hsp_id

  data_type: 'integer'
  extra: {unsigned => 1}
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
  "align_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "hpmd_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "hsp_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<align_id>

=over 4

=item * L</align_id>

=item * L</hpmd_id>

=item * L</hsp_id>

=back

=cut

__PACKAGE__->add_unique_constraint("align_id", ["align_id", "hpmd_id", "hsp_id"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-12-17 14:00:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Byu8coKZJYEEqJNMuGFH7A

__PACKAGE__->has_one('Alignments', 'Nectar::Schema::NECTAR::Result::Alignment', {'foreign.id'=>'self.align_id'}); 
__PACKAGE__->has_many('HPMDs', 'Nectar::Schema::NECTAR::Result::Hpmd', {'foreign.id'=>'self.hpmd_id'}); 
__PACKAGE__->has_many('HSPs', 'Nectar::Schema::NECTAR::Result::Hsp', {'foreign.id'=>'self.hsp_id'}); 

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
