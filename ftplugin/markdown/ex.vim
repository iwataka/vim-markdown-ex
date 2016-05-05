if exists('b:did_ftplugin')
  finish
endif

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
  xmap gC <Plug>(markdown-ex-toggle-checkbox)
  nmap gC <Plug>(markdown-ex-toggle-checkbox)
  nmap gCC <Plug>(markdown-ex-toggle-checkbox-line)
endif

silent! call repeat#set("\<Plug>(markdown-ex-toggle-checkbox)")
silent! call repeat#set("\<Plug>(markdown-ex-toggle-checkbox-line)")

nnoremap <silent> <buffer> <Plug>(markdown-ex-next-link)
      \ :<c-u>call markdown#ex#next_link('sw')<cr>
nnoremap <silent> <buffer> <Plug>(markdown-ex-prev-link)
      \ :<c-u>call markdown#ex#next_link('bsw')<cr>
nnoremap <silent> <buffer> <Plug>(markdown-ex-open-link)
      \ :<c-u>call markdown#ex#open_link()<cr>

if !hasmapto('<Plug>(markdown-ex-next-link)') && maparg('<c-n>', 'n') ==# ''
  nmap <silent> <buffer> <c-n> <Plug>(markdown-ex-next-link)
endif
if !hasmapto('<Plug>(markdown-ex-prev-link)') && maparg('<c-p>', 'n') ==# ''
  nmap <silent> <buffer> <c-p> <Plug>(markdown-ex-prev-link)
endif
if !hasmapto('<Plug>(markdown-ex-open-link)')
  nmap <silent> <buffer> gx <Plug>(markdown-ex-open-link)
endif

xnoremap <silent> <buffer> ic :<c-u>call markdown#ex#text_object(1)<cr>
onoremap <silent> <buffer> ic :<c-u>call markdown#ex#text_object(1)<cr>
xnoremap <silent> <buffer> ac :<c-u>call markdown#ex#text_object(0)<cr>
onoremap <silent> <buffer> ac :<c-u>call markdown#ex#text_object(0)<cr>

setlocal foldtext=markdown#ex#foldtext()
