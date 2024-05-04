cd /users/juancho/flac/tests/licensed_to_ill_02
firstString="A1 Rhymin & Stealin 96.flac"
echo "$firstString" | second_string=$(awk '{gsub(" ","_"); print}')
echo "$second_string" | third_string=$(awk '{gsub("&","and"); print}')
target_dir="/users/juancho/flac"
mv "$firstString" "$target_dir/$third_string"
