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

" This return value can be applied to setqflist() and setloclist() directly
fu! markdown#ex#links(...)
  let start = a:0 > 0 ? a:1 : 0
  let end = a:0 > 1 ? a:2 : line('$')
  let filter = a:0 > 2 ? a:3 : ''

  let lines = getline(start, end)
  let result = []
  let pat =  '\v\[([^\]]+)\]\(([^\)]+)\)'
  let i = 0
  let len = len(lines)
  let bufnr = bufnr('%')
  while i < len
    let seg = matchstr(lines[i], pat)
    if !empty(seg)
      let key = substitute(seg, pat, '\1', '')
      let val = substitute(seg, pat, '\2', '')
      if val =~ filter
        let item = { 'bufnr': bufnr, 'lnum': i + 1, 'title': key, 'text': val }
        call add(result, item)
      endif
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
  if !exists('b:markdown_links')
    let b:markdown_links = markdown#ex#links()
  endif
  for link in b:markdown_links
    if link.title == key
      let uri = link.text
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
  if !exists('b:markdown_links')
    let b:markdown_links = markdown#ex#links()
  endif
  return filter(map(copy(b:markdown_links), 'v:val.title'), 'v:val =~ "^'.a:A.'"')
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
