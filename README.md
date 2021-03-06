# Markdown-EX

![travis-ci](https://travis-ci.org/iwataka/vim-markdown-ex.svg?branch=master)

Extra useful functionalities for markdown editing!

## Introduction

Markdown-style documents now becomes more and more important and many helper
plugins have been created, but they aren't enough intuitive and useful at least
for me. I carefully select really necessary features and implement them in
appropriate way.

## Usage

This provides the below features:

+ Create/Toggle/Remove checkboxes
+ Jump to next/previous links
+ Open links by gx with additional features
+ Open links from opening history (**experimental**)
+ Text object for fenced code blocks
+ Search headers with command-completion

Please check `:help vim-markdown-ex` to see more details.

## Installation

If you don't have your favorite plug-in manager, I strongly recommend
[vim-plug](https://github.com/junegunn/vim-plug).

```vim
Plug 'iwataka/vim-markdown-ex', { 'for': 'markdown', 'on': ['OpenLinkHistory'] }
```

## Related Projects

+ [tpope/vim-markdown](https://github.com/tpope/vim-markdown)
+ [plasticboy/vim-markdown](https://github.com/plasticboy/vim-markdown)
+ [gabrielelana/vim-markdown](https://github.com/gabrielelana/vim-markdown)
+ [pocke/vim-textobj-markdown](https://github.com/pocke/vim-textobj-markdown)
+ [vim-checkbox](https://github.com/jkramer/vim-checkbox)

## Testcase

+ [Free Programming Books](https://github.com/vhf/free-programming-books)

    - [free-programming-books](https://github.com/vhf/free-programming-books/blob/master/free-programming-books.md)
