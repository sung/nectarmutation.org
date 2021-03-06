use utf8;
package Nectar::Schema::UNIPROT::Result::Feature;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::UNIPROT::Result::Feature

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

=head1 TABLE: C<feature>

=cut

__PACKAGE__->table("feature");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 acc

  data_type: 'char'
  default_value: (empty string)
  is_nullable: 0
  size: 12

=head2 start

  data_type: 'integer'
  is_nullable: 1

=head2 end

  data_type: 'integer'
  is_nullable: 1

=head2 featurevariant

  data_type: 'integer'
  is_nullable: 1

=head2 featureclass

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 featuretype

  data_type: 'integer'
  is_nullable: 1

=head2 featureid

  data_type: 'integer'
  is_nullable: 1

=head2 featureevi

  data_type: 'integer'
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
  "acc",
  { data_type => "char", default_value => "", is_nullable => 0, size => 12 },
  "start",
  { data_type => "integer", is_nullable => 1 },
  "end",
  { data_type => "integer", is_nullable => 1 },
  "featurevariant",
  { data_type => "integer", is_nullable => 1 },
  "featureclass",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "featuretype",
  { data_type => "integer", is_nullable => 1 },
  "featureid",
  { data_type => "integer", is_nullable => 1 },
  "featureevi",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-07-20 16:20:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:LQ8z2+N+80G5M7gS9QYgXg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
