## .zshrc
# by Jorge Schrauwen <jorge@blackdot.be>
# Version 2014071701
#
# How to install
# curl -sk "https://docu.blackdot.be/getRaw.php?onlyCode=true&id=configuration:zsh" -o ~/.zshrc
#
# Change Log
# - 20130717: add alias for pyedit
# - 20130716: cleaner sbin handling on solaris
# - 20130629: support for omnios.blackdot.be
# - 20130625: revert some OmniOS stuff due to better understanding of isaexec
# - 20130621: check if staff group on omnios and add sbin to path
# - 20130615: parse .zprofile
# - 20130520: added some stuff for OmniOS
# - 20120308: fixed some mac stuff
# - 20120823: automatic update
# - 20120821: add support to disable UTF-8 checkmark  with .znofancy
echo ""
figlet Tux Hat Linux
echo ""
#archey3 -c yellow
echo ""
echo "To setup Tux Hat Linux type ./setup-tuxhat"
echo ""
echo "What you see, is what you get!"
echo ""
# {{{ updater
  NZSHRC="https://docu.blackdot.be/getRaw.php?onlyCode=true&id=configuration:zsh"
        CHECK_UPDATE=1
        AUTO_UPDATE=1
# }}}
 
# {{{ options
        ## change directory    
        setopt auto_cd          # drop cd
        setopt cd_able_vars     # if var is valid dir, change to var
       
        ## enable command correction
        #setopt correct
        setopt correct_all     
 
        # prevent file overwrite
        setopt no_clobber
 
        ## pound sign in interactive prompt
        setopt interactive_comments
 
        ## superglobs
        setopt extended_glob
        unsetopt case_glob
       
        # expansions performed in prompt
        setopt prompt_subst
        setopt magic_equal_subst
 
        # prompt about background jobs on exit
        setopt check_jobs
 
        # notify on job complete
        setopt notify
# }}}
 
# {{{ variables
        # preferences
        export EDITOR='nano'
        export PAGER='less'
# }}}
 
# {{{ aliasses
        # include external aliasses
        [ -f ~/.aliasses ] && source ~/.aliasses
 
        # nano wrapping
        alias nano='nano -w'
  alias pyedit='nano -ET2 -w'
 
        # default for ls
        alias ll='ls -l'
        alias lr='ls -R'
# }}}
 
