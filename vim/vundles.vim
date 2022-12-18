set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

" let Vundle manage Vundle
" required!
Plugin 'gmarik/vundle'

" Code Completions
Plugin 'Shougo/neocomplcache'

" snippets

" Fast navigation

" Fast editing

Plugin 'imotai/vim-template'

" IDE features
" Other Utils
" Plugin 'humiaozuzu/fcitx-status'
Plugin 'nvie/vim-togglemouse'

" Syntax/Indent for language enhancement
" markup language
Plugin 'tpope/vim-markdown'
" Plugin 'timcharper/textile.vim'
" Golang
Plugin 'fatih/vim-go'
Plugin 'rust-lang/rust.vim'

" FPs
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'ryanoasis/vim-devicons'


" Color Schemes
Plugin 'tomasr/molokai'
Plugin 'chriskempson/vim-tomorrow-theme'

filetype plugin indent on     " required!
