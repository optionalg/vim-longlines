" Name: longline.vim
" Version: $Id$
" Author: Markus Braun
" Summary: Vim plugin to highlight too long lines
" Licence: This program is free software; you can redistribute it and/or
"          modify it under the terms of the GNU General Public License.
"          See http://www.gnu.org/copyleft/gpl.txt
" Section: Documentation {{{1
"
" Description:
"
"   This plugin highlights too long lines where the length exceeds the setting
"   of textwidth.
"
" Installation:
"
"   Copy the longline.vim file to the $HOME/.vim/plugin directory.
"   Refer to ':help add-plugin', ':help add-global-plugin' and ':help
"   runtimepath' for more details about Vim plugins.
"
" Commands:
"
"   :LongLinesToggle
"      Toggle long line highlighting in the current window.
"
"   :LongLinesGlobalToggle
"      Toggle long line highlighting globally.
"
" Mappings:
"
"   <Leader>ll     LongLinesToggle()
"   <Leader>lg     LongLinesGlobalToggle()
"
" Variables:
"
"   g:LongLinesEnabled
"     Enabled the highlighting globally. Default 1.
"
"   g:LongLinesMargin
"     width of the warning highlight. Default 10.
"
" Section: Plugin header {{{1

if (exists("g:loaded_longline") || &cp)
  finish
endif
"if (v:version < 720)
"  finish
"endif
let g:loaded_longline = "$Revision$"

if (!exists("g:LongLinesEnabled"))
  let g:LongLinesEnabled = 1
endif

if (!exists("g:LongLinesMargin"))
  let g:LongLinesMargin = 10
endif

" Section: Autocmd setup {{{1
" to handle the case, when textwidth is modified in a displayed window
autocmd CursorMoved,CursorMovedI * call <SID>LongLines()

" Section: Highlight setup {{{1
highlight default link LongLinesWarning Todo
highlight default link LongLinesError Error

" Section: Functions {{{1
" Function: s:LongLines() {{{2
"
" highlight the too long lines, if requested
function! s:LongLines()
  if has("syntax")
    if !exists("w:LongLinesIds")
      let w:LongLinesIds = []
    endif
    if !exists("w:LongLinesEnabled")
      let w:LongLinesEnabled = 1
    endif
    if &textwidth > 0 && g:LongLinesEnabled != 0 && w:LongLinesEnabled != 0
      if len(w:LongLinesIds) == 0
        let w:LongLinesIds += [ matchadd('LongLinesWarning',  '\%>' . &textwidth . 'v.*\%<' . (&textwidth + g:LongLinesMargin + 1) . 'v') ]
        let w:LongLinesIds += [ matchadd('LongLinesError',    '\%>' . (&textwidth + g:LongLinesMargin) . 'v.*') ]
      endif
    else
      if len(w:LongLinesIds) != 0
        for id in w:LongLinesIds
          call matchdelete(id)
        endfor
        let w:LongLinesIds = []
      endif
    endif
  endif
endfunction

" Function: LongLinesToggle() {{{2
"
" toggle on/off the highlighting
function! s:LongLinesToggle()
  if !exists("w:LongLinesEnabled")
    let w:LongLinesEnabled = 1
  else
    let w:LongLinesEnabled = !w:LongLinesEnabled
  endif

  call s:LongLines()
endfunction

" Function: LongLinesGlobalToggle() {{{2
"
" globally toggle on/off the highlighting
function! s:LongLinesGlobalToggle()
  let g:LongLinesEnabled = !g:LongLinesEnabled

  call s:LongLines()
endfunction

" Function: LongLinesEnabled() {{{2
"
" return if highlighting of too long lines is enabled
function! LongLinesEnabled()
  return (g:LongLinesEnabled && w:LongLinesEnabled)
endfunction

" Section: Commands {{{1
command! LongLinesToggle call s:LongLinesToggle()
command! LongLinesGlobalToggle call s:LongLinesGlobalToggle()

" Section: Mappings {{{1
map <Leader>ll :LongLinesToggle<CR>
map <Leader>lg :LongLinesGlobalToggle<CR>

" vim600:fdm=marker:commentstring="\ %s:
