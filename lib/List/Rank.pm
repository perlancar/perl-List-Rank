package List::Rank;

use strict;
use warnings;

use Exporter qw(import);

# AUTHORITY
# DATE
# DIST
# VERSION

our @EXPORT_OK = qw(rank rankstr rankby sortrank sortrankstr sortrankby);

sub rank(@) { ## no critic: Subroutines::ProhibitSubroutinePrototypes
    my @ary;
    my $i = 0;
    for (@_) { push @ary, [$_, $i++, undef] }
    @ary = sort { $a->[0] <=> $b->[0] } @ary;
    my $j = 1;
    for ($i=0; $i<@ary; $i++) {
        if ($i == 0) {
            $ary[$i][2] = $j;
        } else {
            if ($ary[$i-1][0] == $ary[$i][0]) {
                $ary[$i-1][2] = $ary[$i][2] = "$j=";
            } else {
                $j = $i+1;
                $ary[$i][2] = $j;
            }
        }
    }
    map { $_->[2] } sort { $a->[1] <=> $b->[1] } @ary;
}

sub rankstr(@) { ## no critic: Subroutines::ProhibitSubroutinePrototypes
    my @ary;
    my $i = 0;
    for (@_) { push @ary, [$_, $i++, undef] }
    @ary = sort { $a->[0] cmp $b->[0] } @ary;
    my $j = 1;
    for ($i=0; $i<@ary; $i++) {
        if ($i == 0) {
            $ary[$i][2] = $j;
        } else {
            if ($ary[$i-1][0] eq $ary[$i][0]) {
                $ary[$i-1][2] = $ary[$i][2] = "$j=";
            } else {
                $j = $i+1;
                $ary[$i][2] = $j;
            }
        }
    }
    map { $_->[2] } sort { $a->[1] <=> $b->[1] } @ary;
}

sub rankby(&;@) { ## no critic: Subroutines::ProhibitSubroutinePrototypes
    no strict 'refs'; ## no critic: TestingAndDebugging::ProhibitNoStrict

    my $cmp = shift;

    my $caller = caller();

    my @ary;
    my $i = 0;
    for (@_) { push @ary, [$_, $i++, undef] }
    @ary = sort {
        local ${"$caller\::a"} = $a->[0];
        local ${"$caller\::b"} = $b->[0];
        $cmp->();
    } @ary;
    my $j = 1;
    for ($i=0; $i<@ary; $i++) {
        if ($i == 0) {
            $ary[$i][2] = $j;
        } else {
            if (do {
                local ${"$caller\::a"} = $ary[$i-1][0];
                local ${"$caller\::b"} = $ary[$i][0];
                !$cmp->();
            }) {
                $ary[$i-1][2] = $ary[$i][2] = "$j=";
            } else {
                $j = $i+1;
                $ary[$i][2] = $j;
            }
        }
    }
    map { $_->[2] } sort { $a->[1] <=> $b->[1] } @ary;
}

sub sortrank(@) { ## no critic: Subroutines::ProhibitSubroutinePrototypes
    my @ary;
    my $i = 0;
    for (@_) { push @ary, [$_, $i++, undef] }
    @ary = sort { $a->[0] <=> $b->[0] } @ary;
    my $j = 1;
    for ($i=0; $i<@ary; $i++) {
        if ($i == 0) {
            $ary[$i][2] = $j;
        } else {
            if ($ary[$i-1][0] == $ary[$i][0]) {
                $ary[$i-1][2] = $ary[$i][2] = "$j=";
            } else {
                $j = $i+1;
                $ary[$i][2] = $j;
            }
        }
    }
    map { ($_->[0], $_->[2]) } @ary;
}