# {{{ advanced
        ## fix url quote's
        if [[ ${ZSH_VERSION//\./} -ge 420 ]] ; then
                 autoload -U url-quote-magic
                 zle -N self-insert url-quote-magic
        fi
 
        ## os specific
        case $OSTYPE in linux*)
                # colorization
                [ -f /etc/DIR_COLORS ] && eval $(dircolors -b /etc/DIR_COLORS)
                [ -f ~/.dir_colors ] && eval $(dircolors -b ~/.dir_colors)
 
                if [ -n "${LS_COLORS}" ]; then
                        export ZLSCOLORS="${LS_COLORS}"
                        alias ls='ls --color=auto'
                        alias grep='grep --color=auto'
                fi
        ;; esac
        case $OSTYPE in solaris*)
                # detect root or staff
                [ $UID -eq 0 ] && WANT_SBIN=1
                [ `groups | grep -c staff` -gt 0 ] && WANT_SBIN=1
                [ -n $WANT_SBIN ] && export PATH=/usr/sbin:$PATH
 
                # check for omni repository
                [ -d /opt/omni/bin ] && export PATH=/opt/omni/bin:$PATH
                [ -d /opt/omni/sbin ] && [ -n $WANT_SBIN ] && export PATH=/opt/omni/sbin:$PATH
                [ -d /opt/omni/share/man ] && export MANPATH=/opt/omni/share/man:$MANPATH
               
                # check for obd repository
                [ -d /opt/obd/bin ] && export PATH=/opt/obd/bin:$PATH
                [ -d /opt/obd/sbin ] && [ -n $WANT_SBIN ] && export PATH=/opt/obd/sbin:$PATH
                [ -d /opt/obd/share/man ] && export MANPATH=$MANPATH:/opt/obd/share/man
 
                # check for sfw
                [ -d /usr/sfw/bin ] && export PATH=/usr/sfw/bin:$PATH
 
                # check for gnu
                [ -d /usr/gnu/bin ] && export PATH=/usr/gnu/bin:$PATH
 
                # check for local
                [ -d /usr/local/bin ] && export PATH=/usr/local/bin:$PATH
                [ -d /usr/local/sbin ] && [ -n $WANT_SBIN ] && export PATH=/usr/local/sbin:$PATH
 
                # check for opencsw
                if [ -d /opt/csw/bin ]; then
                        [ $UID = 0 ] && export PATH=/opt/csw/sbin:$PATH
                        export PATH=/opt/csw/gnu:/opt/csw/bin:$PATH
                fi
               
                # colorization
                alias ls='ls --color=auto'
                if [ "`which grep`" = "/usr/gnu/bin/grep" ]; then
                        alias grep='grep --color=auto'
                fi
        ;; esac
        case $OSTYPE in darwin*)
                # colorization
                export CLICOLOR=1
                alias ls='ls -G'
 
                # macports (with gnu)
                if [ -e /opt/local/bin/port ]; then
                        export PATH=/opt/local/libexec/gnubin:/opt/local/bin:/opt/local/sbin:$PATH
                        export MANPATH=/opt/local/share/man:$MANPATH
                        if [ -f ~/.dir_colors ]; then
                                eval $(dircolors -b ~/.dir_colors)
                                export ZLSCOLORS="${LS_COLORS}"
                                unalias ls &> /dev/null
                                alias ls='ls --color=auto'
                        fi
                if [ -e /opt/local/bin/python2 ]; then
                        alias python='/opt/local/bin/python2'
                fi
                fi
        ;; esac
        # zsh shortcuts
        case $OSTYPE in linux*|darwin*)
                alias zshenable='chsh -s $(which zsh)'
                alias zshdisable='chsh -s $(which bash)'
        ;; esac
        case $OSTYPE in solaris*)
                alias zshenable='sudo usermod -s $(which zsh) ${USER}'
                alias zshdisable='sudo usermod -s $(which bash) ${USER}'
        ;; esac
 
        ## host specific
        case ${HOST:r} in
                (Axion|Axino)
                        # add a little info banner
                        if [[ $SHLVL -eq 1 ]] ; then
                                clear
                                echo
                                print -P "\e[1;33m Welcome to: \e[1;34m%m"
                                print -P "\e[1;33m Running: \e[1;34m`uname -srm`\e[1;33m on \e[1;34m%l"
                                print -P "\e[1;33m It is:\e[1;34m %D{%r} \e[1;33m on \e[1;34m%D{%A %b %f %G}"
                                echo
                                tput sgr0
                        fi
 
                        # proper UTF-8
                        export LANG=en_US.UTF-8
 
                        # host color
                        PROMPT_HOST_COLOR=magenta
                ;;
                (yami)
                        # host color
                        PROMPT_HOST_COLOR=green
                ;;
                *)
                        # default host color
                        PROMPT_HOST_COLOR=blue
                ;;  
        esac
 
  ## local configuration
  [[ -e ~/.zprofile ]] && source ~/.zprofile
# }}}
 
