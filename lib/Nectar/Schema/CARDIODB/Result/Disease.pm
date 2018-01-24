use utf8;
package Nectar::Schema::CARDIODB::Result::Disease;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::Disease

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

=head1 TABLE: C<Diseases>

=cut

__PACKAGE__->table("Diseases");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 diag_code

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 des

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
  "diag_code",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "des",
  { data_type => "varchar", is_nullable => 1, size => 500 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<diag_code>

=over 4

=item * L</diag_code>

=back

=cut

__PACKAGE__->add_unique_constraint("diag_code", ["diag_code"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:235IrZJbEtDBRImkhbSNkA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
