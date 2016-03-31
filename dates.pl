#!/usr/bin/perl -w
# Miklós Bán banm@vocs.unideb.hu 2012.06.22 & 2016.03.31 + 0 day 
# USE libdate-calc-perl
# USE POSIX
# @ GPL

my $date = $ARGV[0];
my $diff_date = $ARGV[1];
my $verbose = $ARGV[2]; # verbose output
# nincs használva
#$ymd = $ARGV[3];

if (@ARGV==0) {
    if (-t STDIN) {
        print "Type date arguments: date1 date2|days\n";
    }
	my $buf = <STDIN>;
	chop $buf;
	($date,$diff_date,$verbose) = split / /, $buf;
}
# Params check
if (!defined $date || $date eq '') {
    print "No date-1 defined!\n";
    exit;
}
if (!defined $diff_date || $diff_date eq '') {
    print "No date-2 defined!\n";
    exit;
}
if (!defined $verbose || $verbose eq '') {
    $verbose = 0;
}

# ymd = 'ymd';
# array('year','month','day')
# ... a különbötő dátum típusok kezelése....

# csak hónap nap van megadva a dátumnak
# kiegészíti az idei évvel
if ($date =~ /^(\d{1,2})[^0-9](\d{1,2})$/) {
	($month,$day) = ($1,$2);
	$year = `date +'%Y'`;
	chop $year;
} else {
    # teljes dátum van megadva
	$date =~ /(\d{4})[^0-9](\d{1,2})[^0-9](\d{1,2})/;
	($year,$month,$day) = ($1,$2,$3);
}

# diff date: csak hónap nap van megadva, kiegészíti az idei évvel
if ($diff_date =~ /^(\d{1,2})[^0-9](\d{1,2})$/) {
	$diff_date = sprintf "%s-%s",$1,$2;
	$dyear = `date +'%Y'`;
	chop $dyear;
	$diff_date = sprintf "%s-%s",$dyear,$diff_date;
}
#	print "[$year-$month-$day] $diff_date\n";

# diff date: év hónap nap formátumban
# RETURN DAYS
if ($diff_date =~ /\d{4}[^0-9]\d{1,2}[^0-9]\d{1,2}/) 
{
	# két dátum különbsége
	$isare = 'is';
	$s = '';
    use Date::Calc qw(Delta_Days);
	$Dd = Delta_Days($year,$month,$day,split(/[^0-9]/,$diff_date));

    if ($verbose) {
	    if ($Dd > 1) { 
            $isare = 'are';
            $s = 's';
        }
        use POSIX;
		printf "The difference between %s and %s %s %d day%s; %d week%s","$year-$month-$day",$diff_date,$isare,$Dd,$s,ceil($Dd/7),$s;
	} else {
	    printf "%d",$Dd;
    }
} else {
    # passing weeks as interval!
    if ($diff_date =~ /([0-9]+)w/) {
        $diff_date = $1*7;
    }
    # diff date 
	# +- napok
    # formátumban
    # RETURN DATE
	$s = '';
	$isare = 'is';
	$plus = 'plus';
	if ($diff_date > 1) { $s = 's'; } elsif ($diff_date < 1) { if ($diff_date < -1) { $s='s';}; $plus='minus'; }
	use Date::Calc qw(Add_Delta_Days);
	($Year, $Month, $Day) = Add_Delta_Days($year,$month,$day,$diff_date);
    $Month = sprintf "%02d",$Month;
    $Day = sprintf "%02d",$Day;

    if ($verbose) {
	    if ($diff_date > 1) { 
            $s = 's';
        }
		printf "%s %s %d day%s %s %s","$year-$month-$day",$plus,abs($diff_date),$s,$isare,"$Year-$Month-$Day";	
	} else {
	    print "$Year-$Month-$Day";
    }

}
print "\n";