# {{{ prompt
        # enable colors module
        autoload -U colors && colors
 
        # utf8 checkmarks
        PROMPT_CO='.'
        PROMPT_CE='!'
        case $LANG in *UTF-8)
                case $TERM in (xterm*)
      if [ ! -f ~/.znofancy ]; then
                          PROMPT_CO='✓'
                          PROMPT_CE='✗'
      fi
                ;; esac
        ;; esac
 
        THEME=minimal
        case $THEME in
                gentoo)
                        PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%}%n@)%m %{$fg_bold[blue]%}%(!.%1~.%~) %#%{$reset_color%} '
                ;;
                gentoo-server)
                        PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[yellow]%}%n@)%m %{$fg_bold[blue]%}%(!.%1~.%~) %#%{$reset_color%} '
                ;;
                minimal)
                        PROMPT=$'%{$fg_bold[grey]%}-(%{$reset_color%}%{$fg_bold[white]%}%1~%{$reset_color%}%{$fg_bold[grey]%})-[%{$reset_color%}%(?,%{$fg_bold[green]%}$PROMPT_CO%{$reset_color%},%{$fg_bold[red]%}$PROMPT_CE%{$reset_color%})%{$fg_bold[grey]%}]-%{$reset_color%}%(!.%{$fg_bold[red]%}.%{$fg_bold[yellow]%}){%{$reset_color%} '
                        RPROMPT=$'%(!.%{$fg_bold[red]%}.%{$fg_bold[yellow]%})}%{$reset_color%}%{$fg_bold[grey]%}-(%{$reset_color%}%{$fg_bold[$PROMPT_HOST_COLOR]%}%n@%m%{$reset_color%}%{$fg_bold[grey]%})-%{$reset_color%}'
                ;;
                *)
                        PROMPT=$'%{$fg_bold[grey]%}[%{$fg_bold[yellow]%}%m %{$fg_bold[grey]%}:: %(!.%{$fg_bold[red]%}.%{$fg_bold[green]%})%n%{$fg_bold[grey]%}][%{$fg_bold[blue]%}%~%{$fg_bold[grey]%}]\n[%{$fg[white]%}%D{%H:%M:%S} %{$fg_bold[grey]%}- %(?,%{$fg_bold[green]%}✓%{$reset_color%},%{$fg_bold[red]%}✗%{$reset_color%})%{$fg_bold[grey]%}]%(!.%{$fg_bold[red]%}#.%{$fg_bold[green]%}$)%{$reset_color%} '
                ;;
        esac
        unset THEME
# }}}
 
# {{{ history
        # history file
        HISTFILE=~/.zhistory
        HISTSIZE=10000
        SAVEHIST=10000
 
        # share history file
        setopt share_history
        setopt inc_append_history
 
        # ignore duplicates
        setopt hist_ignore_all_dups
       
        # ignore entries starting with a space
        setopt hist_ignore_space
# }}}
 
# {{{ keybindings
        # generic
        bindkey "\e[1~" beginning-of-line # Home
        bindkey "\e[4~" end-of-line # End
        bindkey "\e[5~" beginning-of-history # PageUp
        bindkey "\e[6~" end-of-history # PageDown
        bindkey "\e[2~" quoted-insert # Ins
        bindkey "\e[3~" delete-char # Del
        bindkey "\e[5C" forward-word
        bindkey "\eOc" emacs-forward-word
        bindkey "\e[5D" backward-word
        bindkey "\eOd" emacs-backward-word
        bindkey "\e\e[C" forward-word
        bindkey "\e\e[D" backward-word
        bindkey "\e[Z" reverse-menu-complete # Shift+Tab
        bindkey ' ' magic-space # becasue I am lazy
 
        # for rxvt
        bindkey "\e[7~" beginning-of-line # Home
        bindkey "\e[8~" end-of-line # End
 
        # for non RH/Debian xterm, can't hurt for RH/Debian xterm
        bindkey "\eOH" beginning-of-line
        bindkey "\eOF" end-of-line
 
        # for freebsd/darwin console
        bindkey "\e[H" beginning-of-line
        bindkey "\e[F" end-of-line
# }}}
 
