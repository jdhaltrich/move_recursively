dir_orig="/users/juancho/flac/tests/licensed_to_ill_02"
filename_orig="A1 Rhymin & Stealin 96.flac"
cd $dir_orig
repl_01="$(echo "$filename_orig" | sed 's/ /_/g')"
repl_02="$(echo "$repl_01" | sed 's/&/and/g')"
#target_dir="/users/juancho/flac"
cd /users/juancho/flac
mv "$dir_orig/$filename_orig" "$dir_orig/$repl_02"

#echo "$firstString" | second_string=$(awk '{gsub(" ","_"); print}')
#echo "$second_string" | third_string=$(awk '{gsub("&","and"); print}')
#target_dir="/users/juancho/flac"
#mv "$firstString" "$target_dir/$third_string"
