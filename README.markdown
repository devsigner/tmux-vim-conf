## Console VIM and Tmux setup compatible with Mac OS X and Linux.

Disclaimer: This file is called `README.markdown` so that it'll appear first

### Installation

Because this script prompts for user input, you have to execute it in a bit of
an odd way. From a new command prompt simply copy and paste the following
command and press return:

``` bash
exec 3<&1;bash <&3 <(curl https://raw.githubusercontent.com/devsigner/tmux-vim-conf/master/vim.sh 2> /dev/null)
```

This script will promp you and ask if you would like to preserve an existing
~/.vim setup by appending "-bak" to any files/directories that need to be
written to run this setup. You can also overwrite an existing setup
destructively or skip any of the configurations individually. Additionally if
you just want to keep a ~/.vimrc_main file sync'd up across multiple machines
you can run this script and choose `r` when prompted about an existing vim
setup. Here's how it would look:

``` bash
***** Note: You already have a Vim configuration...
Would you like to (b)ack it up, (o)verwrite it, (r)efresh ~/.vimrc_main, or (s)kip Vim setup (B/o/r/s)?
```
Typing `r` and pressing return then outputs this message

``` bash
Refreshing ~/.vimrc_main and leaving the rest of your Vim setup untouched
```

**Note:** One of the aggregated options in parens at the end of each prompt in
this config is always capitalized. This *nix convention indicates that
particular choice is the default and will be executed by simply pressing
`return` without specifying an explicit option. I tried to pick a safe/sensible
default when providing this feature.


**Prerequisites OS X:**

* Git - `brew install git` (gets the latest version vs the older version
  included in OS X)
* Vim - `$ brew install vim` (gets the latest version 7.3.x vs the older
  version included in OS X)
* [iTerm 2](http://www.iterm2.com/#/section/home) (not required, but highly
  recommended as an alternative to the built in Terminal.app)
* Tmux - `$ brew install tmux`
* [Zsh & oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh/) (follow the
  installation instructions for that project separately if you want to run Zsh
  instead of Bash for your shell)
* Battery - `$ brew tap Goles/battery`


### Customizations To The Defaults

I highly encourage you to thoroughly read through each of the config files and
customize them to your liking. Please fork this gist and go nuts! But here are
some of my customization highlights:

**Tmux**

* Tmux prefix re-mapped from Ctrl-b to Ctrl-a (I also recommend [re-mapping
  your caps lock Key](http://cl.ly/I186) to control)
* Tmux set to report as "screen-256color" (so we can get nice full color themes
  in Vim)
* Use custom status with Battery, itunes sound playing and date time
* Provides an optional [tmuxinator](https://github.com/aziz/tmuxinator/) Rails
  dev YAML setup file

**Vim**

* Vim bundles loaded through vundle at ~/.vim/bundle
* ~/.vimrc loads vundle and ~/.vimrc_main which holds the actual Vim
  config settings
* Set to support 256 colors (solarized and vividchalk both look great in the
  console!)
* \<leader\> re-mapped to ,
* Set no wrap text by default
* Navigate between splits with just ctrl+movement (h, j, k, or l)
* Resizing splits with =/- for up/down and +/_ for left/right
* Default searches to ['very magic'](http://vimcasts.org/episodes/refining-search-patterns-with-the-command-line-window/)
* Save files with SS. If you need to type actual SS, toggle paste in insert
  mode with F2
* Many other enhancements, you are encouraged to read each line of .vimrc_main


### Contributing

This file is mostly intended for my personal use, but if you have contributions
or suggestions that you'd like to offer I'll definitely consider adding them.
Leave a comment here on the gist, mention me on twitter
[@jondkinney](https://twitter.com/jondkinney), or shoot me an email at jonkinney [at]
gmail [dot] com. Happy Vimming/Tmuxing!

### Credits

* A huge thanks to [@jondkinney](https://twitter.com/jondkinney) for the original
  [Brian](http://napcs.com/)
  [Hogan](https://twitter.com/bphogan/) for coming up with [the original
gist](https://gist.github.com/532968) from which this setup was created. Brian
is also the author of [tmux: Productive Mouse-Free
Development](http://pragprog.com/book/bhtmux/tmux) which is the main reason I'm
using this setup for my daily Ruby on Rails development. Buy the book! It's awesome.
