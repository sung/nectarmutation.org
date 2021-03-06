use utf8;
package Nectar::Schema::NECTAR_DEVEL::Result::NewsOld;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::NECTAR_DEVEL::Result::NewsOld

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

=head1 TABLE: C<News_old>

=cut

__PACKAGE__->table("News_old");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 content

  data_type: 'text'
  is_nullable: 0

=head2 link

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 issued

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 summary

  data_type: 'varchar'
  is_nullable: 1
  size: 700

=head2 tags

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "title",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "content",
  { data_type => "text", is_nullable => 0 },
  "link",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "issued",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "summary",
  { data_type => "varchar", is_nullable => 1, size => 700 },
  "tags",
  { data_type => "varchar", is_nullable => 1, size => 100 },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-10-28 11:14:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:uPpq8+UuMsxge9NAnwmL9A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
