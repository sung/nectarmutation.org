use utf8;
package Nectar::Schema::NECTAR::Result::Hsp;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::NECTAR::Result::Hsp

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

=head1 TABLE: C<HSPs>

=cut

__PACKAGE__->table("HSPs");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 query

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 q_start

  data_type: 'integer'
  is_nullable: 1

=head2 q_end

  data_type: 'integer'
  is_nullable: 1

=head2 hit

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 h_start

  data_type: 'integer'
  is_nullable: 1

=head2 h_end

  data_type: 'integer'
  is_nullable: 1

=head2 hsp_index

  data_type: 'integer'
  is_nullable: 0

=head2 aln_len

  data_type: 'integer'
  is_nullable: 0

=head2 gaps

  data_type: 'integer'
  is_nullable: 0

=head2 evalue

  data_type: 'double precision'
  is_nullable: 0

=head2 pid

  data_type: 'float'
  is_nullable: 0
  size: [5,2]

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "query",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "q_start",
  { data_type => "integer", is_nullable => 1 },
  "q_end",
  { data_type => "integer", is_nullable => 1 },
  "hit",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "h_start",
  { data_type => "integer", is_nullable => 1 },
  "h_end",
  { data_type => "integer", is_nullable => 1 },
  "hsp_index",
  { data_type => "integer", is_nullable => 0 },
  "aln_len",
  { data_type => "integer", is_nullable => 0 },
  "gaps",
  { data_type => "integer", is_nullable => 0 },
  "evalue",
  { data_type => "double precision", is_nullable => 0 },
  "pid",
  { data_type => "float", is_nullable => 0, size => [5, 2] },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<hsp>

=over 4

=item * L</query>

=item * L</hit>

=item * L</hsp_index>

=back

=cut

__PACKAGE__->add_unique_constraint("hsp", ["query", "hit", "hsp_index"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-12-17 14:00:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Hgom/w1nLtDsHQrj3NbCRw

__PACKAGE__->has_many('Alignments', 'Nectar::Schema::NECTAR::Result::Alignment', {'foreign.query'=>'self.query', 'foreign.hit'=>'self.hit', 'foreign.hsp_index'=>'self.hsp_index'}); 

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
