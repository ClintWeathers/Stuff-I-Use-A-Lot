#!/usr/bin/perl
use strict;
use LWP::Simple;

&countWords();
my %wordCount;

print "print the number of time \"Hamlet\" is used in Hamlet: \n";
foreach my $key (keys %wordCount) {
    if ($key =~ /Hamlet/) {
        print "$key => $wordCount{$key}\n";
    }
}

sub countWords()
{
    my $line = get('http://shakespeare.mit.edu/hamlet/full.html')
      or die 'Unable to get the page. Sorry.';

    my @line_words = split(/\W/, $line);
    foreach my $word (@line_words) {
        if ($wordCount{$word}) {
            $wordCount{$word}++;
        }
        else {
            $wordCount{$word} = 1;
        }
    }
}

