" VLC
"----

let s:VLC_PATH = '/Applications/VLC.app/Contents/MacOS/VLC'
let s:RC_OPTIONS = ' --extraintf rc --rc-host localhost:1234'
let s:BASE_VLC_PLAY_COMMAND = 'noglob ' . s:VLC_PATH . s:RC_OPTIONS . ' --rate 1.5 '
let s:FALSE = 0

function! s:OpenVideoInVLC(video)
  let command = s:tmplt(
        \ 'noglob #{VLC_PATH} #{RC_OPTIONS} #{RATE_OPTIONS} "#{video}" &',
        \ {
        \   'VLC_PATH': s:VLC_PATH,
        \   'RC_OPTIONS': s:RC_OPTIONS,
        \   'RATE_OPTIONS': '--rate 1.5',
        \   'video': a:video
        \ })
  call system(command)
endfunction
command! -nargs=1 -complete=file OpenVideoInVLC call <sid>OpenVideoInVLC(<q-args>)

function! s:ChompedSystem(command)
  let value = system(a:command)
  let half_cleaned = substitute(value, '\n$', '', '')
  return substitute(half_cleaned, "", "", "g")
endfunction

function! s:GetVLCCurrentTime()
  return s:ChompedSystem("echo 'get_time' | nc localhost 1234 | grep '> [0-9]' | cut -d ' ' -f 2")
endfunction

function! s:InsertCurrntVLCTime()
  let @a = ' ' . s:GetVLCCurrentTime()
  execute 'normal! Aa'
endfunction
command! InsertCurrntVLCTime call <sid>InsertCurrntVLCTime()

function! s:SeekTimeInVLC(time)
  call system("echo 'seek ". a:time ."' | nc localhost 1234")
endfunction
command! -nargs=1 SeekTimeInVLC call <sid>SeekTimeInVLC(<args>)

function! s:tmplt(template_string, replacements)
  let output_string = a:template_string
  for replaceable in keys(a:replacements)
    let replacement = a:replacements[replaceable]
    let output_string = substitute(output_string, '#{' . replaceable . '}', replacement, 'g')
  endfor
  return output_string
endfunction

function! s:Seek(amount)
  let current_time = s:GetVLCCurrentTime()
  let seek_time = (current_time + a:amount)
  if seek_time > 0
    call s:SeekTimeInVLC(seek_time)
  else
    call s:SeekTimeInVLC(0)
  endif
endfunction
command! SeekForward call <sid>Seek(5)
command! SeekBackward call <sid>Seek(-5)
command! SeekFarForward call <sid>Seek(30)
command! SeekFarBackward call <sid>Seek(-30)
nnoremap <Left> :SeekBackward<cr>
nnoremap <Right> :SeekForward<cr>
nnoremap <Up> :SeekFarForward<cr>
nnoremap <Down> :SeekFarBackward<cr>

" vim:ft=vim
