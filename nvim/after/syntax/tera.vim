" Stock tera.vim uses bare '?' (a literal in Vim regex), so its regions never
" match plain {%..%}/{{..}}/{#..#} delimiters. Redefined with \? until fixed upstream.
syn clear teraCommentBlock teraStatement teraExpression
syn region teraCommentBlock start="{#-\?" end="-\?#}" contains=@Spell
syn region teraStatement start="{%-\?" end="-\?%}" contains=teraKeyword,teraString,teraNumber,teraFunction,teraBoolean,teraFilter,teraOperator,teraIdentifier,teraTest,teraNamespace,teraProperty,teraBracket
syn region teraExpression start="{{-\?" end="-\?}}" contains=teraString,teraNumber,teraFunction,teraBoolean,teraFilter,teraOperator,teraIdentifier,teraTest,teraNamespace,teraProperty,teraBracket
