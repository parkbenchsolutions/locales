#!/usr/bin/perl
use warnings;
use strict;

# my $topdirname = '/Users/kenburcham/code/odinweb/src/components/groups/service-settings/*';
my $topdirname = '/Users/kenburcham/code/odinweb/src/components/groups/*';

# opendir(DIR, $dirname) or die $!;
my %errors = ();
my %fields = ();
my %group = ();
my %common = ();


sub getTags {
   my ($dirname) = @_;
   # print("Dir: $dirname\n");
   my @files = <$dirname/*.js>;
   foreach my $filename (@files) {
      # print "  >> $filename\n";
      open(FH, '<', $filename) or die $!;

      while(<FH>){
         # alerts
         # if(/alert(Success|Danger|Warning|Info|Primary)\(('|\")(.*)('|")\)/) {
         #    if(!exists($errors{$3})) {
         #       $errors{$3} = $3;
         #       print "\"$3\": \"$3\-ODIN\",\n";
         #    }
         # }

         # UiFormFields
         # if(/UiFormField\n?\s*label=("|')(.*)("|')/) {
         #    if(!exists($fields{$2})) {
         #       $fields{$2} = $2;
         #       print "\"$2\": \"$2\-ODIN\",\n";
         #    }
         # }

         # UiListItems
         # if(/UiListItem\n?\s*label=("|')(.*)("|')/) {
         #    if(!exists($common{$2})) {
         #       $common{$2} = $2;
         #       print "\"$2\": \"$2\-ODIN\",\n";
         #    }
         # }

         # titles
         # if(/title\s?=\s?("|')(.*)("|')/) {
         #    if(!exists($common{$2})) {
         #       $common{$2} = $2;
         #       print "\"$2\": \"$2\-ODIN\",\n";
         #    }
         # }

         # titles with tics - but you'll likely have to delete a bunch
         if(/title\s?=\s?{`(.*)`}/) {
            if(!exists($common{$1})) {
               $common{$1} = $1;
               print "\"$1\": \"$1\-ODIN\",\n";
            }
         }

         # captures the label in the columns-like arrays of objects
         # if(/{?\s*key:\s?'(.*)',\s?\n?\s*label:\s?'(.*)'/) {
         #    if(!exists($group{$2})) {
         #       $group{$2} = $2;
         #       print "\"$2\": \"$2\-ODIN\",\n";
         #    }
         # }

         # captures the label in the UiTabs (also in specific namespace like 'group'
         # if(/<div\s*label\s*=\s*{t\(('|")(.*)('|")\)}>/) {
         #    if(!exists($group{$2})) {
         #       $group{$2} = $2;
         #       print "\"$2\": \"$2\-ODIN\",\n";
         #    }
         # }

         # <p>{t(' paragraphs that have translate
         # if(/<p>\n?.*\{t\(('|")(.*)('|").*\n?<\/p>/) {
         #    if(!exists($group{$2})) {
         #       $group{$2} = $2;
         #       print "\"$2\": \"$2\-ODIN\",\n";
         #    }
         # }

         #naked wrapped strings
         # if(/{t\(('|")(.*)('|")\)}/) {
         #    if(!exists($group{$2})) {
         #       $group{$2} = $2;
         #       print "\"$2\": \"$2\-ODIN\",\n";
         #    }
         # }

      }
      close(FH);
   }
   my @dirs = grep { -d } glob $dirname."/*";
   foreach my $dir (@dirs) {
      getTags($dir)
   }

}

getTags($topdirname)