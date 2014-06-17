# Script to install vim configuration files
# Tested with OSX and Ubuntu.
# Will need  modifications for windows if home dir is not set
#
# Easiest way to use this is to run this from your home folder in Terminal:
#
# exec 3<&1;bash <&3 <(curl https://gist.githubusercontent.com/jondkinney/2040114/raw/vim.sh 2> /dev/null)
#
# If you're wondering about the funky chars in the above command...
# I needed it to preserve prompting, see here: http://www.programmingforums.org/post199530.html
#
# You'll need Vim, Git and Curl installed to use this script with bash.
#
# The first few lines check for an existing Vim setup and ask you if you
# want to overwrite it or back it up. I recommend backing any current Vim
# settings up so you can refer to them later if need be.

if [[ -d "$HOME/.vim" && ! -L "$HOME/.vim" ]]; then
  has_dot_vim="true"
fi

if [[ -f $HOME/.vimrc ]]; then
  has_dot_vimrc="true"
fi

if [[ -f $HOME/.vim/vimrc_main ]]; then
  has_vimrc_main="true"
fi

if [[ -f $HOME/.tmux.conf ]]; then
  has_tmux_conf="true"
fi

if [[ -d "$HOME/.tmuxinator" && ! -L "$HOME/.tmuxinator" ]]; then
  has_tmuxinator="true"
fi

function refresh_vimrc_main(){
  curl -s https://gist.githubusercontent.com/jondkinney/2040114/raw/vimrc_main > .vim/vimrc_main
  echo "!!!!! Wrote $HOME/.vim/vimrc_main"
}

function update_vundle_plugins(){
  echo "!!!!! Updating all plugins specified in vundle"
  vim -u .vim/vundle +BundleInstall +qall
  echo ">>>>> Done updating plugins through vundle"
}

function full_vim_setup(){
  echo "!!!!! Creating the necessary Vim directories..."
  mkdir -pv $HOME/.vim/autoload
  mkdir -pv $HOME/.vim/backup
  mkdir -pv $HOME/.vim/bundle
  mkdir -pv $HOME/.vim/snippets
  mkdir -pv $HOME/.vim/sessions

  echo ">>>>> cd to $HOME/"
  cd $HOME

  cd .vim/bundle
  git clone git://github.com/gmarik/vundle.git
  cd $HOME
  echo "!!!!! Installed Vundle/"

  # Install config files
  echo ">>>>> Writing Config Files..."

  curl -s https://gist.githubusercontent.com/jondkinney/2040114/raw/vundle > .vim/vundle
  echo "!!!!! Wrote $HOME/.vim/vundle"

  curl -s https://gist.githubusercontent.com/jondkinney/2040114/raw/.vimrc > .vimrc
  echo "!!!!! Wrote $HOME/.vimrc"

  curl -s https://gist.githubusercontent.com/jondkinney/2040114/raw/_.snippets > .vim/snippets/_.snippets
  echo "!!!!! Wrote $HOME/.vim/snippets/_.snippets"

  refresh_vimrc_main
  update_vundle_plugins
}

if [ "$has_dot_vim" == "true" -o "$has_dot_vimrc" == "true" -o "$has_vimrc_main" == "true" ]; then
  echo "***** Note: You already have a Vim configuration..."
  read -p  "????? Would you like to (b)ack it up, (o)verwrite it, (r)efresh ~/.vimrc_main, or (s)kip Vim setup (B/o/r/s)?"

  if [[ $REPLY =~ ^[Ss]$ ]]; then
    echo ">>>>> Skipping Vim configuration..."
  elif [[ $REPLY =~ ^[Rr]$ ]]; then
    echo ">>>>> Refreshing $HOME/.vimrc_main and leaving the rest of your Vim setup untouched"
    refresh_vimrc_main
  elif [[ $REPLY =~ ^[Oo]$ ]]; then
    echo "!!!!! Deleting current Vim setup..."
    sudo rm -rf $HOME/.vim
    rm -f $HOME/.vimrc
    rm -f $HOME/.vim/vimrc_main
    full_vim_setup
  else
    echo ">>>>> Backing up Vim setup..."
    echo "!!!!! Appending -bak to the relevant folders and files...."
    # remove any old backups
    rm -rf $HOME/.vim-bak
    rm -rf $HOME/.vimrc-bak
    # backup
    mv -fv $HOME/.vim $HOME/.vim-bak
    mv -fv $HOME/.vimrc $HOME/.vimrc-bak
    full_vim_setup
  fi
