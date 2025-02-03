function _fzf_change_directory
  fzf | perl -pe 's/([ ()])/\\\\$1/g'|read foo
  if [ $foo ]
    builtin cd $foo
    commandline -r ''
    commandline -f repaint
  else
    commandline ''
  end
end

function fzf_change_directory
  begin
    echo $HOME/.config
    ls -ad */|perl -pe "s#^#$PWD/#"|grep -v \.git
  end | sed -e 's/\/$//' | awk '!a[$0]++' | _fzf_change_directory $argv
end
