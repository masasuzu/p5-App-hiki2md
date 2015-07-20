# vim: ft=perl
package App::hiki2md;
use 5.008001;
use strict;
use warnings;
use feature qw( say );
use File::Slurp qw( read_file );

our $VERSION = "0.01";

# TODO: テーブルとか厳密に変換したいならば、
#       今のように複数行まとめて置換するのではなく、
#       行単位で処理していかないとつらい。
#


sub run {
    my ($class, $file) = @_;
    die "no file specified" unless $file;
    die "not exist: $file" unless -f $file;

    my $hiki_text = read_file($file);
    my $md_text = $class->convert($hiki_text);
    say $md_text;
}

sub convert {
    my ($class, $text) = @_;
    # プラグイン削除
    # single line
    $text =~ s/^{{[^\n]+}}$//msg;

    # multi line
    $text =~ s/^{{.+}}$//msg;

    # コメント削除
    $text =~ s{^//.+$}{}msg;

    # リンク
    $text =~ s/\[\[([\n]+)\|([\n]+)\]\]/[$1]($2)/msg;

    # 箇条書き
    $text =~ s/^\*{3}/        -/msg;
    $text =~ s/^\*{2}/    -/msg;
    $text =~ s/^\*/-/msg;

    $text =~ s/^#{3}/        1./msg;
    $text =~ s/^#{2}/    1./msg;
    $text =~ s/^#/1./msg;

    # 見出し
    $text =~ s/^!{5}/#####/msg;
    $text =~ s/^!{4}/####/msg;
    $text =~ s/^!{3}/###/msg;
    $text =~ s/^!{2}/##/msg;
    $text =~ s/^!/#/msg;

    # 整形済みテキスト
    $text =~ s/^[ \t]+/    /msg;
    $text =~ s/^<<<\n(.+)\n>>>$/```\n$1\n```/msg;

    # 強調
    $text =~ s/'''([^\n]+)'''/**$1**/msg;
    $text =~ s/''([^\n]+)''/*$1*/msg;

    # 取り消し
    $text =~ s/==([^\n]+)==/~~$1~~/msg;

    # 引用
    $text =~ s/^""/>/msg;

    return $text;
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

