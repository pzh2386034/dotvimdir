function! Goup(path, patterns) abort
    let l:path = a:path
    while 1
        for l:pattern in a:patterns
            let l:current = l:path . '/' . l:pattern
            if stridx(l:pattern, '*') != -1 && !empty(glob(l:current, 1))
                return l:path
            elseif l:pattern =~# '/$'
                if isdirectory(l:current)
                    return l:path
                endif
            elseif filereadable(l:current)
                return l:path
            endif
        endfor
        let l:next = fnamemodify(l:path, ':h')
        if l:next == l:path || (has('win32') && l:next =~# '^//[^/]\+$')
            break
        endif
        let l:path = l:next
    endwhile
    return ''
endfunction

function! Findroot(echo) abort
    let l:bufname = expand('%:p')
    if &buftype !=# '' || empty(l:bufname) || stridx(l:bufname, '://') !=# -1
        return
    endif
    let l:dir = escape(fnamemodify(l:bufname, ':p:h:gs!\!/!:gs!//!/!'), ' ')
    let l:patterns = get(g:, 'findroot_patterns', [
                \  '.git/',
                \  'manifest.json',
                \  '.root'
                \])
    let l:dir = Goup(l:dir, l:patterns)
    if empty(l:dir)
        return ""
    endif
    if get(g:, 'findroot_not_for_subdir', 1) && stridx(tolower(fnamemodify(getcwd(), ':gs!\!/!')), tolower(l:dir)) == 0
        return ""
    endif
    " exe 'lcd' l:dir
    if a:echo
        echom l:dir
    endif
    return l:dir
endfunction
" ===================== 自动搜索加载tag =====================
"function Compile_and_run(game, major, minor)
"execute '!_compile' shellescape(a:game) shellescape(a:major) shellescape(a:minor)
"endfunction
function! Load_tag(word)
    let command_fmt = 'setlocal tags+=%s'
    let search_fmt = 'rg --files  ~/.cache/tags |rg -i %s'
    let searchCmm = printf(search_fmt, a:word)
    let files = systemlist(searchCmm)
    for tagname in files
        let choice = confirm(tagname, "&y\n&n\n&c")
        if choice == 1
            let comm = printf(command_fmt, tagname)
            execute comm
        elseif choice == 2
            continue
        else
            break
        endif
    endfor
endfunc

function! Bitbake_compile()
    let command_fmt = 'bitbake %s'
    let initial_command = Findroot(1)
    let  module = escape(fnamemodify(initial_command, ':t'), ' ')
    let command = printf(command_fmt, module)
    return command
endfunc

" noremap cc :<C-U><C-R>=printf("AsyncRun %s", Bitbake_compile())<CR>
noremap cc :call CompileRunGcc()<CR>
func! CompileRunGcc()
    let bb = getenv('BBPATH')
    echom "=================e"
    if &filetype == 'c'
        if bb == v:null
            exec "!g++ % -o %<"
            exec "!time ./%<"
        else
            let commdfmt = 'AsyncRun %s'
            let command = printf(commdfmt, Bitbake_compile())
            exec command
        endif
    elseif &filetype == 'cpp'
        if bb == v:null
            exec "!g++ % -o %<"
            exec "!time ./%<"
        else
            let commdfmt = 'AsyncRun %s'
            let command = printf(commdfmt, Bitbake_compile())
            exec command
        endif

    elseif &filetype == 'java'
        exec "!javac %"
        exec "!time java %<"
    elseif &filetype == 'sh'
        time bash %
    elseif &filetype == 'python'
        exec "!clear"
        exec "!time python3 %"
    elseif &filetype == 'html'
        if bb == v:null
            exec "!firefox % &"
        else
            let commdfmt = 'AsyncRun %s'
            let command = printf(commdfmt, Bitbake_compile())
            exec command
        endif
    elseif &filetype == 'go'
        exec "!go build %<"
        exec "!time go run %"
    elseif &filetype == 'mkd'
        exec "!~/.vim/markdown.pl % > %.html &"
        exec "!firefox %.html &"
    elseif &filetype == 'javascript'
        let commdfmt = 'AsyncRun %s'
        let command = printf(commdfmt, Bitbake_compile())
        exec command
    else
        echom "unknow filetype"
    endif
endfunc
" Define a custom command to run vimgrep and add the results to the quickfix
command! -nargs=+ -complete=file Gall call s:run_grep("<args>", 0)
command! -nargs=+ -complete=file Gbuf call s:run_grep("<args>", 1)

function! s:run_grep(pattern, search_buffer)
    " Save the current position in the jup list
    let l:old_pos = getpos(".")
    "
    " Run vimgrep with the specified pattern and add the results to the
    " quickfix
    let l:cmd = "vimgrep /" . escape(a:pattern, "/\\") . "/g"
    if a:search_buffer
        let l:cmd .= " %"
    else
        let l:cmd .= " **/*"
    endif
    try
        execute l:cmd . " | copen"
    catch /E480:/
        " Ignore the error message that appears when no matches are found
    endtry
    " Restore the original position in the jump list
    call setpos(".", l:old_pos)
endfunction
