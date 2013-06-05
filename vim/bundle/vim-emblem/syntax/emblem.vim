" Vim syntax file
" Language: Emblem
" Maintainer: Jakub Arnold <darthdeus@gmail.com>

" Quit when a syntax file is already loaded.
if exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'emblem'
endif

" Allows a per line syntax evaluation.
let b:ruby_no_expensive = 1

" Include Ruby syntax highlighting
syn include @emblemRubyTop syntax/ruby.vim
unlet! b:current_syntax
" Include Haml syntax highlighting
syn include @emblemHaml syntax/haml.vim
unlet! b:current_syntax

syn match emblemBegin  "^\s*\(&[^= ]\)\@!" nextgroup=emblemTag,emblemClassChar,emblemIdChar,emblemRuby

syn region  rubyCurlyBlock start="{" end="}" contains=@emblemRubyTop contained
syn cluster emblemRubyTop    add=rubyCurlyBlock

syn cluster emblemComponent contains=emblemClassChar,emblemIdChar,emblemWrappedAttrs,emblemRuby,emblemAttr,emblemInlineTagChar

syn keyword emblemDocType        contained html 5 1.1 strict frameset mobile basic transitional
syn match   emblemDocTypeKeyword "^\s*\(doctype\)\s\+" nextgroup=emblemDocType

syn match emblemTag           "\w\+"         contained contains=htmlTagName nextgroup=@emblemComponent
syn match emblemIdChar        "#{\@!"        contained nextgroup=emblemId
syn match emblemId            "\%(\w\|-\)\+" contained nextgroup=@emblemComponent
syn match emblemClassChar     "\."           contained nextgroup=emblemClass
syn match emblemClass         "\%(\w\|-\)\+" contained nextgroup=@emblemComponent
syn match emblemInlineTagChar "\s*:\s*"      contained nextgroup=emblemTag,emblemClassChar,emblemIdChar

syn region emblemWrappedAttrs matchgroup=emblemWrappedAttrsDelimiter start="\s*{\s*" skip="}\s*\""  end="\s*}\s*"  contained contains=emblemAttr nextgroup=emblemRuby
syn region emblemWrappedAttrs matchgroup=emblemWrappedAttrsDelimiter start="\s*\[\s*" end="\s*\]\s*" contained contains=emblemAttr nextgroup=emblemRuby
syn region emblemWrappedAttrs matchgroup=emblemWrappedAttrsDelimiter start="\s*(\s*"  end="\s*)\s*"  contained contains=emblemAttr nextgroup=emblemRuby

syn match emblemAttr "\s*\%(\w\|-\)\+\s*" contained contains=htmlArg nextgroup=emblemAttrAssignment
syn match emblemAttrAssignment "\s*=\s*" contained nextgroup=emblemWrappedAttrValue,emblemAttrString

syn region emblemWrappedAttrValue matchgroup=emblemWrappedAttrValueDelimiter start="{" end="}" contained contains=emblemAttrString,@emblemRubyTop nextgroup=emblemAttr,emblemRuby,emblemInlineTagChar
syn region emblemWrappedAttrValue matchgroup=emblemWrappedAttrValueDelimiter start="\[" end="\]" contained contains=emblemAttrString,@emblemRubyTop nextgroup=emblemAttr,emblemRuby,emblemInlineTagChar
syn region emblemWrappedAttrValue matchgroup=emblemWrappedAttrValueDelimiter start="(" end=")" contained contains=emblemAttrString,@emblemRubyTop nextgroup=emblemAttr,emblemRuby,emblemInlineTagChar

syn region emblemAttrString start=+\s*"+ skip=+\%(\\\\\)*\\"+ end=+"\s*+ contained contains=emblemInterpolation,emblemInterpolationEscape nextgroup=emblemAttr,emblemRuby,emblemInlineTagChar
syn region emblemAttrString start=+\s*'+ skip=+\%(\\\\\)*\\"+ end=+'\s*+ contained contains=emblemInterpolation,emblemInterpolationEscape nextgroup=emblemAttr,emblemRuby,emblemInlineTagChar

syn region emblemInnerAttrString start=+\s*"+ skip=+\%(\\\\\)*\\"+ end=+"\s*+ contained contains=emblemInterpolation,emblemInterpolationEscape nextgroup=emblemAttr
syn region emblemInnerAttrString start=+\s*'+ skip=+\%(\\\\\)*\\"+ end=+'\s*+ contained contains=emblemInterpolation,emblemInterpolationEscape nextgroup=emblemAttr

syn region emblemInterpolation matchgroup=emblemInterpolationDelimiter start="#{" end="}" contains=@hamlRubyTop containedin=javascriptStringS,javascriptStringD,emblemWrappedAttrs
syn match  emblemInterpolationEscape "\\\@<!\%(\\\\\)*\\\%(\\\ze#{\|#\ze{\)"

syn region emblemRuby matchgroup=emblemRubyOutputChar start="\s*[=]\==[']\=" skip=",\s*$" end="$" contained contains=@emblemRubyTop keepend
syn region emblemRuby matchgroup=emblemRubyChar       start="\s*-"           skip=",\s*$" end="$" contained contains=@emblemRubyTop keepend

syn match emblemComment /^\(\s*\)[/].*\(\n\1\s.*\)*/
syn match emblemText    /^\(\s*\)[`|'].*\(\n\1\s.*\)*/

hi def link emblemAttrString                String
hi def link emblemBegin                     String
hi def link emblemClass                     Type
hi def link emblemClassChar                 Type
hi def link emblemComment                   Comment
hi def link emblemDocType                   Identifier
hi def link emblemDocTypeKeyword            Keyword
hi def link emblemFilter                    Keyword
hi def link emblemIEConditional             SpecialComment
hi def link emblemId                        Identifier
hi def link emblemIdChar                    Identifier
hi def link emblemInnerAttrString           String
hi def link emblemInterpolationDelimiter    Delimiter
hi def link emblemRubyChar                  Special
hi def link emblemRubyOutputChar            Special
hi def link emblemText                      String
hi def link emblemWrappedAttrValueDelimiter Delimiter
hi def link emblemWrappedAttrsDelimiter     Delimiter
hi def link emblemInlineTagChar             Delimiter

let b:current_syntax = "emblem"
