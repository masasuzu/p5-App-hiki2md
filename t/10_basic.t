use strict;
use warnings;
use Test::More;
use Text::Diff qw( diff );

use App::hiki2md;

my $hiki = <<__HIKI__;
{{some_plugin()}}

// comment
// comment

// single line comment


! Hedaline1
!! Hedaline2

this is ''strong'' text. this is '''very storng''' text.
==deleted==

!!! Hedaline3

* list1
** list2
* list1
** list2
*** list3
** list2

# list1
## list2
# list1
## list2
### list3
## list2

!!! Hedaline3
!!!! Hedaline4

* [[google|http://google.com]]
* [[yahoo|http://yahoo.com]], [[yahoo|http://yahoo.jp]]

!!! Hedaline3

<<<
pre
text

pre
text
>>>

!!!! Hedaline4

  pre
  text
  
  text

!!!!! Hedaline5

"" quote
"" quote

"" quote

__HIKI__

my $md = <<__MD__;








# Hedaline1
## Hedaline2

this is *strong* text. this is **very storng** text.
~~deleted~~

### Hedaline3

- list1
    - list2
- list1
    - list2
        - list3
    - list2

1. list1
    1. list2
1. list1
    1. list2
        1. list3
    1. list2

### Hedaline3
#### Hedaline4

- [google](http://google.com)
- [yahoo](http://yahoo.com), [yahoo](http://yahoo.jp)

### Hedaline3

```
pre
text

pre
text
```

#### Hedaline4

    pre
    text
    
    text

##### Hedaline5

> quote
> quote

> quote

__MD__

my $converted = App::hiki2md->convert($hiki);
ok $converted eq $md, diff(\$converted => \$md);
done_testing();
