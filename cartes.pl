#!/usr/bin/perl

# Copyright 2015 Michael Fayad
#
# This file is part of sympa_vote.
#
# This file is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This file is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this file.  If not, see <http://www.gnu.org/licenses/>.

use strict;
use warnings;

open LecteurDeFichier,"<input2014.txt" or die "E/S : $!\n";
open LecteurKmlHead,"<KmlHead.txt" or die "E/S : $!\n";
open LecteurKmlStyles,"<./Styles/PQKmlStyles.txt" or die "E/S : $!\n";
open LecteurKmlFoot,"<KmlFoot.txt" or die "E/S : $!\n";
open RedacteurKML,">output.kml" or die $!;
open RedacteurDeFichier,">output.txt" or die $!;

while (my $Ligne = <LecteurKmlHead>)
{
   print RedacteurKML "$Ligne";
}

while (my $Ligne = <LecteurKmlStyles>)
{
   print RedacteurKML "$Ligne";
}

# Styles KML
my $Pourcentage0a4    = "pourcentage0a4_principal";
my $Pourcentage5a9    = "pourcentage5a9_principal";
my $Pourcentage10a14  = "pourcentage10a14_principal";
my $Pourcentage15a19  = "pourcentage15a19_principal";
my $Pourcentage20a24  = "pourcentage20a24_principal";
my $Pourcentage25a29  = "pourcentage25a29_principal";
my $Pourcentage30a34  = "pourcentage30a34_principal";
my $Pourcentage35a39  = "pourcentage35a39_principal";
my $Pourcentage40plus = "pourcentage40plus_principal";

my $PqVoteIdx = 0;
my $PlqVoteIdx = 4;
my $PcqVoteIdx = 6;
my $QsVoteIdx = 5;
my $OnVoteIdx = 1;
my $PmVoteIdx = 2;
my $PvVoteIdx = 3;

my $PourcentageVotesPQ = 0;
my $PourcentageVotesPLQ = 0;
my $PourcentageVotesCAQ = 0;
my $PourcentageVotesQS = 0;
my $PourcentageVotesON = 0;
my $PourcentageVotesPM = 0;
my $PourcentageVotesPV = 0;
my $PourcentageVotesPCQ = 0;
my $PourcentageVotesAbst = 0;

while (my $Ligne = <LecteurDeFichier>)
{
   if($Ligne =~ /al, v;\d+;;(\d+);(\d+);(\d+);(\d+);(\d+);(\d+);(\d+);(\d+);(\d+);(\d+);\d+;/)
   {
      my @VoteArr = ($3,$4,$5,$6,$7,$8,$9);
      my $SectionId = $1;
      my $TotalVotes = $10;
      my $NbElecteursInscrits = $2;
      
      if($2 ne 0)
      {      
         $PourcentageVotesPQ = $VoteArr[$PqVoteIdx]/$2;
         $PourcentageVotesPLQ = $VoteArr[$PlqVoteIdx]/$2;
         $PourcentageVotesCAQ = 0;
         $PourcentageVotesQS = $VoteArr[$QsVoteIdx]/$2;
         $PourcentageVotesON = $VoteArr[$OnVoteIdx]/$2;
         $PourcentageVotesPM = $VoteArr[$PmVoteIdx]/$2;
         $PourcentageVotesPV = $VoteArr[$PvVoteIdx]/$2;
         $PourcentageVotesPCQ = $VoteArr[$PcqVoteIdx]/$2;
         $PourcentageVotesAbst = ($2-$10)/$2;
      }
      else
      {
         $PourcentageVotesPQ = 0;
         $PourcentageVotesPLQ = 0;
         $PourcentageVotesCAQ = 0;
         $PourcentageVotesQS = 0;
         $PourcentageVotesON = 0;
         $PourcentageVotesPM = 0; 
         $PourcentageVotesPV = 0;
         $PourcentageVotesPCQ =0;
         $PourcentageVotesAbst = 0;
      }
      
      my $PourcentageVotes = $PourcentageVotesPQ;  

      open LecteurGPS,"<GpsSv.txt" or die "E/S : $!\n";
      
      while (my $Ligne = <LecteurGPS>)
      {
         if($Ligne =~ /^$SectionId,\t\t\t\t\t\t\t\t\t(.+)$/)
         {
            my $StyleToUse = $Pourcentage0a4;
            if ($PourcentageVotes < 0.03)
            {
               $StyleToUse = $Pourcentage0a4;
            }
            elsif ($PourcentageVotes < 0.07)
            {
               $StyleToUse = $Pourcentage5a9;
            }                  
            elsif ($PourcentageVotes < 0.12)
            {
               $StyleToUse = $Pourcentage10a14;
            }     
            elsif ($PourcentageVotes < 0.18)
            {
               $StyleToUse = $Pourcentage15a19;
            }     
            elsif ($PourcentageVotes < 0.24)
            {
               $StyleToUse = $Pourcentage20a24;
            }     
            elsif ($PourcentageVotes < 0.29)
            {
               $StyleToUse = $Pourcentage25a29;
            }     
            elsif ($PourcentageVotes < 0.33)
            {
               $StyleToUse = $Pourcentage30a34;
            }     
            else
            {
               $StyleToUse = $Pourcentage40plus;
            }                       
            
            my $PourcentageVotesStrPq = sprintf("%.3f", $PourcentageVotesPQ);
            my $PourcentageVotesStrPlq = sprintf("%.3f", $PourcentageVotesPLQ);
            my $PourcentageVotesStrCaq = sprintf("%.3f", $PourcentageVotesCAQ);
            my $PourcentageVotesStrQs = sprintf("%.3f", $PourcentageVotesQS);
            my $PourcentageVotesStrOn = sprintf("%.3f", $PourcentageVotesON);
            my $PourcentageVotesStrPm = sprintf("%.3f", $PourcentageVotesPM);
            my $PourcentageVotesStrPv = sprintf("%.3f", $PourcentageVotesPV);
            my $PourcentageVotesStrPcq = sprintf("%.3f", $PourcentageVotesPCQ);
            my $PourcentageVotesStrAbst = sprintf("%.3f", $PourcentageVotesAbst);
            
            print RedacteurKML "\t<Placemark><name>$SectionId</name><description>$PourcentageVotesStrPq pour le PQ\n$PourcentageVotesStrPlq pour le PLQ\n$PourcentageVotesStrCaq pour la CAQ\n$PourcentageVotesStrQs pour QS\n$PourcentageVotesStrOn pour ON\n$PourcentageVotesStrPm pour le PM\n$PourcentageVotesStrPv pour le PVQ\n$PourcentageVotesStrPcq pour le PCQ\n$PourcentageVotesStrAbst abstentions</description><styleUrl>#$StyleToUse</styleUrl><Polygon><tessellate>1</tessellate><outerBoundaryIs><LinearRing><coordinates>$1</coordinates></LinearRing></outerBoundaryIs></Polygon></Placemark>\n";
         }
      }
      
      $SectionId++;
      
      close LecteurGPS;
      print RedacteurDeFichier "$SectionId,$PourcentageVotes\n";
   }
}

while (my $Ligne = <LecteurKmlFoot>)
{
   print RedacteurKML "$Ligne";
}

close LecteurKmlHead;
close LecteurKmlStyles;
close LecteurKmlFoot;
close RedacteurKML;
close LecteurDeFichier;
close RedacteurDeFichier;
