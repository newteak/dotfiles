" Plugins Section
call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
  " Write
  Plug 'SirVer/ultisnips'
  Plug 'tommcdo/vim-lion'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-speeddating'
  Plug 'tpope/vim-surround'

  " Language
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'elixir-editors/vim-elixir'

  " Utils
  Plug 'airblade/vim-gitgutter'
  Plug 'easymotion/vim-easymotion'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'mattesgroeger/vim-bookmarks'
  Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
  Plug 'vim-scripts/fcitx.vim'
  Plug 'preservim/tagbar'
  Plug 'simeji/winresizer'
  Plug 'jremmen/vim-ripgrep'
  Plug 'stefandtw/quickfix-reflector.vim'
  Plug 'jiangmiao/auto-pairs'
  Plug 'preservim/nerdtree'

  " Color
  Plug 'ap/vim-css-color'
  Plug 'machakann/vim-highlightedyank'
  Plug 'morhetz/gruvbox'
  Plug 'ntpeters/vim-better-whitespace'
  Plug 'ryanoasis/vim-devicons'
  Plug 'Yggdroot/indentLine'

  " DEPRECATED
  " Plug 'tpope/vim-endwise'
  " Plug 'APZelos/blamer.nvim'
  " Plug 'junegunn/goyo.vim'
call plug#end()

" plugin name: easymotion
let g:EasyMotion_do_mapping=0
let g:EasyMotion_smartcase=1

" plugin name: ultisnips
let g:UltiSnipsExpandTrigger="<TAB>"
let g:UltiSnipsJumpForwardTrigger='<TAB>'
let g:UltiSnipsJumpBackwardTrigger='<S-TAB>'

let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetDirectories=['~/.local/share/snippets/ultisnips']

" resolve when insert mode keyon function freeeze
if has('nvim')
    au VimEnter * if exists('#UltiSnips_AutoTrigger')
        \ |     exe 'au! UltiSnips_AutoTrigger'
        \ |     aug! UltiSnips_AutoTrigger
        \ | endif
endif

" " plugin name: nerdtree
let NERDTreeQuitOnOpen=1

" plugin name: vim-gutter
let g:gitgutter_map_keys=0
let g:gitgutter_set_sign_backgrounds=0

" plugin name: vim-highlightedyank
let g:highlightedyank_highlight_duration=150
highlight HighlightedyankRegion cterm=reverse gui=reverse

" plugin name: indentLine
let g:indentLine_showFirstIndentLevel = 0
let g:indentLine_fileTypeExclude = ["vimwiki", "help", "undotree", "diff"]
let g:indentLine_char = '|'

" plugin name: vim-wiki
let g:vimwiki_list=[
    \{
    \   'path': '~/Documents/wiki/',
    \   'syntax' : 'markdown',
    \   'ext' : '.md',
    \   'diary_rel_path': './today',
    \},
    \{
    \   'path': '~/Documents/wiki-company/',
    \   'syntax' : 'markdown',
    \   'ext' : '.md',
    \   'index' : 'index',
    \   'diary_rel_path': './today',
    \},
\]

let g:auto_template_list = [
    \{
    \   'path': '~/Documents/wiki/',
    \},
    \{
    \   'path': '~/Documents/wiki/computer/',
    \},
    \{
    \   'path': '~/Documents/wiki/literature/',
    \},
    \{
    \   'path': '~/Documents/wiki/language/',
    \},
    \{
    \   'path': '~/Documents/wiki/exercise/',
    \},
    \{
    \   'path': '~/Documents/wiki/music/',
    \},
    \{
    \   'path': '~/Documents/wiki/note/',
    \},
    \{
    \   'path': '~/Documents/wiki/cook/',
    \},
    \{
    \   'path': '~/Documents/wiki-company/',
    \},
\]

" set conceallevel
let g:vimwiki_conceallevel=0
let g:vimwiki_global_ext=0

" disable table shortcut
let g:vimwiki_table_mappings=0

" disable auto fold
let g:vimwiki_folding='custom'

augroup vimwikiauto
    " <C-s> move table column to right
    autocmd FileType vimwiki inoremap <C-s> <C-r>=vimwiki#tbl#kbd_tab()<CR>
    " <C-a> move table column to left
    autocmd FileType vimwiki inoremap <C-a> <Left><C-r>=vimwiki#tbl#kbd_shift_tab()<CR>
    " diabled tab
    autocmd FileType vimwiki silent! iunmap <buffer> <Tab>
augroup END

autocmd FileType vimwiki nnoremap <C-h> :VimwikiGoBackLink<CR>

let g:md_modify_disabled = 0

function! LastModified()
    if g:md_modify_disabled
        return
    endif
    if &modified
        " echo('markdown updated time modified')
        let save_cursor = getpos(".")
        let n = min([10, line("$")])
        keepjumps exe '1,' . n . 's#^\(.\{,10}lastmod\s*: \).*#\1' .
            \ strftime('%Y-%m-%d %H:%M:%S+0900') . '#e'
        call histdel('search', -1)
        call setpos('.', save_cursor)
    endif
endfun

function! NewTemplate()
    let l:wiki_directory = v:false
    for wiki in g:auto_template_list
        if expand('%:p:h') . '/' == expand(wiki.path)
            let l:wiki_directory = v:true
            break
        endif
    endfor
    if !l:wiki_directory
        return
    endif
    if line("$") > 1
        return
    endif

    let l:template = []
    call add(l:template, '---')
    call add(l:template, 'title        : "' . expand('%:t:r') . expand('"'))
    call add(l:template, 'summary      : "' . expand('%:t:r') . expand('"'))
    call add(l:template, 'date         : ' . strftime('%Y-%m-%d %H:%M:%S+0900'))
    call add(l:template, 'lastmod      : ' . strftime('%Y-%m-%d %H:%M:%S+0900'))
    call add(l:template, 'related link :')
    call add(l:template, 'tags         : [""]')
    call add(l:template, 'categories   : [""]')
    call add(l:template, 'draft        : true')
    call add(l:template, '---')
    call add(l:template, '')
    call setline(1, l:template)
    execute 'normal! G'
    execute 'normal! $'

    echom 'new wiki page has created'
endfunction

function! UdpateRelatedLinks()
    execute 'silent !related_link' '"%:t:r"' '"%:p"'
endfunction

augroup vimwikiauto
    autocmd BufWritePre *wiki*/*.md call LastModified()
    autocmd BufWritePost *wiki*/*.md call UdpateRelatedLinks()
    autocmd BufRead,BufNewFile *wiki*/*.md call NewTemplate()
augroup END

function! UpdateBookProgress()
  let l:save_cursor = getpos(".")
  let l:awk_command = "awk '{print int($4 * 100 / $6), \"\\% :\", $4, $5, $6 }'"
  %g,\v^\d+ \% : \d+ \/ \d+,exe "normal! V!" . l:awk_command . "\<CR>"
  call setpos('.', l:save_cursor)
endfunction

augroup bookupdateauto
  autocmd BufWritePre *wiki/book.md call UpdateBookProgress()
augroup END

" plugin name: vim-better-whitespace
let g:better_whitespace_enabled=1

" save the buffer whenever text is changed
if expand("%:p") =~ 'COMMIT_EDITMSG'
  let g:auto_save = 0
else
  let g:auto_save = 1
endif

if g:auto_save
    autocmd TextChanged,TextChangedI <buffer> silent write
endif

" Set Section
set nocompatible

if has("syntax")
  syntax on
end

if has("gui_running")
  set guifont=JetBrainsMonoNL\ Nerd\ Font\ Mono:h14
endif

filetype plugin indent on

let g:vim_json_conceal=0

set autoindent

set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=4

set hlsearch
set incsearch
set ignorecase
set smartcase

set autoread

set encoding=utf-8
set fencs=utf-8
lang en_US.UTF-8
set fileformats=unix,dos,mac

set history=9999

set backspace=2

set hidden

set noerrorbells

set scrolloff=8

set showcmd
set wildmenu
set showmode

set number
set relativenumber

set nobackup
set noswapfile
if has("persistent_undo")
  let target_path_nvim = expand('~/.cache/nvim/undo/')
  let target_path_vim = expand('~/.vim/undo/')

  if !isdirectory(target_path_nvim)
    call mkdir(target_path_nvim, "p", 0700)
  endif

  if !isdirectory(target_path_vim)
    call mkdir(target_path_vim, "p", 0700)
  endif

  if has('nvim')
    let &undodir=target_path_nvim
    set undofile
  else
    let &undodir=target_path_vim
    set undofile
  endif
endif

set listchars=tab:→\ ,trail:-,eol:↲,extends:»,precedes:«,nbsp:%,space:·
set showbreak=↪
set list

set updatetime=100

let g:netrw_banner = 0

" remember cusor postion
au BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\ exe "norm g`\"" |
\ endif

for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '%', '-', '#' ]
    execute 'xnoremap i' . char . ' :<C-u>normal! T' . char . 'vt' . char . '<CR>'
    execute 'onoremap i' . char . ' :normal vi' . char . '<CR>'
    execute 'xnoremap a' . char . ' :<C-u>normal! F' . char . 'vf' . char . '<CR>'
    execute 'onoremap a' . char . ' :normal va' . char . '<CR>'
endfor

" add custome file type
autocmd BufNewFile,BufRead *.msg set filetype=message

" set indent by filetype
autocmd FileType ruby setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType typescript setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType javascript setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType go setlocal tabstop=4 noexpandtab

" https://github.com/vim/vim/blob/v8.2.0/runtime/indent/html.vim#L217-L220
let g:html_indent_inctags = 'p'

augroup format_options
  autocmd!
  autocmd BufEnter * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END

" Save file as sudo on files that require root permission
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Color Set
set termguicolors
set t_Co=256
let g:gruvbox_termcolors=256
let g:gruvbox_improved_warnings = 1
let g:gruvbox_transparent_bg=1
let g:gitgutter_override_sign_column_highlight=1
colorscheme gruvbox
set background=dark

set colorcolumn=81
highlight ColorColumn cterm=NONE ctermbg=236 ctermfg=red guibg=#3c3839 guifg=#ff0000

set signcolumn=yes:1
highlight SignColumn cterm=NONE ctermbg=NONE ctermfg=NONE

highlight Comment ctermfg=green

highlight BookmarkSign    ctermbg=NONE ctermfg=160 guibg=NONE guifg=#ff0000
highlight BookmarkLine    ctermbg=255  ctermfg=235 guibg=#ffffff guifg=#000000

highlight CustomColorTodo ctermbg=green ctermfg=black guibg=#BFFF00 guifg=#000000
highlight CustomColorError ctermbg=red  ctermfg=black guibg=#FF0000 guifg=#000000
highlight CustomColorWarning ctermbg=yellow ctermfg=black guibg=#FFFF00 guifg=#000000
highlight CustomColorOptimize ctermbg=blue ctermfg=black guibg=#0000FF guifg=#000000
highlight CustomColorHack ctermbg=214 ctermfg=black guibg=#F7B124 guifg=#000000
highlight CustomColorHelp ctermbg=106 ctermfg=black guibg=#AAB01E guifg=#000000
highlight CustomColorDeprecated ctermbg=255 ctermfg=black guibg=#FFFFFF guifg=#000000

augroup HiglightTODO
  autocmd!
  autocmd WinEnter,VimEnter * :silent! call matchadd('CustomColorTodo', 'TODO', -1)
  autocmd WinEnter,VimEnter * :silent! call matchadd('CustomColorError', 'FIXME\|XXX', -1)
  autocmd WinEnter,VimEnter * :silent! call matchadd('CustomColorWarning', 'WARNING', -1)
  autocmd WinEnter,VimEnter * :silent! call matchadd('CustomColorOptimize', 'OPTIMIZE', -1)
  autocmd WinEnter,VimEnter * :silent! call matchadd('CustomColorHack', 'HACK', -1)
  autocmd WinEnter,VimEnter * :silent! call matchadd('CustomColorHelp', 'HELP', -1)
  autocmd WinEnter,VimEnter * :silent! call matchadd('CustomColorDeprecated', 'DEPRECATED', -1)
augroup END

" status bar
set statusline=
set statusline+=\ %R                                       "Readonly or not
set statusline+=%m                                         "Modified
set statusline+=\ %F                                       "File full path
set statusline+=\ %l:%c                                    "Line:Col Number
set statusline+=\ %p%%\                                    "Row Percentage
set statusline+=%=                                         "Right side
set statusline+=\ %Y\ \|                                   "File type
set statusline+=\ %{&fileencoding?&fileencoding:&encoding} "Encoding
set statusline+=\[%{&fileformat}\]                         "Encoding2
set statusline+=\ 

" Thank you luke smith
" When shortcut files are updated, renew bash and ranger configs with new material:
autocmd BufWritePost bm-files,bm-dirs !shortcuts

"Key Mapping Section
let mapleader=" "

nnoremap <SPACE> <Nop>

nnoremap <silent> <leader><ENTER> :Marks<CR>

" When I press double space, I press as hard as possible. That make my boss think
" I'm a good programmer.
nnoremap <leader><SPACE> :
vnoremap <leader><SPACE> :

nnoremap <silent> Q <nop>

" Window
nnoremap <silent> w <nop>

nnoremap ww <C-w><C-w>
nnoremap wv <C-w><C-v>
nnoremap ws <C-w><C-s>

nnoremap wq <C-w><C-c>
nnoremap wo <C-w><C-o>

nnoremap wh <C-w><C-h>
nnoremap wj <C-w><C-j>
nnoremap wk <C-w><C-k>
nnoremap wl <C-w><C-l>

" plugin name: winresizer
let g:winresizer_start_key = 'wr'

" RELOAD
nnoremap <leader>R :source $XDG_CONFIG_HOME/nvim/init.vim<CR>

" Emacs on vim
inoremap <C-a> <HOME>
inoremap <C-e> <END>

nnoremap Y y$
nnoremap <C-y> y^
nnoremap <leader>Y "+y$
nnoremap <leader><C-y> "+y^
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>p "+p
vnoremap <leader>p "+p

nnoremap <leader>a ggVG

" We are fzf familiy. vim for life.
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>r :History<CR>
nnoremap <silent> <C-p> :GFiles<CR>
nnoremap <silent> <c-s> :Lines<CR>
vnoremap <silent> <c-s>s y:Lines <C-r>0<CR>
nmap <leader>x <plug>(fzf-maps-n)
xmap <leader>x <plug>(fzf-maps-x)
omap <leader>x <plug>(fzf-maps-o)

" DRY: Don't Repeat Yasnippet.
nnoremap <C-k> :Snippets<CR>
inoremap <C-k> <ESC>:Snippets<CR>

" Move like ninja🥷.
noremap <leader>` <C-^>

" vim's "s" is ready for snipper.
nnoremap s <Nop>

nmap <silent> sf <Plug>(easymotion-bd-fl)
vmap <silent> sf <Plug>(easymotion-bd-fl)
nmap <silent> ss <Plug>(easymotion-bd-f2)
vmap <silent> ss <Plug>(easymotion-bd-f2)
nmap <silent> sn <Plug>(easymotion-f2)
vmap <silent> sn <Plug>(easymotion-f2)
nmap <silent> sp <Plug>(easymotion-F2)
vmap <silent> sp <Plug>(easymotion-F2)

nmap <silent> sh <Plug>(easymotion-bl)
vmap <silent> sh <Plug>(easymotion-bl)
nmap <silent> sk <Plug>(easymotion-k)
vmap <silent> sk <Plug>(easymotion-k)
nmap <silent> sj <Plug>(easymotion-j)
vmap <silent> sj <Plug>(easymotion-j)
nmap <silent> sl <Plug>(easymotion-wl)
vmap <silent> sl <Plug>(easymotion-wl)

nmap <silent> s. <Plug>(easymotion-repeat)
vmap <silent> s. <Plug>(easymotion-repeat)

" Fix cursor on middle of screen
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" "g" is vim's goto func.
nnoremap <silent> g[ :GitGutterPrevHunk<CR>
nnoremap <silent> g] :GitGutterNextHunk<CR>

" <c-j> key is missing part of vim. I found this feature
nnoremap <C-j> i<CR><ESC>

nnoremap <C-l> :nohl<CR>

nnoremap <leader>; :
vnoremap <leader>; :

nnoremap <leader>\ :Ag<CR>
nnoremap \ :Rg<SPACE>

nnoremap x "_x
vnoremap x "_x

" Private DB
let g:vimwiki_map_prefix = '<Leader>v'
nmap <leader>vv <Plug>VimwikiIndex
nmap <leader>vi <Plug>VimwikiDiaryIndex
nmap <leader>v<leader>v <Plug>VimwikiMakeDiaryNote
nmap <leader>v<leader>i <Plug>VimwikiDiaryGenerateLinks
nmap <leader>vt :VimwikiTable<CR>

nnoremap <silent> <leader>b :Buffers<cr>

nnoremap <silent> n nzzzv
nnoremap <silent> N Nzzzv

nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap J mzJ`z
inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap ? ?<C-g>u

nnoremap <silent> <leader>. :e.<CR>
nnoremap <silent> <leader>, :e $XDG_CONFIG_HOME/nvim/init.vim<CR>

" Bookmarks
nmap <silent> <leader>ma <Plug>BookmarkShowAll
nmap <silent> <leader>mc <Plug>BookmarkClearAll
nmap <silent> <leader>me <Plug>BookmarkAnnotate
nmap <silent> <leader>mm <Plug>BookmarkToggle
nmap <silent> <leader>m] <Plug>BookmarkNext
nmap <silent> <leader>m[ <Plug>BookmarkPrev

nnoremap <silent> <F1> :h <C-r>=expand("<cword>")<CR>
vnoremap <silent> <F1> y :h <C-r>0
nnoremap <silent> <F2> :NERDTreeToggle<CR>
nnoremap <silent> <leader><F2> :NERDTreeFind<CR>
nnoremap <silent> <F3> :Lines TODO<CR>
nnoremap <silent> <F4> :UltiSnipsEdit<cr>
nnoremap <silent> <F8> :TagbarToggle<cr>
nnoremap <silent> <F12> <C-z>

" DEPRECATED

" " plugin name: blamer
" let g:blamer_enabled = 1
" let g:blamer_delay = 0
" let g:blamer_show_in_visual_modes = 0
" let g:blamer_show_in_insert_modes = 0
" let g:blamer_date_format = '%y/%m/%d %H:%M'
" let g:blamer_prefix = ' > '

" " plugin name: goyo
" function! s:goyo_enter()
"   imap <ESC> <ESC>zz
"   IndentGuidesDisable
" endfunction

" function! s:goyo_leave()
"   imap <ESC> <ESC>
"   IndentGuidesEnable
" endfunction

" autocmd! User GoyoEnter nested call <SID>goyo_enter()
" autocmd! User GoyoLeave nested call <SID>goyo_leave()

" nnoremap <silent> <F11> :Goyo<cr>

" nvim defualt
" vim visual star search
" xnoremap * :<C-u>call <SID>VisualSetSearch('/')<CR>/<C-R>=@/<CR><CR>
" function! s:VisualSetSearch(cmdtype)
"   let temp = @s
"   norm! gv"sy
"   let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
"   let @s = temp
" endfunction

