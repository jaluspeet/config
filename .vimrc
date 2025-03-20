syntax enable
filetype on
filetype plugin on
filetype indent on
set updatetime=100
set termwinsize=10x0
set scrolloff=999
set autoindent
set noexpandtab
set tabstop=4
set shiftwidth=4
set hlsearch
set number
set relativenumber
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
set ttimeout
set ttimeoutlen=100
set autoread
set nolangremap
let g:netrw_banner = 0
let g:netrw_winsize = 20
set statusline+=%*\ %n\ %*
set statusline+=%*%{&ff}%*
set statusline+=%*%y%*
set statusline+=%*\ %<%F%*
set statusline+=%*%m%*
set statusline+=%*%=%5l%*
set statusline+=%*/%L%*
set statusline+=%*%4v\ %*
let g:fuzzyy_enable_mappings = 0
let g:lsp_use_native_client = 0
let g:lsp_semantic_enabled = 0
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_highlights_enabled = 1
let g:lsp_diagnostics_highlight_delay = 0
let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_document_code_action_signs_enabled = 0
let g:lsp_diagnostics_virtual_text_align = 'right'
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_inlay_hints_enabled = 0
let g:NERDTreeWinPos = "right"
let g:NERDTreeChDirMode = 2
let g:fuzzyy_window_layout = { 'files': { 'width': 0.9, 'height': 0.9 }, 'grep': { 'width': 0.9, 'height': 0.9 }, 'buffers': { 'width': 0.9, 'height': 0.9 } }
let g:fuzzyy_exclude_file = [
			\ '*.swp', 'tags',
			\ '*.exe', '*.dll', '*.so', '*.bin', '*.o', '*.obj', '*.a', '*.lib',
			\ '*.class', '*.jar', '*.war', '*.ear', '*.pyc', '*.pyo', '*.pyd',
			\ '*.zip', '*.tar', '*.gz', '*.bz2', '*.xz', '*.7z', '*.rar', '*.cab',
			\ '*.iso', '*.img', '*.dmg', '*.vmdk', '*.vdi', '*.qcow2',
			\ '*.pdf', '*.png', '*.jpg', '*.jpeg', '*.gif', '*.bmp', '*.tiff', '*.webp',
			\ '*.mp3', '*.wav', '*.flac', '*.aac', '*.ogg', '*.wma', '*.m4a',
			\ '*.mp4', '*.mkv', '*.avi', '*.mov', '*.wmv', '*.flv', '*.webm',
			\ '*.ttf', '*.otf', '*.woff', '*.woff2',
			\ '*.ico', '*.cur', '*.svgz',
			\ '*.db', '*.sqlite', '*.sqlite3', '*.mdb', '*.accdb',
			\ '*.bak', '*.tmp', '*.swp', '*.swo', '*.swn',
			\ '*.log', '*.trace', '*.pcap', '*.cap',
			\ '*.pak', '*.dat', '*.bin', '*.res', '*.dll',
			\ '*.rdb', '*.ldb', '*.sst', '*.log', '*.ldb',
			\ '*.crash', '*.dump', '*.dmp',
			\ '*.efi', '*.rom', '*.bin', '*.hex', '*.img',
			\ '*.lock', '*.pid'
			\ ]
let g:fuzzyy_exclude_dir = [
			\ '.git', '.hg', '.svn',
			\ 'node_modules', 'bower_components', 'vendor',
			\ 'dist', 'out', 'build', 'target', 'bin', 'obj',
			\ '__pycache__', '.mypy_cache', '.pytest_cache', 'venv', '.venv',
			\ '.gradle', 'gradle', '.idea', '.vscode', '.vs', '.settings',
			\ 'coverage', 'logs', 'tmp', 'cache',
			\ '.DS_Store', 'Thumbs.db', 'Desktop.ini'
			\ ]


" FUNCTIONS
autocmd FileType qf setlocal nonumber norelativenumber nocursorline

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

function! s:on_lsp_buffer_enabled() abort
	setlocal omnifunc=lsp#complete
	setlocal signcolumn=yes
	if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
