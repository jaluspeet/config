syntax enable
filetype on
filetype plugin on
filetype indent on
set updatetime=100
set scrolloff=10
set autoindent
set noexpandtab
set tabstop=4
set cursorline
set nospell
set shiftwidth=4
set hlsearch
set path=**
set number
set noswapfile
set ignorecase
set smartcase
set nowrap
set incsearch
set mouse=a
set splitright
set splitbelow
set title
set list
set listchars=tab:>\ ,trail:_,extends:>,precedes:<,nbsp:~
set nocompatible
set wildmenu
set autowrite
set autowriteall
set signcolumn=number
set omnifunc=syntaxcomplete#Complete
set wildmode=longest:full,full
set wildoptions+=pum
set wildoptions+=fuzzy
set clipboard=unnamedplus,unnamed
set pumheight=15
set laststatus=2
set completeopt=menuone,noinsert,noselect,preview
set sessionoptions-=options
set viewoptions-=options
set complete-=i
set smarttab
set backspace=indent,eol,start
set nrformats-=octal
set timeout
set timeoutlen=100
set autoread
set nolangremap
let g:netrw_banner = 1
let g:netrw_winsize = 20
let g:netrw_liststyle = 1
set statusline+=%*\ %n\ %*
set statusline+=%*%{&ff}%*
set statusline+=%*%y%*
set statusline+=%*\ %<%F%*
set statusline+=%*%m%*
set statusline+=%*%=%5l%*
set statusline+=%*/%L%*
set statusline+=%*%4v\ %*

colorscheme lunaperche
highlight! CursorLine ctermbg=NONE guibg=NONE cterm=NONE term=NONE
highlight! Normal guibg=NONE ctermbg=NONE
highlight! Warning ctermfg=DarkYellow guifg=DarkYellow cterm=underline term=underline
highlight! Information ctermfg=Blue guifg=Blue cterm=underline term=underline
highlight! Hint ctermfg=Green guifg=Green cterm=underline term=underline

augroup highlight_user_events
	autocmd!
	autocmd ColorScheme * highlight! CursorLine ctermbg=NONE guibg=NONE cterm=NONE term=NONE
	autocmd ColorScheme * highlight! Normal guibg=NONE ctermbg=NONE
	autocmd ColorScheme * highlight! Warning ctermfg=DarkYellow guifg=DarkYellow cterm=underline term=underline
	autocmd ColorScheme * highlight! Information ctermfg=Blue guifg=Blue cterm=underline term=underline
	autocmd ColorScheme * highlight! Hint ctermfg=Green guifg=Green cterm=underline term=underline
augroup END

let vimDir = '$HOME/.vim'

if stridx(&runtimepath, expand(vimDir)) == -1
	let &runtimepath.=','.vimDir
endif

if has('persistent_undo')
	let myUndoDir = expand(vimDir . '/undodir')
	call system('mkdir ' . vimDir)
	call system('mkdir ' . myUndoDir)
	let &undodir = myUndoDir
	set undofile
endif

autocmd FileType qf setlocal norelativenumber nobuflisted

augroup QFClose
	au!
	au WinEnter * if winnr('$') == 1 && &buftype == "quickfix"|q|endif
augroup END

function! RunToQuickfixAsync(...) abort
  let l:cmd = join(a:000, ' ')
  call job_start(l:cmd, {
        \ 'out_cb': function('s:OnJobOut'),
        \ 'err_cb': function('s:OnJobOut'),
        \ 'exit_cb': function('s:OnJobExit')
        \ })
endfunction

let s:output = []

function! s:OnJobOut(job_id, data) abort
  if a:data !=# ''
    call extend(s:output, [a:data])
  endif
endfunction

function! s:OnJobExit(job_id, status) abort
  call setqflist([], 'r', {'lines': s:output})
  let s:output = []
  copen
  call PlaceQuickfixSigns()
endfunction

" synchronous version, for older vim
" function! RunToQuickfix(...) abort
" 	let l:cmd = join(a:000, ' ')
" 	let l:output = system(l:cmd)
" 	cgetexpr l:output
" 	copen
" 	call PlaceQuickfixSigns()
" endfunction

command! -nargs=+ -complete=file RunQF call RunToQuickfixAsync(<f-args>)

sign define QuickfixLineSign text=>> texthl=Error
function! PlaceQuickfixSigns() abort
	sign unplace *
		let qflist = getqflist()
	for idx in range(len(qflist))
		let entry = qflist[idx]
		if has_key(entry, 'bufnr') && has_key(entry, 'lnum') && entry['bufnr'] > 0
			execute 'sign place' idx+1 'line=' . entry['lnum'] . ' name=QuickfixLineSign buffer=' . entry['bufnr']
		endif
	endfor
endfunction

let g:mapleader = ' '
nnoremap <leader>n :noh<CR>
nnoremap <leader>s :wa!<CR>
nnoremap <leader>c :RunQF <UP>
nnoremap <leader>f :find 
nnoremap <leader>g :vimgrep 
nnoremap <leader>d :e %:h<CR>
nnoremap <leader>j :bnext<CR>
nnoremap <leader>k :bprev<CR>
nnoremap <leader>q :bd<CR>

nnoremap <silent>ge :try<bar>cnext<bar>catch /^Vim\%((\a\+)\)\=:E\%(553\<bar>42\):/<bar>cfirst<bar>cnext<bar>endtry<CR>
nnoremap <silent>gE :cprevious<CR>
nnoremap <silent><expr> <leader>e empty(filter(getwininfo(), 'v:val.quickfix')) ? ':copen<CR>' : ':cclose<CR>'
