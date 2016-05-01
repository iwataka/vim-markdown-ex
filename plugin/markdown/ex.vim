if &compatible || (exists('g:loaded_markdown_ex') && g:loaded_markdown_ex)
  finish
endif
let g:loaded_markdown_ex = 1

com! -nargs=? -complete=customlist,markdown#ex#link_complete MarkdownOpenLink
      \ call markdown#ex#open_link(<q-args>)
