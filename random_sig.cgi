#! /usr/bin/perl
#
# Read a random signature from ~/pim/signatures and print it as a blockquote.
# If query string == "style=plain" then return text/plain instead.

$HOME = '/home/jmenard';
open(SIGS, "$HOME/pim/signatures") || exit(0);

$plain = ($ENV{'QUERY_STRING'} eq 'style=plain');

while (<SIGS>) {
    last if $_ eq "\n";
#    next if /^\#/;
    $header .= $_;
}
$count = 0;
while (<SIGS>) {
#    next if /^\#/;
    if ($_ eq "\n") { ++$count; }
    else { $sig[$count] .= $_;}
}
close(SIGS);
++$count;

srand();
@signature = split("\n", $sig[int(rand($count))]);

# header
if ($plain) {
  print "Content-type: text/plain\n\n";
}
else {
  print "Content-type: text/html\n\n";
  print "<blockquote>\n";
}

# body
foreach (@signature) {
  print($_) if $plain;
  print(html_safe($_) . "<br />") unless $plain;
  print "\n";
}

#footer
unless ($plain) {
  print "</blockquote>\n";
}
exit(0);

sub html_safe {
    $str = shift;

    $str =~ s/&/&amp;/g;
    $str =~ s/</&lt;/g;
    $str =~ s/>/&gt;/g;
    $str =~ s/"/&quot;/g;
    return $str;
}
