TODO

# ~/.bash_aliases

# Kill all running containers.
alias dockerkillall='docker kill $(docker ps -q)'

# Delete all stopped containers.
alias dockercleanc='printf "\n>>> Deleting stopped containers\n\n" && docker rm $(docker ps -a -q --filter status=exited)'

# Delete all untagged images.
alias dockercleani='printf "\n>>> Deleting untagged images\n\n" && docker rmi $(docker images -q -f dangling=true)'

# Delete all stopped containers and untagged images.
alias dockerclean='dockercleanc || true && dockercleani'


https://github.com/jcf/dotfiles
https://github.com/geerlingguy/ansible-role-dotfiles
https://github.com/pavel-v-chernykh/ansible-dotfiles
https://github.com/danieljaouen/ansible-dotfiles
https://github.com/NeuromaticSystems/ansible-ubuntu/blob/master/conf_and_bin.yml
https://github.com/periclesmacedo/ansible-dev-linux
https://github.com/AlbanAndrieu/ansible-locale
https://galaxy.ansible.com/list#/roles/4795
https://github.com/aussielunix/ansible-locale
https://github.com/jdauphant/ansible-role-ssh-config
https://github.com/jdauphant/ansible-role-dns

Oh-my-fish plugins: https://gist.github.com/derekstavis/26b7fc254cbc9bc4d461
https://github.com/sjl/z-fish
https://github.com/edc/bass Make Bash utilities usable in Fish shell

https://github.com/fisherman/fisherman
https://github.com/abaez/ansible-role-fish installs fisherman and bass
also https://github.com/tobywf/ansible-dotfiles/blob/master/roles/fish/tasks/main.yml

http://sift-tool.org/samples.html

https://github.com/gleitz/howdoi

sudo apt-add-repository ppa:inkscape.dev/stable
sudo apt-get update
sudo apt-get install inkscape

docker run -d -p 9000:9000 --privileged -v /var/run/docker.sock:/var/run/docker.sock dockerui/dockerui

https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit

# -----------------------------------------------------------------------------

https://github.com/andrewrothstein/ansible-jq

* For Algo developers, consider docker pull rocker/ropensci

* For admin, install shpkpr (https://github.com/shopkeep/shpkpr) to manage Marathon from cmd line

* Use of --storage-driver=overlay for Docker doesnàt work on older Ubuntu 14.04, add auto detection for this feature

* Install fish functions (u,p,r...) and aliases for docker, git...

curl -sL get.fisherman.sh | fish
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
fisher install jethrokuan/fzf
#fisher install jethrokuan/autojump
#  + alias z=j
#sudo sh -c "curl https://raw.githubusercontent.com/rupa/z/master/z.sh > /usr/local/bin/z.sh && chmod +x /usr/local/bin/z.sh"
#fisher install oh-my-fish/plugin-z
# add set -g Z_SCRIPT_PATH /usr/local/bin/z.sh to ~/.config/fish/config.sh, before source $fisher_home/config.fish
sudo sh -c "curl https://raw.githubusercontent.com/clvv/fasd/1.0.1/fasd > /usr/local/bin/fasd && chmod +x /usr/local/bin/fasd"
fisher install available
fisher install autoinit
fisher install fasd # oh-my-fish/plugin-fasd

# Algorithm developer:
  sudo npm install -g yaml2json json2yaml

sudo -H npm install -g ungit

https://github.com/TomasTomecek/sen

https://github.com/nvbn/thefuck/

https://github.com/junegunn/fzf
