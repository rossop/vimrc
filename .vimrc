" ============================================================================
" ============================================================================
"								VIMRC CHANGES LOG
" ============================================================================
" ============================================================================
" inspiration from VIMCAST					Oct 2017


" ============================================================================
"									COLORS
" ============================================================================
"highlight SpecialKey guifg=#4a4a59
" highlight Normal ctermfg=grey ctermbg=darkgrey
"-----------------------------------------------------------------------------
"Show lines numbers and length
"-----------------------------------------------------------------------------
set number  " make it not happen if is txt
set tw=79   " width of the document (used by gd)
set nowrap  " don't automatically wrap on load
set fo-=t   " don't automatically wrap text when typing
set colorcolumn=80
"-----------------------------------------------------------------------------
"Colorscheme
"-----------------------------------------------------------------------------
syntax enable
let g:solarized_termcolors=256
colorscheme solarized
set background=dark
  
"	autocmd Filetype text :call color blackboard
" ============================================================================



" ============================================================================
"									SETTINGS
" ============================================================================
"avoid pressing shift when wanting to recall :
nnoremap ; :

"------------------------------------------------------------------------------
"Avoid using arrows - positive reinforcement
"------------------------------------------------------------------------------
"let mapleader = ","
"nmap <leader>a :call <SID>arrows!()<CR>

"------------------------------------------------------------------------------
"shortcut to rapidly toggle `set list`
"------------------------------------------------------------------------------
nmap <leader>l :set list!<CR>
"shortcut stripping trailing whitespaces
  nnoremap <silent> <F5> :call <SID>StripTrailingWhitespaces()<CR>

"-----------------------------------------------------------------------------
"shortcut for indents
"-----------------------------------------------------------------------------
nmap <D-[> <<
nmap <D-]> >>
vmap <D-[> <gv
vmap <D-]> >gv

"------------------------------------------------------------------------------
"shortcut for Multiple Tabs
"------------------------------------------------------------------------------
"	Tab movement shortcuts -- add a system dependent comand so that it does not 
"	crash for linux
map <D-S-]> gt
map <D-S-[> gT
map <D-1> 1gt
map <D-2> 2gt
map <D-3> 3gt
map <D-4> 4gt
map <D-5> 5gt
map <D-6> 6gt
map <D-7> 7gt
map <D-8> 8gt
map <D-9> 9gt
map <D-0> :tablast<CR>

"------------------------------------------------------------------------------
" Edit shortcuts
"------------------------------------------------------------------------------
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

"------------------------------------------------------------------------------
"Soft wrapping ---  LATEX use 
"------------------------------------------------------------------------------
command! -nargs=* Wrap set wrap linebreak nolist
"Move around soft wrap
vmap <D-j> gj
vmap <D-k> gk
vmap <D-4> g$
vmap <D-6> g^
vmap <D-0> g^
nmap <D-j> gj
nmap <D-k> gk
nmap <D-4> g$
nmap <D-6> g^
nmap <D-0> g

"------------------------------------------------------------------------------
"Spelling shortcut
"------------------------------------------------------------------------------
" Toggle spell checking on and off with `,s`
let mapleader = ","
nmap <silent> <leader>s :set spell!<CR>

" Quick .vimrc open
let mapleader = ","
nmap <leader>v :tabedit $MYVIMRC<CR>

" Set region to British English
set spelllang=en_gb

"------------------------------------------------------------------------------
"White Spaces
"------------------------------------------------------------------------------

" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

"Set Tab default settings - use "Stab" to change
set ts=4 sts=4 sw=4 noexpandtab
" Only do this part when compiled with support for autocommands
if has("autocmd")
  " Enable file type detection
  filetype on

  " Syntax of these languages is fussy over tabs Vs spaces
  autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType vim  setlocal ts=2 sts=2 sw=2 expandtab

  " Customisations based on house-style (arbitrary)
  autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType javascript setlocal ts=4 sts=4 sw=4 noexpandtab
  autocmd FileType python  setlocal ts=4 sts=4 sw=4 noexpandtab
  " Treat .rss files as XML
  autocmd BufNewFile,BufRead *.rss setfiletype xml
endif

"Automatically strip whitelines
autocmd BufWritePre *.py,*.js :call <SID>StripTrailingWhitespaces()


" ============================================================================
" BUFFERS and MULTIPLE WINDOWS
"Deal with hidden buffers
set hidden

" ============================================================================
" 				FUNCTIONS
" ============================================================================

" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction

function! SummarizeTabs()
  try
    echohl ModeMsg
    echon ' tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction

"Strip Trailing Whitespaces
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

"Restore cursor position and highlight sintax
if has("autocmd")
  " Enable filetype detection
  filetype plugin indent on

  " Restore cursor position
  autocmd BufReadPost *
        \  if line("'\"") > 1 && line("'\"") <= line("$") |
        \    exe "normal! g`\"" |
        \  endif
  endif
if &t_Co > 2 || has("gui_running")
  " Enable syntax highlighting
  syntax on
endif


" Source the vimrc file after saving it
if has("autocmd")
   autocmd bufwritepost .vimrc source $MYVIMRC
endif

" Show syntax highlighting groups for word under cursor
nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
	if !exists("*synstack")
		return
	endif
	echo map(synstack(line('.'), col('.')), 'synIDattr(v:val,"name")')
endfunction

"------------------------------------------------------------------------------
"Avoid using arrows - positive reinforcement
"------------------------------------------------------------------------------
"function! <SID>arrows!()
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
"endfunction
