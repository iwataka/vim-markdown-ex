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

if !hasmapto('<Plug>(markdown-ex-toggle-checkbox)') || maparg('gC', 'n') ==# ''
  xmap gC <Plug>(markdown-ex-toggle-checkbox)
  nmap gC <Plug>(markdown-ex-toggle-checkbox)
  nmap gCC <Plug>(markdown-ex-toggle-checkbox-line)
endif

silent! call repeat#set("\<Plug>(markdown-ex-toggle-checkbox)")
silent! call repeat#set("\<Plug>(markdown-ex-toggle-checkbox-line)")

setlocal foldtext=markdown#ex#foldtext()
