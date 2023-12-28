#!/usr/bin/env sh

sourced=0
if [ -n "$ZSH_VERSION" ]; then
	case $ZSH_EVAL_CONTEXT in *:file) sourced=1;; esac
elif [ -n "$KSH_VERSION" ]; then
	[ "$(cd -- "$(dirname -- "$0")" && pwd -P)/$(basename -- "$0")" != "$(cd -- "$(dirname -- "${.sh.file}")" && pwd -P)/$(basename -- "${.sh.file}")" ] && sourced=1
elif [ -n "$BASH_VERSION" ]; then
	(return 0 2>/dev/null) && sourced=1
else
	case ${0##*/} in sh|-sh|dash|-dash) sourced=1;; esac
fi

if [ $sourced = 1 ]; then
	echo "Error: Script must NOT be sourced."
else
	#zift_dir="$(dirname "$0")"
	zift_dir="$(cd $(dirname "$0") && pwd)"

	echo $zift_dir > $HOME/.zift_dir

	cd $zift_dir

	for file in *; do
		case "$file" in
			zift-*.tar.gz.gpg)
				echo "File '$file' matches the pattern"
				echo ""

				zift=$file
				new_zift=${file%.tar.gz.gpg}

				gpg --decrypt "$zift" | tar xzf - && rm -rf "$zift"

				if [ -f "$zift_dir/$zift" ]; then
					echo ""
					echo "Decryption Failed: '$zift_dir/$zift'"
				elif [ -d "$zift_dir/$new_zift" ]; then
					echo ""
					echo "Decryption Complete: '$zift_dir/$zift' -> '$zift_dir/$new_zift'"
				fi
				;;
			*)
				# echo "File $file does not match the pattern"
				;;
		esac
	done
fi

