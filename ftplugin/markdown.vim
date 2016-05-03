if exists('b:did_ftplugin')
  finish
endif

com! -nargs=? -complete=customlist,markdown#ex#link_complete MarkdownOpenLink
      \ call markdown#ex#open_link(<q-args>)
