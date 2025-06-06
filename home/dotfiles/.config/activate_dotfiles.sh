# loop through all folders and files
for program in $(ls -d  *)
do
  # create softlink to config folder for all folders and files unless it is the README
  if [ ! $program == 'README.md' ]; then
	rm -r ~/.config/$program
    	ln -s $PWD/$program ~/.config/$program
  fi
done

# make some scripts executable
chmod +x $PWD/sway/scripts/autotiling/start.sh
chmod +x $PWD/sway/scripts/autotiling/main.py
chmod +x $PWD/sway/scripts/audio/toggle_mic_mute.sh 
