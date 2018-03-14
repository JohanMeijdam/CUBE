#!/usr/bin/perl
use HTML::Entities;
use URI::Escape;
#
# CubeGenerator
#
($ModelFile, $TemplateFile, $CodeFile) = @ARGV;
#
# Model File Processing
# ===== ==== ==========
#
print "\n";
print "CubeGen v2.`8  14 March 2018\n";
print "=====================================\n";
print "Reading Model      : $ModelFile\n";
######################################################################################
# Lezen van de modelfile in memory struktuur.
# Inhoud gekopieerd omdat deze wordt gedeeld tussen de generator en de model import.
######################################################################################
$MODEL="$ModelFile";
open MODEL, "$MODEL" or die "Cannot open $MODEL:$!";

$I = 0;
$ModelLineCount = 0;
$Number = 1;
$NodeNumber[$I] = 0;
$NodeId[$I] = "ROOT";
$NodeSubNumber[$I] = 0;
$SubNumberCounter[$I] = 0;
$NodeString[$I] = "Root";
$NodeFirst[$I] = -1;
$NodeFirstSequ[$I] = -1;
$NodeType[$I] = "R";
$NodeParent[$I] = -1;
$NodeNext[$I] = -1;
$NodeNextSequ[$I] = -1;
$NodeValuePntr[$I] = -1;
$NodeValueCount[$I] = -1;
$NodeRef[$I] = 0;
$V = 0;
$NodeValue[$V] = -1;

$J = 0;    
$Parent[$J] = 0;
while(<MODEL>) {
	$ModelString = $_;
	$ModelLineCount++;
	$ModelString =~ s/\t//g;
	if (substr($ModelString, 0, 1) eq '!') {
		next;
	}
#	print $ModelString; 
	$IndexColon = index($ModelString, ':');
	if ($IndexColon > 1) { 
		$IndexRelSep = index($ModelString, '|');
		if ($IndexRelSep > 1 && $IndexRelSep < $IndexColon) {
			$Rels = substr($ModelString, $IndexRelSep+1, $IndexColon-$IndexRelSep-1);
			$ModelString = substr($ModelString, 0, $IndexRelSep).substr($ModelString, $IndexColon);
			$IndexColon = $IndexRelSep;
		} else {
			$Rels = "NONE";
		}
		$Tag = substr($ModelString, 1, $IndexColon-1);
		$IndexBracket = index ($Tag, '[');
		$Id = '';
		if ($IndexBracket > 1) {
			if (substr($Tag, $IndexColon-2, 1) eq ']') {
				$Id = substr($Tag,$IndexBracket+1, $IndexColon-$IndexBracket-3);
			} else {
				print "Error[$ModelLineCount]: ']' not found at end of tag\n";
			}
			$Tag = substr($Tag, 0, $IndexBracket);
		}
	} else {
		print "Error[$ModelLineCount]: ':' not found\n"; 
	}
	$IndexSemiColon = index($ModelString, ';');
	$IndexSeparator = index($ModelString, '|');

	if ($IndexSemiColon > 1) { 
		if ($IndexSeparator > 1) {
			$Name = substr($ModelString, $IndexColon+1, $IndexSeparator-$IndexColon-1);
		} else {	
			$Name = substr($ModelString, $IndexColon+1, $IndexSemiColon-$IndexColon-1);
		}
	} else {
		print "Error[$ModelLineCount]: ';' not found in: $ModelString;\n"; 
	}

	$Sign = substr ($ModelString,0,1);
	if ($Sign eq "+" || $Sign eq "=" || $Sign eq ">") {
		$LineSign = $Sign;
		ProcessModelLine();
		if ($IndexSeparator > -1) {
			$Values = substr($ModelString, $IndexSeparator+1, $IndexSemiColon-$IndexSeparator-1);
			$NodeValuePntr[$I] = $V;
			$NodeValueCount[$I] = 1;
			while (1) {
				$IndexSeparator = index($Values,'|');
				if ($IndexSeparator > -1) {
					$NodeValue[$V] = uri_unescape(substr($Values, 0, $IndexSeparator));
					$Values = substr($Values, $IndexSeparator+1);
					$V++;
				} else {	
					$NodeValue[$V] = uri_unescape($Values);
					$V++;
					last;
				}
				$NodeValueCount[$I]++;			
			}
		} else {
			$NodeValuePntr[$I] = -1;
			$NodeValueCount[$I] = 0;
		}

		# Process inline references
		if ($Rels ne "NONE") {
			while($IndexRelSep > -1) {
				$IndexRelSep = index($Rels, '|');
				if ($IndexRelSep > -1) {
					$Rel = substr($Rels, 0, $IndexRelSep);
					$Rels = substr($Rels, $IndexRelSep+1);
				} else {
					$Rel = $Rels;
				}
				$IndexComma = index($Rel, ',');
				if ($IndexComma	> -1) {
					$LineSign = ">";
					$Id = '';
					$Tag = substr($Rel,0,$IndexComma);
					$Name = substr($Rel,$IndexComma+1);
					ProcessModelLine();
				} else {
					print "Error[$ModelLineCount]: ',' not found in rel spec\n";
				}			
			}
			if ($Sign eq "=") {
				$J = $J-2;
			}
		}
	} elsif ($Sign eq "-") {
		$J = $J-2;
	} else {
		print "Error[$ModelLineCount]: no +,- or =\n";
	}
}

# Resolve pointers and Create reverse pointers
$LastNr = $I;
for ($i=0; $i<=$LastNr; $i++) {
	if ($NodeType[$i] eq "P") {
		# Find node'
		$Tag = '*'.$NodeString[$NodeParent[$NodeParent[$NodeParent[$i]]]];
		$NodeRef[$i] = -1;
		for ($j=0; $j<=$I; $j++) {
			if ($NodeId[$j] eq $NodeString[$i]) {
				$NodeRef[$i] = $j;
				last;
			}
		}
		if ($NodeRef[$i] != -1) {
			# Find tag in node
			$N = -1;
			for ($j=0; $j<=$I; $j++) {
				if ($NodeString[$j] eq $Tag && $NodeParent[$j] == $NodeRef[$i]) {
					$N = $j;
					last;
				}
			}
		}
		if ($N == -1) {
			$I++;
			$SubNumberCounter[$I] = 0;
			# Update First/next
			if ($NodeFirst[$NodeRef[$i]] == -1) {
				$NodeFirst[$NodeRef[$i]] = $I;
			} else {
				for ($j=0; $j<=$I-1; $j++) {
					if ($NodeParent[$j] == $NodeRef[$i] && $NodeNext[$j] == -1) {
						$NodeNext[$j] = $I;
						last;
					}
				}
			}
			$NodeType[$I] = 'T';
			$NodeString[$I] = $Tag;
			$NodeParent[$I] = $NodeRef[$i];
			$NodeNext[$I] = -1;
			$NodeFirst[$I] = $I + 1;
			$N = $I;
		} else {
			# Update next of value
			for ($j=0; $j<=$I; $j++) {
				if ($NodeParent[$j] == $N && $NodeNext[$j] == -1) {
					$NodeNext[$j] = $I + 1;
					last;
				}
			}
		}
		$I++;
		$NodeType[$I] = 'P';
		$NodeString[$I] = $NodeId[$NodeParent[$NodeParent[$i]]];
		$NodeNumber[$I] = $Number;
		$SubNumberCounter[$N]++;
		$NodeSubNumber[$I] = $SubNumberCounter[$N];
		$NodeParent[$I] = $N;
		$NodeNext[$I] = -1;
		$NodeFirst[$I] = -1;
		$NodeRef[$I] = $NodeParent[$NodeParent[$i]]; 
		$Number++;
	}
}

sub ProcessModelLine {
		if($NodeFirst[$Parent[$J]] > -1) {
			$N = $NodeFirst[$Parent[$J]]; 
			while (1) {
				if ($Tag eq $NodeString[$N]) {
					last;
				}
				if ($NodeNext[$N] > -1) {
					$N = $NodeNext[$N];
				} else {
					$I++;
					$SubNumberCounter[$I] = 0;
					$NodeFirst[$I] = -1; 
					$N = $I;
					$NodeNext[$N] = -1;
					$NodeNext[$NodeLast[$Parent[$J]]] = $N;
					$NodeLast[$Parent[$J]] = $N;
					last;
				}				 
			}
		} else {
			$I++;
			$SubNumberCounter[$I] = 0;
			$NodeFirst[$I] = -1; 
			$N = $I;
			$NodeFirst[$Parent[$J]] = $N;
			$NodeNext[$N] = -1;
			$NodeLast[$Parent[$J]] = $N;
		}
		$NodeParent[$N] = $Parent[$J];
		$NodeString[$N] = $Tag;
		$NodeType  [$N] = "T";

		$J++;
		$Parent[$J] = $N;
		$I++;
		$SubNumberCounter[$I] = 0;
		$NodeFirst[$I] = -1;
		if ($NodeFirst[$Parent[$J]] > -1) {
			$NodeNext[$NodeLast[$Parent[$J]]] = $I;
		} else {
			$NodeFirst[$Parent[$J]] = $I;
		}
		$NodeLast[$Parent[$J]] = $I;

		# Sequence pointers
		$NodeFirstSequ[$I] = -1;
		$NodeNextSequ[$I] = -1;
		if ($NodeFirstSequ[$Parent[$J-1]] > -1) {
			$NodeNextSequ[$NodeLastSequ[$Parent[$J-1]]] = $I;
		} else {
			$NodeFirstSequ[$Parent[$J-1]] = $I;
		}
		$NodeLastSequ[$Parent[$J-1]] = $I;

		$NodeParent[$I] = $Parent[$J];
		$NodeNumber[$I] = $Number;
		$SubNumberCounter[$Parent[$J]]++;
		$NodeSubNumber[$I] = $SubNumberCounter[$Parent[$J]];
		$Number++;
		if ($Id ne '') {	
			for ($i=0; $i<$I; $i++) {
				if ($NodeId[$i] eq $Id) {
					print "Error: Duplicate id '$Id'\n";
					$Id = '';
					last;
				}
			}
		}
		$NodeId[$I] = $Id;
		$NodeString[$I] = uri_unescape($Name);

		if ($LineSign eq ">") {
			$NodeType[$I] = "P";
		} else {
			$NodeType[$I] = "V";
		}
		$NodeNext[$I] = -1;

		if ($LineSign eq "+" || ($LineSign eq "=" && $Rels ne "NONE")) {
			$J++;
			$Parent[$J] = $I;
		} else {
			$J--;
		}
}
######################################################################################
# Einde modelfile import
######################################################################################

if (0) {
	$NODEFILE="nodefile.csv";
	open NODEFILE, ">$NODEFILE" or die "Cannot open $NODEFILE:$!";

	print NODEFILE "Nr;Id;Type;String;Node;SubN;Prnt;Next;Frst;NxtS;FstS;Ref;\n";
	for ($i=0; $i<=$I; $i++) {
		print NODEFILE "$i;$NodeId[$i];$NodeType[$i];" . EscapeModelChars($NodeString[$i]) . ";$NodeNumber[$i];$NodeSubNumber[$i];$NodeParent[$i];$NodeNext[$i];$NodeFirst[$i];$NodeNextSequ[$i];$NodeFirstSequ[$i];$NodeRef[$i];\n";
	}
close NODEFILE;
}

#print "@NodeString\n";
#print "@NodeNumber\n";
#print "@NodeId\n";
#print "@NodeSubNumber\n";
#print "@NodeParent\n";
#print "@NodeNext\n";
#print "@NodeFirst\n";
#print "@NodeValuePntr\n";
#print "@NodeValueCount\n";
#print "@NodeValue\n";

#
# Start Generation
# ===== ==========
#
print "Preparing Template : $TemplateFile\n";
local $/=undef;

$TEMPLATE="$TemplateFile";
open TEMPLATE, "$TEMPLATE" or die "Cannot open $TEMPLATE:$!";
$TemplateString = <TEMPLATE>;

$CODE="$CodeFile";
open CODE, ">$CODE" or die "Cannot open $CODE:$!";

