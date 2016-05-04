if &compatible || (exists('g:loaded_markdown_ex') && g:loaded_markdown_ex)
  finish
endif
let g:loaded_markdown_ex = 1

com! -nargs=? -complete=file MarkdownOpenLink
      \ call markdown#link#execute(<q-args>)
