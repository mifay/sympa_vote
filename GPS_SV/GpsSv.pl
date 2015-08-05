use strict;
use warnings;

open LecteurDeFichier,"<.\\input.kml" or die "E/S : $!\n";
open RedacteurDeFichier,">.\\output.txt" or die $!;

my $IsParsingSections = 0;
my $SectionCourante = "";

while (my $Ligne = <LecteurDeFichier>)
{
   if($Ligne =~ /^\t\t\t<name>Sections de vote<\/name>$/)
   {
      $IsParsingSections = 1;
   } 
   elsif($IsParsingSections eq 1 and $Ligne =~ /^\t\t\t\t<name>(.+)<\/name>$/)
   {
      $SectionCourante = $1;
   }  
   elsif($IsParsingSections eq 1 and $Ligne =~ /^\t\t\t\t\t\t\t\t(.+)$/)
   {
      print RedacteurDeFichier "$SectionCourante,\t\t\t\t\t\t\t\t\t$1\n"
   }      
}

close LecteurDeFichier;
close RedacteurDeFichier;