" Vim syntax file
" Language: YAFL (Yet Another Functional Language)
" Maintainer: Fredrik Andersson
" Latest Revision> 27 Nov 2016
"
if exists('b:current_syntax') && b:current_syntax == 'yafl'
  finish
endif


" Highlight long strings.
syntax sync fromstart

" Keywords
syn match yaflKeyword /\<\%(def\|int\|dec\|str\|bool\|fun\)\>/ display
hi def link yaflKeyword Keyword

syn match yaflBoolean /\<\%(true\|false\)\>/ display
hi def link yaflBoolean Boolean

" A string escape sequence
syn match yaflEscape /\\\d\d\d\|\\x\x\{2\}\|\\u\x\{4\}\|\\./ contained display
hi def link yaflEscape SpecialChar
" A non-interpolated string
syn cluster yaflBasicString contains=yaflEscape
" An interpolated string
syn cluster yaflInterpString contains=@yaflBasicString,yaflInterp

" Regular strings
syn region yaflString start=/"/ skip=/\\\\\|\\"/ end=/"/
\                       contains=@yaflInterpString
syn region yaflString start=/'/ skip=/\\\\\|\\'/ end=/'/
\                       contains=@yaflBasicString
hi def link yaflString String

" A string escape sequence
syn match yaflEscape /\\\d\d\d\|\\x\x\{2\}\|\\u\x\{4\}\|\\./ contained display
hi def link yaflEscape SpecialChar

syn region yaflRegex start=#\%(\%()\|\%(\i\|\$\)\@<!\d\)\s*\|\i\)\@<!/=\@!\s\@!#
\                      end=#/[gimy]\{,4}\d\@!#
\                      oneline contains=@yaflBasicString,yaflRegexCharSet
syn region yaflRegexCharSet start=/\[/ end=/]/ contained
\                             contains=@yaflBasicString
hi def link yaflRegex String
hi def link yaflRegexCharSet yaflRegex

" A heregex
syn region yaflHeregex start=#///# end=#///[gimy]\{,4}#
\                        contains=@yaflInterpString,yaflHeregexComment,
\                                  yaflHeregexCharSet
\                        fold
syn region yaflHeregexCharSet start=/\[/ end=/]/ contained
\                               contains=@yaflInterpString
hi def link yaflHeregex yaflRegex
hi def link yaflHeregexCharSet yaflHeregex

" Heredoc strings
syn region yaflHeredoc start=/"""/ end=/"""/ contains=@yaflInterpString
\                        fold
syn region yaflHeredoc start=/'''/ end=/'''/ contains=@yaflBasicString
\                        fold
hi def link yaflHeredoc String

" Ignore reserved words in dot accesses.
syn match yaflDotAccess /\.\@<!\.\s*\%(\I\|\$\)\%(\i\|\$\)*/he=s+1 contains=@yaflIdentifier
hi def link yaflDotAccess yaflExtendedOp

" A integer, including a leading plus or minus
syn match yaflNumber /\%(\i\|\$\)\@<![-+]\?\d\+\%(e[+-]\?\d\+\)\?/ display
" A hex, binary, or octal number
syn match yaflNumber /\<0[xX]\x\+\>/ display
syn match yaflNumber /\<0[bB][01]\+\>/ display
syn match yaflNumber /\<0[oO][0-7]\+\>/ display
syn match yaflNumber /\<\%(Infinity\|NaN\)\>/ display
hi def link yaflNumber Number

" A floating-point number, including a leading plus or minus
syn match yaflFloat /\%(\i\|\$\)\@<![-+]\?\d*\.\@<!\.\d\+\%([eE][+-]\?\d\+\)\?/
\                     display
hi def link yaflFloat Float

syn keyword yaflTodo TODO FIXME XXX contained
hi def link yaflTodo Todo

syn match yaflComment /#.*/ contains=@Spell,yaflTodo
hi def link yaflComment Comment

syn region yaflBlockComment start=/####\@!/ end=/###/
\                             contains=@Spell,yaflTodo
hi def link yaflBlockComment yaflComment

" A comment in a heregex
syn region yaflHeregexComment start=/#/ end=/\ze\/\/\/\|$/ contained
\                               contains=@Spell,yaflTodo
hi def link yaflHeregexComment yaflComment


syn region yaflInterp matchgroup=yaflInterpDelim start=/#{/ end=/}/ contained
\                       contains=@yaflAll
hi def link yaflInterpDelim PreProc

" This is required for interpolations to work.
syn region yaflCurlies matchgroup=yaflCurly start=/{/ end=/}/
\                        contains=@yaflAll
syn region yaflBrackets matchgroup=yaflBracket start=/\[/ end=/\]/
\                         contains=@yaflAll
syn region yaflParens matchgroup=yaflParen start=/(/ end=/)/
\                       contains=@yaflAll

" These are highlighted the same as commas since they tend to go together.
hi def link yaflBlock yaflSpecialOp
hi def link yaflBracket yaflBlock
hi def link yaflCurly yaflBlock
hi def link yaflParen yaflBlock

" This is used instead of TOP to keep things yafl-specific for good
" embedding. `contained` groups aren't included.
syn cluster yaflAll contains=
\                              yaflKeyword,
\                              yaflSpecialOp,yaflBoolean,
\                              yaflString,
\                              yaflNumber,yaflFloat,
\                              yaflComment,yaflBlockComment,
\                              yaflRegex,yaflHeregex,
\                              yaflHeredoc,
\                              yaflDotAccess,
\                              yaflCurlies,yaflBrackets,
\                              yaflParens

if !exists('b:current_syntax')
  let b:current_syntax = "yafl"
endif
