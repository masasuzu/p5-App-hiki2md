# vim: ft=perl
package App::hiki2md;
use 5.008001;
use strict;
use warnings;
use feature qw( say );
use File::Slurp qw( read_file );

our $VERSION = "0.01";

sub run {
    my ($class, $file) = @_;
    die "no file specified" unless $file;
    die "not exist: $file" unless -f $file;

    open my $fh, '<', $file;
    my $md_text = $class->convert($fh);
    say $md_text;
}

sub convert {
    my ($class, $fh) = @_;

    my @outputs;

    my $in_plugin_block;
    my $in_table_block;
    my $in_preformated_block;
    while (my $line = <$fh>) {
        chomp $line;
        # プラグイン削除
        if ($in_plugin_block) {
            if ($line =~ m/}}\z/) {
                undef $in_plugin_block;
            }
            next;
        }
        if ($line =~ m/\A{{/) {
            # single line
            next if $line =~ m/\A{{.+}}\z/;
            $in_plugin_block = 1;
        }
        if ($in_preformated_block) {
            if ($line =~ m/\A>>>/) {
                undef $in_preformated_block;
                push @outputs, '```';

                next;
            }
            push @outputs, $line;
            next;
        }
        if ($line =~ m/\A<<<\z/) {
            $in_preformated_block = 1;
            push @outputs, '```';
            next;
        }

        # コメント削除
        next if $line =~ m{\A//.+\z};

        # 整形済みテキスト
        $line =~ s/\A[ \t]+/    /;

        # 引用
        $line =~ s/\A""/>/;

        # リンク
        $line =~ s/\[{2}([^\[\]\|]+?)\|([^\[\]\|]+?)\]{2}/[$1]($2)/g;


        # 箇条書き
        $line =~ s/\A[*]{3}/        -/;
        $line =~ s/\A[*]{2}/    -/;
        $line =~ s/\A[*]/-/;

        $line =~ s/\A#{3}/        1./;
        $line =~ s/\A#{2}/    1./;
        $line =~ s/\A#/1./;

        # 見出し
        $line =~ s/\A!{5}/#####/;
        $line =~ s/\A!{4}/####/;
        $line =~ s/\A!{3}/###/;
        $line =~ s/\A!{2}/##/;
        $line =~ s/\A!/#/;

        # 強調
        $line =~ s/'''(.+)'''/**$1**/g;
        $line =~ s/''(.+)''/*$1*/g;

        # 取り消し
        $line =~ s/==(.+)==/~~$1~~/g;
        push @outputs, $line;
    }


    return join("\n", @outputs);
}


1;
__END__

=encoding utf-8

=head1 NAME

App::hiki2md - convert hiki document to markdown.

=head1 SYNOPSIS

    hiki2md input_hiki > output.md

=head1 DESCRIPTION

App::hiki2md is ...

=head1 TODO

=over 4

=item * テーブル

=item * 用語定義

=back

=head1 SEE ALSO

http://hikiwiki.org/ja/TextFormattingRules.html

=head1 LICENSE

Copyright (C) SUZUKI Masashi.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

SUZUKI Masashi E<lt>m15.suzuki.masashi@gmail.comE<gt>

=cut