endfunction

augroup lsp_install
	au!
	autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

function! s:custom_highlights_apply() abort
	highlight Normal guibg=NONE ctermbg=NONE
	highlight LineNr guibg=NONE ctermbg=NONE
	highlight NonText guibg=NONE ctermbg=NONE
	
	highlight SignColumn guibg=NONE ctermbg=NONE
	highlight Comment cterm=italic term=italic
	
	highlight! link GitGutterAdd DiffAdd
	highlight! link GitGutterDelete DiffDelete
	highlight! link GitGutterChange DiffChange
	highlight! link GitGutterAdd DiffAdd
	highlight! link GitGutterDelete DiffDelete
	highlight! link GitGutterChange DiffChange

	highlight link lspInlayHintsParameter Nontext
	highlight link lspInlayHintsType Nontext

	highlight Error ctermbg=White guibg=White ctermfg=Red guifg=Red
	highlight Warning ctermbg=Yellow guibg=Yellow ctermfg=Black guifg=Black
	highlight Information ctermbg=Blue guibg=Blue ctermfg=White guifg=White
	highlight Hint ctermbg=Green guibg=Green ctermfg=Black guifg=Black
	highlight! link QuickFixLine Error
	highlight! link LspErrorText Error
	highlight! link LspWarningText Warning
	highlight! link LspInformationText Info
	highlight! link LspHintText Hint
	highlight! link LspErrorHighlight Error
	highlight! link LspWarningHighlight Warning
	highlight! link LspInformationHighlight Info
	highlight! link LspHintHighlight Hint
	highlight! link LspErrorVirtualText Error
	highlight! link LspWarningVirtualText Warning
	highlight! link LspInformationVirtualText Info
	highlight! link LspVirtualText Hint
endfunction

augroup custom_highlights
	autocmd!
	autocmd ColorScheme * call s:custom_highlights_apply()
augroup END

colorscheme habamax

" PLUGINS
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin()
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'Donaldttt/fuzzyy'
Plug 'tpope/vim-dispatch'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-fugitive'
call plug#end()

" KEYBINDS
let g:mapleader = ' '
nnoremap <C-s> :wa!<CR>
nnoremap <F5> :Make<CR>

nnoremap <leader>n :noh<CR>
nnoremap <silent><leader>f :FuzzyFiles<CR>
nnoremap <silent><leader>s :FuzzyGrep<CR>
nnoremap <silent><leader>c :FuzzyCommands<CR>
nnoremap <silent><leader>b :FuzzyBuffers<CR>
nnoremap <silent><leader>h :FuzzyCmdHistory<CR>
nnoremap <silent><leader>t :term<CR>
nnoremap <silent><leader>g :Git<CR>
nnoremap <silent><leader>e :NERDTreeToggle<CR>

inoremap <expr><Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr><cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

nnoremap <silent><C-h> <C-W><C-H>
nnoremap <silent><C-j> <C-W><C-J>
nnoremap <silent><C-k> <C-W><C-K>
nnoremap <silent><C-l> <C-W><C-L>
tnoremap <silent><C-h> <C-\><C-N><C-W><C-H>
tnoremap <silent><C-j> <C-\><C-N><C-W><C-J>
tnoremap <silent><C-k> <C-\><C-N><C-W><C-K>
tnoremap <silent><C-l> <C-\><C-N><C-W><C-L>

nmap gd <plug>(lsp-definition)
nmap gr <plug>(lsp-references)
nmap gi <plug>(lsp-implementation)
nmap gt <plug>(lsp-type-definition)
nmap ge <plug>(lsp-previous-diagnostic)
nmap gE <plug>(lsp-next-diagnostic)
nmap K <plug>(lsp-hover)
nmap <expr><c-f> lsp#scroll(+4)
nmap <expr><c-d> lsp#scroll(-4)
nmap <leader>r <plug>(lsp-rename)
nmap <leader>a <plug>(lsp-code-action)
nmap <leader>o <plug>(lsp-document-symbol)
nmap <leader>d <plug>(lsp-document-diagnostics)
