package Variable::Disposition;
# ABSTRACT: dispose of variables
use strict;
use warnings;

use parent qw(Exporter);

our $VERSION = '0.001';

=head1 NAME

Variable::Disposition - helper functions for disposing of variables

=head1 SYNOPSIS

 use feature qw(say);
 use Variable::Disposition;
 my $x = [];
 dispose $x;
 say '$x is no longer defined';

=head1 DESCRIPTION

Provides some basic helper functions for making sure variables go away
when you want them to.

Currently only includes L</dispose>, and exports this by default. Other
functions for use with L<Future> and L<IO::Async> are likely to be added
later.

=cut

our @EXPORT = our @EXPORT_OK = qw(dispose);

use Scalar::Util ();

=head1 METHODS

=cut

=head2 dispose

Undefines the given variable, then checks that the original ref was destroyed.

 my $x = [1,2,3];
 dispose $x;
 # $x is no longer defined.

This is primarily intended for cases where you no longer need a variable, and want
to ensure that you haven't accidentally captured a strong reference to it elsewhere.

=cut

sub dispose($) {
	die "Variable not defined" unless defined $_[0];
	die "Variable was not a ref" unless ref $_[0];
	Scalar::Util::weaken(my $copy = $_[0]);
	undef $_[0];
	die "Variable was not released" if defined $copy;
}

1;

__END__

=head1 SEE ALSO

=over 4

=item * L<Devel::Refcount> - assert_oneref is almost identical to this, although it doesn't clear the variable it's called on

=item * L<Closure::Explicit> - provides a sub{} wrapper that will complain if you capture a lexical without explicitly declaring that you're going to do that.

=back

=head1 AUTHOR

Tom Molesworth <cpan@perlsite.co.uk>

=head1 LICENSE

Copyright Tom Molesworth 2014. Licensed under the same terms as Perl itself.

