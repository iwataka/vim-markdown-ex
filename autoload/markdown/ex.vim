let s:save_cpo = &cpoptions
set cpoptions&vim

if !exists('g:markdown_ex_link_history_path')
  let g:markdown_ex_link_history_path = expand('~/.cache/vim-markdown-ex/history.txt')
  if !isdirectory(fnamemodify(g:markdown_ex_link_history_path, ':h'))
    call mkdir(fnamemodify(g:markdown_ex_link_history_path, ':h'), 'p')
  endif
endif
if !exists('g:markdown_ex_link_history_max')
  let g:markdown_ex_link_history_max = 100
endif
if !exists('g:markdown_ex_auto_foldopen')
  let g:markdown_ex_auto_foldopen = &foldopen =~# 'search'
endif

let s:search_linkpat = '\v\[([^\]]+)\]\(\zs([^\)]+)\ze\)'
let s:linkpat = '\v\[([^\]]+)\]\(([^\)]+)\)'

fu! markdown#ex#toggle_checkbox(type, ...)
  if a:0
    let [lnum1, lnum2] = [a:type, a:1]
  else
    let [lnum1, lnum2] = [line("'["), line("']")]
  endif

  let linenr = lnum1
  while linenr <= lnum2
    let line = getline(linenr)
    if line =~ '\v^\s*[-+*]\s*\[x\]'
      let line = substitute(line, '\v^\s*[-+*]\s\zs\s*\[[^\]]*\]\s*\ze', '', '')
    elseif line =~ '\v^\s*[-+*]\s*\[\s*\]'
      let line = substitute(line, '\v^(\s*[-+*]\s*\[)\s*(\])', '\1'.'x'.'\2', '')
    elseif line =~ '\v^\s*[-+*]\s*'
      let line = substitute(line, '\v^(\s*[-+*]\s*)(.*)', '\1'.'[ ] '.'\2', '')
    endif
    call setline(linenr, line)
    let linenr += 1
  endwhile
endfu

fu! markdown#ex#foldtext()
  let line = foldtext()
  return substitute(line, '\v\[(.*)\]\(.*\)', '\1', 'g')
endfu

fu! markdown#ex#next_link(flags, count)
  let i = 0
  while i < a:count
    call search(s:search_linkpat, a:flags)
    let i += 1
  endwhile
  if g:markdown_ex_auto_foldopen
    call s:foldopen()
  endif
endfu

fu! markdown#ex#open_link()
  let line = getline(line('.'))
  let len = len(line)
  let col = col('.')
  let dist = len(line)
  let text = ''
  let end = 0
  while 1
    let [txt, start, end] = matchstrpos(line, s:linkpat, end)
    if empty(txt)
      break
    endif
    let dst = col < start ? start - col : col <= end ? 0 : col - end
    if dst < dist
      let dist = dst
      let text = txt
    endif
  endwhile
  call s:open_link(text)
endfu

fu! s:open_link(text)
  let uri = substitute(a:text, s:linkpat, '\2', '')
  let uri = empty(uri) ? expand('<cfile>') : uri
  if uri =~ '\v^http://|^https://'
    call s:assure_link_history()
    let item = {
          \ 'title': substitute(a:text, s:linkpat, '\1', ''),
          \ 'uri': substitute(a:text, s:linkpat, '\2', '')
          \ }
    call s:add_history(item)
    call s:open(uri)
  elseif uri =~ '\v^#'
    let pat = substitute(uri, '\v^#', '\\v^#+\\s*', '')
    let pat = substitute(pat, '--', '\\A*', 'g')
    let pat = substitute(pat, '-', '\\A*', 'g')
    let pat = substitute(pat, '$', '\\A*', '')
    let ic = &ic
    let &ic = 1
    call search(pat, 'sw')
    let &ic = ic
  else
    let dir = fnamemodify(expand('%'), ':h')
    if uri =~ '\v^/'
      let root = s:root(dir)
      if empty(root)
        return 0
      else
        let uri = root.uri
      endif
    else
      let uri = dir.'/'.uri
    endif
    if filereadable(uri) || isdirectory(uri)
      exe 'edit '.uri
    endif
  endif
