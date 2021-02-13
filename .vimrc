""" colors
syntax on
set background=dark

""" disable backups
set nowritebackup
set nobackup
set noswapfile

""" default options
set nocompatible 						" use new features
set clipboard=unnamed 					" use OS clipboard by default
set wildmenu 							" enhance completion
set mouse=a 							" enable mouse in all modes
set esckeys 							" allow cursor keys in insert mode
set backspace=indent,eol,start 			" backspace through everything in insert mode
set ttyfast								" optimize for fast terminal connections
set gdefault							" add g flag to search/replace by default
set encoding=utf-8 nobomb				" use utf8 and avoid adding bom characters
set modeline							" enable modeline support
set modelines=4							" number of lines down vim will check for set commands
set number								" enable line numbers
set cursorline							" highlight current line
set tabstop=2 shiftwidth=2				" tabs width
set expandtab                   		" use spaces, not tabs (optional)
set list								" add extra visible chars
set listchars=tab:\|\ ,eol:¬,trail:·,extends:❯,precedes:❮,nbsp:_
set laststatus=2						" always show status line
set noerrorbells						" disable error bells
set nostartofline						" don't reset cursor to start of line when moving
set ruler								" show cursor
set showmode							" show current mode
set title								" display filename in titlebar
set showcmd								" show command as it's being typed
set scrolloff=3							" scroll three lines before the horizontal window border

""" search
set hlsearch							" highlight search matches
set incsearch							" highlight as pattern is typed
set ignorecase							" ignore case of searches


""" mappings
"let mapleader="\<Space>"				" change leader to space instead of backslash

" command-line map to save as root with w!!
cmap w!! w !sudo tee > /dev/null %

" strip trailing whitespace (ss)
function! s:strip_whitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call s:strip_whitespace()<CR>

" save as root (W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

""" automatic commands
if has("autocmd")
	filetype on							" Enable file type detection
	autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
	autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
endif

