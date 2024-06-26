#!/usr/bin/perl
use HTML::Entities;
use URI::Escape;
use Switch;
#
# Cube Model Import
#
($ModelFile, $ImportFile) = @ARGV;
#
# Model File Processing
# ===== ==== ==========
#
print "\n";
print "CubeGen v2.7  30 Jun 2014\n";
print "=====================================\n";
print "Reading Model\n";
######################################################################################
# Lezen van de modelfile in memory struktuur.
# Inhoud gekopieerd omdat deze wordt gedeeld tussen de generator en de model import.
######################################################################################
$MODEL="$ModelFile";
open MODEL, "$MODEL" or die "Cannot open $MODEL:$!";

$I = 0;
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
				print "Error: ']' not found at end of tag\n";
			}
			$Tag = substr($Tag, 0, $IndexBracket);
		}
	} else {
		print "Error: ':' not found\n"; 
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
		print "Error: ';' not found\n"; 
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
					print "Error: ',' not found in rel spec\n";
				}			
			}
			if ($Sign eq "=") {
				$J = $J-2;
			}
		}
	} elsif ($Sign eq "-") {
		$J = $J-2;
	} else {
		print "Error: no +,- or =\n";
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
		print NODEFILE "$i;$NodeId[$i];$NodeType[$i];" . uri_escape($NodeString[$i]) . ";$NodeNumber[$i];$NodeSubNumber[$i];$NodeParent[$i];$NodeNext[$i];$NodeFirst[$i];$NodeNextSequ[$i];$NodeFirstSequ[$i];$NodeRef[$i];\n";
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
# Generate ModelImport file
#
$IMPORT="$ImportFile";

# Parent Key Variables
$FKeyItp = '';
$FKeyIte = '';
$FKeyBot = '';
$FKeyTyp[0] = '';
$ITyp = 0;
$FKeyTsg[0] = '';
$ITsg = 0;
$FKeyAtb = '';
$FKeyRef = '';
$FKeySrv = '';
$FKeySys = '';
$FKeyFun = '';

open IMPORT, ">$IMPORT" or die "Cannot open $IMPORT:$!";

print IMPORT "----------------------------------------------------------\n";
print IMPORT "-- CubeTool Model Import DML\n";
print IMPORT "--\n";
print IMPORT "-- Model: $ModelFile\n";
print IMPORT "----------------------------------------------------------\n";
print IMPORT "--\n";
print IMPORT "-- Delete All\n";
print IMPORT "--\n";
print IMPORT "DELETE FROM itp.v_information_type;\n";
print IMPORT "DELETE FROM itp.v_information_type_element;\n";
print IMPORT "DELETE FROM itp.v_permitted_value;\n";
print IMPORT "DELETE FROM bot.v_business_object_type;\n";
print IMPORT "DELETE FROM bot.v_type;\n";
print IMPORT "DELETE FROM bot.v_type_specialisation_group;\n";
print IMPORT "DELETE FROM bot.v_type_specialisation;\n";
print IMPORT "DELETE FROM bot.v_attribute;\n";
print IMPORT "DELETE FROM bot.v_derivation;\n";
print IMPORT "DELETE FROM bot.v_description_attribute;\n";
print IMPORT "DELETE FROM bot.v_restriction_type_spec_atb;\n";
print IMPORT "DELETE FROM bot.v_reference;\n";
print IMPORT "DELETE FROM bot.v_description_reference;\n";
print IMPORT "DELETE FROM bot.v_restriction_type_spec_ref;\n";
print IMPORT "DELETE FROM bot.v_restriction_target_type_spec;\n";
print IMPORT "DELETE FROM bot.v_service;\n";
print IMPORT "DELETE FROM bot.v_service_step;\n";
print IMPORT "DELETE FROM bot.v_service_argument;\n";
print IMPORT "DELETE FROM bot.v_restriction_type_spec_typ;\n";
print IMPORT "DELETE FROM bot.v_json_path;\n";
print IMPORT "DELETE FROM bot.v_description_type;\n";
print IMPORT "DELETE FROM sys.v_system;\n";
print IMPORT "DELETE FROM sys.v_system_bo_type;\n";
print IMPORT "DELETE FROM fun.v_function;\n";
print IMPORT "DELETE FROM fun.v_argument;\n";

$i = $NodeFirst[0];
CreateInsertStmnts ($i,'');

print IMPORT "EXIT;\n";
print "Ready\n";

sub CreateInsertStmnts {
my ($i, $j, $Sequence, $FKeyFlag);
my (@FkeyValues);
	while (1) {
		if ($_[0] == -1) {
			last;
		}
		if ($NodeType[$NodeFirst[$_[0]]] ne 'P') {
			switch ($NodeString[$_[0]]) {
				case "INFORMATION_TYPE" {
					print IMPORT "--\n";
					print IMPORT "-- Insert INFORMATION_TYPE business object types\n";
					print IMPORT "--\n";
					$j = $NodeFirst[$_[0]];
					while (1) {
						if ($j == -1) {
							last;
						}
						print IMPORT "INSERT INTO itp.v_information_type (NAME)\n"; 
						print IMPORT "	VALUES ('".ReplX($NodeString[$j])."');\n";
						print IMPORT "\n";
						$FkeyValues[0] = ReplX($NodeString[$j]);
						$i = $NodeFirst[$j];
						CreateInsertStmnts($i,@FkeyValues);
						$j = $NodeNext[$j];
					}
				}
				case "INFORMATION_TYPE_ELEMENT" {
					$j = $NodeFirst[$_[0]];
					while (1) {
						if ($j == -1) {
							last;
						}
						print IMPORT "INSERT INTO itp.v_information_type_element (FK_ITP_NAME, SEQUENCE, SUFFIX, DOMAIN, LENGTH, DECIMALS, CASE_SENSITIVE, DEFAULT_VALUE, SPACES_ALLOWED, PRESENTATION)\n"; 
						print IMPORT "	VALUES ('$_[1]', ".ReplX($NodeString[$j]).", '".ReplX($NodeValue[$NodeValuePntr[$j]])."', '".ReplX($NodeValue[$NodeValuePntr[$j]+1])."', ".ReplX($NodeValue[$NodeValuePntr[$j]+2]).", ".ReplX($NodeValue[$NodeValuePntr[$j]+3]).", '".ReplX($NodeValue[$NodeValuePntr[$j]+4])."', '".ReplX($NodeValue[$NodeValuePntr[$j]+5])."', '".ReplX($NodeValue[$NodeValuePntr[$j]+6])."', '".ReplX($NodeValue[$NodeValuePntr[$j]+7])."');\n";
						print IMPORT "\n";
						$FkeyValues[0] = $_[1];
						$FkeyValues[1] = ReplX($NodeString[$j]);
						$i = $NodeFirst[$j];
						CreateInsertStmnts($i,@FkeyValues);
						$j = $NodeNext[$j];
					}
				}
				case "PERMITTED_VALUE" {
					$j = $NodeFirst[$_[0]];
					$Sequence = 0;
					while (1) {
						if ($j == -1) {
							last;
						}
						$Sequence++;
						print IMPORT "INSERT INTO itp.v_permitted_value (CUBE_SEQUENCE, FK_ITP_NAME, FK_ITE_SEQUENCE, CODE, PROMPT)\n"; 
						print IMPORT "	VALUES ($Sequence, '$_[1]', $_[2], '".ReplX($NodeString[$j])."', '".ReplX($NodeValue[$NodeValuePntr[$j]])."');\n";
						print IMPORT "\n";
						$j = $NodeNext[$j];
					}
				}
				case "BUSINESS_OBJECT_TYPE" {
					print IMPORT "--\n";
					print IMPORT "-- Insert BUSINESS_OBJECT_TYPE business object types\n";
					print IMPORT "--\n";
					$j = $NodeFirst[$_[0]];
					$Sequence = 0;
					while (1) {
						if ($j == -1) {
							last;
						}
						$Sequence++;
						print IMPORT "INSERT INTO bot.v_business_object_type (CUBE_SEQUENCE, NAME, CUBE_TSG_TYPE, DIRECTORY, API_URL)\n"; 
						print IMPORT "	VALUES ($Sequence, '".ReplX($NodeString[$j])."', '".ReplX($NodeValue[$NodeValuePntr[$j]])."', '".ReplX($NodeValue[$NodeValuePntr[$j]+1])."', '".ReplX($NodeValue[$NodeValuePntr[$j]+2])."');\n";
						print IMPORT "\n";
						$FkeyValues[0] = ReplX($NodeString[$j]);
						$i = $NodeFirst[$j];
						CreateInsertStmnts($i,@FkeyValues);
						$j = $NodeNext[$j];
					}
				}
				case "TYPE" {
					$j = $NodeFirst[$_[0]];
					$Sequence = 0;
					while (1) {
						if ($j == -1) {
							last;
						}
						$Sequence++;
						if ($NodeString[$NodeParent[$NodeParent[$_[0]]]] eq 'TYPE') {
							$FKeyFlag = 1;
						} else {
							$FKeyFlag = 0;
						}
						print IMPORT "INSERT INTO bot.v_type (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, NAME, CODE, FLAG_PARTIAL_KEY, FLAG_RECURSIVE, RECURSIVE_CARDINALITY, CARDINALITY, SORT_ORDER, ICON, TRANSFERABLE)\n"; 
						print IMPORT "	VALUES ($Sequence, '$_[1]', ".SwitchFlag($FKeyFlag,"'".$_[2]."'").", '".ReplX($NodeString[$j])."', '".ReplX($NodeValue[$NodeValuePntr[$j]])."', '".ReplX($NodeValue[$NodeValuePntr[$j]+1])."', '".ReplX($NodeValue[$NodeValuePntr[$j]+2])."', '".ReplX($NodeValue[$NodeValuePntr[$j]+3])."', '".ReplX($NodeValue[$NodeValuePntr[$j]+4])."', '".ReplX($NodeValue[$NodeValuePntr[$j]+5])."', '".ReplX($NodeValue[$NodeValuePntr[$j]+6])."', '".ReplX($NodeValue[$NodeValuePntr[$j]+7])."');\n";
						print IMPORT "\n";
						$FkeyValues[0] = $_[1];
						$FkeyValues[1] = ReplX($NodeString[$j]);
						$i = $NodeFirst[$j];
						CreateInsertStmnts($i,@FkeyValues);
						$j = $NodeNext[$j];
					}
				}
				case "TYPE_SPECIALISATION_GROUP" {
					$j = $NodeFirst[$_[0]];
					$Sequence = 0;
					while (1) {
						if ($j == -1) {
							last;
						}
						$Sequence++;
						if ($NodeString[$NodeParent[$NodeParent[$_[0]]]] eq 'TYPE_SPECIALISATION_GROUP') {
							$FKeyFlag = 1;
						} else {
							$FKeyFlag = 0;
						}
						print IMPORT "INSERT INTO bot.v_type_specialisation_group (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, FK_TSG_CODE, CODE, NAME, PRIMARY_KEY, XF_ATB_TYP_NAME, XK_ATB_NAME)\n"; 
						print IMPORT "	VALUES ($Sequence, '$_[1]', '$_[2]', ".SwitchFlag($FKeyFlag,"'".$_[3]."'").", '".ReplX($NodeString[$j])."', '".ReplX($NodeValue[$NodeValuePntr[$j]])."', '".ReplX($NodeValue[$NodeValuePntr[$j]+1])."', '".ReplX(GetXkey($j,'ATTRIBUTE','TYPE',001))."', '".ReplX(GetXkey($j,'ATTRIBUTE','ATTRIBUTE',001))."');\n";
						print IMPORT "\n";
						$FkeyValues[0] = $_[1];
						$FkeyValues[1] = $_[2];
						$FkeyValues[2] = ReplX($NodeString[$j]);
						$i = $NodeFirst[$j];
						CreateInsertStmnts($i,@FkeyValues);
						$j = $NodeNext[$j];
					}
				}
				case "TYPE_SPECIALISATION" {
					$j = $NodeFirst[$_[0]];
					$Sequence = 0;
					while (1) {
						if ($j == -1) {
							last;
						}
						$Sequence++;
						print IMPORT "INSERT INTO bot.v_type_specialisation (CUBE_SEQUENCE, FK_BOT_NAME, FK_TYP_NAME, FK_TSG_CODE, CODE, NAME, XF_TSP_TYP_NAME, XF_TSP_TSG_CODE, XK_TSP_CODE)\n"; 
						print IMPORT "	VALUES ($Sequence, '$_[1]', '$_[2]', '$_[3]', '".ReplX($NodeString[$j])."', '".ReplX($N