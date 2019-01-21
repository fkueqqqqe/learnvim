source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

" enable mouse
set mouse=a
set tabstop=4
set softtabstop=4
set shiftwidth=4

"encoding setting
set fileencodings=utf-8,ucs-bom,cp936,big5
set fileencoding=utf-8

"set autoindent
set expandtab
set smarttab

" setting of delay;
" timeoutlen used for mapping delay;
" ttimeoutlen used for key code delays;
set timeoutlen=500 
set ttimeoutlen=0

"back to console
noremap <leader>, :sh<CR>
"enable syntax highlight
syn on
" enable line number;
set number

"map jk to <esc>
noremap jk <esc>
inoremap jk <esc>

"operator-pending;
onoremap pa i(
onoremap sq i[
onoremap cu i{
onoremap b /return<cr>
onoremap in( :<c-u>normal! f(vi(<cr>

" html programming ;
nnoremap <leader>> <esc>^f>lvf<h

"php - debug
inoremap <leader>db echo "<pre>";<CR>print_r();<CR>echo "</pre>";<esc>khi
" comment the code
nnoremap <leader>/ 0i//<esc>j<esc>

"php template;
inoremap <leader>p <?php<CR>   <CR>?><esc>ki

" include file
inoremap <leader>i include "";<esc>h<esc>i

" echo 
inoremap <leader>e echo "";<esc>h<esc>i

" vimscript file setting --------{{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
"}}}

" add apostrophe,single quotation,square,bracket;
nnoremap <leader>' viw<esc>i'<esc>bi'<esc>
nnoremap <leader>" viw<esc>i"<esc>bi"<esc>
nnoremap <leader>[ viw<esc>i]<esc>bi[<esc>
nnoremap <leader>< viw<esc>i><esc>bi<<esc>
nnoremap <leader>( viw<esc>i)<esc>bi(<esc>

" highlight a word;
nnoremap <space> viw
"select the content between the sign;

"set the default leader
let mapleader=","

"edit vimrc
nnoremap <leader>ev :vsplit /etc/vimrc<CR>

" reread the vimrc file
nnoremap <leader>sv :source /etc/vimrc<CR>

"Vundle needed configs
set nocompatible
filetype off
set rtp+=$VIMRUNTIME/bundle/Vundle.vim

call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'mattn/emmet-vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'scrooloose/nerdtree'

call vundle#end()

"nertree toggle
map <leader>fl :NERDTreeToggle<CR>

"toggle the files
nnoremap <leader>hw <C-w>h
nnoremap <leader>lw <C-w>l
nnoremap <leader>kw <C-w>k
nnoremap <leader>jw <C-w>j

" folding
" set the default method: manual
set foldmethod=manual

set diffexpr=MyDiff()
function! MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

" Setting some decent VIM settings for programming

set ai                          " set auto-indenting on for programming
set showmatch                   " automatically show matching brackets. works like it does in bbedit.
set vb                          " turn on the "visual bell" - which is much quieter than the "audio blink"
set ruler                       " show the cursor position all the time
set laststatus=2                " make the last line where the status is two lines deep so you can see status always
set backspace=indent,eol,start  " make that backspace key work the way it should
set nocompatible                " vi compatible is LAME
set background=dark             " Use colours that work well on a dark background (Console is usually black)
set showmode                    " show the current mode
set clipboard=unnamed           " set clipboard to unnamed to access the system clipboard under windows
syntax on                       " turn syntax highlighting on by default

" Show EOL type and last modified timestamp, right after the filename
set statusline=%<%F%h%m%r\ [%{&ff}]\ (%{strftime(\"%H:%M\ %d/%m/%Y\",getftime(expand(\"%:p\")))})%=%l,%c%V\ %P

"------------------------------------------------------------------------------
" Only do this part when compiled with support for autocommands.
if has("autocmd")
    "Set UTF-8 as the default encoding for commit messages
    autocmd BufReadPre COMMIT_EDITMSG,MERGE_MSG,git-rebase-todo setlocal fileencodings=utf-8

    "Remember the positions in files with some git-specific exceptions"
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$")
      \           && expand("%") !~ "COMMIT_EDITMSG"
      \           && expand("%") !~ "MERGE_EDITMSG"
      \           && expand("%") !~ "ADD_EDIT.patch"
      \           && expand("%") !~ "addp-hunk-edit.diff"
      \           && expand("%") !~ "git-rebase-todo" |
      \   exe "normal g`\"" |
      \ endif

      autocmd BufNewFile,BufRead *.patch set filetype=diff
      autocmd BufNewFile,BufRead *.diff set filetype=diff

      autocmd Syntax diff
      \ highlight WhiteSpaceEOL ctermbg=red |
      \ match WhiteSpaceEOL /\(^+.*\)\@<=\s\+$/

      autocmd Syntax gitcommit setlocal textwidth=74
endif " has("autocmd")
