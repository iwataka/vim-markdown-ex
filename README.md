# Markdown-EX

Extra functionalities for markdown!

## Functions

+ markdown#ex#toggle_checkbox(linenr)

    Toggles (or create if not exists) checkbox on the specified line.

+ markdown#ex#remove_checkbox(linenr)

    Removes checkbox on the specified line.

+ markdown#ex#foldtext()

    foldtext() function for markdown.
    See `:help foldtext()`.

+ markdown#ex#links(...)

    Extracts links from the current markdown buffer

## Configuration

Here is my configuration:

```vim
if has('autocmd')
  augroup vimrc-markdown
    autocmd FileType markdown nnoremap <buffer>
          \ <cr> :<c-u>call markdown#ex#toggle_checkbox(line('.'))<cr>
    autocmd FileType markdown nnoremap <buffer>
          \ <s-cr> :<c-u>call markdown#ex#remove_checkbox(line('.'))<cr>
    if exists('g:markdown_folding')
      autocmd FileType markdown
            \ setlocal foldtext=markdown#ex#foldtext()
    endif
    autocmd FileType markdown com! -nargs=? MarkdownShowLinks
          \ call s:markdown_show_links(<q-args>)
  augroup END
endif

fu! s:markdown_show_links(filter)
  call setqflist(markdown#ex#links(0, line('$'), a:filter))
  cwindow
endfu
```

## TODO

+ Write a document
+ Create some text-objects (for fenced code blocks or something else).
