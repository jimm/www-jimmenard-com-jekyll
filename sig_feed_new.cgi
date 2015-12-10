#! /usr/bin/perl
# -*- perl -*-
#
# Read a random signature from ~/pim/signatures and print it as a blockquote.

use POSIX qw(strftime);

$HOME = '/home/jmenard';
$SIGFILE = "$HOME/pim/signatures";
open(SIGS, $SIGFILE) || exit(0);

($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
 $atime,$mtime,$ctime,$blksize,$blocks)
    = stat($SIGFILE);
$t = strftime("%e %a %Y %H:%M:%S -0000", gmtime($mtime));

print "Content-type: text/plain\n\n";
print <<EOF;
<!DOCTYPE rss PUBLIC "-//Netscape Communications//DTD RSS 0.91//EN" "http://my.netscape.com/publish/formats/rss-0.91.dtd">
<rss version="0.91">
<channel>
<title>Jim Menard&apos;s Signatures</title>
<link>http://www.jimmenard.com/sigs.html</link>
<description>Jim Menard&apos;s signature collection</description>
<language>en-us</language>
<webMaster>jim@jimmenard.com</webMaster>
<managingEditor>jim@jimmenard.com (Jim Menard)</managingEditor>
<pubDate>$t</pubDate>
<lastBuildDate>$t</lastBuildDate>
EOF

while (<SIGS>) {
    last if $_ eq "\n";
#    next if /^\#/;
    $first_line .= $_;		# ignored
}
$count = 0;
while (<SIGS>) {
#    next if /^\#/;
    if ($_ eq "\n") { ++$count; }
    else { $sig[$count] .= $_; }
}
close(SIGS);
++$count;

# body
$count = 1;
foreach (@sig) {
  print "<item>\n";
  print "<title><![CDATA[Jim Menard, jim@jimmenard.com, jim.menard@gmail.com\n$_]]></title>\n";
  print "<description>Signature $count</description>\n";
  print "</item>\n";
  ++$count;
}

#footer
print <<EOF;
</channel>
</rss>
EOF
exit(0);
