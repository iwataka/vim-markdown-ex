let s:save_cpo = &cpoptions
set cpoptions&vim

fu! markdown#ex#toggle_checkbox(linenr)
  let line = getline(a:linenr)
  if line =~ '\v^\s*[-+*]\s*\[x\]'
    let line = substitute(line, '\v^(\s*[-+*]\s*\[)x(\])', '\1'.' '.'\2', '')
  elseif line =~ '\v^\s*[-+*]\s*\[\s*\]'
    let line = substitute(line, '\v^(\s*[-+*]\s*\[)\s*(\])', '\1'.'x'.'\2', '')
  elseif line =~ '\v^\s*[-+*]\s*'
    let line = substitute(line, '\v^(\s*[-+*]\s*)(.*)', '\1'.'[ ] '.'\2', '')
  endif
  call setline(a:linenr, line)
endfu

fu! markdown#ex#remove_checkbox(linenr)
  let line = getline(a:linenr)
  if line =~ '\v^\s*[-+*]\s*\[.*\]'
    let line = substitute(line, '\v^\s*[-+*]\s\zs\s*\[[^\]]*\]\s*\ze', '', '')
  endif
  call setline(a:linenr, line)
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

let &cpo = s:save_cpo
unlet s:save_cpo
