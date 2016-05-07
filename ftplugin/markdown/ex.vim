" This imitates tpope's vim-commentary
" https://github.com/tpope/vim-commentary
xnoremap <silent> <buffer> <Plug>(markdown-ex-toggle-checkbox)
      \ :<c-u>call markdown#ex#toggle_checkbox(line("'<"), line("'>"))<cr>
nnoremap <silent> <buffer> <Plug>(markdown-ex-toggle-checkbox)
      \ :<c-u>set opfunc=markdown#ex#toggle_checkbox<cr>g@
nnoremap <silent> <buffer> <Plug>(markdown-ex-toggle-checkbox-line)
      \ :<c-u>set opfunc=markdown#ex#toggle_checkbox<bar>exe 'norm! 'v:count1.'g@_'<cr>
com! -buffer -range -bar CheckboxToggle call markdown#ex#toggle_checkbox(<line1>, <line2>)

if !hasmapto('<Plug>(markdown-ex-toggle-checkbox)') && maparg('gC', 'n') ==# ''
  xmap <buffer> gC <Plug>(markdown-ex-toggle-checkbox)
  nmap <buffer> gC <Plug>(markdown-ex-toggle-checkbox)
  nmap <buffer> gCC <Plug>(markdown-ex-toggle-checkbox-line)
endif

silent! call repeat#set("\<Plug>(markdown-ex-toggle-checkbox)")
silent! call repeat#set("\<Plug>(markdown-ex-toggle-checkbox-line)")

nnoremap <silent> <buffer> <Plug>(markdown-ex-next-link)
      \ :<c-u>call markdown#ex#next_link('sw', v:count1)<cr>
nnoremap <silent> <buffer> <Plug>(markdown-ex-prev-link)
      \ :<c-u>call markdown#ex#next_link('bsw', v:count1)<cr>
nnoremap <silent> <buffer> <Plug>(markdown-ex-open-link)
      \ :<c-u>call markdown#ex#open_link()<cr>

if !hasmapto('<Plug>(markdown-ex-next-link)') && maparg('<c-n>', 'n') ==# ''
  nmap <buffer> <c-n> <Plug>(markdown-ex-next-link)
endif
if !hasmapto('<Plug>(markdown-ex-prev-link)') && maparg('<c-p>', 'n') ==# ''
  nmap <buffer> <c-p> <Plug>(markdown-ex-prev-link)
endif
if !hasmapto('<Plug>(markdown-ex-open-link)')
  nmap <buffer> gx <Plug>(markdown-ex-open-link)
endif

xnoremap <silent> <buffer> <Plug>(markdown-ex-textobj-code-block-i)
      \ :<c-u>call markdown#ex#text_object(1)<cr>
onoremap <silent> <buffer> <Plug>(markdown-ex-textobj-code-block-i)
      \ :<c-u>call markdown#ex#text_object(1)<cr>
xnoremap <silent> <buffer> <Plug>(markdown-ex-textobj-code-block-a)
      \ :<c-u>call markdown#ex#text_object(0)<cr>
onoremap <silent> <buffer> <Plug>(markdown-ex-textobj-code-block-a)
      \ :<c-u>call markdown#ex#text_object(0)<cr>

if !hasmapto('<Plug>(markdown-ex-textobj-code-block-i)')
  if maparg('ic', 'x') ==# ''
    xmap <buffer> ic <Plug>(markdown-ex-textobj-code-block-i) ==# ''
  endif
  if maparg('ic', 'o') ==# ''
    omap <buffer> ic <Plug>(markdown-ex-textobj-code-block-i)
  endif
endif
if !hasmapto('<Plug>(markdown-ex-textobj-code-block-a)')
  if maparg('ac', 'x') ==# ''
    xmap <buffer> ac <Plug>(markdown-ex-textobj-code-block-a)
  endif
  if maparg('ac', 'o') ==# ''
    omap <buffer> ac <Plug>(markdown-ex-textobj-code-block-a)
  endif
endif

setlocal foldtext=markdown#ex#foldtext()
