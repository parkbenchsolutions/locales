#!/usr/bin/perl
use warnings;
use strict;

# my $topdirname = '/Users/kenburcham/code/odinweb/src/components/groups/service-settings/*';
# my $topdirname = '/Users/kenburcham/code/odinweb/src/components/bulk/bulk-enterprise-clone';
# my $topdirname = '/Users/kenburcham/code/odinweb/src/components/bulk';
# my $topdirname = '/Users/kenburcham/code/odinweb/src/components/audits/*';
# my $topdirname = '/Users/kenburcham/code/odinweb/src/components/system/*';
# my $topdirname = '/Users/kenburcham/code/odinweb/src/components/autoAttendant/*';
my $topdirname = '/Users/kenburcham/code/odinweb/src/components/branding';
# my $topdirname = '/Users/kenburcham/code/odinweb/src/components/call-processing-policy/*';
# my $topdirname = '/Users/kenburcham/code/odinweb/src/components/departments/*';
# my $topdirname = '/Users/kenburcham/code/odinweb/src/components/events/*';
# my $topdirname = '/Users/kenburcham/code/odinweb/src/components/exports/*';
# my $topdirname = '/Users/kenburcham/code/odinweb/src/components/*';
# my $topdirname = '/Users/kenburcham/code/odinweb/src/components/service-provider';
# my $topdirname = '/Users/kenburcham/code/odinweb/src/components/users';
# my $topdirname = '/Users/kenburcham/code/odinweb/src/components/groups';
# my $topdirname = '/Users/kenburcham/code/odinweb/src/components/*';

# opendir(DIR, $dirname) or die $!;
my %errors = ();
my %group = ();
my %common = ();


sub getTags {
   my ($dirname) = @_;
   print("Dir: $dirname\n");
   my @files = <$dirname/*.js>;
   foreach my $filename (@files) {
      print "  >> $filename\n";
      open(FH, '<', $filename) or die $!;
      local $/;
      $_ = <FH>;
      close(FH);

      # alerts
      # while (/alert(Success|Danger|Warning|Info|Primary)\(('|\")(.*)('|")\)/g) {
      #    $errors{$3} = $3;
      # }

      # # UiFormField labels
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
      #placeholder="No Service Provider Selected"
      # while (/\s*placeholder\s?=\s?("|'|{`)(.*)("|'|`})/g) {
      #    $common{$2} = $2;
      # }

      ####################


      # # captures the label in the columns-like arrays of objects
      # while (/{?\s*key:\s?'(.*)',\s?\n?\s*label:\s?("|'|{`)(.*?)("|'|`})/g) {
      #    $group{$3} = $3;
      # }
      #
      # # captures the label in the UiTabs (also in specific namespace like 'group'
      while (/<div\s*label\s*=\s*{t\(('|")(.*)('|")\)}>/g) {
         $group{$2} = $2;
      }
      #
      # # <p>{t(' paragraphs that have translate
      # while (/<p>\n?.*\{t\(("|'|{`)(.*?)("|'|`}).*\n?<\/p>/g) {
      #    $group{$2} = $2;
      # }
      #
      # #naked wrapped strings (radio buttons, etc.)
            # while (/\{t\(("|')(.*?)("|')\)\}/g) {
            # while (/t\(("|')(.*?)("|')\)/g) {
      # while (/^\s*{t\(('|")(.*?)('|")/gm) {
      #    $group{$2} = $2;
      # }


      #
      #label: 'Session Admission'
      # while (/^\s*label\s?:\s*'(.*?)'/gm) {
      #    $group{$1} = $1;
      # }

      #other things to do

      # &nbsp; {t('Leave Blank')}
      # <b>{t('Please enter number or ranges on separate line')}</b>
      # return Promise.resolve(t('Phone is added'))
      # <span> {t('Archive')}</span>

      ## done
      # <Breadcrumb.Item>{t('Create Auto Attendant')}</Breadcrumb.Item>
      # while (/<Breadcrumb\.Item>{t\('(.*?)'/g) {
      #    $common{$1} = $1;
      # }



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