BEGIN {
    my $log;

    if (exists $ENV{MCTEST} and $ENV{MCTEST}) {
        $ENV{MCDEBUG} = 1;
        open $log, ">>", ",,debug.log" or die "Couldn't open ,,debug.log";
        $log->autoflush (1);
    }

    if ($ENV{MCDEBUG}) {
        *DEBUG = sub () {1};
    } else {
        *DEBUG = sub () {0};
    }

    *LOG = sub (@) {
        local $Data::Dumper::Indent = 1;
        local $Data::Dumper::Quotekeys = 0;
        local $Data::Dumper::Sortkeys = 1;
        local $Data::Dumper::Terse = 1;
        my $format = shift or return;
        chomp (my $entry = @_ ? sprintf $format, map {
            if (defined $_) {
                if (ref $_) {
                    if (blessed $_ and $_->can ('as_string')) {
                        $_->as_string;
                    } else {
                        Dumper $_;
                    }
                } else {
                    $_
                }
            } else {
                '[undef]'
            }
        } @_ : $format);
        # my $output = "$callerinfo[3] $entry\n";
        my $output = "$entry\n";
        if ($ENV{MCTEST}) {
            $log->print ($output);
        } else {
            warn $output;
        }
    };
}

1;
