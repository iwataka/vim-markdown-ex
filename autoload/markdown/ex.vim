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

let &cpo = s:save_cpo
unlet s:save_cpo
