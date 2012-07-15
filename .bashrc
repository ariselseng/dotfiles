# exports
#------------
	export EDITOR=nano
	
	# use most as manpager
	if which most &>/dev/null; then
		export MANPAGER="/usr/bin/most" 
	fi

	GREP_OPTIONS="--exclude-dir=\.svn --exclude-dir=log --exclude-dir=\.git"
	export GREP_OPTIONS 
#####


# aliases and functions
#-------------------------

	# editor
	# ----------
		# line numbers in nano
		alias nano='nano -c'
		nanox () { nano $1 && chmod u+x $1 ;}
	#####

	 # dev
        # ---------
                # merge the remote changes (e.g. 'git pull') before pushing again
                alias gpp='git pull --rebase && git push'

                # prevents creating merge commits
                alias gmf='git merge --ff-only'

                # makes it easy to review changes in files.
                alias gap='git add --patch'

                # interactively add files
                alias gai='git add --interactive'
	

	# filesystem
	# -----------
	
		# find top 5 big files
		alias findbig="find . -type f -exec ls -s {} \; | sort -n -r | head -5"

		# find folder changes fast
		alias recursivetime='find . -type f -print0 | xargs -0 ls --color=auto -lhtr'
		
		# lists size of folders in ./
		alias foldersize="du --max-depth=1|sort -n|cut -f2|tr '\n' '\0'|xargs -0 du -sh 2>/dev/null"
		
		# mkdir and cd to it. 
		function mkcd () { mkdir -p $1 && cd $1 ; } 

		# to navigate to the different directories
		alias cd..='cd ..'
		alias ..='cd ..'
		alias ...='cd ../..'

		# better listings
		alias ll='ls -l'
		alias la='ls -A'
		alias l='ls -CF'
		alias ls="ls --color=always"

		#human df
		alias df='df -h'
		
		# color activate!
		if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
			
			# retrieves .dircolors
			eval `dircolors ~/.dircolors`
			alias ls='ls --color=auto'
			alias grep='grep --color=auto'
			alias fgrep='fgrep --color=auto'
			alias egrep='egrep --color=auto'

			alias diff='colordiff'
		fi
	#####


	# gui
	#------
		# using zenity to tell you whenever a script is finished. Example: "sleep 60; z"
		alias z='zenity --info --text="You will not believe it, but your command has finished now! :-)" --display :0.0'
	#####


	# images 
	#-----------
		# optimize all .png in a folder
		alias pngoptimize='optipng -o3 *png && advpng -z -4 *png && advdef -z -4 *png'
	#####


	# audio 
	# ---------------
		alias wav2mp3='for i in *wav; do lame -q 0 --vbr-new -V 0 "$i" -o "${i%.*}.mp3"; done'
		alias flac2lame='for file in *.flac; do flac -cd "$file" | lame -q 0 --vbr-new -V 0 - "${file%.flac}.mp3"; done'
		alias flac2lamevoice='for file in *.flac; do flac -cd "$file" | lame -q0 --abr 80 -mm -a - "${file%.flac}.mp3"; done'
		alias flac2wav='for i in *.flac; do gst-launch-0.10 filesrc location="$i" ! flacdec ! wavenc ! filesink location="${i%.flac}.wav"; done'
		alias wav2flac='flac --best *.wav'
		function m4b2lamevoice () { faad --stdio "$1" |lame -q0 --abr 80 -mm -a - -o "${$1%.m4b}.mp3" }

		# text2speech
		say() { mplayer "http://translate.google.com/translate_tts?q=$1" > /dev/null 2>&1; }
	#####


	# sysinfo
	# ---------
		# exact free memory in mb
		alias freemem="free -m | awk '/-\/\+\ buffers\/cache:/ {print \$4}\'"

		# Check powerconsumption on a laptop.
		alias powerconsumption="upower -i /org/freedesktop/UPower/devices/battery_BAT0|egrep '"energy-rate"|time\ to\ empty|percentage'"
	#####


	# network
	#----------------
		# lists used tcp ports
		alias listusedports='netstat -tlnp'

		# makes ping stop after 5 pings
		alias ping='ping -c 5'

		# rsync with progress info
		alias rsync='rsync --progress'

		# make ann ssh tunnel. Connect with socks5 to localhost:9999
		alias sshproxy='ssh -D 9999 remoteuser@server.com'

		# prints external ip
		alias myip="wget http://cmyip.com -qO - | grep -Ewo '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' | uniq"
			
		# finds your location by geoip or another in $1
		geoip() { wget -qO - http://freegeoip.net/xml/$1 | sed '3,12!d;s/<//g;s/>/: /g;s/\/.*//g' ; }

		# complete ssh bases on history# complete ssh bases on history
		complete -W "$(echo $(grep '^ssh ' ~/.bash_history | sort -u | sed 's/^ssh //'))" ssh

		# make entries in ssh config
		ssh-client-setup () {
		if [ "$@" == "" ];
			then
			echo "Usage $(basename 0$)"
			else
				echo "" >> ~/.ssh/config	
				echo "Host $1" >> ~/.ssh/config	
				echo "	Hostname $2" >> ~/.ssh/config	
				echo "	Port $3" >> ~/.ssh/config
				echo "	IdentityFile ~/.ssh/keys.d/$(hostname)_$1" >> ~/.ssh/config	
		fi

		}

	#####

	## Archives
	#--------------

		# Extract about anything
		extract () {
			if [ -f $1 ] ; then
				case $1 in
					*.tar.bz2)   tar xvjf $1   ;;
					*.tar.gz)    tar xvzf $1   ;;
					*.bz2)       bunzip2 $1    ;;
					*.rar)       unrar x $1    ;;
					*.gz)        gunzip $1     ;;
					*.tar)       tar xvf $1    ;;
					*.tbz2)      tar xvjf $1   ;;
					*.tgz)       tar xvzf $1   ;;
					*.zip)       unzip $1      ;;
					*.Z)         uncompress $1 ;;
					*.7z)        7z x $1       ;;
					*)           echo "'$1' cannot be extracted via >extract<" ;;
				esac
			else
				echo "'$1' is not a valid file"
			fi
		}

		# making unrar more convinient
		alias unrar='unrar e'
		alias unrarall='unrar e *.rar'


		# great extract and compress commands. mk* outputs to ..
		alias mktar='time { tar -cvf ../"${PWD##*/}.tar" *;echo "----------";echo " " ; echo "Execution time: "; }'
		alias mkxz='time { tar --xz -cvf ../"${PWD##*/}.tar.xz" *;echo "----------";echo " " ; echo "Execution time: "; }'
		alias mkbz2='time { tar -cvjf ../"${PWD##*/}.tar.bz2" *;echo "----------";echo " " ; echo "Execution time: "; }'
		alias mkgz='time { tar -cvzf ../"${PWD##*/}.tar.gz" *;echo "----------";echo " " ; echo "Execution time: "; }'
		alias mkrar='time { rar ar -m5 ../"${PWD##*/}.rar" *;echo "----------";echo " " ; echo "Execution time: "; }'
		alias untar='tar -xvf'
		alias unbz2='tar -xvjf'
		alias ungz='tar -xvzf'
	#####

