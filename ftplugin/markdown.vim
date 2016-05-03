if exists('b:did_ftplugin')
  finish
endif

com! CheckboxToggle call markdown#ex#toggle_checkbox(line('.'))
com! CheckboxRemove call markdown#ex#remove_checkbox(line('.'))
setlocal foldtext=markdown#ex#foldtext()
com! -nargs=? -complete=customlist,markdown#ex#link_complete MarkdownOpenLink
      \ call markdown#ex#open_link(<q-args>)
