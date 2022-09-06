""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               Basic settings                               "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" use vim defaults instead of 100% vi compatibility
set nocompatible

" configure backspace so it acts as it should act
set backspace=indent,eol,start

" show line number
set number

" highlight current line
set cursorline

" a buffer becomes hidden when it is abandoned
set hidden

" set how many lines of history VIM has to remember
set history=1000

" don't redraw while executing macros for good performance
set lazyredraw

" turn on the wild menu
set wildmenu

" don't display the status prompt like '-- INSERT --'
set noshowmode

" indent using 4 spaces instead of tab, except for go files
set softtabstop=4
set tabstop=4
set expandtab
set shiftwidth=4
autocmd FileType go set noexpandtab

" highlight search results
set hlsearch
" make search act like search in modern browser
set incsearch

" search is case insensitive unless uppercase letters appear
set ignorecase
set smartcase

" auto read when a file is changed from the outside
set autoread

" set utf-8 as standard encoding
set encoding=utf-8

" enable syntax highlighting
syntax enable

" disable bell
set noerrorbells visualbell t_vb=

" enable filetype plugins
filetype plugin on
filetype indent on

set noswapfile
set autoindent

" remember more recently used files
set viminfo='100,"50

" set ctags file path
set tags=.tags

" return to last edit position when opening file
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif

" :W -> sudo saves the file
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  Keymaps                                   "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let space be <leader>
let mapleader = " "

" <F2> -> toogle paste mode
set pastetoggle=<F2>

" alt+z -> toogle word wrap
nnoremap <silent> Ω :set wrap!<CR>

" <backspace> -> turn off highlighting search results
nnoremap <silent> <backspace> :nohlsearch<CR>

" keep visual mode when changing indent
vnoremap < <gv
vnoremap > >gv

" save/exit
nnoremap <leader>q :q<CR>
nnoremap <leader>a :qa<CR>
nnoremap <leader>w :w!<CR>
nnoremap <leader>x :x<CR>

" move between split-windows
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

" zd -> insert python breakpoint
nnoremap zd Oimport ipdb; ipdb.set_trace(context=7)<ESC>
" zc -> clear all breakpoints
nnoremap zc :g/import ipdb; ipdb.set_trace(context=7)/d<CR>

" [b -> previous buffer
nnoremap <silent> [b :bp<CR>
" ]b -> next buffer
nnoremap <silent> ]b :bn<CR>
" [d -> delete current buffer without close split window
nnoremap <silent> [d :call DeleteBuffer()<CR>
fu! DeleteBuffer()
    let bufNo = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
    if bufNo > 1
        exec "bp | bd #"
    else
        exec "bd"
    endif
endf

" substitute
cnoremap %s        %s/\v//g<left><left><left>
vnoremap <leader>s :s/\v//g<left><left><left>
nnoremap <leader>s :%s/\<<C-R><C-W>\>//g<left><left>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                             Plugins Management                             "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim_runtime/plugged')

Plug 'ervandew/supertab'
Plug 'joshdick/onedark.vim', { 'branch': 'main' }
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary', { 'on': '<Plug>Commentary' }
Plug 'tpope/vim-fugitive'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'mhinz/vim-startify'
Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-nerdtree/nerdtree', { 'on': 'NERDTreeToggle' }
Plug '~/.fzf' | Plug 'junegunn/fzf.vim'

call plug#end()

" nerdtree
nnoremap <leader>n :NERDTreeToggle<CR>
" exit vim if nerdtree is the only window left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" unmap <C-J> and <C-H> in nerdtree buffer to switch between tmux panels
let g:NERDTreeMapJumpPrevSibling=""
let g:NERDTreeMapJumpNextSibling=""
" If another buffer tries to replace nerdtree, put it in the other window
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr('%') | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

" lightline
set laststatus=2
set showtabline=2
let g:lightline = {
      \ 'colorscheme': 'onedark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'tabline': {
      \   'left': [ ['buffers'] ],
      \   'right': [ ['close'] ]
      \ },
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers'
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel'
      \ }
  \ }

" startify
" do not show <empty buffer> and <quit>
let g:startify_enable_special = 0

" onedark.vim
" prevent from reporting an error when onedark.vim is not installed
try
colorscheme onedark
catch
endtry

" supertab
" traverse the completion list from top to bottom
let g:SuperTabDefaultCompletionType = "<c-n>"

" vim-commentary
map  gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine

" vim-fugitive
nnoremap <leader>gs :Gstatus<CR>
" show the difference between git head and current
nnoremap <leader>gd :Gdiffsplit<CR>
" switch back to fugitive buffer and close it
nnoremap <Leader>gD <C-W>h<C-W>c

" fzf
nnoremap <C-P>     :Files<CR>
nnoremap <leader>m :History<CR>
nnoremap <leader>f :Rg 
