# Collection of useful aliases and other stuff that I usually adjust in .bashrc

function as_func() {
	apt-cache search $1 | sort
}

function au_func() {
	# also ask Akregator to persist it's database, this is a workaround for bugs
	# https://bugs.kde.org/show_bug.cgi?id=210408
	# https://bugs.kde.org/show_bug.cgi?id=199232
	# https://bugs.kde.org/show_bug.cgi?id=196633
	# https://bugs.kde.org/show_bug.cgi?id=185507
	# I didn't have a better place to put this so it is executed as part of the d-bus session
	#dbus-send --session --dest=org.kde.akregator --type=method_call /Akregator  org.kde.akregator.part.saveSettings

	sudo apt-get update && sudo apt-get dist-upgrade
}

function _usbmount() {
	#echo "Looking at $1"
	mount $1 2> /dev/null && (echo "Mounting $1" && nautilus $1 &)
}

function _usbumount() {
	#echo "Looking at $1"
	mount | grep $1 && (echo "Unmounting $1" && umount $1)
}

function _u_func() {
	geany -l 1 "$@" &
}

function __gradle_func() {
	if [ -x gradlew ]
	then
		GRADLE_OPTS="-Xms128m -Xmx400m" nice -n 10 ./gradlew "$@" | \
  perl -pe'$m|=/BUILD .*SUCCESS/; END {exit!$m}' && \
  (which notify-send > /dev/null && notify-send --icon=face-cool "`basename $(pwd)`: gradle $*" "Build SUCCESS" ; exit 0) || \
  (which notify-send > /dev/null && notify-send --icon=face-crying "`basename $(pwd)`: gradle $*" "Build FAILED" ; exit 1)
	else
		GRADLE_OPTS="-Xms128m -Xmx400m" nice -n 10 gradle "$@" | \
  perl -pe'$m|=/BUILD .*SUCCESS/; END {exit!$m}' && \
  (which notify-send > /dev/null && notify-send --icon=face-cool "`basename $(pwd)`: gradle $*" "Build SUCCESS" ; exit 0) || \
  (which notify-send > /dev/null && notify-send --icon=face-crying "`basename $(pwd)`: gradle $*" "Build FAILED" ; exit 1)
	fi
}

function __gnome_open_func() {
	for i in "$@"
	do
		echo $i
		gnome-open "$i"
		sleep 2
	done
}

alias as="as_func"
alias ap="apt-cache showpkg"
alias ai="sudo apt-get install"
alias au="au_func"
alias lcdoff="xset dpms force off"
alias apo="apt-cache policy"
alias u="_u_func"
alias iotop="iotop -o -d 5 -P -k"
alias bob="/etc/cron.daily/bob"

# git aliases, http://www.catonmat.net/blog/git-aliases/
alias ga='git add'
alias gp='git push'
alias gl='git log'
alias gst='git status'
alias gd='git diff'
alias gdc='git diff --cached'
alias gm='git commit -m'
alias gma='git commit -am'
alias gb='git branch -a'
alias gco='git checkout'
alias gra='git remote add'
alias grr='git remote rm'
alias gpu='git pull'
alias gcl='git clone'
alias svndiff='svn diff --diff-cmd diff -x -uw '
alias iot='sudo iotop -d 30 -o -P -k'
alias ifwatch='sudo watch --differences=cumulative --interval=30 ifconfig'
alias usbmount='for i in b c d e f;do _usbmount /usb$i;done;mount | grep usb'
alias usbumount='for i in a b c d e f;do _usbumount /usb$i;done;mount | grep usb'
alias debuildnew='debuild "-i(.git|.svn|.travis.yml)" -S -sa'
alias debuildexisting='debuild "-i(.git|.svn|.travis.yml)" -S -sd'
alias doc='sudo docker'
alias g='__gradle_func'
alias o='__gnome_open_func'
alias git-import-orig='gbp import-orig'
alias git-import-dsc='gbp import-dsc'
alias git-import-dscs='gbp import-dscs'

# * If on master: gbin branch1 <-- this will show you what's in branch1 and not in master
# * If on master: gbout branch1 <-- this will show you what's in master that's not in branch 1
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
  }

function gbin {
  echo branch \($1\) has these commits and \($(parse_git_branch)\) does not
	  git log ..$1 --no-merges --format='%h | Author:%an | Date:%ad | %s' --date=local
}

function gbout {
  echo branch \($(parse_git_branch)\) has these commits and \($1\) does not
	  git log $1.. --no-merges --format='%h | Author:%an | Date:%ad | %s' --date=local
}


export TERM=xterm
if [ `uname --machine` == armv7l ];then
  export JAVA_HOME=/usr/lib/jvm/jdk-8-oracle-arm32-vfp-hflt/
else
  export JAVA_HOME=/usr/lib/jvm/java-8-oracle/
fi

DEBEMAIL=dominik.stadler@gmx.at
DEBFULLNAME="Dominik Stadler (Ubuntu key)"
export DEBEMAIL DEBFULLNAME

# see http://pkg-perl.alioth.debian.org/howto/quilt.html
export QUILT_PATCHES=debian/patches

# sudo dpkg --configure -a


# color for manpages, see http://tuxarena.blogspot.com/2009/06/6-bash-productivity-tips.html
export LESS_TERMCAP_mb=$'\E[01;31m' # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m' # begin bold
export LESS_TERMCAP_me=$'\E[0m' # end mode
export LESS_TERMCAP_se=$'\E[0m' # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m' # begin standout-mode - info box export LESS_TERMCAP_ue=$'\E[0m' # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

wiki() { dig +short txt $1.wp.dg.cx; }
memtop() { ps aux | sort -nk +4 | tail; }

# somehow this did include spansish es_ES?!
export LANGUAGE="de_AT:de"

export EDITOR=vi
