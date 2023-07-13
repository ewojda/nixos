export EDITOR="emacs"
export WEBKIT_FORCE_SANDBOX=0
export WINEJAILCMD=wine64
alias 7z=7zz

function edit-nixcfg() {
	sudoedit /etc/nixos/configuration.nix "$@"
}

function nrebuild() {
	sudo nixos-rebuild boot "$@"
}

function nrebuild-switch() {
	sudo nixos-rebuild switch "$@"
}

function offline() {
	firejail --noprofile --net=none "$@"
}

function eman() {
	emacs -nw --eval "(progn (man \"$1\") (delete-window))"
}

function eterm() {
    emacs -nw --eval '(term "/run/current-system/sw/bin/bash")'
}

function jap() {
	LANG="ja_JP.UTF8" "$@"
}

function force-mount-ntfs () {
	sudo mount -t ntfs-3g -o remove_hiberfile "$@"
}

function force-mount-ntfs2 () {
	sudo ntfsfix "$1"
	force-mount-ntfs "$@"
}

function find-nixpkgs () {
	find /nix/var/nix/profiles/per-user/root/channels/nixos/ "$@"
}

function ew-cd-and-run () {
	WD="$(pwd)"
	cd "$1"
	shift 1
	"$@"
	cd "$WD"
}

function play-steam() {
	firejail\
	 --profile=steam\
	 --whitelist=/home/emil/Downloads/Games/\
	 --whitelist=/home/emil/Documents/\
	 --whitelist=/mnt/ntfs/\
	 "$@"\
	 steam
}

function play-steam-offline() {
	play-steam --net=none "$@"
}

function lsblk2() {
	lsblk -o LABEL,PATH,SIZE,FSTYPE,FSAVAIL,MOUNTPOINTS,PARTUUID
	#lsblk -o PATH,FSAVAIL,SIZE,FSTYPE,LABEL
}

function yt-dlp-music() {
	yt-dlp\
		--ignore-errors\
		--output '%(playlist_title)s/%(title)s.%(ext)s'\
		--no-continue\
		--extract-audio\
		--audio-format mp3\
		--embed-thumbnail\
		--embed-metadata\
		"$@"

		# --audio-quality 0\
		# --parse-metadata "title:%(title)s"\
		# --parse-metadata "album:%(playlist_title)s"\
		# --parse-metadata "artist:%(uploader)s"\
}

function with-emulated-desktop() {
	WINEJAILCMD="$WINEJAILCMD explorer /desktop=name,1900x1000" "$@"
}

function winejail() {
#	WINEDEBUG=-all firejail --net=none --profile=wine --whitelist=/home/emil/.wine/ --whitelist=/home/emil/Downloads gamemoderun wine64 "$@"
#	WINEDEBUG=-all firejail --net=none --profile=wine --whitelist=/home/emil/.wine/ --whitelist=/home/emil/Downloads wine64 "$@"
	WINEDEBUG=-all firejail\
	 --net=none\
	 --profile=wine\
	 --whitelist=/home/emil/.wine/\
	 --whitelist=/home/emil/Downloads\
	 --whitelist=/home/emil/Documents/Electronic\ Arts/\
	 --whitelist=/home/emil/Documents/Eidos/\
	 --whitelist=/home/emil/.local/share/wineprefixes/\
	 $WINEJAILCMD "$@"
}

function nix-store-path-of() {
	nix eval -f '<nixpkgs>' --raw "$@"
}

function my-nixpkgs() {
	echo 'path:/nix/var/nix/profiles/per-user/root/channels/nixos/'
}

function to-appimage() {
	nix bundle --bundler github:ralismark/nix-appimage "$@"
}

function rcalc() {
	OUT=""
	OUT+="#+begin_src R :exports both :results file graphics :file /tmp/r-output.png"
	OUT+="\n\n"
	OUT+="#+end_src"
	OUT+="\n\n"
	OUT+="#+begin_src R"
	OUT+="\n\n"
	OUT+="#+end_src"
	emacs -nw\
	 --insert <(echo -e "$OUT")\
	 --eval '(org-mode)'
}

function rss() {
	picofeed\
	 --web\
	 'https://videos.icum.to/feeds/videos.xml?sort=-publishedAt'\
	 `#Exanima` 'https://store.steampowered.com/feeds/news/app/362490/?cc=PL&l=english&snr=1_2108_9__2107'\
	 `#Bannerlord` 'https://store.steampowered.com/feeds/news/app/261550/?cc=PL&l=english&snr=1_2108_9__2107'\
	 'https://web3isgoinggreat.com/feed.xml'\
	 'https://sizeof.cat/index.xml'\
	 'https://boards.4channel.org/news/index.rss'\
	 'https://www.theregister.com/headlines.atom'\
	 'https://www.technologyreview.com/feed'\
	 'https://www.lesswrong.com/feed.xml?view=curated-rss'\
	 'https://www.thefp.com/feed'\
	 'https://dailysceptic.org/feed/'\
	 'https://www.spiked-online.com/feed/'\
	 'https://hitchensblog.mailonsunday.co.uk/rss.xml'\
	 'https://snork.ca/feed.xml'\
	 'https://librarian.pussthecat.org/@millennialwoes:4/rss'\
	 'https://anchor.fm/s/11bc7314/podcast/rss'\
	 'https://unlimitedhangout.com/feed/'\
	 'https://downshiftology.com/feed/'\
	 'https://totempole666.com/feed/'\
	 'http://www.buttsmithy.com/feed/'\
	 'https://feeds.megaphone.fm/darknetdiaries'\
	 'https://lemire.me/blog/feed/'\
	 'https://fabiensanglard.net/rss.xml'\
	 'https://nullprogram.com/feed/'\
	 'https://vrelnir.blogspot.com/feeds/posts/default'\
	 'https://trybun.org.pl/wiadomosci/feed'\
	 'https://trybun.org.pl/blog/feed'\
	 'https://adarma.pl/aktualnosci/feed'\
	 'https://mises.org/feed/rss.xml'\
	 'https://firearmsradio.net/category/fudd-busters/feed/'
}

function nixpls() {
	nix profile list | awk '{ print $1 " " $2 }'
}

function nixps() {
	nix search $(my-nixpkgs) "$@"
}

function nixpi() {
	nix profile install $(my-nixpkgs)#"$@"
}

function nixpr() {
	nix profile remove "$@"
}

function rtor() {
	sudo systemctl restart tor.service
}

function play() {
	/home/emil/Projects/Go/play/play /home/emil/Downloads/Games/* /mnt/ntfs/Games/ ~/.wine/drive_c/Games/
}
