function s
  if test -x ./status.sh -a (basename (pwd)) != project-scripts
    ./status.sh
  else
    git status
  end
end