endfu

fu! s:assure_link_history()
  if !exists('s:link_history')
    let lines = filereadable(g:markdown_ex_link_history_path) ?
          \ readfile(g:markdown_ex_link_history_path) : []
    let str = empty(lines) ? '[]' : join(lines, '')
    let s:link_history = eval(str)
    augroup vim_markdown_ex
      autocmd!
      autocmd VimLeavePre * call s:save_history()
    augroup END
  endif
endfu

fu! s:add_history(item)
  let i = 0
  while i < len(s:link_history)
    if s:link_history[i].title == a:item.title
      call remove(s:link_history, i)
      break
    endif
    let i += 1
  endwhile
  call insert(s:link_history, a:item, 0)
endfu

fu! s:save_history()
  let str = string(s:link_history[0:g:markdown_ex_link_history_max])
  call writefile([str], g:markdown_ex_link_history_path)
endfu

fu! s:open(url)
  if has('mac')
    let cmd = 'open'
  elseif has('win32unix') && executable('cygstart')
    let cmd = 'cygstart'
  elseif has('unix')
    let cmd = 'xdg-open'
  elseif has('win32')
    let cmd = 'rundll32 url.dll,FileProtocolHandler'
  endif
  call system(cmd.' '.shellescape(a:url))
endfu

fu! s:root(cwd)
  let rmarkers = ['.git', '.hg', '.svn', '.bzr', '_darcs']
  for mark in rmarkers
    let rdir = finddir(mark, a:cwd.';')
    if !empty(rdir)
      return fnamemodify(rdir, ':h')
    endif
  endfor
  return ''
endfu

fu! markdown#ex#text_object(inner)
  let cols = []
  let lines = getline(0, '$')
  let lnum = line('.')
  let len = len(lines)
  let i = 0
  while i < len
    let line = lines[i]
    if line =~ '\v^```'
      call add(cols, i + 1)
    endif
    let i += 1
  endwhile
  let [n1, n2] = s:between(cols, lnum)
  let flag = a:inner ? 1 : 0
  if n1 > 0
    execute printf('normal! %dGV%dG', n1 + flag, n2 - flag)
  endif
endfu

fu! s:between(list, n)
  let len = len(a:list)
  let i = 0
  while i < len - 1
    let n1 = a:list[i]
    let n2 = a:list[i + 1]
    if n1 <= a:n && a:n <= n2
      return [n1, n2]
    endif
    let i += 2
  endwhile
  return [-1, -1]
endfu

fu! markdown#ex#search_header(flags)
  let s:headers = filter(getline(0, line('$')), 'v:val =~ "\\v^#+"')
  let s:headers = map(s:headers, 'substitute(v:val, "\\v^#+\\s*", "", "")')
  call inputsave()
  let prompt = a:flags =~ 'b' ? '?' : '/'
  let key = input(prompt, '', 'customlist,markdown#ex#complete_header')
  call inputrestore()
  if !empty(key)
    call search('\V\^#\+\s\*'.key.'\$', a:flags)
    if g:markdown_ex_auto_foldopen
      call s:foldopen()
    endif
  endif
endfu

fu! s:foldopen()
  let i = 0
  let level = foldlevel(line('.'))
  while i < level
    foldopen
    let i += 1
  endwhile
endfu

fu! markdown#ex#complete_header(A, L, P)
  return filter(copy(s:headers), 'v:val =~ "\\V\\^".a:A')
endfu

fu! markdown#ex#open_link_history(...)
  call s:assure_link_history()

  if a:0
    let title = a:1
  else
    call inputsave()
    let title = input('Title> ', '',
          \ 'customlist,markdown#ex#open_link_history_complete')
    call inputrestore()
  endif
  for item in s:link_history
    if item.title == title
      call s:open(item.uri)
      break
    endif
  endfor
endfu

fu! markdown#ex#open_link_history_complete(A, L, P)
  call s:assure_link_history()
  let titles = map(copy(s:link_history), 'v:val.title')
  return filter(titles, 'v:val =~ "\\v^".a:A')
endfu

let &cpo = s:save_cpo
unlet s:save_cpo
