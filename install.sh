#!/usr/bin/env bash
#set -e
#set -u

function message {
    echo -e "\e[00;32m$1\e[00m"
}

function error {
    echo -e "\e[00;31m$1\e[00m"
    exit 1
}

git=`which git`
fortune=`which fortune`
tmp_text_file='/tmp/arkitect'
tmp_dat_file='/tmp/arkitect.dat'
tmp_quotes='/tmp/arkitect-quotes'
fortune_path='/usr/share/games/fortunes/'

if [ -z $git ]; then
    error 'git has to be installed'
fi

if [ -z $fortune ]; then
    error 'fortune has to be installed'
fi

if [ -d $tmp_quotes ]; then
    rm -rf $tmp_quotes
fi

message 'updating quotes'
git pull origin master &> /dev/null

message 'installing quotes'
mkdir $tmp_quotes
cp -r quotes/*.txt $tmp_quotes

for quote in $tmp_quotes/*.txt; do
    separator="%"
    last_char=$(cat "$quote" | tail -c 1)
    if [ ! $last_char = "\n" ]; then
        separator="\n$separator"
    fi;
    echo -e $separator >> "$quote"
done
cat $tmp_quotes/*.txt > $tmp_text_file
strfile $tmp_text_file $tmp_dat_file -s
sudo cp $tmp_dat_file $tmp_text_file $fortune_path
message 'done !'
