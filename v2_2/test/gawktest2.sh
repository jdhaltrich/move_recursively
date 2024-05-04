#array1=("juan" "diluca" "juandiluca" "dilucahaltrich" "haltrich" "haltrichjuan" "juanhaltrich" "dilucajuan")
vardir1="juandiluca"
vardir2="juandilucahaltrich"
#printf '%s\n' "${array1[@]}"
#newvar3=$(printf '%s\n' "${array1[@]}" |
#newvar3=$(gawk -v x="$vardir1" -v z="$vardir2" 'BEGIN{ FS = "\n" }{print gensub(x,z, NF);}' "/mnt/local/drive_02/shared/linuxstp/wrk/dvlp/type02scr/mv_recursive/gawktest2")
#printf '%s\n' "${newvar3[@]}"
gawk -i inplace -v x="$vardir1" -v z="$vardir2" 'BEGIN{ FS = "\n" }{print gensub(x,z, NF);}' "/mnt/local/drive_02/shared/linuxstp/wrk/dvlp/type02scr/mv_recursive/gawktest2"
