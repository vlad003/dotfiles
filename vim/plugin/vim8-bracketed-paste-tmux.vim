" Code taken from https://github.com/chrisjohnson/vim8-bracketed-paste-mode-tmux/blob/master/plugin/vim8-bracketed-paste-tmux.vim
" Discussion: https://github.com/ConradIrwin/vim-bracketed-paste/issues/32


" NOTE: iTerm2 will show up as xterm-256color, and tmux shows up as
" screen-256color. We want to avoid using this on xterm because it leads to
" lag when hitting <ESC> (it takes about a second to get into NORMAL mode).
let s:screen = &term =~ 'screen'
let s:tmux = &term =~ 'tmux'

" make use of Xterm "bracketed paste mode"
" http://www.xfree86.org/current/ctlseqs.html#Bracketed%20Paste%20Mode
" http://stackoverflow.com/questions/5585129
if s:screen || s:tmux
  function! s:BeginXTermPaste(ret)
    set paste
    return a:ret
  endfunction

  " enable bracketed paste mode on entering Vim
  let &t_ti .= "\e[?2004h"

  " disable bracketed paste mode on leaving Vim
  let &t_te = "\e[?2004l" . &t_te

  set pastetoggle=<Esc>[201~
  inoremap <expr> <Esc>[200~ <SID>BeginXTermPaste("")
  nnoremap <expr> <Esc>[200~ <SID>BeginXTermPaste("i")
  vnoremap <expr> <Esc>[200~ <SID>BeginXTermPaste("c")
  cnoremap <Esc>[200~ <nop>
  cnoremap <Esc>[201~ <nop>
endif
