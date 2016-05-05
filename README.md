# Markdown-EX

Extra useful functionalities for markdown editing!

## Introduction

Markdown-style documents now becomes more and more important and many helper
plugins have been created, but they aren't enough intuitive and useful at least
for me. I carefully select really necessary features and implement them in
appropriate way.

## Usage

+ Create/Toggle/Remove checkboxes

    - By default, you can run `:CheckboxToggle` command or type `gCC` to create/toggle/remove a checkbox on the current line.
    - Both ways can accept visual selection.
    - `gCC` mapping can be repeated by dot if you use [vim-repeat](https://gihtub.com/tpope/vim-repeat).

+ Jump to next/previous links

    - By default, `<c-n>` to jump to the next link and `<c-p>` to jump to the previous one.

+ Open links by gx with additional features

    - Try to find URL on the current line even if the cursor is not on it.
    - Support header jumps (e.g. `[Title](#title)`).

+ Text object for fenced code blocks

    `` i` `` and `` a` `` indicate not only built-in text objects but also fenced code blocks.

## Related Projects

+ [tpope/vim-markdown](https://github.com/tpope/vim-markdown)
+ [plasticboy/vim-markdown](https://github.com/plasticboy/vim-markdown)
+ [gabrielelana/vim-markdown](https://github.com/gabrielelana/vim-markdown)
