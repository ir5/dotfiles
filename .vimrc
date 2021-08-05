"-------------------------------------------------------------------------------
" Set up Vundle
"-------------------------------------------------------------------------------
set nocompatible              " required
filetype off                  " required

" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)
Plugin 'vim-scripts/indentpython.vim'
"Bundle 'Valloric/YouCompleteMe'
Plugin 'scrooloose/syntastic'
Plugin 'nvie/vim-flake8'
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'
"Plugin 'unite.vim'
Bundle 'L9'
Bundle 'FuzzyFinder'
" Plugin 'rust-lang/rust.vim'
Plugin 'leafgarland/typescript-vim'

Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'

" Coc.nvim:
" https://github.com/neoclide/coc.nvim
" https://github.com/neoclide/coc-rls
Plugin 'neoclide/coc.nvim', {'branch': 'release'}

Plugin 'vim-airline/vim-airline'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

"-------------------------------------------------------------------------------
" General settings
"-------------------------------------------------------------------------------
set encoding=utf-8

set ignorecase
set smartcase

set shiftwidth=2
set expandtab
set smarttab
set autoindent
set cindent
set backspace=2
set wrapscan
set showmatch
set wildmenu
set formatoptions+=mM

syntax on
set number
set ruler
set nolist
set wrap
set laststatus=2
set cmdheight=1
set showcmd
set notitle
set scrolloff=5

set nobackup
set nowritebackup
set backupdir=~/.vimbackup
let &directory=&backupdir

set hidden

"imap <C-a> <C-o>0
"imap <C-e> <C-o>$

nmap <C-h> h
nmap <C-l> l
nmap ,vp :r! cat -~M

nmap j g<Down>
nmap k g<Up>
vmap j g<Down>
vmap k g<Up>

nmap <Tab>n :tabn<CR>
nmap <Tab>p :tabp<CR>
nmap <Tab>c :tabnew<CR>:tabmove<CR>
nmap <Tab>K :tabclose<CR>
nmap <Tab>0 :tabfirst<CR>
nmap <Tab>$ :tablast<CR>
nmap <Tab>m0 :tabm 0<CR>
nmap <Tab>m1 :tabm 1<CR>
nmap <Tab>m2 :tabm 2<CR>
nmap <Tab>m3 :tabm 3<CR>
nmap <Tab>m4 :tabm 4<CR>
nmap <Tab>m5 :tabm 5<CR>
nmap <Tab>m6 :tabm 6<CR>
nmap <Tab>m7 :tabm 7<CR>
nmap <Tab>m8 :tabm 8<CR>
nmap <Tab>m9 :tabm 9<CR>
nmap <Tab>1 1gt<CR>
nmap <Tab>2 2gt<CR>
nmap <Tab>3 3gt<CR>
nmap <Tab>4 4gt<CR>
nmap <Tab>5 5gt<CR>
nmap <Tab>6 6gt<CR>
nmap <Tab>7 7gt<CR>
nmap <Tab>8 8gt<CR>
nmap <Tab>9 9gt<CR>
nmap <Tab>0 10gt<CR>
nmap <Tab>s :tabs<CR>
nmap ,eeuc :e ++enc=eucJP<CR>
nmap ,eutf :e ++enc=utf-8<CR>
nmap B :cd %:h<CR>

nmap ,f :FufFileWithCurrentBufferDir<CR>
nmap ,b :FufBuffer<CR>
nmap ,d :FufDirWithCurrentBufferDir<CR>

set ttyfast
let g:buftabs_only_basename=1
let g:buftabs_in_statusline=1


"hi TabLine     term=reverse cterm=reverse ctermfg=white ctermbg=black
"hi TabLineSel  term=bold cterm=bold,underline ctermfg=5
"hi TabLineFill term=reverse cterm=reverse ctermfg=white ctermbg=black

hi TabLine term=reverse cterm=reverse ctermfg=162 ctermbg=253
hi TabLineSel term=bold cterm=bold ctermfg=15 ctermbg=38
hi TabLineFill term=reverse cterm=reverse ctermfg=162 ctermbg=162

set showtabline=2

"-------------------------------------------------------------------------------
" tabline
"-------------------------------------------------------------------------------
function! MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let buflen = tabpagewinnr(a:n, '$')
  let bufname = fnamemodify(bufname(buflist[winnr - 1]), ':t')
  let label = a:n . ": "
  let label .= bufname == '' ? 'No name' : bufname
  let label .= '[' . buflen . ']'
  return label
endfunction

function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif
    let s .= '%' . (i + 1) . 'T'
    let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
  endfor
  let s .= '%#TabLineFill#%T'
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999Xx'
  endif
  return s
endfunction
set tabline=%!MyTabLine()

"-------------------------------------------------------------------------------
" Python settings
"-------------------------------------------------------------------------------
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
let python_highlight_all=1
au BufEnter *.py setlocal nosmartindent
au BufEnter *.py setlocal nocindent
au BufEnter *.py setlocal sw=4
au BufEnter *.py setlocal indentkeys+=0#
au BufEnter *.pyx setlocal nosmartindent
au BufEnter *.pyx setlocal nocindent
au BufEnter *.pyx setlocal sw=4
au BufEnter *.pyx setlocal indentkeys+=0#
highlight BadWhitespace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.pyx match BadWhitespace /\s\+$/
au BufRead,BufNewFile wscript setfiletype python
au BufRead,BufNewFile *.prototxt setfiletype python
au BufNewFile,BufRead *.bql  setf sql

let g:syntastic_python_checkers = ['flake8']

colorscheme zenburn
set hls

"-------------------------------------------------------------------------------
" C++11
"-------------------------------------------------------------------------------
let g:syntastic_cpp_compiler_options = ' -std=c++14 -Wall'
let g:syntastic_cpp_check_header = 1

"-------------------------------------------------------------------------------
" powerline
"-------------------------------------------------------------------------------
let g:airline_powerline_fonts = 1
