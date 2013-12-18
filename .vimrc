"set t_Co=8 "change to use 8 colors only, useful when doing ssh over browser.
colorscheme desert

syn on
set laststatus=2
set hlsearch
set incsearch
set ignorecase
set smartcase
set number
set nocompatible
set nowrap
set ruler
set showcmd
set smartindent
set smarttab
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set printoptions+=number:y
set guioptions=ag
set matchpairs=(:),{:},[:],<:>
set textwidth=80
set wildmenu
"set noloadplugins
"set spell
"set autoindent
"set autoread
"set completeopt=menu,longest
set pumheight=10
hi Pmenu guibg=#2a2a2a ctermbg=237
hi PmenuSel guibg=#8a8a8a ctermbg=233
hi PmenuSbar guibg=#ffffff ctermbg=white
hi PmenuThumb guibg=#444444 guifg=#444444 ctermbg=222 ctermfg=222

autocmd WinLeave * setlocal nocursorline
autocmd WinEnter * setlocal cursorline
autocmd BufLeave * setlocal nocursorline
autocmd BufEnter * setlocal cursorline

hi CursorLine guibg=#444444 cterm=none ctermbg=237
hi LineNr     guifg=#CCCCCC guibg=#333333
hi CursorColumn guibg=#2a2a2a cterm=none ctermbg=234
set cursorcolumn
match CursorLine /\%'[.*\%']/
"123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
"         |         |         |         |         |         |         |         |         |         |         |         |

set colorcolumn=81,101
hi ColorColumn guibg=#3A3A3A ctermbg=237

vmap <tab> >gv
vmap <s-tab> <gv
" Sort command to sort imports (among other things) and remove duplicates. The
" pattern reads: sort by matching the portion between zs and ze, where this is a
" sequence of chars (not including " " ; or :)
" vmap <c-o> :sort/\zs[^;: ]*\ze[;:,]\=/ur<CR>
vmap <c-o> :sort/.*/ur<CR>

autocmd FileType make setlocal noet sw=8 sts=8

au Syntax dart runtime! syntax/dart.vim
au BufNewFile,BufRead *.dart set filetype=dart

" Extra options for python
function! PythonExtra()
  " highlight current column to make it easier to indent a line
  autocmd WinLeave * setlocal nocursorcolumn
  autocmd WinEnter * setlocal cursorcolumn
  autocmd BufLeave * setlocal nocursorcolumn
  autocmd BufEnter * setlocal cursorcolumn
  hi CursorColumn guibg=#2a2a2a cterm=none ctermbg=234
endfunction
au! BufNewFile,BufRead,BufWritePost,BufEnter,BufLeave *.py call PythonExtra()


" Different colors for nested parenthesis
hi javaParen1 guifg=#AAFFFF
hi javaParen2 guifg=#88BBBB

highlight DiffChange guibg=#444444 ctermbg=238
highlight DiffText guibg=#777777 ctermbg=244
highlight DiffAdd guibg=#4f8867 ctermbg=29
highlight DiffDelete guibg=#870000 ctermbg=88

augroup filetypedetect
au BufNewFile,BufRead *.html,*.java,*.js,*.c,*.cpp,*.h,*.dart syn spell notoplevel
au BufNewFile,BufRead,BufWritePost,BufEnter,BufLeave *.java,*.js,*.dart set cino==j1,+2s,(4,g1,h1
au BufNewFile,BufRead,BufWritePost,BufEnter,BufLeave *.java,*.js set textwidth=80
au BufNewFile,BufRead,BufEnter *Test.java colorscheme slate
au BufNewFile,BufRead,BufEnter *Test.java hi cursorline guibg=#440044
au BufNewFile,BufRead,BufEnter *Test.java hi ColorColumn guibg=#3A3A3A ctermbg=blue
au BufLeave *Test.java colorscheme desert
au BufLeave *Test.java hi ColorColumn guibg=#3A3A3A ctermbg=blue
augroup END

" map gc to make the current working directory that of the file we are editing.
nmap gc :cd %:h<cr>
nmap g<Up> :cd ..<cr>

" better matching with %
runtime macros/matchit.vim

" Find long lines (recursively)
nnoremap <Leader>ll :grep -R ".\{81\}" .<cr>
nnoremap <Leader>ts :grep -R " $" .<cr>

au! BufWritePost .vimrc source %

set guifont=Terminus\ 12


" Using dmenu to list all files in the client:
function! DmenuOpen(cmd)
  " Find a file and pass it to cmd
  let res = system("git ls-files | dmenu -i -b -l 20 -p 'open file:' -nb '#2a2a2a' -nf white -sb '#8a8a8a' ")
  let fname = substitute(res, '\n$', '', '')
  if empty(fname)
    return
  endif
  execute a:cmd . " " . fname
endfunction
map <Leader>f :call DmenuOpen("e")<cr>
let java_allow_cpp_keywords=1