sub sortrankstr(@) { ## no critic: Subroutines::ProhibitSubroutinePrototypes
    my @ary;
    my $i = 0;
    for (@_) { push @ary, [$_, $i++, undef] }
    @ary = sort { $a->[0] cmp $b->[0] } @ary;
    my $j = 1;
    for ($i=0; $i<@ary; $i++) {
        if ($i == 0) {
            $ary[$i][2] = $j;
        } else {
            if ($ary[$i-1][0] eq $ary[$i][0]) {
                $ary[$i-1][2] = $ary[$i][2] = "$j=";
            } else {
                $j = $i+1;
                $ary[$i][2] = $j;
            }
        }
    }
    map { ($_->[0], $_->[2]) } @ary;
}

sub sortrankby(&;@) { ## no critic: Subroutines::ProhibitSubroutinePrototypes
    no strict 'refs'; ## no critic: TestingAndDebugging::ProhibitNoStrict

    my $cmp = shift;

    my $caller = caller();

    my @ary;
    my $i = 0;
    for (@_) { push @ary, [$_, $i++, undef] }
    @ary = sort {
        local ${"$caller\::a"} = $a->[0];
        local ${"$caller\::b"} = $b->[0];
        $cmp->();
    } @ary;
    my $j = 1;
    for ($i=0; $i<@ary; $i++) {
        if ($i == 0) {
            $ary[$i][2] = $j;
        } else {
            if (do {
                local ${"$caller\::a"} = $ary[$i-1][0];
                local ${"$caller\::b"} = $ary[$i][0];
                !$cmp->();
            }) {
                $ary[$i-1][2] = $ary[$i][2] = "$j=";
            } else {
                $j = $i+1;
                $ary[$i][2] = $j;
            }
        }
    }
    map { ($_->[0], $_->[2]) } @ary;
}

1;
# ABSTRACT: Ranking of list elements

=head1 SYNOPSIS

Return the ranks of the elements if sorted numerically (note that equal values
will be given equal ranks):

 my @ranks = rank 10, 30, 20, 20; # => 1, 4, "2=", "2="

Return the ranks of the elements if sorted ascibetically:

 my @ranks = rankstr "apricot", "cucumber", "banana", "banana"; # => 1,4,"2=","2="

Return the ranks of the elements if sorted by a custom sorter:

 my @ranks = rankby {length($a) <=> length($b)}
     "apricot", "cucumber", "banana", "banana"; # => 3, 4, "1=", "1="

Return the ranks of records (taken from L<Sort::Rank>'s Synopsis):

 my @ranks = rankby {$b->{score} <=> $a->{score}} (
     {   score   => 80,  name    => 'Andy'       },
     {   score   => 70,  name    => 'Chrissie'   },
     {   score   => 90,  name    => 'Alex'       },
     {   score   => 90,  name    => 'Rosie'      },
     {   score   => 80,  name    => 'Therese'    },
     {   score   => 10,  name    => 'Mac'        },
     {   score   => 10,  name    => 'Horton'     },
 ); # => ("3=", 5, "1=", "1=", "3=", "6=", "6=")

Sort the list numerically and return the elements as well as ranks in pairs:

 my @res = sortrank 10, 30, 20, 20; # => 10,1, 20,"2=", 20,"2=", 30,4

Sort the list ascibetically and return the elements as well as ranks in pairs:

 my @res = sortrankstr "apricot", "cucumber", "banana", "banana";
     # => "apricot",1, "banana","2=", "banana","2=", "cucumber",4

Sort the list by a custom sorter and return the elements as well as ranks in
pairs:

 my @res = sortrankby {length($a) <=> length($b)} "apricot", "cucumber", "banana", "banana";
     # => "banana","1=", "banana","1=", "apricot",3, "cucumber",4


=head1 FUNCTIONS

=head2 rank

=head2 rankstr

=head2 rankby

=head2 sortrank

=head2 sortrankstr

=head2 sortrankby


=head1 SEE ALSO

L<Sort::Rank> also accomplishes the same thing, but by default it expects an
arrayref *of hashrefs* with key C<score> in each hashref. To process a list of
scalars, you need to supply a coderef to supply the scores. Another thing is,
the module does not provide a way to sort by a custom order.