# package manager stuff
#------------------------
	# debian package stuff
	if which apt-get &>/dev/null; then
	    alias ag='sudo apt-get'
		alias ai='sudo apt-get install'
		alias ar='sudo apt-get remove'
		alias ags='aptitude search -V'
		alias aupdate='sudo aptitude update'
		alias aupgrade='sudo aptitude upgrade'
		alias auu='sudo aptitude update; sudo aptitude safe-upgrade'
		

		complete -cf ags
		complete -cf ai
		complete -cf ar
	fi

	# arch package stuff
	if which pacman &>/dev/null; then
		alias yu='yaourt --noconfirm  -Syyu --aur' # full system upgrade
		alias yi='yaourt --noconfirm -S' # install
		alias y='yaourt'
		alias ys='yaourt -Ss'
		alias yr='yaourt --noconfirm -R' # remove
			
		complete -cf yaourt
		complete -cf pacman
		complete -cf yr
		complete -cf yi

		# list and sort all packages after filesize (using pacman)
		alias pkgsize='paste <(pacman -Q | awk "{ print $1; }" | xargs pacman -Qi | grep "Size" | awk "{ print $4$5; }") <(pacman -Q | awk "{print $1; }") | sort -n | column -t'
	fi
	


# shell
#--------------

	# promt
	if [[ ${EUID} == 0 ]] ; then
			PS1='\[\033[34;1m\]\u\[\033[35;1m\]@\[\033[32;1m\]\H\[\033[0m\]:\w\n # '
		else
			PS1='\[\033[34;1m\]\u\[\033[35;1m\]@\[\033[32;1m\]\H\[\033[0m\]:\w\n ➔ '
	fi

	# enable completions you have installed
	if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
	    . /etc/bash_completion
	fi

	#random completers
	complete -cf man
	complete -cf sudo
	complete -cf whereis
	complete -cf killall

	# long history and sync across terminals
	HISTSIZE=9000
	HISTFILESIZE=$HISTSIZE
	HISTCONTROL=ignorespace:ignoredups

	history() {
	  _bash_history_sync
	  builtin history "$@"
	}

	_bash_history_sync() {
	  builtin history -a         #1
	  HISTFILESIZE=$HISTFILESIZE #2
	  builtin history -c         #3
	  builtin history -r         #4
	}

	PROMPT_COMMAND=_bash_history_sync
########


# refresh this file
alias refresh=". $HOME/.bashrc"
#-------------------------------
