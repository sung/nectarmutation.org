use utf8;
package Nectar::Schema::CARDIODB::Result::MetaCall;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::MetaCall

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

=head1 TABLE: C<_MetaCalls>

=cut

__PACKAGE__->table("_MetaCalls");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 sample_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 uid

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 dibayes

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 dp_dibayes

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 smallindel

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 gatk

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 dp_gatk

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 samtool

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 dp_samtool

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 cg

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 dp_cg

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "sample_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "uid",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "dibayes",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "dp_dibayes",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "smallindel",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "gatk",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "dp_gatk",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "samtool",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "dp_samtool",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "cg",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "dp_cg",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<sample_var>

=over 4

=item * L</sample_id>

=item * L</uid>

=back

=cut

__PACKAGE__->add_unique_constraint("sample_var", ["sample_id", "uid"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dxfdBsgkjR3xC86BwMOPIQ

__PACKAGE__->belongs_to('Samples', 'Nectar::Schema::CARDIODB::Result::Sample', {'foreign.id'=>'self.sample_id'});
__PACKAGE__->belongs_to('_UnifiedCalls', 'Nectar::Schema::CARDIODB::Result::UnifiedCall', {'foreign.id'=>'self.uid'});
__PACKAGE__->belongs_to('ClassifiedCalls', 'Nectar::Schema::CARDIODB::Result::ClassifiedCall', {'foreign.uid'=>'self.uid'});
 __PACKAGE__->belongs_to('IsNovel', 'Nectar::Schema::CARDIODB::Result::IsNovel', {'foreign.uid'=>'self.uid'});

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