ProcessIncludes ($TemplateString);
RemoveComment($TemplateString);
ProcessText ($TemplateString);
GetBody($TemplateString);
PerformPerl($TemplateString,"DECL"); 
$I = 0;
foreach $Parm (@ARGV[3..$#ARGV]) {
	$I++;
	$ParmUpper = uc $Parm;
	$ParmLower = lc $Parm;
	$TemplateString =~ s/<<$I>>/$Parm/g ;
	$TemplateString =~ s/<<$I:U>>/$ParmUpper/g ;
	$TemplateString =~ s/<<$I:L>>/$ParmLower/g ;
}
print "Generating Code    : $CodeFile\n";

$NodeIndex = 0;

# Stack
$StackIndex = -1;
$StackNodeIndex[0] = 0;
$StackTag[0] = 'init';
$StackTagIndex[0] = 0;
$StackRepeatIndex[0] = 0;
$StackRepeatGroupId[0] = 0;
$StackTagValid[0] = 0;
$StackNumber[0] = 0;
$StackSubNumber[0] = 0;
$StackId [0] = 'init';
$StackName[0] = 'init';
$StackValueCount[0] = 0;
$StackIx[0] = 0;
$StackIxValidH[0] = 0;
$StackValue[0][0] = 'init';
$StackTemplateSegment[0] = 'init';
$StackFlagSequence[0] = 0;
$StackFlagWildcard[0] = 0;
$StackTagValidWildcard[0] = 0;
$StackCondition[0] = 'init';
$StackNode[0][0] = -1;
$StackFlagPointer[0][0] = 0;
$StackSelectedNode[0][0] = 0;
# Indentation
$IndentLevel = 0;

#print "---------------------------\n";
ProcessTemplateSegment (0, 0, '#', $TemplateString);

print "Ready\n";

sub ProcessIncludes {
#
# Vervang de include verwijzingen met de inhoud herhaal net zolang tot er geen includes meer zijn.
#
my ($IndexIncl, $Index2);
my ($IncludeFile, $INCLUDE);

	while($IndexIncl > -1) {
		$IndexIncl = index($_[0], '[[INCLUDE,');
		if ($IndexIncl > -1) {
			$Index2 = index($_[0], ']]', $IndexIncl);
			if ($Index2 > -1) {

				$IncludeFile = substr($_[0], $IndexIncl+10, $Index2-$IndexIncl-10);
				$INCLUDE = "$IncludeFile";
				open INCLUDE, "$INCLUDE" or die "Cannot open $INCLUDE:$!";
				$IncludeString = <INCLUDE>;
				GetBody($IncludeString);

# Regex is toch niet zo krachtig dus dan maar zo
				$_[0] = substr($_[0],0,$IndexIncl) . $IncludeString . substr($_[0],$Index2+2);
#				$IncludeFile =~ s/\x5c/\x5cx5c/g ;
#				$IncludeFile =~ s/\x2e/\x5cx2e/g ;
#				$_[0] =~ s/\x5b\x5bINCLUDE\x2c$IncludeFile\x5d\x5d/$IncludeString/g ;
 
			} else {
				print CODE "\n[ERROR: End of INCLUDE-tag ']]' not found]\n";
				exit;
			}
		}
	}
}

sub ProcessText {
#
# Vervang de Textsegmenten
# [[TEXT,name]]....<<T1>>....<<T2>>...[[ENDTEXT]]
# <<TEXT,name[|]T1[|]T2[|]>>
#
my ($IndexText, $Index2, $Index3, $Index4, $I, $J);
my ($TextIndex, @TextTag, @TextValue);
my ($Count, $TextName, $TextQualifier, $TextReplace, $TextReplVal, $TextParms);
my ($IndexSep1, $IndexSep2, $ParmVal, $P, $FlagParms);

	$TextIndex = 0;
	$IndexText = 0;
	while($IndexText > -1) {
		$IndexText = index($_[0], '[[TEXT,');
		if ($IndexText > -1) {
			$Index2 = index($_[0], ']]', $IndexText);
			if ($Index2 > -1) {
				$TextTag[$TextIndex] = substr($_[0], $IndexText+7, $Index2-$IndexText-7);
				for ($I = 0; $I < $TextIndex; $I++) {
					if ($TextTag[$TextIndex] eq $TextTag[$I]) {
						print CODE "\n[ERROR: Duplicate Textsegment (tag=$TextTag[$TextIndex])]\n";
						exit;
					}
				}
				$Index3 = index($_[0], '[[ENDTEXT]]');
				$Index4 = index($_[0], '[[TEXT,', $IndexText+1);
				if ($Index3 > -1) {
					if (($Index4 > -1) && ($Index4 < $Index3)) {
						print CODE "\n[ERROR: Nested TEXT not supported]\n";
						exit;
					}
					$TextValue[$TextIndex] = substr($_[0], $Index2+2, $Index3-$Index2-2);
					$_[0] = substr($_[0],0,$IndexText) . substr($_[0],$Index3+11);
				} else {
					print CODE "\n[ERROR: End of body '[[ENDTEXT]]' not found]\n";
					exit;
				}
				$TextIndex = $TextIndex + 1;
			} else {
				print CODE "\n[ERROR: End of TEXT-tag ']]' not found]\n";
				exit;
			}
		}
	}

	$Count = 0;
	$IndexText = 0;
	while($IndexText > -1) {
		$IndexText = index($_[0], '<<TEXT,');
		if ($IndexText > -1) {
			$Index2 = index($_[0], '>>', $IndexText);
			if ($Index2 > -1) {
				$Index4 = index($_[0], '[|]', $IndexText);
				if (($Index4 <= -1) || ($Index4 > $Index2)) {
					$Index4 = $Index2;
				}
				$Index3 = index($_[0], '.', $IndexText);
				if (($Index3 > -1 ) && ($Index3 < $Index4)) {
					$TextName = substr($_[0], $IndexText+7, $Index3-$IndexText-7);
					$TextQualifier = substr($_[0], $Index3+1, $Index4-$Index3-1);
					$TextReplace = $TextName . '.' . $TextQualifier;
				} else {
					$TextName = substr($_[0], $IndexText+7, $Index4-$IndexText-7);
					$TextQualifier = '';
					$TextReplace = $TextName;
				}
				if ($Index2 > $Index4) {
					$FlagParms = 1;
					$Index2 = index($_[0], '[|]>>', $IndexText);
					if ($Index2 == -1) {
						print CODE "\n[ERROR: End of TEXT-tag '[|]>>' not found]\n";
						exit;
					}  
					$TextParms = substr($_[0], $Index4+3, $Index2-$Index4-3);
					$TextReplace = $TextReplace . '[|]' . $TextParms . '[|]';
 				} else {
					$FlagParms = 0;
					$TextParms = '';
				}
			} else {
				print CODE "\n[ERROR: End of TEXT-tag '>>' not found]\n";
				exit;
			}
			for ($I = 0; $I < $TextIndex; $I++) {
				if ($TextTag[$I] eq $TextName) {
					$TextReplVal = $TextValue[$I];
					if ( $TextQualifier ne '' ) {
						$TextReplVal =~ s/<<TEXT,(.*?)(:|>)(.*?)(>{1,2})/<<TEXT,$1_$TextQualifier$2$3$4/g;
					}
					if ( $FlagParms ) {
						$IndexSep2 = 0;
						$P = 1;
						while (1) {
							$IndexSep1 = index($TextParms, '[|]', $IndexSep2);
							if ($IndexSep1 > -1) {
								$ParmVal = substr($TextParms,$IndexSep2,$IndexSep1-$IndexSep2);
								$IndexSep2 = $IndexSep1 + 3;
							} else {
								$ParmVal = substr($TextParms,$IndexSep2);
							}
							$TextReplVal =~ s/<<T$P>>/$ParmVal/g;
							$P++;
							if ($IndexSep1 == -1) {
								last;
							}
						}	
					}
					$_[0] =~ s/\Q<<TEXT,$TextReplace>>\E/$TextReplVal/g;
					last;
				}
			}
			if ($I == $TextIndex) {
				$_[0] =~ s/\Q<<TEXT,$TextReplace>>\E/[ERROR: Text:$TextReplace not found]/g;
			}
			if ($Count > 1000) {
				print CODE "\n[ERROR: Endless loop in text processing]\n";
				exit;
			}
			$Count++;
		}
	}
}

sub GetBody {
#
# Selecteer body segment
#
my ($IndexBody, $Index2);

	$IndexBody = index($_[0], '[[BODY]]');
	if ($IndexBody > -1) {
		$Index2 = index($_[0], '[[ENDBODY]]', $IndexBody);
		if ($Index2 > -1) {
			$_[0] = substr($_[0], $IndexBody+8, $Index2-$IndexBody-8);
		} else {
			print CODE "\n[ERROR: End of body '[[ENDBODY]]' not found]\n";
			exit;
		}
	}
}

sub RemoveComment {
#
# Verwijder commentaar [[* *]]
#
my ($Index1, $Index2);
my ($Comment);
	$Index1 = 0;
	while($Index1 > -1) {
		$Index1 = index($_[0], '[[*');
		if ($Index1 > -1) {
			$Index2 = index($_[0], '*]]', $Index1);
			if ($Index2 > -1) {
				$_[0] = substr($_[0],0,$Index1) . substr($_[0],$Index2+3);
			} else {
				print CODE "\n[ERROR: End of comment '*]]' not found]\n";
				exit;
			}
		}
	}
}

sub PerformPerl {
#
# Voer perlscript(s) uit
# [[DECL:...]][[EVAL:...]][[EVAL:(...)]](no output)
#
my ($Index1, $Index2);
my ($PerlString, $PerlResult);
	$Index1 = 0;
	while($Index1 > -1) {
		$Index1 = index($_[0], '[['.$_[1].':');
		if ($Index1 > -1) {
			$Index2 = index($_[0], ']]', $Index1);
			if ($Index2 > -1) {
				$PerlString = substr($_[0],$Index1+7, $Index2-$Index1-7);
				$PerlResult = eval $PerlString;
				if ($_[1] eq "DECL") { 
					$_[0] = substr($_[0],0,$Index1) . substr($_[0],$Index2+2);
				} 
				if ($_[1] eq "EVAL") {
					if (substr($PerlString,0,1) eq '(' && substr($PerlString,length($PerlString)-1,1) eq ')') {
						$_[0] = substr($_[0],0,$Index1) . substr($_[0],$Index2+2);
					} else {
						$_[0] = substr($_[0],0,$Index1) . $PerlResult . substr($_[0],$Index2+2);
					}
				}
			} else {
				print CODE "\n[ERROR: ']]' for '[['.$_[1].':' not found]\n";
				exit;
			}
		}
	}
}

sub PerformTabs {
#
# Voer perlscript(s) uit
# [[TABS:<increment>]]
#
my ($Index1, $Index2);
my ($Increment);
	$Index1 = 0;
	while($Index1 > -1) {
		$Index1 = index($_[0], '[[TABS:');
		if ($Index1 > -1) {
			$Index2 = index($_[0], ']]', $Index1);
			if ($Index2 > -1) {
				$Increment = substr($_[0],$Index1+7, $Index2-$Index1-7);
				$IndentLevel = $IndentLevel + $Increment;
				$_[0] = substr($_[0],0,$Index1) . substr($_[0],$Index2+2);
			} else {
				print CODE "\n[ERROR: ']]' for '[[TABS:' not found]\n";
				exit;
			}
		}
	}
}

sub PerformValue {
#
# Voer Value functie(s) uit
# [[VALUE,<Tag>:<LoopSpec>:<seperator>]]
#
my ($Index1, $Index2, $Index3);
my ($IndexArrow, $From, $To, $ValueCount, $Flag);
my ($Tag, $ValueSpec, $LoopSpec, $Seperator, $Value, $I, $J);
	$Index1 = 0;
	while($Index1 > -1) {
		$Index1 = index($_[0], '[[VALUE,');
		if ($Index1 > -1) {
			$Index2 = index($_[0], ':', $Index1);
			if ($Index2 > -1) {
				$Index3 = index($_[0], ']]', $Index2);
				if ($Index2 > -1) {
					$Tag = substr($_[0],$Index1+8, $Index2-$Index1-8);
					$ValueSpec = substr($_[0],$Index2+1, $Index3-$Index2-1);
					$Index2 = index($ValueSpec, ':');
					if ($Index2 > -1) {
						$LoopSpec = substr($ValueSpec,0,$Index2);
						$Seperator = substr($ValueSpec,$Index2+1);
					} else {
						$LoopSpec = $ValueSpec;
						$Seperator = '';
					}
					$I = DetermineStackPointerTagN($Tag);
					$IndexArrow = index($LoopSpec,'>');
					if ($IndexArrow > -1) {
						$From = substr($LoopSpec,0,$IndexArrow);
						$To = substr($LoopSpec,$IndexArrow+1);
					} else {
						$From = $LoopSpec;
						$To = $LoopSpec;
					}
					$ValueCount = $NodeValueCount[$StackNode[$I][$StackNodeIndex[$I]]];
					$Flag = 1;
					if ($From eq 'N') {
						$From = $ValueCount;
						if ($To > $ValueCount) {
							$Flag = 0;
						}
					} elsif ($From < 0) {
						$From = 0; 
					}
					if ($To eq 'N') {
						$To = $ValueCount;
						if ($From > $ValueCount) {
							$Flag = 0;
						}
					} elsif ($To < 0) {
						$To = 0; 
					}
					$Value = '';
					if ( $Flag ) {
						if ($From > $To) {
							for ($J = $From; $J >= $To; $J--) {
								if ($J == 0) {
									$Value = $Value . EscapeModelChars($StackName[$I]);
								} else {
									$Value = $Value . EscapeModelChars($StackValue[$I][$J]);
								}
								if ($J > $To) {
									$Value = $Value . $Seperator;
								}
							}
						} else {
							for ($J = $From; $J <= $To; $J++) {
								if ($J == 0) {
									$Value = $Value . EscapeModelChars($StackName[$I]);
								} else {
									$Value = $Value . EscapeModelChars($StackValue[$I][$J]);
								}
								if ($J < $To) {
									$Value = $Value . $Seperator;
								}
							}
						}
					}
					$_[0] = substr($_[0],0,$Index1) . $Value . substr($_[0],$Index3+2);
				} else {
					print CODE "\n[ERROR: ']]' for '[[VALUE' not found]\n";
					exit;
				}
			} else {
				print CODE "\n[ERROR: ':' for '[[VALUE' not found]\n";
				exit;
			}
		}
	}
}

sub ProcessTemplateSegment {
#
# Bepaal of de IF, LOOP, SEQUENCE struktuur moet worden gelezen.
#
#
my ($FlagSequence, $NodeIndex, $DfltTag, $TemplateSegment) = @_;
my ($IndexIf, $IndexLoop, $IndexRepeat, $IndexSequ, $IndexFor, $IndexTempl, $IndexMin, $Index);

	if (length($TemplateSegment) > 0 ) {
		$IndexIf     = index($TemplateSegment, '[[IF');
		$IndexLoop   = index($TemplateSegment, '[[LOOP');
		$IndexRepeat = index($TemplateSegment, '[[REPEAT');
		$IndexFor    = index($TemplateSegment, '[[FOR');
		$IndexSequ   = index($TemplateSegment, '[[SEQUENCE');
		$IndexTempl  = index($TemplateSegment, '[[TEMPLATE');

		if (($IndexIf == -1) && ($IndexLoop == -1) && ($IndexRepeat == -1) && ($IndexFor == -1) && ($IndexSequ == -1) && ($IndexTempl == -1)) {
			ExportCode($TemplateSegment);
		} else {
			$MaxValue = 99999999;
			if ($IndexIf     == -1) { $IndexIf     = $MaxValue; }
			if ($IndexLoop   == -1) { $IndexLoop   = $MaxValue; }
			if ($IndexRepeat == -1) { $IndexRepeat = $MaxValue; }
			if ($IndexFor    == -1) { $IndexFor    = $MaxValue; }
			if ($IndexSequ   == -1) { $IndexSequ   = $MaxValue; }
			if ($IndexTempl  == -1) { $IndexTempl  = $MaxValue; }
			$IndexMin = $MaxValue; 
			if ($IndexIf     < $IndexMin ) { $IndexMin = $IndexIf; }
			if ($IndexLoop   < $IndexMin ) { $IndexMin = $IndexLoop; }
			if ($IndexRepeat < $IndexMin ) { $IndexMin = $IndexRepeat; }
			if ($IndexFor    < $IndexMin ) { $IndexMin = $IndexFor; }
			if ($IndexSequ   < $IndexMin ) { $IndexMin = $IndexSequ; }
			if ($IndexTempl  < $IndexMin ) { $IndexMin = $IndexTempl; }

			ExportCode(substr($TemplateSegment, 0, $IndexMin));
	
			if ($IndexIf == $IndexMin) { 	
				ProcessTemplateSegmentIf ($FlagSequence, $NodeIndex, $DfltTag, substr($TemplateSegment, $IndexIf));
			} elsif ($IndexLoop == $IndexMin) {
				if (substr($TemplateSegment,$IndexLoop,10) eq '[[LOOP,*]]') {
					ProcessSequence ($NodeIndex, $DfltTag, substr($TemplateSegment, $IndexLoop));
					$Index = ProcessLeveling($TemplateSegment,'LOOP,*',$IndexLoop);
					ProcessTemplateSegment (0, $NodeIndex, $DfltTag, substr($TemplateSegment, $Index+13));
				} elsif (substr($TemplateSegment,$IndexLoop,11) eq '[[LOOP,>*]]') {
					ProcessSequence ($NodeIndex, $DfltTag, substr($TemplateSegment, $IndexLoop));
					$Index = ProcessLeveling($TemplateSegment,'LOOP,>*',$IndexLoop);
					ProcessTemplateSegment (0, $NodeIndex, $DfltTag, substr($TemplateSegment, $Index+14));
				} else {
					ProcessTemplateSegmentLoop (0, $NodeIndex, $DfltTag, substr($TemplateSegment, $IndexLoop));
				}
			} elsif ($IndexRepeat == $IndexMin) {
				ProcessTemplateSegmentRepeat ($FlagSequence, $NodeIndex, $DfltTag, substr($TemplateSegment, $IndexRepeat));
			} elsif ($IndexFor == $IndexMin) {
				ProcessTemplateSegmentFor($FlagSequence, $NodeIndex, $DfltTag, substr($TemplateSegment, $IndexFor));
			} elsif ($IndexSequ == $IndexMin) {
				ProcessTemplateSegmentSequ($FlagSequence, $NodeIndex, $DfltTag, substr($TemplateSegment, $IndexSequ));
			} else {
				ProcessTemplateTemplate($FlagSequence, $NodeIndex, $DfltTag, substr($TemplateSegment, $IndexTempl));
			} 
		}
	}
}

sub ProcessTemplateSegmentIf {
#
# Lees textsegmenten tussen een [[IF...] en een [[ENDIF]] match de tag met de node om vervolgens de functie voor het verwerken van de loops uit te voeren.
#
# [[IF[,<tag>]:<condition>]]
# [[ELSIF[,<tag>]:<condition>]]
# [[ELSE]]
# [[ENDIF]]
#
my ($FlagSequence, $NodeIndex, $DfltTag, $TemplateSegment) = @_;
my ($Index2, $IndexColon, $IndexSegment, $IndexIf);
my ($IfLevel, $IndexElse, $IndexEndif, $IndexEndElse, $IndexLeveling, $IndexLevelingIf);
my ($Condition, $Tag, $CondNodeIndex, $IStack, $Logical);

	$Index2 = index($TemplateSegment, ']]');
	$IndexSegment = $Index2 + 2;
	if ($Index2 > -1) {
		$IndexColon = index($TemplateSegment, ':');
		if ($IndexColon > -1 && $IndexColon < $Index2) {
			$Condition = substr($TemplateSegment, $IndexColon+1, $Index2-$IndexColon-1);
		} else {
			print CODE "\n[ERROR: No condition in IF]\n";
			exit;
		}

		if (substr($TemplateSegment, 4, 1) eq ',') {
			$Tag = substr($TemplateSegment, 5, $IndexColon-5);
		} else {
			$Tag = $DfltTag;
		}
		$CondNodeIndex = $NodeIndex;
		ProcessTag($Tag, $CondNodeIndex, $IStack);
		$IfLevel = 1;
		$IndexLeveling = $Index2;
		$IndexElse = -1;
		while($IfLevel > 0) {
			$IndexIf = index($TemplateSegment, '[[IF', $IndexLeveling + 1);
			$IndexEndif = index($TemplateSegment, '[[ENDIF]]', $IndexLeveling + 1);
			if ($IfLevel == 1) {
				$IndexElse = index($TemplateSegment, '[[ELS', $IndexLeveling + 1);
			} else {
				$IndexElse = -1;
			}
			if ($IndexElse > -1 && $IndexElse < $IndexEndif) {
				$IndexEndElse = $IndexElse;
			} else {
				$IndexEndElse = $IndexEndif;
			}
			if ($IndexEndElse > -1) {
				if ($IndexIf == -1 || $IndexIf > $IndexEndElse) {
					$IfLevel -= 1;
					$IndexLeveling = $IndexEndElse;
				} else {
					$IfLevel += 1;
					$IndexLeveling = $IndexIf;
				} 
			} else {
				print CODE "\n[ERROR: [[ENDIF]] not found]\n";
				exit;
			}
		}
		$Logical = EvaluateCondition($Condition, $CondNodeIndex, $IStack, $Tag);
		if ($Logical == 1) {
			ProcessTemplateSegment ($FlagSequence, $NodeIndex, $DfltTag, substr($TemplateSegment , $IndexSegment, $IndexLeveling-$IndexSegment));
		}
		if ($IndexElse > -1 && $IndexElse < $IndexEndif) {
			$IndexLevelingIf = $IndexLeveling;
			$IndexSegment = $IndexLeveling + 8;
			$IndexLeveling = ProcessLeveling($TemplateSegment,'IF',$IndexLeveling);
			if ($Logical == 0) {
				if (substr($TemplateSegment,$IndexLevelingIf,8) eq '[[ELSE]]') {
					ProcessTemplateSegment ($FlagSequence, $NodeIndex, $DfltTag, substr($TemplateSegment, $IndexSegment, $IndexLeveling-$IndexSegment));
				} elsif (substr($TemplateSegment,$IndexLevelingIf,7) eq '[[ELSIF') {
					ProcessTemplateSegment ($FlagSequence, $NodeIndex, $DfltTag, '[['.substr($TemplateSegment, $IndexLevelingIf+5, $IndexLeveling-$IndexSegment+12));
				} else {
					print CODE "\n[ERROR: Invalid [[ELS... option]\n";
					exit;
				}
			}
		}
		$IndexSegment = $IndexLeveling + 9;
		ProcessTemplateSegment ($FlagSequence, $NodeIndex, $DfltTag, substr($TemplateSegment, $IndexSegment));
	} else {
		print CODE "\n[ERROR: End of IF-tag ']]' not found]\n";
		exit;
	}
}

sub ProcessTemplateSegmentLoop {
#
# Lees textsegmenten tussen een [[LOOP...]] en een [[ENDLOOP...]] match de tag met de node om vervolgens de functie voor het verwerken van de text in de loop uit te voeren.
#
# [[LOOP,<tag>:<condition>]]
#	[[REPEAT:<type_indent>]]
# [[ENDLOOP]]
#
my ($FlagSequence, $NodeIndex, $DfltTag, $TemplateSegment) = @_;
my ($Index2, $Index3, $IndexSegment, $IndexC, $IndexColon, $IndexL);
my ($Condition, $Type, $Tag, $Endtag, $Name);

	$IndexSegment = 0;
	$Index2 = index($TemplateSegment, ']]');
	if ($Index2 > -1) {
		$IndexC = index($TemplateSegment, ',');
		if ($IndexC > -1 && $IndexC < $Index2) {
			$Tag = substr($TemplateSegment, $IndexC+1, $Index2-$IndexC-1);
		} else {
			print CODE "\n[ERROR: No comma in tag]\n";
			exit;
		}
		$IndexColon = index($Tag, ':');
		if ($IndexColon > -1) {
			$Condition = substr($Tag, $IndexColon+1);
			$Tag = substr($Tag, 0, $IndexColon);
		} else {
			$Condition = 'none';
		}
		$EndTag = "[[ENDLOOP,$Tag]]";
		$IndexL = ProcessLeveling($TemplateSegment,'LOOP',$Index2);
		$Index3 = index($TemplateSegment, $EndTag, $IndexL);
		if ($Index3 == $IndexL) {
			$IndexSegment = $Index3 + length($EndTag);
			ProcessLoop($FlagSequence, $NodeIndex, $Tag, $Condition, substr($TemplateSegment , $Index2+2, $Index3-$Index2-2));
		} else {
			print CODE "\n[ERROR: End tag $EndTag not matched]\n";
			exit;
		}
	}
	if (!$FlagSequence) {
		# Binnen een sequence alleen de LOOP verwerken.
		ProcessTemplateSegment ($FlagSequence, $NodeIndex, $DfltTag, substr($TemplateSegment, $IndexSegment));
	}
}
sub ProcessTemplateSegmentRepeat {
#
# Lees Herhaal LOOP
#
# [[LOOP,<tag>:<condition>]]
#	[[REPEAT,<tag>:<type_indent>]]
# [[ENDLOOP]]
#
my ($FlagSequence, $NodeIndex, $DfltTag, $TemplateSegment) = @_;
my ($IndentType, $Index2, $IndexSegment, $IndexColon, $IndexComma, $Tag, $I, $J);

	$Index2 = index($TemplateSegment, ']]');
	if ($Index2 > -1) {
		$IndexColon = index(substr($TemplateSegment, 0, $Index2), ':');
		if ($IndexColon > -1) {
			$IndentType = substr($TemplateSegment, $IndexColon+1, $Index2-$IndexColon-1);
		} else {
			$IndentType = 'none';
			$IndexColon = $Index2;
		}
		$IndexComma = index(substr($TemplateSegment, 0, $IndexColon), ',');
		if ($IndexComma > -1) {
			$Tag = substr($TemplateSegment, $IndexComma+1, $IndexColon-$IndexComma-1);
			for ($I = $StackIndex; $I > -1; $I--) {
				if ($StackTag[$I] eq $Tag) {
					last;
				}
			}
			if ($StackRepeatGroupId[$I] == 0) {
				for ($J = $StackIndex; $J >= $I; $J--) {
					$StackRepeatGroupId[$J] = $I + 1;
					$StackRepeatIndex[$J] = 1;
				}
			}
		} else {
			$I = $StackIndex;
		}
		if ($IndentType eq 'TAB') {
			$IndentLevel = $IndentLevel + 1;
		}
 		if ($StackFlagSequence[$I]) {
 			ProcessSequence ($NodeIndex, $DfltTag, $StackTemplateSegment[$I]);
 		} else {
			ProcessLoop($FlagSequence, $NodeIndex, $StackTag[$I], $StackCondition[$I], $StackTemplateSegment[$I]);
 		}
		if ($IndentType eq 'TAB') {
			$IndentLevel = $IndentLevel - 1;
		}
		$IndexSegment = $Index2 + 2;
	} else {
		print CODE "\n[ERROR: End of repeat tag ']]' not found]\n";
		exit;
	}
	ProcessTemplateSegment ($FlagSequence, $NodeIndex, $DfltTag, substr($TemplateSegment, $IndexSegment));
}
sub ProcessLoop {
#
# Lees de items bij de tag en voer de functie vul de stack en herhaal de hoofdfunctie voor ieder item.
#
my ($FlagSequence, $NodeIndex, $Tag, $Condition, $TemplateSegment) = @_;
my ($I, $J, $TagParent, $Node);

	$StackIndex += 1;
	if ($StackIndex > 9999) {
		print CODE "\n[ERROR: Infinite REPEAT detected]\n";
		exit;
	}
#print "+LOOP($StackIndex) $Tag:$StackTag[$StackIndex]:$StackTagIndex[$StackIndex]:$FlagSequence;\n";
	$StackCondition[$StackIndex] = $Condition;
	$StackFlagSequence[$StackIndex] = $FlagSequence;
	$StackFlagWildcard[$StackIndex] = $Tag eq '*' || $Tag eq '>*' || $Tag eq '^';
	$StackIxValidH[$StackIndex] = 1;

	if (substr($Tag,0,1) eq '^') {
		if ($FlagSequence) {
			print CODE "\n[ERROR: Parent Loop not allowed in sequence]\n";
			exit;
		}
		$StackTemplateSegment[$StackIndex] = $TemplateSegment;
		$I = $NodeParent[$NodeParent[$NodeIndex]];
		while (1) {
			if ($I == 0) {
				last;
			}
			if (($Tag ne '^' || $NodeString[$NodeParent[$I]] eq substr($Tag,1)) && EvaluateCondition($Condition, $I, $StackIndex, $Tag)) {
				last;
			}
			$I = $NodeParent[$NodeParent[$I]];
		}
		if ($I > 0) {
			$StackNode[$StackIndex][0] = $I;
			$StackFlagPointer[$StackIndex][0] = 0;
			$StackTag[$StackIndex] = '^'.$NodeString[$NodeParent[$I]];
			$StackIx[$StackIndex] = 0;
			NodeToStack ($I, 0);
			ProcessTemplateSegment ($FlagSequence, $I, $Tag, $TemplateSegment);
			NodeFromStack ();
		}
	} else {
		if (!$FlagSequence) {
			$StackTemplateSegment[$StackIndex] = $TemplateSegment;
			$StackTag[$StackIndex] = $Tag;
		} 
		$I = $NodeFirst[$NodeIndex];
		while (1) {
			if ($NodeString[$I] eq $Tag || $Tag eq '*' || $Tag eq '>*') {
				if (!$FlagSequence) {
					# Bij geen sequence hier de stacknodes vullen.
					$I = $NodeFirst[$I];
					$J = 0;
					while ($I > -1) {
						if ($NodeType[$I] eq "P" && $NodeRef[$I] > -1) {
							$StackNode[$StackIndex][$J] = $NodeRef[$I];
							$StackFlagPointer[$StackIndex][$J] = 1;
						} else {
							$StackNode[$StackIndex][$J] = $I;
							$StackFlagPointer[$StackIndex][$J] = 0;
						}
						$I = $NodeNext[$I];
						$J++;
					}
					$StackNode[$StackIndex][$J] = -1;
				}
				$J = 0;
				$I = $StackNode[$StackIndex][0];
				$StackIx[$StackIndex] = 0;
				while($I > -1) {
					if (!($StackFlagPointer[$StackIndex][$J] && $Tag eq '*') && !(!$StackFlagPointer[$StackIndex][$J] && $Tag eq '>*') && EvaluateCondition($Condition, $I, $StackIndex, $Tag)) {
						NodeToStack ($I, $J);
						ProcessTemplateSegment ($FlagSequence, $I, $Tag, $TemplateSegment);
						NodeFromStack ();
					}
					$J++;
					$I = $StackNode[$StackIndex][$J];
				}
				last;
			}
			$I = $NodeNext[$I];
			if ($I == -1) {
				last;
			}
		}
	}
#print "-LOOP($StackIndex) $Tag:$StackTag[$StackIndex]:$StackTagIndex[$StackIndex]:$FlagSequence;\n";
	$StackIndex -= 1;
}

sub NodeToStack {
#
#	Zet Node gegevens op de stack.
#
my ($I, $J) = @_;
my ($V, $L);

	for ($L = $StackIndex-1; $L >= 0; $L--) {
		if ($StackTag[$L] eq $StackTag[$StackIndex]) { 	
			$StackTagIndex[$StackIndex] = $StackTagIndex[$L]+1;
			$StackTagValid[$L] = 0;
			if ($StackRepeatGroupId[$L] > 0) {
				$StackRepeatGroupId[$StackIndex] = $StackRepeatGroupId[$L];
				$StackRepeatIndex[$StackIndex] = $StackRepeatIndex[$L] + 1;
			} else {
				$StackRepeatGroupId[$StackIndex] = 0;
				$StackRepeatIndex[$StackIndex] = 0;
			}
			last;
		}
	}
	if ($StackTagIndex[$StackIndex] == 0) {
		$StackTagIndex[$StackIndex] = 1;
	}
	if ($StackFlagWildcard[$StackIndex]) {
		for ($L = $StackIndex-1; $L >= 0; $L--) {
			if ($StackFlagWildcard[$L]) { 	
				$StackTagValidWildcard[$L] = 0;
				last;
			}
		}
		$StackTagValidWildcard[$StackIndex] = 1;
	}
	$StackTagValid[$StackIndex] = 1;

	$StackNodeIndex[$StackIndex] = $J;
	$StackNumber[$StackIndex] = $NodeNumber[$I];
	$StackSubNumber[$StackIndex] = $NodeSubNumber[$I];
	$StackId[$StackIndex] = $NodeId[$I];	
	$StackName[$StackIndex] = $NodeString[$I];	
	$StackValueCount[$StackIndex] = $NodeValueCount[$I];
	$StackIx[$StackIndex]++;
	for ($V = 1; $V <= $NodeValueCount[$I]; $V++) {
		$StackValue[$StackIndex][$V] = $NodeValue[$NodeValuePntr[$I]+$V-1];	
	}
	$StackSelectedNode[$StackIndex][$StackIx[$StackIndex]] = $I;
}

sub NodeFromStack {
#
#	Zet de valid vlaggen weer terug.
#
	$StackTagIndex[$StackIndex] = 0;
	$StackRepeatGroupId[$StackIndex] = 0;
	$StackRepeatIndex[$StackIndex] = 0;

	for ($L = $StackIndex-1; $L >= 0; $L--) {
		if ($StackTag[$L] eq $StackTag[$StackIndex]) { 	
			$StackTagValid[$L] = 1;
			last;
		}
	}
	if ($StackFlagWildcard[$StackIndex]) {
		for ($L = $StackIndex-1; $L >= 0; $L--) {
			if ($StackFlagWildcard[$L]) { 	
				$StackTagValidWildcard[$L] = 1;
				last;
			}
		}
	}
}

sub ProcessTemplateSegmentFor {
#
# Lees textsegmenten tussen een [[FOR...] en een [[ENDFOR]] match de tag met de node om vervolgens de functie voor het verwerken van de loops uit te voeren.
#
# [[FOR[H|V|][,<tag>]:<loopspec>:<seperator>]] 
# [[FOR[H|V|]_CASE[,<tag>]:<loopspec>:<condition>]] 
# [[ENDFOR]]
#
my ($FlagSequence, $NodeIndex, $DfltTag, $TemplateSegment) = @_;
my ($Index2, $IndexColon, $IndexComma, $IndexSegment, $IndexL);
my ($LoopSpec, $Tag, $SepCond, $ForType, $ForHV, $Inc);
my ($IndexArrow, $From, $To);

	$Index2 = index($TemplateSegment, ']]');
	$IndexSegment = $Index2 + 2;
	if ($Index2 > -1) {
		$IndexColon = index($TemplateSegment, ':');
		if ($IndexColon > -1 && $IndexColon < $Index2) {
			$LoopSpec = substr($TemplateSegment, $IndexColon+1, $Index2-$IndexColon-1);
		} else {
			print CODE "\n[ERROR: No loop specification in FOR]\n";
			exit;
		}
		$IndexComma = index(substr($TemplateSegment, 0, $IndexColon), ',');
		if ($IndexComma > -1) {
			$Tag = substr($TemplateSegment, $IndexComma+1, $IndexColon-$IndexComma-1);
		} else {
			if ($DfltTag eq '*') {
				$Tag = $StackTag[$StackIndex];
			} else {
				$Tag = $DfltTag;
			}
		}
		$IndexColon = index($LoopSpec,':');
		if ($IndexColon > -1) {
			$SepCond = substr($LoopSpec,$IndexColon+1);
			$LoopSpec = substr($LoopSpec,0,$IndexColon);
		} else {
			$SepCond = '';
		}
		if (substr($TemplateSegment,5,1) eq 'H') {
			$ForHV = 'H';
			$Inc = 1;
		} elsif (substr($TemplateSegment,5,1) eq 'V') {
			$ForHV = 'V';
			$Inc = 1;
		} else {
			$ForHV = 'V'; #default
			$Inc = 0;
		}
		if (substr($TemplateSegment,5+$Inc,5) eq '_CASE') {
			$ForType = 'C';
			if ($SepCond eq '') {
				print CODE "\n[ERROR: No condition in FOR..CASE]\n";
				exit;
			} 
		} else {
			$ForType = 'N'; 
		}
		$IndexL = ProcessLeveling($TemplateSegment,'FOR',$Index2);
		$IndexArrow = index($LoopSpec,'>');
		if ($IndexArrow > -1) {
			$From = substr($LoopSpec,0,$IndexArrow);
			$To = substr($LoopSpec,$IndexArrow+1);
		} else {
			print CODE "\n[ERROR: '>' not found in loop specification]\n";
		}
		if ($ForHV eq 'V') {
			ProcessForVLoop ($FlagSequence, $NodeIndex, $Tag,  $From, $To, $SepCond, $ForType, substr($TemplateSegment , $IndexSegment, $IndexL-$IndexSegment));
		} else {
			ProcessForHLoop ($FlagSequence, $NodeIndex, $Tag,  $From, $To, $SepCond, $ForType, substr($TemplateSegment , $IndexSegment, $IndexL-$IndexSegment));
		}
		$IndexSegment = $IndexL + 10;
	} else {
		print CODE "\n[ERROR: End of FOR-tag ']]' not found]\n";
		exit;
	}
	ProcessTemplateSegment ($FlagSequence, $NodeIndex, $DfltTag, substr($TemplateSegment, $IndexSegment));
}

sub ProcessForVLoop {
#
# Lees de items bij de tag en voer de functie vul de stack en herhaal de hoofdfunctie voor ieder item.
#
#
my ($FlagSequence, $NodeIndex, $Tag,  $From, $To, $SepCond, $ForType, $TemplateSegment) = @_;
my ($I, $Node);
my ($IndexN, $IndexV, $TagIndexN, $TagIndexV, $FromPntr, $ToPntr, $CondNodeIndex, $Logical);
my (@TagValidSafe);

	$IndexN = DetermineStackPointerTagN($Tag);
	$TagIndexN = $StackTagIndex[$IndexN];
	$IndexV = DetermineStackPointerTagV($Tag, $IndexN);
	$TagIndexV = $StackTagIndex[$IndexV];

	$FromPntr = ProcessLocator ($TagIndexN, $TagIndexV, $From);
	$ToPntr   = ProcessLocator ($TagIndexN, $TagIndexV, $To);

	if ($StackRepeatGroupId[$IndexV] > 0) {
		for ($I = $StackIndex; $I >= 0; $I--) {
			if ($StackRepeatGroupId[$I] == $StackRepeatGroupId[$IndexV]) {
				$TagValidSafe[$I] = $StackTagValid[$I];
				$StackTagValid[$I] = 0;
			}
		}
	} else {
		$StackTagValid[$IndexV] = 0;
	}	

	if ($FromPntr > -1 && $ToPntr > -1) {
		if ($FromPntr >= $ToPntr) {
			for ($I = $IndexN; $I >= 0; $I--) {
				if (($StackTag[$I] eq $Tag  || $Tag eq '*' || $Tag eq '>*') && $StackTagIndex[$I] <= $FromPntr) {
					if ($ForType eq 'C') {
						$CondNodeIndex = $StackNode[$I][$StackNodeIndex[$I]]; 
						$Logical = EvaluateCondition($SepCond, $CondNodeIndex, $I, $Tag);
						if ($Logical == 1) {
							ProcessTagValid ($I,1);
							ProcessTemplateSegment ($FlagSequence, $StackNode[$I][$StackNodeIndex[$I]], $Tag, $TemplateSegment);
							ProcessTagValid ($I,0);
							last;  
						}	
					} else {
						ProcessTagValid ($I,1);
						ProcessTemplateSegment ($FlagSequence, $StackNode[$I][$StackNodeIndex[$I]], $Tag, $TemplateSegment);
						ProcessTagValid ($I,0);
						if ($StackTagIndex[$I] > $ToPntr) {
							print CODE $SepCond;
						} else {
							last;
						}
					}
				}
			}
		} else {
			for ($I = 0; $I <= $IndexN; $I++) {
				if (($StackTag[$I] eq $Tag  || $Tag eq '*' || $Tag eq '>*') && $StackTagIndex[$I] >= $FromPntr) {
					if ($ForType eq 'C') {
						$CondNodeIndex = $StackNode[$I][$StackNodeIndex[$I]]; 
						$Logical = EvaluateCondition($SepCond, $CondNodeIndex, $I, $Tag);
						if ($Logical == 1) {
							ProcessTagValid ($I,1);
							ProcessTemplateSegment ($FlagSequence, $StackNode[$I][$StackNodeIndex[$I]], $Tag, $TemplateSegment);
							ProcessTagValid ($I,0);
							last;  
						}	
					} else {
						ProcessTagValid ($I,1);
						ProcessTemplateSegment ($FlagSequence, $StackNode[$I][$StackNodeIndex[$I]], $Tag, $TemplateSegment);
						ProcessTagValid ($I,0);
						if ($StackTagIndex[$I] < $ToPntr) {
							print CODE $SepCond;
						} else {
							last;
						}
					}
				}
			}
		} 		
	}
	if ($StackRepeatGroupId[$IndexV] > 0) {
		for ($I = $StackIndex; $I >= 0; $I--) {
			if ($StackRepeatGroupId[$I] == $StackRepeatGroupId[$IndexV]) {
				$StackTagValid[$I] = $TagValidSafe[$I];
			}
		}
	} else { 
		$StackTagValid[$IndexV] = 1;
	}		
}

sub ProcessTagValid {
my ($Index, $Flag) = @_;
my ($I);
	if ($StackRepeatGroupId[$Index] > 0) {
		for ($I = $StackIndex; $I >= 0; $I--) {
			if ($StackRepeatGroupId[$I] == $StackRepeatGroupId[$Index] && $StackRepeatIndex[$I] == $StackRepeatIndex[$Index]) {
				$StackTagValid[$I] = $Flag;
			}
		}
	} else {
		$StackTagValid[$Index] = $Flag;
	}
}


sub ProcessForHLoop {
#
# Lees de items bij de tag en voer de functie vul de stack en herhaal de hoofdfunctie voor ieder item.
#
#
my ($FlagSequence, $NodeIndex, $Tag,  $From, $To, $SepCond, $ForType, $TemplateSegment) = @_;
my ($I, $Node, $V);
my ($Index, $FromPntr, $ToPntr, $TagValidPntr, $CondNodeIndex, $Logical);
my ($SaveName, @SaveValue, $SaveNumber, $SaveSubNumber, $SaveId);

	$Index = DetermineStackPointerTagN($Tag);

	$FromPntr = ProcessLocator ($StackIx[$Index],$StackIxValidH[$Index],$From);
	$ToPntr   = ProcessLocator ($StackIx[$Index],$StackIxValidH[$Index],$To);

	if ($FromPntr > -1 && $ToPntr > -1) {
		$SaveName = $StackName[$Index];
		for ($V = 1; $V <= $NodeValueCount[$Index]; $V++) { $SaveValue[$V] = $NodeValue[$NodeValuePntr[$Index]+$V-1]; }
		$SaveNumber = $StackNumber[$Index];
		$SaveSubNumber = $StackSubNumber[$Index];
		$SaveId = $StackId[$Index];

		if ($FromPntr >= $ToPntr) {
			for ($I = $FromPntr; $I >= $ToPntr; $I--) { 
				ProcessForHLoopItem($Index,$I);
				ProcessTemplateSegment ($FlagSequence, $StackSelectedNode[$Index][$I], $Tag, $TemplateSegment);
				if ($I > $ToPntr) {
					print CODE $SepCond;
				}
			} 
		} else {
			for ($I = $FromPntr; $I <= $ToPntr; $I++) {
				ProcessForHLoopItem($Index,$I);
				ProcessTemplateSegment ($FlagSequence, $StackSelectedNode[$Index][$I], $Tag, $TemplateSegment);
				if ($I < $ToPntr) {
					print CODE $SepCond;
				}
			}
		} 
		$StackName[$Index] = $SaveName;
		for ($V = 1; $V <= $NodeValueCount[$Index]; $V++) { $NodeValue[$NodeValuePntr[$Index]+$V-1] = $SaveValue[$V]; }
		$StackNumber[$Index] = $SaveNumber;
		$StackSubNumber[$Index] = $SaveSubNumber;
		$StackId[$Index] = $SaveId;
	}
}

sub ProcessForHLoopItem {
my ($Index, $I) = @_;
my ($N, $V);

	$N = $StackSelectedNode[$Index][$I];
	$StackName[$Index] = $NodeString[$N];
	for ($V = 1; $V <= $NodeValueCount[$N]; $V++) { $StackValue[$Index][$V] = $NodeValue[$NodeValuePntr[$N]+$V-1]; }
	$StackNumber[$Index] = $NodeNumber[$N];
	$StackSubNumber[$Index] = $NodeSubNumber[$N];
	$StackId[$Index] = $NodeId[$N];
	$StackIxValidH[$Index] = $I;	

}

sub ProcessTemplateSegmentSequ {
#
# Lees textsegmenten tussen een [[SEQUENCE...]] en een [[ENDSQUENCE...]] match de tag met de node om vervolgens de functie voor het verwerken van de text in de loop uit te voeren.
#
# [[SEQUENCE]]
# 	[[LOOP,<tag>:<condition>]]
#		[[REPEAT:<type_indent>]]
# 	[[ENDLOOP]]
# [[ENDSEQUENCE]]
#
my ($FlagSequence, $NodeIndex, $DfltTag, $TemplateSegment) = @_;
my ($Index, $IndexSegment, $IndexL, $Endtag);

	$IndexSegment = 0;
	$EndTag = "[[ENDSEQUENCE]]";
	$IndexL = ProcessLeveling($TemplateSegment,'SEQUENCE',$Index2);
	$Index = index($TemplateSegment, $EndTag, $IndexL);
	if ($Index == $IndexL) {
		$IndexSegment = $Index + length($EndTag);
		ProcessSequence ($NodeIndex, $DfltTag, substr($TemplateSegment , 12, $Index-12));
	} else {
		print CODE "\n[ERROR: End tag $EndTag not matched]\n";
		exit;
	}
	ProcessTemplateSegment ($FlagSequence, $NodeIndex, $DfltTag, substr($TemplateSegment, $IndexSegment));
}

sub ProcessSequence {
#
# Bepaal aan de hand van de volgorde in het model welke loops worden aangeroepen.
# Als de tag veranderd is dit een nieuwe LOOP.
#
my ($NodeIndex, $DfltTag, $TemplateSegment) = @_;
my ($Tag, $Index, $I, $J);
my ($LoopLevel, $IndexLoop, $IndexEndloop, $IndexLeveling);

	$I = $NodeFirstSequ[$NodeIndex];
	while ($I != -1) {
		$Tag = $NodeString[$NodeParent[$I]];
		$J = 0;
		while ($NodeString[$NodeParent[$I]] eq $Tag && $I > -1) {
			if ($NodeType[$I] eq "P" && $NodeRef[$I] > -1) {
				$StackNode[$StackIndex+1][$J] = $NodeRef[$I];
				$StackFlagPointer[$StackIndex+1][$J] = 1;
			} else {
				$StackNode[$StackIndex+1][$J] = $I;
				$StackFlagPointer[$StackIndex+1][$J] = 0;
			}
			$I = $NodeNextSequ[$I];
			$J++;
		}
		$StackNode[$StackIndex+1][$J] = -1;

		$Index = -1;
		$IndexLeveling = -1;
		while(1) {

			$IndexLeveling = index($TemplateSegment, "[[LOOP", $IndexLeveling + 1);
			if ($IndexLeveling == -1) {
				last;
			}
			$Index = index($TemplateSegment, "[[LOOP,$Tag]]", $IndexLeveling);
			if ($Index == $IndexLeveling) {
				last;
			} else {
				$Index = index($TemplateSegment, "[[LOOP,$Tag:", $IndexLeveling);
				if ($Index == $IndexLeveling) {
					last;
				} else {
					$Index = index($TemplateSegment, "[[LOOP,*]]", $IndexLeveling);
					if ($Index == $IndexLeveling) {
						last;
					} else {
						$Index = index($TemplateSegment, "[[LOOP,>*]]", $IndexLeveling);
						if ($Index == $IndexLeveling) {
							last;
						}
					}
				}
			}

			$LoopLevel = 1;
			while($LoopLevel > 0) {
				$IndexLoop = index($TemplateSegment, '[[LOOP', $IndexLeveling + 1);
				$IndexEndloop = index($TemplateSegment, '[[ENDLOOP', $IndexLeveling + 1);
				if ($IndexEndloop > -1) {
					if ($IndexLoop == -1 || $IndexLoop > $IndexEndloop) {
						$LoopLevel -= 1;
						$IndexLeveling = $IndexEndloop;
					} else {
						$LoopLevel += 1;
						$IndexLeveling = $IndexLoop;
					} 
				} else {
					print CODE "\n[ERROR: Endloop of $Tag not found within sequence]\n";
					exit;
				}
			}
		}

		if ($Index > -1) {
			$StackTemplateSegment[$StackIndex+1] = $TemplateSegment;
			$StackTag[$StackIndex+1] = $Tag;
			ProcessTemplateSegmentLoop (1, $NodeIndex, $DfltTag, substr($TemplateSegment, $Index));
		}
	}
}

###########################
sub ProcessTemplateTemplate {
#
# Voer Template vanuit Model uit.
#
# [[TEMPLATE:ref>]]
# ref = <tag>[(location)][property Number][:functie] 
#
my ($FlagSequence, $NodeIndex, $DfltTag, $TemplateSegment) = @_;
my ($Index2, $IndexColon, $IndexSegment);
my ($ModelTemplate);

	$Index2 = index($TemplateSegment, ']]');
	$IndexSegment = $Index2 + 2;
	if ($Index2 > -1) {
		$IndexColon = index($TemplateSegment, ':');
		if ($IndexColon > -1 && $IndexColon < $Index2) {
			$ModelTemplate = "<<".substr($TemplateSegment, $IndexColon+1, $Index2-$IndexColon-1).">>";
			PerformReplace ($ModelTemplate);
###			print CODE "###".$ModelTemplate."###";
			ProcessTemplateSegment ($FlagSequence, $NodeIndex, $DfltTag, $ModelTemplate);
		} else {
			print CODE "\n[ERROR: No semicolon in TEMPLATE]\n";
			exit;
		}
	} else {
		print CODE "\n[ERROR: End of TEMPLATE-tag ']]' not found]\n";
		exit;
	}
	ProcessTemplateSegment ($FlagSequence, $NodeIndex, $DfltTag, substr($TemplateSegment, $IndexSegment));
}
#############################

sub ProcessLeveling {
#
# Bepaal het einde '[[END' van het struktuur statement.
#
my ($StartTag, $EndTag, $LoopLevel, $IndexLeveling, $IndexLoop, $IndexEndloop);
	$StartTag = "[[" . @_[1];
	$EndTag = "[[END" . @_[1];
	$IndexLeveling =  @_[2];
	$LoopLevel = 1;
	while($LoopLevel > 0) {
		$IndexLoop = index(@_[0], $StartTag, $IndexLeveling + 1);
		$IndexEndloop = index(@_[0], $EndTag, $IndexLeveling + 1);
		if ($IndexEndloop > -1) {
			if ($IndexLoop == -1 || $IndexLoop > $IndexEndloop) {
				$LoopLevel -= 1;
				$IndexLeveling = $IndexEndloop;
			} else {
				$LoopLevel += 1;
				$IndexLeveling = $IndexLoop;
			} 
		} else {
			print CODE "\n[ERROR: End tag $EndTag... not found]\n";
			exit;
		}
	}
	return $IndexEndloop;
}

sub DetermineStackPointerTagN {
#
# Bepaal positie N van de tag in de stack.
#
my ($Tag) = @_;
my ($I);
	if ($Tag eq '*' || $Tag eq '>*') { 
		for ($I = $StackIndex; $I > -1; $I--) {
			if ($StackFlagWildcard[$I]) {
				return $I;
			}
		}
		if ($I == -1) {
			print CODE "\n[ERROR: Tag for wildcard not found ($StackIndex)]\n";
			exit;
		}
	} else {
		for ($I = $StackIndex; $I > -1; $I--) {
			if ($Tag eq $StackTag[$I]) {
				return $I;
			}
		}
		if ($I == -1) {
			print CODE "\n[ERROR: Tag $Tag not found ($StackIndex)]\n";
			exit;
		}
	}
}

sub DetermineStackPointerTagV {
#
# Bepaal positie V van de tag in de stack, going down from Index.
#
my ($Tag, $Index) = @_;
my ($I);
	if ($Tag eq '*') { 
		for ($I = $Index; $I > -1; $I--) {
			if ($StackFlagWildcard[$I] && $StackTagValidWildcard[$I]) {
				last;
			}
		}
	} else {
		for ($I = $Index; $I > -1; $I--) {
			if ($Tag eq $StackTag[$I] && $StackTagValid[$I]) {
				last;
			}
		}
	}
	return $I;
}

sub ProcessLocator {
my ($IndexN, $IndexV, $Loc) = @_;
my ($I);

	if ($Loc eq 'N') {
		$I = $IndexN;
	} elsif (substr($Loc,0,2) eq 'N-') {
		$I = $IndexN-substr($Loc,2);
	} elsif (substr($Loc,0,2) eq 'N+') {
		$I = $IndexN+substr($Loc,2);
	} elsif ($Loc eq 'V') {
		$I = $IndexV;
	} elsif (substr($Loc,0,2) eq 'V-') {
		if ($IndexV < 0) {
			$I = -1;
		} else {
			$I = $IndexV-substr($Loc,2);
		}
	} elsif (substr($Loc,0,2) eq 'V+') {
		if ($IndexV < 0) {
			$I = -1;
		} else {
			$I = $IndexV+substr($Loc,2);
		}
	} else {
		$I = $Loc;
	}
	if ($I > $IndexN) {
		return -1;
	} elsif ($I <= 0) {
		return -1;
	} else {
		return $I;
	}
	if ($I == 0) {
		print CODE "\n[ERROR: Invalid Locator '$Loc' in loop specification]\n";
	}		
}

sub PerformReplace {
#
# Vervang de <<ref>> referenties.
# ref = <tag>[(location)][property Number][:functie] 
# location = [N|N-1|N-2|V+1|V|V-1| etc...]
# Functies:
#	U: Upper Case
#	L: Lower Case
#	N: UniekNummer
#	S: Subnummer (binnen parent)
#	I: Id
#	H: HTML escapes including linefeeds
#	HE: HTML escapes excluding linefeeds
#	P: % escapes
#	C: Camel Case
#	IX: Index
# ref = *TAG[:functie] geeft de tag.

my ($Tag, $TagUpper, $TagLower, $TagCamel, $Id, $Name, $Index, $NameUpper, $NameLower, $NameCamel, $NrString, $SubNrString, $HtmlString, $HtmlStringE, $PercString);
my ($I, $V, $JN, $JV, $K, $LocN, $LocI, $FlagTwoTimes, $IndexN, $IndexV);

	for ($I = $StackIndex; $I >= 0; $I--) {
		if (index($_[0],'<<') == -1 ){
			last;
		}

		$LocI = $StackTagIndex[$I];
		if ($I == $StackIndex || $StackTag[$I] ne $StackTag[$I+1]) {
			$IndexN = DetermineStackPointerTagN($StackTag[$I]);
			$IndexV = DetermineStackPointerTagV($StackTag[$I], $IndexN);
			$JN = $LocI - $StackTagIndex[$IndexN];
			if ($JN == 0) {
				$LocN = "N";
			} else {
				$LocN = "N$JN";
			}
			$JV = $LocI - $StackTagIndex[$IndexV]; 
		} else {
			$JN--;
			$LocN = "N$JN";
			$JV--;
		}

		$Tag = $StackTag[$I];
		if ($StackFlagWildcard[$I]) {
			$TagUpper = uc $Tag;
			$TagLower = lc $Tag;
			$TagCamel = $TagLower;
			$TagCamel =~ s/(_[a-z])/\U$1/g;
			$TagCamel =~ s/_//g;
			$TagCamel =~ s/(.)/\u$1/;
			$_[0] =~ s/<<\*TAG>>/$Tag/g ;
			$_[0] =~ s/<<\*TAG:U>>/$TagUpper/g ;
			$_[0] =~ s/<<\*TAG:L>>/$TagLower/g ;
			$_[0] =~ s/<<\*TAG:C>>/$TagCamel/g ;
		}

		if (substr($Tag,0,1) eq "^") {
			$Tag = "\\" . $Tag;
		}

		$NrString = sprintf("%05d", $StackNumber[$I]);
		$SubNrString = sprintf("%03d", $StackSubNumber[$I]);
		$Id = $StackId[$I];

		if ($StackFlagWildcard[$I]) {
			$FlagTwoTimes = 1;
		} else {
			$FlagTwoTimes = 0;
		}

		while(1) {
			$Name = $StackName[$I];
			$Index = $StackIx[$I];
			$NameUpper = uc $Name;
			$NameLower = lc $Name;
			$HtmlStringE = encode_entities($Name);
			$HtmlString = $HtmlStringE;
			$HtmlString =~ s/\n/<br>/g;
			$NameCamel = $NameLower;
			$NameCamel =~ s/(_[a-z])/\U$1/g;
			$NameCamel =~ s/_//g;
			$NameCamel =~ s/(.)/\u$1/;
			$PercString = uri_escape($Name);
			$PercString =~ s/'/%27/g;
			if ($StackTagValid[$I]) {
				$_[0] =~ s/<<$Tag>>/$Name/g ;
				$_[0] =~ s/<<$Tag:I>>/$Id/g ;
				$_[0] =~ s/<<$Tag:U>>/$NameUpper/g ;
				$_[0] =~ s/<<$Tag:L>>/$NameLower/g ;
				$_[0] =~ s/<<$Tag:N>>/$NrString/g ;
				$_[0] =~ s/<<$Tag:S>>/$SubNrString/g ;
				$_[0] =~ s/<<$Tag:H>>/$HtmlString/g ;
				$_[0] =~ s/<<$Tag:HE>>/$HtmlStringE/g ;
				$_[0] =~ s/<<$Tag:P>>/$PercString/g ;
				$_[0] =~ s/<<$Tag:C>>/$NameCamel/g ;
				$_[0] =~ s/<<$Tag:IX>>/$Index/g ;
			}
			$_[0] =~ s/<<$Tag\($LocN\)>>/$Name/g ;
			$_[0] =~ s/<<$Tag\($LocN\):I>>/$Id/g ;
			$_[0] =~ s/<<$Tag\($LocN\):U>>/$NameUpper/g ;
			$_[0] =~ s/<<$Tag\($LocN\):L>>/$NameLower/g ;
			$_[0] =~ s/<<$Tag\($LocN\):N>>/$NrString/g ;
			$_[0] =~ s/<<$Tag\($LocN\):S>>/$SubNrString/g ;
			$_[0] =~ s/<<$Tag\($LocN\):H>>/$HtmlString/g ;
			$_[0] =~ s/<<$Tag\($LocN\):HE>>/$HtmlStringE/g ;
			$_[0] =~ s/<<$Tag\($LocN\):P>>/$PercString/g ;
			$_[0] =~ s/<<$Tag\($LocN\):C>>/$NameCamel/g ;
			$_[0] =~ s/<<$Tag\($LocN\):IX>>/$Index/g ;

			$_[0] =~ s/<<$Tag\($LocI\)>>/$Name/g ;
			$_[0] =~ s/<<$Tag\($LocI\):I>>/$Id/g ;
			$_[0] =~ s/<<$Tag\($LocI\):U>>/$NameUpper/g ;
			$_[0] =~ s/<<$Tag\($LocI\):L>>/$NameLower/g ;
			$_[0] =~ s/<<$Tag\($LocI\):N>>/$NrString/g ;
			$_[0] =~ s/<<$Tag\($LocI\):S>>/$SubNrString/g ;
			$_[0] =~ s/<<$Tag\($LocI\):H>>/$HtmlString/g ;
			$_[0] =~ s/<<$Tag\($LocI\):HE>>/$HtmlStringE/g ;
			$_[0] =~ s/<<$Tag\($LocI\):P>>/$PercString/g ;
			$_[0] =~ s/<<$Tag\($LocI\):C>>/$NameCamel/g ;
			$_[0] =~ s/<<$Tag\($LocI\):IX>>/$Index/g ;

			if ($JV == 0) {
				$_[0] =~ s/<<$Tag\(V\)>>/$Name/g ;
				$_[0] =~ s/<<$Tag\(V\):I>>/$Id/g ;
				$_[0] =~ s/<<$Tag\(V\):U>>/$NameUpper/g ;
				$_[0] =~ s/<<$Tag\(V\):L>>/$NameLower/g ;
				$_[0] =~ s/<<$Tag\(V\):N>>/$NrString/g ;
				$_[0] =~ s/<<$Tag\(V\):S>>/$SubNrString/g ;
				$_[0] =~ s/<<$Tag\(V\):H>>/$HtmlString/g ;
				$_[0] =~ s/<<$Tag\(V\):HE>>/$HtmlStringE/g ;
				$_[0] =~ s/<<$Tag\(V\):P>>/$PercString/g ;
				$_[0] =~ s/<<$Tag\(V\):C>>/$NameCamel/g ;
				$_[0] =~ s/<<$Tag\(V\):IX>>/$Index/g ;
			} elsif ($JV > 0) {
				$_[0] =~ s/<<$Tag\(V\+$JV\)>>/$Name/g ;
				$_[0] =~ s/<<$Tag\(V\+$JV\):I>>/$Id/g ;
				$_[0] =~ s/<<$Tag\(V\+$JV\):U>>/$NameUpper/g ;
				$_[0] =~ s/<<$Tag\(V\+$JV\):L>>/$NameLower/g ;
				$_[0] =~ s/<<$Tag\(V\+$JV\):N>>/$NrString/g ;
				$_[0] =~ s/<<$Tag\(V\+$JV\):S>>/$SubNrString/g ;
				$_[0] =~ s/<<$Tag\(V\+$JV\):H>>/$HtmlString/g ;
				$_[0] =~ s/<<$Tag\(V\+$JV\):HE>>/$HtmlStringE/g ;
				$_[0] =~ s/<<$Tag\(V\+$JV\):P>>/$PercString/g ;
				$_[0] =~ s/<<$Tag\(V\+$JV\):C>>/$NameCamel/g ;
				$_[0] =~ s/<<$Tag\(V\+$JV\):IX>>/$Index/g ;
			} else {
				$_[0] =~ s/<<$Tag\(V$JV\)>>/$Name/g ;
				$_[0] =~ s/<<$Tag\(V$JV\):I>>/$Id/g ;
				$_[0] =~ s/<<$Tag\(V$JV\):U>>/$NameUpper/g ;
				$_[0] =~ s/<<$Tag\(V$JV\):L>>/$NameLower/g ;
				$_[0] =~ s/<<$Tag\(V$JV\):N>>/$NrString/g ;
				$_[0] =~ s/<<$Tag\(V$JV\):S>>/$SubNrString/g ;
				$_[0] =~ s/<<$Tag\(V$JV\):H>>/$HtmlString/g ;
				$_[0] =~ s/<<$Tag\(V$JV\):HE>>/$HtmlStringE/g ;
				$_[0] =~ s/<<$Tag\(V$JV\):P>>/$PercString/g ;
				$_[0] =~ s/<<$Tag\(V$JV\):C>>/$NameCamel/g ;
				$_[0] =~ s/<<$Tag\(V$JV\):IX>>/$Index/g ;
			}

			for ($V = 1; $V <= $StackValueCount[$I]; $V++) {
				$Name = $StackValue[$I][$V];
				$NameUpper = uc $Name;
				$NameLower = lc $Name;
				$HtmlStringE = encode_entities($Name);
				$HtmlString = $HtmlStringE;
				$HtmlString =~ s/\n/<br>/g;
				$NameCamel = $NameLower;
				$NameCamel =~ s/(_[a-z])/\U$1/g;
				$NameCamel =~ s/_//g;
				$NameCamel =~ s/(.)/\u$1/;
				$PercString = uri_escape($Name);
				$PercString =~ s/'/%27/g;
				if ($StackTagValid[$I]) {
					$_[0] =~ s/<<$Tag$V>>/$Name/g;
					$_[0] =~ s/<<$Tag$V:U>>/$NameUpper/g;
					$_[0] =~ s/<<$Tag$V:L>>/$NameLower/g;
					$_[0] =~ s/<<$Tag$V:H>>/$HtmlString/g;
					$_[0] =~ s/<<$Tag$V:HE>>/$HtmlStringE/g;
					$_[0] =~ s/<<$Tag$V:P>>/$PercString/g;
					$_[0] =~ s/<<$Tag$V:C>>/$NameCamel/g;
				}
				$_[0] =~ s/<<$Tag\($LocN\)$V>>/$Name/g;
				$_[0] =~ s/<<$Tag\($LocN\)$V:U>>/$NameUpper/g;
				$_[0] =~ s/<<$Tag\($LocN\)$V:L>>/$NameLower/g;
				$_[0] =~ s/<<$Tag\($LocN\)$V:H>>/$HtmlString/g;
				$_[0] =~ s/<<$Tag\($LocN\)$V:HE>>/$HtmlStringE/g;
				$_[0] =~ s/<<$Tag\($LocN\)$V:P>>/$PercString/g;
				$_[0] =~ s/<<$Tag\($LocN\)$V:C>>/$NameCamel/g;

				$_[0] =~ s/<<$Tag\($LocI\)$V>>/$Name/g;
				$_[0] =~ s/<<$Tag\($LocI\)$V:U>>/$NameUpper/g;
				$_[0] =~ s/<<$Tag\($LocI\)$V:L>>/$NameLower/g;
				$_[0] =~ s/<<$Tag\($LocI\)$V:H>>/$HtmlString/g;
				$_[0] =~ s/<<$Tag\($LocI\)$V:HE>>/$HtmlStringE/g;
				$_[0] =~ s/<<$Tag\($LocI\)$V:P>>/$PercString/g;
				$_[0] =~ s/<<$Tag\($LocI\)$V:C>>/$NameCamel/g;

				if ($JV == 0) {
					$_[0] =~ s/<<$Tag\(V\)$V>>/$Name/g ;
					$_[0] =~ s/<<$Tag\(V\)$V:U>>/$NameUpper/g ;
					$_[0] =~ s/<<$Tag\(V\)$V:L>>/$NameLower/g ;
					$_[0] =~ s/<<$Tag\(V\)$V:H>>/$HtmlString/g ;
					$_[0] =~ s/<<$Tag\(V\)$V:HE>>/$HtmlStringE/g ;
					$_[0] =~ s/<<$Tag\(V\)$V:P>>/$PercString/g ;
					$_[0] =~ s/<<$Tag\(V\)$V:C>>/$NameCamel/g ;
				} elsif ($JV > 0) {
					$_[0] =~ s/<<$Tag\(V\+$JV\)$V>>/$Name/g ;
					$_[0] =~ s/<<$Tag\(V\+$JV\)$V:U>>/$NameUpper/g ;
					$_[0] =~ s/<<$Tag\(V\+$JV\)$V:L>>/$NameLower/g ;
					$_[0] =~ s/<<$Tag\(V\+$JV\)$V:H>>/$HtmlString/g ;
					$_[0] =~ s/<<$Tag\(V\+$JV\)$V:HE>>/$HtmlStringE/g ;
					$_[0] =~ s/<<$Tag\(V\+$JV\)$V:P>>/$PercString/g ;
					$_[0] =~ s/<<$Tag\(V\+$JV\)$V:C>>/$NameCamel/g ;
				} else {
					$_[0] =~ s/<<$Tag\(V$JV\)$V>>/$Name/g ;
					$_[0] =~ s/<<$Tag\(V$JV\)$V:U>>/$NameUpper/g ;
					$_[0] =~ s/<<$Tag\(V$JV\)$V:L>>/$NameLower/g ;
					$_[0] =~ s/<<$Tag\(V$JV\)$V:H>>/$HtmlString/g ;
					$_[0] =~ s/<<$Tag\(V$JV\)$V:HE>>/$HtmlStringE/g ;
					$_[0] =~ s/<<$Tag\(V$JV\)$V:P>>/$PercString/g ;
					$_[0] =~ s/<<$Tag\(V$JV\)$V:C>>/$NameCamel/g ;
				}
			}
			if ($FlagTwoTimes) {
				$FlagTwoTimes = 0;
				$Tag = '\*';
			} else {
				last;
			}
		} 
	}	
	if ($IndentLevel > 0) {
		for ($I = 1; $I <= $IndentLevel; $I++) {
			$_[0] =~ s/\n/\n\t/g;
		}		
	}
}

sub ExportCode {
my ($ExportString) = @_;
	PerformTabs($ExportString);
	PerformReplace($ExportString);
	PerformPerl($ExportString,"EVAL");
	PerformValue($ExportString);
	ExportCodeFile($ExportString);
}

sub ExportCodeFile {
#
# Open eventueel een nieuwe file en exporteer de code.
# [[FILE,<filename>>]]
#
my ($IndexFile, $Index2);

	$IndexFile = index($_[0], '[[FILE,');
	if ($IndexFile > -1) {
		$Index2 = index($_[0], ']]', $IndexFile);
		if ($Index2 > -1) {
			$CodeFile = substr($_[0], $IndexFile+7, $Index2-$IndexFile-7);
			if ($IndexFile > 0) {
				print CODE substr($_[0],0,$IndexFile);
			}
			print "Generating Code    : $CodeFile\n";
			$CODE = "$CodeFile";
			open CODE, ">$CODE" or die "Cannot open $CODE:$!";
			if (length($_[0]) > $Index2+1) {
				print CODE substr($_[0],$Index2+2);
			}
		} else {
			print CODE "\n[ERROR: End of FILE-tag ']]' not found]\n";
			exit;
		}
	} else {
		print CODE $_[0];
	}
}

sub EvaluateCondition {
#
# !(<condition>[AND](<condition>[OR]<condition>[OR]<condition>)OR<condition>) etc....
#
my ($Condition, $INode, $IStack, $Tag) = @_;
my (@CondItem, $Index, $J, $J1, $J2, $P, $P1, $Result, $Level);
	$P = 0;
	$P1 = 0;
	$Index = 0;
	$Level = 0;
	while(1) {
		$J = index(substr($Condition,$P), '[OR]');
		$J1 = index(substr($Condition,$P), '(');
		$J2 = index(substr($Condition,$P), ')');
		if ($Level == 0 && ($J <= $J1 || $J1 == -1)) {
			if($J > -1) {
				$CondItem[$Index] = substr($Condition, $P1, $J+($P-$P1));
				$P = $P + $J + 4;
				$P1 = $P;
				$Index = $Index + 1;
			} else {
				$CondItem[$Index] = substr($Condition, $P1);
				last;
			} 
		} else {
			if ($J1 > -1 || $J2 > -1) {
				if ($J1 == -1 || $J1 > $J2) {
					$Level -= 1;
					$P = $P + $J2 + 1;
				} else {
					$Level += 1;
					$P = $P + $J1 + 1;
				}
			} elsif ($Level != 0) {
					print CODE "\n[ERROR: End parenthesis not found in $Condition ]\n";
					exit;
			}
		}
		if ($Level < 0) {
			print CODE "\n[ERROR: Start parenthesis not found in $Condition ]\n";
			exit;
		}
	}

	if ($Index > 0) {
		$Result = 0;
		for ($J = 0; $J <= $Index; $J++) {
			$Result = $Result || EvaluateCondition($CondItem[$J], $INode, $IStack, $Tag);
		}
		return $Result;
	}

	$P = 0;
	$P1 = 0;
	$Index = 0;
	$Level = 0;
	while(1) {
		$J = index(substr($Condition,$P), '[AND]');
		$J1 = index(substr($Condition,$P), '(');
		$J2 = index(substr($Condition,$P), ')');
		if ($Level == 0 && ($J <= $J1 || $J1 == -1)) {
			if($J > -1) {
				$CondItem[$Index] = substr($Condition, $P1, $J+($P-$P1));
				$P = $P + $J + 5;
				$P1 = $P;
				$Index = $Index + 1;
			} else {
				$CondItem[$Index] = substr($Condition, $P1);
				last;
			} 
		} else {
			if ($J1 > -1 || $J2 > -1) {
				if ($J1 == -1 || $J1 > $J2) {
					$Level -= 1;
					$P = $P + $J2 + 1;
				} else {
					$Level += 1;
					$P = $P + $J1 + 1;
				}
			} elsif ($Level != 0) {
					print CODE "\n[ERROR: End parenthesis not found in $Condition ]\n";
					exit;
			}
		}
		if ($Level < 0) {
			print CODE "\n[ERROR: Start parenthesis not found in $Condition ]\n";
			exit;
		}
	}

	if ($Index > 0) {
		$Result = 1;
		for ($J = 0; $J <= $Index; $J++) {
			$Result = $Result && EvaluateCondition($CondItem[$J], $INode, $IStack, $Tag);
		}
		return $Result;
	}

	if (substr($Condition,0,2) eq "!(") {
		$P = length($Condition);
		if (substr($Condition,$P-1) ne ")") {
			print CODE "\n[ERROR: Missing end parenthesis in $Condition ]\n";
			exit;
		}
		$Condition = substr($Condition,2,$P-3);
		$Result = EvaluateCondition($Condition, $INode, $IStack, $Tag);
		if ($Result) {
			return 0;
		} else { 
			return 1;
		}
	}
	if (substr($Condition,0,1) eq "(") {
		$P = length($Condition);
		if (substr($Condition,$P-1) ne ")") {
			print CODE "\n[ERROR: Missing end parenthesis in $Condition ]\n";
			exit;
		}
		$Condition = substr($Condition,1,$P-2);
		return EvaluateCondition($Condition, $INode, $IStack, $Tag);
	}

	return EvaluateConditionItem($Condition, $INode, $IStack, $Tag);
}

sub EvaluateConditionItem {
#
# !				Not
# [<TAG>.]FIRST				Eerste in groep
# [<TAG>.]LAST				Laatste in groep
# [<TAG>.]ROOT				Hoogste in REPEAT structuur
# [<TAG>.]LEVEL(<repeat level>)		Is van level in repeat
# [<TAG>.]CHILD(<tag>:<condition>)	Bestaat child
# [<TAG>.]PARENT(<tag>:<condition>)	Bestaat parent
# [<TAG>.]ID(<value>)			Heeft ID
# [<TAG>.]TAG(<value>)			Heeft Tag
# P<number>=<value>			Parameter 1..n=Value
# [<TAG>.]<number>=<value>		0=Naam 1..n=Value
# EVAL:...				Perl result true/false
#
my ($Condition, $INode, $IStack, $Tag) = @_;
my ($ChildTag, $ChildCondition, $ParentTag, $ParentCondition, $Id, $Index1,  $IndexPoint, $IndexColon, $CondValue, $ValueIndex, $True, $False, $I, $J, $K, $P);
my ($Loc, $ILocStack, $IndexN, $IndexV);
my ($PerlString, $PerlResult, $LoopElement);

	$Condition =~ s/^\s+//; # Left trim white spaces
	if (substr($Condition,0,1) eq "!") {
		$True = 0;
		$False = 1;
		$Condition = substr($Condition,1);
		$Condition =~ s/^\s+//; # Left trim white spaces
	} else {
		$True = 1;
		$False = 0;
	}
	$IndexPoint = index($Condition, '.');
	if ($IndexPoint == 0) {
		print CODE "\n[ERROR: No tag (before point) in condition item]\n";
		exit;
	}

	$Index1 = index($Condition, "EVAL:");
	if ($Index1 == -1) {
		$Condition =~ s/\s+//g;	# Remove white spaces	
	}	
	if ($IndexPoint > -1) {
		for $LoopElement ("=","CHILD(","PARENT(","FIRST","LAST","ROOT","LEVEL(","TAG(","EVAL:") {
			$Index1 = index($Condition, $LoopElement);
			if ($Index1 > -1 && $Index1 < $IndexPoint) { 
				$IndexPoint = -1;
				last;
			}
   		}
	}
	
	if ($IndexPoint > -1) {
		$Tag = substr($Condition,0,$IndexPoint);
		ProcessTag($Tag, $INode, $IStack);
		$Condition = substr($Condition,$IndexPoint+1);
	}
	if ($Condition eq "none") {
		return $True;
	} elsif (substr($Condition,0,6) eq "CHILD(") {

		$P = length($Condition);
		if (substr($Condition,$P-1) ne ")") {
			print CODE "\n[ERROR: Missing end parenthesis in $Condition ]\n";
			exit;
		}
		$IndexColon = index($Condition, ':');
		if ($IndexColon == -1) {
			$ChildTag = substr($Condition,6,$P-7);
			$ChildCondition = 'none'
		} else {
			$ChildTag = substr($Condition,6,$IndexColon-6);
			$ChildCondition = substr($Condition,$IndexColon+1,$P-$IndexColon-2);
		}
		$J = $NodeFirst[$INode];
		while ($J > -1) {
			if ($NodeString[$J] eq $ChildTag) {
				if ($ChildCondition ne 'none') {
					$I = $NodeFirst[$J];
					while ($I > -1) {
						if ($NodeType[$I] eq 'P') {
							$K = $NodeRef[$I];
						} else {
							$K = $I;
						}
						if (EvaluateCondition($ChildCondition, $K, -1, $ChildTag)) {
							return $True;
						}
						$I = $NodeNext[$I];
					}
					return $False;
				} else {
					return $True;
				}
			}
			$J = $NodeNext[$J];
		}
		return $False;
	} elsif (substr($Condition,0,7) eq "PARENT(") {
		$P = length($Condition);
		if (substr($Condition,$P-1) ne ")") {
			print CODE "\n[ERROR: Missing end parenthesis in $Condition ]\n";
			exit;
		}
		$IndexColon = index($Condition, ':');
		if ($IndexColon == -1) {
			$ParentTag = substr($Condition,7,$P-8);
			$ParentCondition = 'none'
		} else {
			$ParentTag = substr($Condition,7,$IndexColon-7);
			$ParentCondition = substr($Condition,$IndexColon+1,$P-$IndexColon-2);
		}
		$I = $NodeParent[$NodeParent[$INode]];
		while ($I > -1) {
			if ($NodeString[$NodeParent[$I]] eq $ParentTag) {
				if ($ParentCondition ne 'none') {
					if (EvaluateCondition($ParentCondition, $I, -1, $ParentTag)) {
						return $True;
					} else {
						return $False;
					}
				} else {
					return $True;
				}
			}
			$I = $NodeParent[$NodeParent[$I]];
		}
		return $False;
	} elsif ($Condition eq "FIRST") {
		if ($IStack == -1) {
			print CODE "\n[ERROR: Condition $Condition not nested in LOOP]\n";
			exit;
		}
		$J = 0;
		while ($INode != $StackNode[$IStack][$J]) {
			if (EvaluateCondition($StackCondition[$IStack], $StackNode[$IStack][$J], $IStack, $Tag)) {
				return $False;
			}
			$J++; 
		}
		return $True;
	} elsif ($Condition eq "LAST") {
		if ($IStack == -1) {
			print CODE "\n[ERROR: Condition $Condition not nested in LOOP]\n";
			exit;
		}
		$J = $StackNodeIndex[$IStack] + 1;
		while ($StackNode[$IStack][$J] > -1) {
			if (EvaluateCondition($StackCondition[$IStack], $StackNode[$IStack][$J], $IStack, $Tag)) {
				return $False;
			}
			$J++; 
		}
		return $True;
	} elsif ($Condition eq "ROOT") {
		if ($NodeParent[$NodeParent[$INode]] == 0) {
			return $True;
		} else { 
			if ($NodeString[$NodeParent[$INode]] ne $NodeString[$NodeParent[$NodeParent[$NodeParent[$INode]]]]) {
				return $True;
			} else {
				return $False;
			}
		}
	} elsif (substr($Condition,0,6) eq "LEVEL(") {
		$P = length($Condition);
		if (substr($Condition,$P-1) ne ")") {
			print CODE "\n[ERROR: Missing end parenthesis in $Condition ]\n";
			exit;
		}
		if ($IStack == -1) {
			print CODE "\n[ERROR: Condition $Condition not nested in LOOP]\n";
			exit;
		}
		$Loc = substr($Condition,6,$P-7);
		$IndexN = DetermineStackPointerTagN($Tag);
		$IndexV = DetermineStackPointerTagV($Tag, $IndexN);
		$ILocStack = ProcessLocator ($StackTagIndex[$IndexN], $StackTagIndex[$IndexV], $Loc);
		if ($ILocStack == $StackTagIndex[$IStack] && $StackTag[$IStack] eq $Tag) {
			return $True;
		} else {
			return $False;
		}
	} elsif (substr($Condition,0,4) eq "TAG(") {
		$P = length($Condition);
		if (substr($Condition,$P-1) ne ")") {
			print CODE "\n[ERROR: Missing end parenthesis in $Condition ]\n";
			exit;
		}
		$Tag = substr($Condition,4,$P-5);
		if ($StackTag[$StackIndex] eq $Tag) {
			return $True;
		} else {
			return $False;
		}
	} elsif (substr($Condition,0,3) eq "ID(") {
		$P = length($Condition);
		if (substr($Condition,$P-1) ne ")") {
			print CODE "\n[ERROR: Missing end parenthesis in $Condition ]\n";
			exit;
		}
		$Id = substr($Condition,3,$P-4);
		PerformReplace($Id);
		if ($StackId[$StackIndex] eq $Id) {
			return $True;
		} else {
			return $False;
		}
	} elsif (substr($Condition,0,1) eq "P") {
		$Index1 = index($Condition, '=');
		if ($Index1 > -1) {
			$ValueIndex = substr($Condition, 1, $Index1-1);
			if ($ValueIndex == 0 && $ValueIndex ne '0') {
				print CODE "[ERROR: Invalid parameter number $ValueIndex in condition.]";
				exit;
			}
			if ($ValueIndex >= 1 && $ValueIndex <= $#ARGV-2) {
				$CondValue = substr($Condition, $Index1+1);
				if ($CondValue eq @ARGV[$ValueIndex+2]) {
					return $True;
				} else {
					return $False;
				}
			} else {
				print CODE "[ERROR: Parameter number $ValueIndex in condition out of range.]";
				exit;
			}
		}
	} elsif (substr($Condition,0,5) eq "EVAL:") {
		$PerlString = substr($Condition,5);
		PerformReplace($PerlString);
		$PerlResult = eval $PerlString;
		if($PerlResult) {
			return $True;
		} else {
			return $False;
		}
	} else {
		$Index1 = index($Condition, '=');
		if ($Index1 > -1) {
			$ValueIndex = substr($Condition, 0, $Index1);
			if ($ValueIndex == 0 && $ValueIndex ne '0') {
				print CODE "[ERROR: Invalid number $ValueIndex in condition.]";
				exit;
			}
			if ($ValueIndex <= $NodeValueCount[$INode])  {
				$CondValue = substr($Condition, $Index1+1);
				PerformReplace($CondValue);
				if ($ValueIndex == 0) {
					if ($NodeString[$INode] eq $CondValue) {
						return $True;
					} else {
						return $False;
					}
				} else {
					if ($NodeValue[$NodeValuePntr[$INode]+$ValueIndex-1] eq $CondValue ) {
						return $True;
					} else {
						return $False;
					}
				}
			} else {
				return $False;
			}
		} else {
			print CODE "[ERROR: Invalid condition $Condition]";
			exit;
		}
	}
}

sub ProcessTag {
#
# Verwerk de Tag in de condition
#
my ($Index1, $Index2, $IndexSpec);
my ($TagIndexN, $IndexV, $TagIndexV, $Pntr, $IStack, $I);

	if ($_[0] eq '#') {return;}
	$Index1 = index($_[0], '(');
	if ($Index1 > -1) {
		$Index2 = index($_[0], ')');
		if ($Index2 == -1 || $Index2 < $Index1) {
			print CODE "[ERROR: Syntax error in tag $_[0]]";
			exit;
		}
		$IndexSpec = substr($_[0],$Index1+1,$Index2-$Index1-1);
		$_[0] = substr($_[0],0,$Index1);
	} else {
		$IndexSpec = 'V';
	}
	$IStack = DetermineStackPointerTagN($_[0]);
	$TagIndexN = $StackTagIndex[$IStack];
	$IndexV = DetermineStackPointerTagV($_[0], $IStack);
	$TagIndexV = $StackTagIndex[$IndexV];
	$Pntr = ProcessLocator ($TagIndexN, $TagIndexV, $IndexSpec);
	for ($I = $IStack; $I >= 0; $I--) {
		if (($StackTag[$I] eq $_[0] || $_[0] eq '*' || $_[0] eq '>*') && $StackTagIndex[$I] == $Pntr) {
			last;
		}
	}
	$_[2] = $I;
	if ($_[2] > -1) {
		$_[1] = $StackNode[$_[2]][$StackNodeIndex[$_[2]]];
	} else {
		$_[1] = -1;
	}
}

sub EscapeModelChars {
my ($ReplaceString) = @_;

	$ReplaceString =~ s/\x25/%25/g;
	$ReplaceString =~ s/\x3B/%3B/g;
	$ReplaceString =~ s/\x22/%22/g;
	$ReplaceString =~ s/\x7C/%7C/g;
	$ReplaceString =~ s/\x0D/%0D/g;
	$ReplaceString =~ s/\x0A/%0A/g;
	$ReplaceString =~ s/\x09/%09/g;
	return $ReplaceString;
}
