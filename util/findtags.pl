#!/usr/bin/perl
use warnings;
use strict;

# my $topdirname = '/Users/kenburcham/code/odinweb/src/components/groups/service-settings/*';
my $topdirname = '/Users/kenburcham/code/odinweb/src/components/groups/*';

# opendir(DIR, $dirname) or die $!;
my %tags = ();
my %fields = ();

sub getTags {
   my ($dirname) = @_;
   # print("Dir: $dirname\n");
   my @files = <$dirname/*.js>;
   foreach my $filename (@files) {
      # print "  >> $filename\n";
      open(FH, '<', $filename) or die $!;

      while(<FH>){
         #errors
         # if(/alert(Success|Danger|Warning|Info|Primary)\(('|\")(.*)('|")\)/) {
         #    if(!exists($tags{$3})) {
         #       $tags{$3} = $3;
         #       print "\"$3\": \"$3\-ODIN\",\n";
         #    }
         # }

         #formFields
         # if(/UiFormField label=("|')(.*)("|')/) {
         #    if(!exists($fields{$2})) {
         #       $fields{$2} = $2;
         #       print "\"$2\": \"$2\-ODIN\",\n";
         #    }
         # }

         if(/UiListItem label=("|')(.*)("|')/) {
            if(!exists($fields{$2})) {
               $fields{$2} = $2;
               print "\"$2\": \"$2\-ODIN\",\n";
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