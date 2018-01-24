use utf8;
package Nectar::Schema::CARDIODB::Result::Run;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::Run

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

=head1 TABLE: C<Runs>

=cut

__PACKAGE__->table("Runs");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 run_name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 created

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=head2 platform

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 mask

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 is_multiplex

  data_type: 'enum'
  default_value: 'TRUE'
  extra: {list => ["TRUE","FALSE","N/A"]}
  is_nullable: 1

=head2 run_type

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 primer_info

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 des

  data_type: 'text'
  is_nullable: 1

=head2 extra

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "run_name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "created",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 0 },
  "platform",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "mask",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "is_multiplex",
  {
    data_type => "enum",
    default_value => "TRUE",
    extra => { list => ["TRUE", "FALSE", "N/A"] },
    is_nullable => 1,
  },
  "run_type",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "primer_info",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "des",
  { data_type => "text", is_nullable => 1 },
  "extra",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<run_name>

=over 4

=item * L</run_name>

=back

=cut

__PACKAGE__->add_unique_constraint("run_name", ["run_name"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:g7QFGHHfzJgDzo5yC+GtPw

__PACKAGE__->has_many('Samples', 'Nectar::Schema::CARDIODB::Result::Sample', {'foreign.run_id'=>'self.id'});

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
