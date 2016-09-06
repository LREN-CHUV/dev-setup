function p
  if test -x ./push.sh
    ./push.sh
  else
    if test -n (git branch --no-color -a 2>/dev/null | sed 's/^..//' | head -n 1 | grep 'detached')
      git push origin master
    else
      git push
    end
  end
end
