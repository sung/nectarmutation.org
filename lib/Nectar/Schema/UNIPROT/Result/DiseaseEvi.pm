use utf8;
package Nectar::Schema::UNIPROT::Result::DiseaseEvi;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::UNIPROT::Result::DiseaseEvi

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

=head1 TABLE: C<diseaseEvi>

=cut

__PACKAGE__->table("diseaseEvi");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 acc

  data_type: 'char'
  is_nullable: 0
  size: 12

=head2 evidence

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "acc",
  { data_type => "char", is_nullable => 0, size => 12 },
  "evidence",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=item * L</evidence>

=back

=cut

__PACKAGE__->set_primary_key("id", "evidence");


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-07-20 16:20:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qYMq5e0GTk7GOKccZVhG5Q

__PACKAGE__->might_have('Evidences', 'Nectar::Schema::UNIPROT::Result::Evidence', {'foreign.evidence'=>'self.evidence', 'foreign.acc'=>'self.acc'}); #has_many =>left join

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
