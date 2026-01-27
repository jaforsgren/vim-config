" darkdark - A nice dark theme

set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = 'darkdark'

function! s:h(face, guibg, guifg, ctermbg, ctermfg, gui)
  let l:cmd="highlight " . a:face
  
  if a:guibg != ""
    let l:cmd = l:cmd . " guibg=" . a:guibg
  endif

  if a:guifg != ""
    let l:cmd = l:cmd . " guifg=" . a:guifg
  endif

  if a:ctermbg != ""
    let l:cmd = l:cmd . " ctermbg=" . a:ctermbg
  endif

  if a:ctermfg != ""
    let l:cmd = l:cmd . " ctermfg=" . a:ctermfg
  endif

  if a:gui != ""
    let l:cmd = l:cmd . " gui=" . a:gui
  endif

  exec l:cmd
endfun


" ==========> Colors dictionary

" GUI colors dictionary (hex)
let s:hex = {}
" Terminal colors dictionary (256)
let s:bit = {}

let s:hex.color0="#000"
let s:hex.color1="#7e7e7e" " ui lines AND text telescope etc
let s:hex.color2="#deef43"
let s:hex.color3="#14213D"
let s:hex.color4="#353535"
let s:hex.color5="#0a0a0a"
let s:hex.color6="#323232"
let s:hex.color7="#141414"
let s:hex.color8="#464646"
let s:hex.color9="#3eaaed"
let s:hex.color10="#2d2d2d"
let s:hex.color11="#ecffff"
let s:hex.color12="#4b4b4b"
let s:hex.color13="#d59aa6"
let s:hex.color14="#1e1e1e"
let s:hex.color15="#ddf2ff"
let s:hex.color16="#50a7dd"
let s:hex.color17="#232323"
let s:hex.color18="#729098"
let s:hex.color19="#f1a82b"
let s:hex.color20="#5acae9" " Identifier
let s:hex.color21="#f8889e"
let s:hex.color22="#bcbcbc" " operator
let s:hex.color23="#d2e56f"
let s:hex.color24="#b5cea8"

let s:bit.color14="66"
let s:bit.color16="74"
let s:bit.color20="151"
let s:bit.color1="152"
let s:bit.color10="175"
let s:bit.color17="181"
let s:bit.color15="185"
let s:bit.color19="186"
let s:bit.color18="188"
let s:bit.color7="189"
let s:bit.color12="195"
let s:bit.color2="229"
let s:bit.color8="231"
let s:bit.color5="232"
let s:bit.color0="233"
let s:bit.color11="234"
let s:bit.color3="235"
let s:bit.color4="236"
let s:bit.color6="238"
let s:bit.color9="239"
let s:bit.color13="253"


" ==========> General highlights 
call s:h("Normal", s:hex.color0, s:hex.color1, s:bit.color0, s:bit.color1, "none")
call s:h("Cursor", s:hex.color2, s:hex.color3, s:bit.color2, s:bit.color3, "none")
call s:h("Visual", s:hex.color4, "", s:bit.color4, "", "none")
call s:h("ColorColumn", s:hex.color5, "", s:bit.color5, "", "none")
call s:h("LineNr", "", s:hex.color6, "", s:bit.color4, "none")
call s:h("CursorLine", s:hex.color7, "", s:bit.color0, "", "none")
call s:h("CursorLineNr", "", s:hex.color8, "", s:bit.color6, "none")
call s:h("CursorColumn", s:hex.color7, "", s:bit.color0, "", "none")
call s:h("StatusLineNC", s:hex.color7, s:hex.color9, s:bit.color0, s:bit.color7, "none")
call s:h("StatusLine", s:hex.color10, s:hex.color11, s:bit.color4, s:bit.color8, "none")
call s:h("VertSplit", "", s:hex.color12, "", s:bit.color9, "none")
call s:h("Folded", s:hex.color7, s:hex.color13, s:bit.color0, s:bit.color10, "none")
call s:h("Pmenu", s:hex.color14, s:hex.color15, s:bit.color11, s:bit.color12, "none")
call s:h("PmenuSel", s:hex.color5, s:hex.color16, s:bit.color5, s:bit.color13, "none")
call s:h("EndOfBuffer", s:hex.color0, s:hex.color17, s:bit.color0, s:bit.color3, "none")
call s:h("NonText", s:hex.color0, s:hex.color17, s:bit.color0, s:bit.color3, "none")

call s:h("FloatBorder", s:hex.color0, s:hex.color0, s:bit.color0, s:bit.color9, "none")
call s:h("NormalFloat", s:hex.color0, s:hex.color0, s:bit.color0, s:bit.color1, "none")
highlight link TelescopeBorder FloatBorder
highlight link TelescopePromptBorder FloatBorder
highlight link TelescopeResultsBorder FloatBorder
highlight link TelescopePreviewBorder FloatBorder


" ==========> Syntax highlights
call s:h("Comment", "", s:hex.color18, "", s:bit.color14, "none")
call s:h("Constant", "", s:hex.color19, "", s:bit.color15, "none")
call s:h("Special", "", s:hex.color19, "", s:bit.color15, "none")
call s:h("Identifier", "", s:hex.color20, "", s:bit.color16, "none")
call s:h("Function", "", s:hex.color21, "", s:bit.color17, "none")
call s:h("Statement", "", s:hex.color19, "", s:bit.color15, "none")
call s:h("Operator", "", s:hex.color22, "", s:bit.color18, "none")
call s:h("PreProc", "", s:hex.color19, "", s:bit.color15, "none")
call s:h("Type", "", s:hex.color19, "", s:bit.color15, "none")
call s:h("String", "", s:hex.color23, "", s:bit.color19, "none")
call s:h("Number", "", s:hex.color24, "", s:bit.color20, "none")

highlight link cStatement Statement
highlight link cSpecial Special

call s:h("FloatBorder", "", "#ff0000", "", "196", "none")


augroup DarkdarkTelescope
  autocmd!
  autocmd ColorScheme darkdark call s:h(
        \ "FloatBorder",
        \ s:hex.color0,
        \ s:hex.color0,
        \ s:bit.color0,
        \ s:bit.color9,
        \ "none"
        \ )
augroup END
