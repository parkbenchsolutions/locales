#!/usr/bin/perl
use warnings;
use strict;

# my $topdirname = '/Users/kenburcham/code/odinweb/src/components/groups/service-settings/*';
my $topdirname = '/Users/kenburcham/code/odinweb/src/components/groups/*';

# opendir(DIR, $dirname) or die $!;
my %errors = ();
my %group = ();
my %common = ();


sub getTags {
   my ($dirname) = @_;
   # print("Dir: $dirname\n");
   my @files = <$dirname/*.js>;
   foreach my $filename (@files) {
      # print "  >> $filename\n";
      open(FH, '<', $filename) or die $!;
      local $/;
      $_ = <FH>;
      close(FH);

      # alerts
      # while (/alert(Success|Danger|Warning|Info|Primary)\(('|\")(.*)('|")\)/g) {
      #    $errors{$3} = $3;
      # }

      # # # UiFormField labels
      # while (/UiFormField(.*?)label\s?=\s?("|'|{`)(.*?)("|'|`})/gs) {
      #    $common{$3} = $3;
      # }
      # #
      # # # UiInputCheckbox labels
      # while (/<UiInputCheckbox(.*?)label\s?=\s?("|'|{`)(.*?)("|'|`})/gs) {
      #    $common{$3} = $3;
      # }
      # #
      # # # UiSections
      # while (/<UiSection(.*?)title\s?=\s?("|'|{`)(.*?)("|'|`})/gs) {
      #    $common{$3} = $3;
      # }
      # #
      # # # UiListItems
      # while (/<UiListItem(.*?)label\s?=\s?("|'|{`)(.*?)("|'|`})/gs) {
      #    $common{$3} = $3;
      # }
      # #
      # # # titles that were missed
      # while (/title\s?=\s?("|'|{`)(.*?)("|'|`})/g) {
      #    $common{$2} = $2;
      # }
      # #
      # # # labels on their own line so also missed
      # while (/^\s*label\s?=\s?("|'|{`)(.*)("|'|`})/g) {
      #    $common{$2} = $2;
      # }
      #
      # captures the label in the columns-like arrays of objects
      while (/{?\s*key:\s?'(.*)',\s?\n?\s*label:\s?("|'|{`)(.*?)("|'|`})/g) {
         $group{$2} = $2;
      }

      # captures the label in the UiTabs (also in specific namespace like 'group'
      while (/<div\s*label\s*=\s*{t\(('|")(.*)('|")\)}>/g) {
         $group{$2} = $2;
      }

      # <p>{t(' paragraphs that have translate
      while (/<p>\n?.*\{t\(("|'|{`)(.*?)("|'|`}).*\n?<\/p>/g) {
         $group{$2} = $2;
      }

      #naked wrapped strings
      while (/{t\(("|'|{`)(.*?)("|'|`})\)}/g) {
         $group{$2} = $2;
      }
      #



   }
   my @dirs = grep { -d } glob $dirname."/*";
   foreach my $dir (@dirs) {
      getTags($dir)
   }

}

getTags($topdirname);

print "--- COMMON ---\n";
foreach my $tag (keys %common) {
   print "\"$tag\": \"$tag\-ODIN\",\n";
}
print "--- END --- \n\n";

print "--- GROUP ---\n";
foreach my $tag (keys %group) {
   print "\"$tag\": \"$tag\-ODIN\",\n";
}
print "--- END --- \n\n";

print "--- ALERT ---\n";
foreach my $tag (keys %errors) {
   print "\"$tag\": \"$tag\-ODIN\",\n";
}
print "--- END --- \n\n";