# {{{ auto completion
        ## base
        autoload -U compinit && compinit
 
        ## complete from withing word
        setopt complete_in_word
 
        ## complete aliases
        setopt complete_aliases
 
        ## pretty menu's
        zstyle ':completion:*' menu select=1
        zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
        setopt auto_menu        # show menu on 2nd <tab>
        setopt list_rows_first  # use row list if possible
 
        ## Ignore completions for commands that we dont have
        zstyle ':completion:*:functions' ignored-patterns '_*'
 
        ## enable case-insensitive completion
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
 
        ## enable caching
        zstyle ':completion::complete:*' use-cache on
        zstyle ':completion::complete:*' cache-path ~/.zcache
 
        ## Prevent re-suggestion
        zstyle ':completion:*:rm:*' ignore-line yes
        zstyle ':completion:*:scp:*' ignore-line yes
        zstyle ':completion:*:ls:*' ignore-line yes
 
        ## enable killall menu
        zstyle ':completion:*:processes-names' command 'ps -u $(whoami) -o comm='
        zstyle ':completion:*:processes-names' menu yes select
        zstyle ':completion:*:processes-names' force-list always       
 
        ## enable kill menu
        zstyle ':completion:*:kill:*' command 'ps -u $(whoami) -o pid,pcpu,pmem,cmd'
        zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;32'
        zstyle ':completion:*:*:kill:*' menu yes select
        zstyle ':completion:*:kill:*' force-list always
        zstyle ':completion:*:kill:*' insert-ids single
 
        ## enable make completion
        compile=(all clean compile disclean install remove uninstall)
        compctl -k compile make
 
        ## ssh host completion
        if [ ! -f ~/.ssh/config ]; then
                [ -f ~/.ssh/known_hosts ] && rm ~/.ssh/known_hosts
                mkdir -p ~/.ssh
                echo "HashKnownHosts no" >>! ~/.ssh/config
                chmod 0600 ~/.ssh/config
        fi
        zstyle -e ':completion::*:ssh:*:hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
        zstyle ':completion:*:ssh:*' group-order hosts-domain hosts-host users hosts-ipaddr
 
        ## ssh user completion cleanup
        zstyle ':completion:*:ssh:*:users' ignored-patterns \
                adm alias apache at bin cron cyrus daemon distcache exim ftp games gdm \
                guest gopher haldaemon halt mail man messagebus mysql named news nobody nut \
                nfsnobody lp operator portage postfix postgres postmaster qmaild qmaill qmailp \
                qmailq qmailr qmails rpmbuild rpc rpcuser shutdown smmsp squid sshd sync saslauth \
                uucp vcsa vpopmail xfs
# }}}
 
# {{{ functions
        # update .zshrc
        zshupdate() {
                # main
                if [ -z "`which curl`" ]; then
                        echo 'Please install curl!'
                        exit
                fi
                NV=`curl -sk ${NZSHRC} | head -n3 | tail -n1 | awk '{ print $3 }'`
                OV=`cat ~/.zshrc | head -n3 | tail -n1 | awk '{ print $3 }'`
                [ -z "${NV}" ] && NV=0
               
                if [ ${NV} -gt ${OV} ]; then
                        echo -n "[>>] Updating from ${OV} to ${NV} ...\r"
                        mv ~/.zshrc ~/.zshrc.old
                        curl -sk ${NZSHRC} -o ~/.zshrc
                        source ~/.zshrc
                        echo '[OK]'
                else
                        echo "[OK] No update needed."
                fi
        }
 
        # auto update check
        if [ ${CHECK_UPDATE} -gt 0 ]; then
                if [ `find ~/.zshrc -mmin +1440` ]; then
                        touch ~/.zshrc
                        NV=`curl -sk -m 3 ${NZSHRC} | head -n3 | tail -n1 | awk '{ print $3 }'`
                        OV=`cat ~/.zshrc | head -n3 | tail -n1 | awk '{ print $3 }'`
                        [ -z "${NV}" ] && NV=0
               
                        if [ ${NV} -gt ${OV} ]; then
                                if [ ${CHECK_UPDATE} -gt 0 ]; then
                                        zshupdate
                                else
                                        echo "Please run zshupdate to update .zshrc to version ${NV}!"
                                fi
                        fi
                fi
        fi
 
        # remove ssh known_hosts key
        delete_sshhost() {
                if [[ -z "$1" ]] ; then
                        echo "usage: \e[1;36mdelete_sshhost \e[1;0m< host >"
                        echo "       Removes the specified host from ssh known host list"
                else
                        sed -i -e "/$1/d" $HOME/.ssh/known_hosts
                fi
        }
# }}}