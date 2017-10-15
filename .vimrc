" ============================================================================
" ============================================================================
"														VIMRC CHANGES LOG
" ============================================================================
" ============================================================================
" inspiration from VIMCAST					Oct 2017


" ============================================================================
"										SETTINGS
" ============================================================================
"shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>
"shortcut stripping trailing whitespaces
	nnoremap <silent> <F5> :call <SID>StripTrailingWhitespaces()<CR>

"shortcut for indents
nmap <D-[> <<
nmap <D-]> >>
vmap <D-[> <gv
vmap <D-]> >gv

"shortcut for Multiple Tabs
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
  autocmd FileType vim  setlocal ts=2 sts=2 sw=2 noexpandtab

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
"										COLORS
" ============================================================================
"Invisible character colors 
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59
" highlight Normal ctermfg=grey ctermbg=darkgrey
"Colorscheme
color blackboard
" ============================================================================


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
