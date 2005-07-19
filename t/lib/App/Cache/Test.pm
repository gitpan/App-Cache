package App::Cache::Test;
use strict;
use App::Cache;
use Path::Class qw();
use Storable qw(nstore retrieve);
use Test::More;
use base qw( Class::Accessor::Chained::Fast );
__PACKAGE__->mk_accessors(qw());

sub file {
  my $self = shift;
  my $cache = App::Cache->new;
  isa_ok($cache, 'App::Cache');
  is($cache->application, 'App::Cache::Test');
  like($cache->directory, qr/app_cache_test/);

  $cache->delete('test');
  my $data = $cache->get('test');
  is($data, undef);

  $cache->set('test', 'one');
  $data = $cache->get('test');
  is($data, 'one');

  $cache->clear;
  $data = $cache->get('test');
  is($data, undef);

  $cache->set('test', { foo => 'bar' });
  $data = $cache->get('test');
  is_deeply($data, { foo => 'bar' });

  $cache->ttl(1);
  sleep 2;
  $data = $cache->get('test');
  is($data, undef);
}

sub code {
  my $self = shift;
  my $cache = App::Cache->new({ttl => 1});
  my $data = $cache->get_code("code", sub { $self->onetwothree() });
  is_deeply($data, [1, 2, 3]);
  $data = $cache->get_code("code", sub { $self->onetwothree() });
  is_deeply($data, [1, 2, 3]);
  sleep 2;
  $data = $cache->get_code("code", sub { $self->onetwothree() });
  is_deeply($data, [1, 2, 3]);
}

sub onetwothree {
  my $self = shift;
  return [1, 2, 3];
}

sub url {
  my $self = shift;
  my $cache = App::Cache->new({ttl => 1});
  my $orig = $cache->get_url("http://www.google.com/ncr");
  like($orig, qr{I'm Feeling Lucky});
  my $html = $cache->get_url("http://www.google.com/ncr");
  is($html, $orig);
  sleep 2;
  $html = $cache->get_url("http://www.google.com/ncr");
  is($html, $orig);
}

sub scratch {
  my $self = shift;
  my $cache = App::Cache->new({ttl => 1});
  my $scratch = $cache->scratch;
  foreach my $i (1..10) {
    my $filename = Path::Class::File->new($scratch, "$i.dat");
    nstore({ i => $i }, "$filename") || die "Error writing to $filename: $!";
  }
  foreach my $i (1..10) {
    my $filename = Path::Class::File->new($scratch, "$i.dat");
    is(retrieve("$filename")->{i}, $i);
  }
  $cache->clear;
  foreach my $i (1..10) {
    my $filename = Path::Class::File->new($scratch, "$i.dat");
    ok(!-f $filename);
  }
}

1;
