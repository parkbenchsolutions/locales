#!/usr/bin/perl
use warnings;
use strict;

# my $filename = '/Users/kenburcham/code/odinweb/src/components/groups/service-settings/group-series-completion.js';
my $topdirname = '/Users/kenburcham/code/odinweb/src/components/*';

# opendir(DIR, $dirname) or die $!;
my %tags = ();

sub getTags {
   my ($dirname) = @_;
   # print("Dir: $dirname\n");
   my @files = <$dirname/*.js>;
   foreach my $filename (@files) {
      # print "  >> $filename\n";
      open(FH, '<', $filename) or die $!;

      while(<FH>){
         if(/alert(Success|Danger|Warning|Info|Primary)\(('|\")(.*)('|")\)/) {
            if(!exists($tags{$3})) {
               $tags{$3} = $3;
               print "\"$3\": \"$3\-ODIN\",\n";
            }
         }
      }
      close(FH);
   }
   my @dirs = grep { -d } glob $dirname."/*";
   foreach my $dir (@dirs) {
      getTags($dir)
   }

}

getTags($topdirname)