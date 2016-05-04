fu! markdown#link#execute(expr)
  call s:init(a:expr)
  call inputsave()
  let key = input('Link> ', '', 'customlist,markdown#link#complete')
  call inputrestore()
  let uris = get(s:links, key, '')
  if len(uris) == 1
    let uri = uris[0]
  else
    let uri = s:choose(uris, 'Which to open? ')
  endif
  if !empty(uri)
    call s:open_link(uri)
  endif
  return 1
endfu

fu! markdown#link#complete(A, L, P)
  return filter(keys(s:links), 'v:val =~ "^'.a:A.'"')
endfu

fu! s:init(expr)
  let s:expr = empty(a:expr) ? bufnr('%') : a:expr
  if bufexists(s:expr)
    let lines = getbufline(s:expr, 0, '$')
  elseif filereadable(s:expr)
    let lines = readfile(s:expr)
  endif
  if exists('lines')
    let s:links = s:links(lines)
    return 1
  endif
  return 0
endfu

fu! s:edit()
  if bufexists(s:expr)
    exe 'buffer '.s:expr
  elseif filereadable(s:expr)
    exe 'edit '.s:expr
  else
    throw 'Invalid expression'
  endif
endfu

fu! s:choose(textlist, msg)
  redraw!
  for i in range(len(a:textlist))
    echo (i + 1).'. '.a:textlist[i]
  endfor
  echo a:msg
  let len = len(a:textlist)
  let str = ''
  while len > 1
    let str .= getchar()
    let len = len / 10
  endwhile
  let index = str2nr(nr2char(str)) - 1
  redraw!
  if index >= 0 && index < len(a:textlist)
    return a:textlist[index]
  endif
endfu

fu! s:open_link(uri)
  let uri = a:uri
  if uri =~ '\v^http://|^https://'
    call s:open(uri)
  elseif uri =~ '\v^#'
    call s:edit()
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

fu! s:links(lines)
  let i = 0
  let len = len(a:lines)
  let result = {}
  let pat =  '\v\[([^\]]+)\]\(([^\)]+)\)'
  while i < len
    let seg = matchstr(a:lines[i], pat)
    if !empty(seg)
      let key = substitute(seg, pat, '\1', '')
      let val = substitute(seg, pat, '\2', '')
      if has_key(result, key)
        call add(result[key], val)
      else
        let result[key] = [val]
      endif
    endif
    let i += 1
  endwhile
  return result
endfu
