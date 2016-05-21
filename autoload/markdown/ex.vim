let s:save_cpo = &cpoptions
set cpoptions&vim

let s:linkpat = '\v\[([^\]]+)\]\(\zs([^\)]+)\ze\)'

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
    call search(s:linkpat, a:flags)
    let i += 1
  endwhile
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
  if !empty(text)
    let uri = substitute(text, s:linkpat, '\2', '')
    call s:open_link(uri)
  endif
endfu

fu! s:open_link(uri)
  let uri = a:uri
  if uri =~ '\v^http://|^https://'
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
    exe 'edit '.uri
  endif
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
  endif
endfu

fu! markdown#ex#complete_header(A, L, P)
  return filter(copy(s:headers), 'v:val =~ "\\V\\^".a:A')
endfu

let &cpo = s:save_cpo
unlet s:save_cpo
