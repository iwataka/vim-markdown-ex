let s:save_cpo = &cpoptions
set cpoptions&vim

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

fu! markdown#ex#links(...)
  let start = a:0 > 0 ? a:1 : 0
  let end = a:0 > 1 ? a:2 : line('$')
  let filter = a:0 > 2 ? a:3 : ''
  let lines = getline(start, end)
  return filter(s:links(lines), 'v:val.uri =~ "^'.filter.'"')
endfu

fu! s:links(lines)
  let i = 0
  let len = len(a:lines)
  let result = []
  let pat =  '\v\[([^\]]+)\]\(([^\)]+)\)'
  while i < len
    let seg = matchstr(a:lines[i], pat)
    if !empty(seg)
      let key = substitute(seg, pat, '\1', '')
      let val = substitute(seg, pat, '\2', '')
      let item = { 'title': key, 'uri': val }
      call add(result, item)
    endif
    let i += 1
  endwhile
  return result
endfu

fu! markdown#ex#open_link(key)
  if empty(a:key)
    call inputsave()
    let key = input('Link> ', '', 'customlist,markdown#ex#link_complete')
    call inputrestore()
  else
    let key = a:key
  endif
  let links = markdown#ex#links()
  for link in links
    if link.title == key
      let uri = link.uri
      break
    endif
  endfor
  if exists('uri')
    if uri =~ '\v^http://|^https://'
      call s:open(uri)
    elseif uri =~ '\v^#'
      let pat = substitute(uri, '\v^#', '\\v^#+\\s*', '')
      let pat = substitute(pat, '-', '[- ]', 'g')
      let ic = &ic
      let &ic = 1
      call search(pat)
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
  endif
  return 1
endfu

fu! markdown#ex#link_complete(A, L, P)
  let links = markdown#ex#links()
  return filter(map(copy(links), 'v:val.title'), 'v:val =~ "^'.a:A.'"')
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
  call system(cmd.' '.a:url)
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

let &cpo = s:save_cpo
unlet s:save_cpo
