# Markdown-EX

Extra functionalities for markdown!

## Functions

+ markdown#ex#toggle_checkbox(linenr)

    Toggle (or create if not exists) checkbox on the specified line.

+ markdown#ex#remove_checkbox(linenr)

    Remove checkbox on the specified line.

+ markdown#ex#foldtext()

    foldtext() function for markdown.
    See `:help foldtext()`.

## Configuration

Here is my configuration:

```vim
autocmd vimrcEx FileType markdown nnoremap <buffer>
      \ <cr> :<c-u>call markdown#ex#toggle_checkbox(line('.'))<cr>
autocmd vimrcEx FileType markdown nnoremap <buffer>
      \ <s-cr> :<c-u>call markdown#ex#remove_checkbox(line('.'))<cr>
autocmd vimrcEx FileType markdown setlocal foldtext=markdown#ex#foldtext()
```

## TODO

+ Write a document
+ Add some operator functions (for fenced code blocks or something else).