else
  read -p  "????? No previous Vim setup detected, proceed with a full Vim configuration (Y/n)?"
  if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo ">>>>> Skipping Vim configuration..."
  else
    full_vim_setup
  fi
fi


function setup_tmux(){
  echo ">>>>> Setting up Tmux..."
  curl -s https://gist.githubusercontent.com/jondkinney/2040114/raw/.tmux.conf > $HOME/.tmux.conf
  echo "!!!!! Wrote $HOME/.tmux.conf"

  read -p  "????? Install OS X clipboard support for Tmux and Vim (Y/n)?"

  if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo ">>>>> Skipping OS X clipboard support"
  else
    echo ">>>>> Ensure /usr/local/bin exists"
    sudo mkdir -pv /usr/local/bin
    curl -s https://gist.githubusercontent.com/jondkinney/2040114/raw/reattach-to-user-namespace > /usr/local/bin/reattach-to-user-namespace
    echo "!!!!! Wrote /usr/local/bin/reattach-to-user-namespace"
    echo ">>>>> Ensure /usr/local/bin/reattach-to-user-namespace is executable"
    sudo chmod +x /usr/local/bin/reattach-to-user-namespace
    echo "***** NOTE: make sure /usr/local/bin is also in your PATH"
  fi
  echo ">>>>> Tmux setup complete"
  echo "***** Might I suggest some Tmux and tmuxinator bash aliases?"
  echo
  echo "alias tl='tmux ls'"
  echo "alias ta='tmux attach -t \$*'"
  echo "alias tk='tmux kill-session -t \$*'"
  echo "alias to='tmuxinator open \$*'"
  echo "alias ts='tmuxinator start \$*'"
  echo
  echo "***** If you so choose, you can manually add the above aliases to your ~/.bashrc or ~/.zshrc or ~/.oh-my-zsh/custom/your_name_shortcuts.zsh"

  read -p  "????? Add rails dev tmuxinator yaml file to $HOME/.tmuxinator (Y/n)"

  if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo ">>>>> Skipping Tmuxinator rails dev config"
  else
    echo "!!!!! Creating the necessary tmuxinator directories..."
    if [ "$has_tmuxinator" == "true" ]; then
      echo "***** note: $HOME/.tmuxinator already exists"
    else
      mkdir -pv $HOME/.tmuxinator
    fi
    curl -s https://gist.githubusercontent.com/jondkinney/2040114/raw/rails.yml > $HOME/.tmuxinator/rails.yml
    echo "!!!!! Wrote $HOME/.tmuxinator/rails.yml"
    echo "***** NOTE: make sure to install the tmuxinator gem in your global gemset (or another accessible place if you don't use RVM)"
  fi
}

if [ "$has_tmux_conf" == "true" ]; then
  echo "***** Note: You already have a Tmux configuration..."
  read -p  "????? Would you like to (b)ack it up, (o)verwrite it, or (s)kip Tmux alltogether (B/o/s)?"

  if [[ $REPLY =~ ^[Oo]$ ]]; then
    echo "!!!!! Deleting current Tmux setup..."
    rm -fv $HOME/.tmux.conf
    setup_tmux
  elif [[ $REPLY =~ ^[Ss]$ ]]; then
    echo ">>>>> Skipping Tmux"
  else
    echo "!!!!! Backing up Tmux setup. Appending -bak to the relevant files..."
    mv -fv $HOME/.tmux.conf $HOME/.tmux.conf-bak
    setup_tmux
  fi
else
  echo ">>>>> No previous Tmux config detected"
  read -p  "????? Would you like to add this Tmux config (Y/n)?"
  if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo ">>>>> Skipping Tmux"
  else
    setup_tmux
  fi
fi
