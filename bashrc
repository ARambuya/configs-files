export PS1='\u[\W]\$ '
export PAGER=/usr/bin/most
export EDITOR=/usr/bin/vim

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

export BROWSER=/usr/bin/firefox

PS1="\[\e[0;33m\]┌─[\[\e[1;31m\u\e[0;33m\]]──[\[\e[0;34m\]${HOSTNAME%%.*}\[\e[0;33m\]]\[\e[0;32m\]:\w$\[\e[0;33m\]\n\[\e[0;33m\]└──\[\e[0;33m\]>>\[\e[0m\]"