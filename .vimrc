" Set various useful options to make everything nicer
set nocompatible   " Allow the use of vim-specific stuff
set expandtab
set shiftwidth=4
set softtabstop=4
set backspace=indent,eol,start
set hidden
set whichwrap=b,s
set incsearch
set showmatch
set ignorecase
set smartcase
set history=100   " Keep more history
set ruler         " Show the cursor position all the time
set showcmd       " Show commands at all times

if version >= 600
    if has("autocmd")
        "Some autocmd's
        autocmd!

        autocmd FileType lisp set autoindent lisp
        autocmd FileType mail set tw=72
        autocmd FileType make set noet sw=8 sts=0
        autocmd FileType tex set tw=76
        autocmd FileType text set tw=76

        " These are no longer necessary because of programmable indentation.
        " autocmd FileType perl,ruby set cinkeys=0{,0},:,!^F,o,O,e|set cindent
        " autocmd FileType c set cindent
        " autocmd FileType cpp set cindent
        " autocmd FileType java set cindent
        " autocmd FileType sh set autoindent

        autocmd BufRead *.buf set ft=sql
        autocmd BufRead,BufNewFile README set ft=text
        autocmd BufRead,BufNewFile *.txt set ft=text
        autocmd BufRead,BufNewFile ChangeLog set ft=text sts=8
        autocmd BufRead .emacs set ft=lisp
    endif

    filetype indent on
    filetype plugin on

    " Might not be necessary
    set background=dark
    syntax on

    " Enable mouse support
    "set mouse=a

    " Make comments look nicer
    highlight Comment ctermfg=green

    " Aligns the selected assignment statements neatly by inserting space characters
    function Align(line1, line2)
        let i = a:line1
        let mycount = a:line2
        let maxindex = 0

        while i <= mycount
            let line = getline(i)
            let index = match(line, "=")
            if index > maxindex
                let maxindex = index
            endif
            let i = i + 1
        endw

        let i = a:line1
        while i <= mycount
            let line = getline(i)
            let index = match(line, "=")
            if index < maxindex
                let diff = maxindex - index
                while diff > 0
                    let line = substitute(line, "=", " =", "")
                    let diff = diff - 1
                endw
                call setline(i, line)
            endif
            let i = i + 1
        endw
    endf

    " Define the Align command to call the Align function
    command -nargs=0 -range Align call Align(<line1>,<line2>)

    " TODO Find better keybindings
    map <F2> o
    map <F3> :Align
    " Macro to do list auto-numbering
    map <F4> 0y/\([a-z]\<Bar>$\)AP0$
    " Macro to make a Perl accessor out of its name
    map <F5> ^y$Isub <Esc>A { $_[0]->{_<Esc>pa}; }<Esc><Down>
    " Macro to make an XML element pair out of a word
    map <F6> ^ywi<A></pa>
endif
