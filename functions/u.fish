function u
  if test -x ./update.sh -a (basename (pwd)) != project-scripts
    ./update.sh
  else
    git pull --rebase
    if test -x ./after-update.sh
      ./after-update.sh
    end
  end
end
