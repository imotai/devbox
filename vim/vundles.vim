set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

" let Vundle manage Vundle
" required!
Plugin 'gmarik/vundle'

" Code Completions
Plugin 'Shougo/neocomplcache'
Plugin 'Raimondi/delimitMate'
Plugin 'ervandew/supertab'

" snippets

" Fast navigation
Plugin 'jwhitley/vim-matchit'
Plugin 'Lokaltog/vim-easymotion'

" Fast editing

Plugin 'aperezdc/vim-template'
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/nerdcommenter'
Plugin 'sjl/gundo.vim'
Plugin 'godlygeek/tabular'
Plugin 'nathanaelkane/vim-indent-guides'

" IDE features
Plugin 'scrooloose/nerdtree'
Plugin 'majutsushi/tagbar'
Plugin 'mileszs/ack.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'Lokaltog/vim-powerline'
Plugin 'bronson/vim-trailing-whitespace'

" Other Utils
" Plugin 'humiaozuzu/fcitx-status'
Plugin 'nvie/vim-togglemouse'

" Syntax/Indent for language enhancement
" markup language
Plugin 'tpope/vim-markdown'
" Plugin 'timcharper/textile.vim'
" Golang
Plugin 'fatih/vim-go'

" FPs
Plugin 'kien/rainbow_parentheses.vim'

" Color Schemes
Plugin 'tomasr/molokai'
Plugin 'chriskempson/vim-tomorrow-theme'

filetype plugin indent on     " required!
