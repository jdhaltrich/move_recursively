

codearguments <- commandArgs(trailingOnly = TRUE)

targetdir <- print(codearguments[1], quote = TRUE)


filelist <- list.files(
                path = targetdir,
                pattern = NULL,
                all.files = TRUE,
                full.names = TRUE,
                recursive = TRUE,
                ignore.case = FALSE,
                include.dirs = FALSE,
                no.. = FALSE
        )


maxdepthdir=$(printf '%d\n' "$(cd "${targetdir}" && find . -mindepth 0 -type d -printf '%d\n' | sort -rn | head -1)")

if [[ ! -d "${logdir}" ]]; then
	mkdir -p "${logdir}"
	mkdir -p "${lslogdir}"
	mkdir -p "${proctimesdir}"
fi

END=${maxdepthdir}


# dirs

dirmv () {
	if [[ "${timestampsswitch}" == "-t" || "${timestampsswitch}" == "-T" ]]; then
		dirmvstart=($(timestamps))
		dirmv_timelog="${proctimesdir}/dirmv_proctimes"
		dirmv_string="total running time dirmv function"
	fi

	for (( i = 0; i <= $END; i++ )); do
		if [[ "${timestampsswitch}" == "-t" || "${timestampsswitch}" == "-T" ]]; then
			depthdirstart=($(timestamps))
			depthdir_timelog="${proctimesdir}/depthdir_timelog_$i"
			depthdir_string="total running time incremental directories depth"
		fi

		depthlist="${lslogdir}/depth_$i"
		
		find "${targetdir}" -mindepth $i -maxdepth $i -type d \( -not -path "${logdir}" -o -not -path "${lslogdir}" -o -not -path "${proctimesdir}" \) | sort -n > "${depthlist}"
		
		if [[ "${timestampsswitch}" == "-t" || "${timestampsswitch}" == "-T" ]]; then
			depthdirfinish=($(timestamps))
			source tslog ${depthdirstart[0]} ${depthdirfinish[0]} -s "${depthdirstart[1]}" -f "${depthdirfinish[1]}" "${depthdir_timelog}" "${depthdir_string}"
		fi
	done

	for (( i = $END; i >= 0; i-- )); do
		if [[ "${timestampsswitch}" == "-t" || "${timestampsswitch}" == "-T" ]]; then
			renamedirstart=($(timestamps))
			renamedir_timelog="${proctimesdir}/renamedir_timelog_0_$i"
			renamedir_string="total running time rename directories"
		fi

		while IFS= read -r aline; do
			targetbase="$(printf '%s\n' "$aline" | sed 's/\/[^/]*$//')"
			targetfilename=$(printf '%s\n' "$aline" | sed 's/^[^:]*[/]//' | sed 's/!//g;s/@//g;s/#//g;s/\$//g;s/%//g;s/\^//g;s/&//g;s/*//g;s/(//g;s/)//g;s/-//g;s/,//g;s/\[//g;s/\]//g;s/{//g;s/}//g' | sed "s/'//g" | sed "s/ /_/g;s/\(.*\)/\L\1/g" | sed 's/\.//2g')
			targetfilepath="${targetbase}/${targetfilename}"
				if [[ "$aline" != "${targetfilepath}" ]]; then
					if [[ "${verbosemode}" == "silent" ]]; then
						mv "$aline" "${targetfilepath}"
					else
						mv -v "$aline" "${targetfilepath}"
					fi
				fi
		done < "${lslogdir}/depth_$i"


		if [[ "${timestampsswitch}" == "-t" || "${timestampsswitch}" == "-T" ]]; then
			renamedirfinish=($(timestamps))
			source tslog ${renamedirstart[0]} ${renamedirfinish[0]} -s "${renamedirstart[1]}" -f "${renamedirfinish[1]}" "${renamedir_timelog}" "${renamedir_string}"
		fi
	done

	if [[ "${timestampsswitch}" == "-t" || "${timestampsswitch}" == "-T" ]]; then
		dirmvfinish=($(timestamps))
		source tslog ${dirmvstart[0]} ${dirmvfinish[0]} -s "${dirmvstart[1]}" -f "${dirmvfinish[1]}" "${dirmv_timelog}" "${dirmv_string}"
	fi
}

# files

filemv () {
	if [[ "${timestampsswitch}" == "-t" || "${timestampsswitch}" == "-T" ]]; then
		filemvstart=($(timestamps))
		filemv_timelog="${proctimesdir}/filemv_proctimes"
		filemv_string="total running time filemv function"
	fi

#	find "${targetdir}" -mindepth 0 -type f \( -not -path "${logdir}" \) | sort -n > "${lslogdir}/filedepth0"
	find "${targetdir}" -mindepth 0 -type f \( -not -path "${logdir}" -o -not -path "${lslogdir}" -o -not -path "${proctimesdir}" \) | sort -n > "${lslogdir}/filedepth0"
	if [[ "${timestampsswitch}" == "-T" ]]; then
		filerenamed="${lslogdir}/filedepth1_renamed"
		touch "${filerenamed}"
	fi
	fileunchanged="${lslogdir}/filedepth1_unchanged"
	touch "${fileunchanged}"

	while IFS= read -r fileline; do
		if [[ "${timestampsswitch}" == "-T" ]]; then
			rnmfile_start=$(tsf)
		fi

		rootfiledir="$(printf '%s\n' "$fileline" | sed 's/\/[^/]*$//')"
		rootfilename01_full="$(printf '%s\n' "$fileline" | sed 's/^[^:]*[/]//')"
		rootfilename02_base="$(printf '%s\n' "${rootfilename01_full}" | sed 's/\.[^\.]*$//')"
		
		rootformat01_test=$(printf '%s\n' "${rootfilename01_full}" | awk -F "." '{print NF-1}')
		if [[ ${rootformat01_test} -ne 0 ]]; then
			rootformat="$(printf '%s\n' "${rootfilename01_full}" | sed 's/.*\././')"
		fi
		
		targetfilename01_base="$(printf '%s\n' "${rootfilename02_base}" | sed 's/!//g;s/@//g;s/#//g;s/\$//g;s/%//g;s/\^//g;s/&//g;s/*//g;s/(//g;s/)//g;s/-//g;s/,//g;s/\[//g;s/\]//g;s/{//g;s/}//g' | sed "s/'//g" | sed "s/ /_/g;s/\(.*\)/\L\1/g" | sed 's/\.//2g')"
		
		if [[ ${rootformat01_test} -eq 0 ]]; then
			targetfilename02_full="${targetfilename01_base}"
		else
			targetfilename02_full="${targetfilename01_base}${rootformat}"
		fi
		
		targetfilepath="${rootfiledir}/${targetfilename02_full}"
		
		if [[ "$fileline" != "${targetfilepath}" ]]; then
			if [[ "${verbosemode}" == "silent" ]]; then
				mv "$fileline" "${targetfilepath}"
			else
				mv -v "$fileline" "${targetfilepath}"
			fi
			if [[ "${timestampsswitch}" == "-T" ]]; then
				rnmfile_end=($(timestamps))
				rnmfileproctime_real=$(source prtime 0 ${rnmfile_start[0]} ${rnmfile_end[0]})
				printf '%s - %s seconds - %s\n' "${rnmfile_end[1]}" "${rnmfileproctime_real}" "${targetfilepath}" >> "${filerenamed}"
			fi
		else
			fileunchanged_ts="$(date --iso-8601=ns)"
			printf '%s - %s\n' "${fileunchanged_ts}" "$fileline" >> "${fileunchanged}"
		fi
	done < "${lslogdir}/filedepth0"
	
	if [[ "${timestampsswitch}" == "-t" || "${timestampsswitch}" == "-T" ]]; then
		filemvfinish=($(timestamps))
		source tslog ${filemvstart[0]} ${filemvfinish[0]} -s "${filemvstart[1]}" -f "${filemvfinish[1]}" "${filemv_timelog}" "${filemv_string}"
	fi
}

scrmode () {
	case "${switch}" in
		-d)
				dirmv
				;;
		-f)
				filemv
				;;
		-F)
				dirmv
				filemv
				;;
	esac
}

scrmode "${switch}"

printf '%s %s %s %s %s\n' "script mode run as: depth" "${switch}" "${targetdir}" "${verboseswitch}" "${timestampsswitch}" > "${scrmodefull}"

if [[ "${timestampsswitch}" == "-t" || "${timestampsswitch}" == "-T" ]]; then
	scrfinish=($(timestamps))
	source tslog ${scrstart[0]} ${scrfinish[0]} -s "${scrstart[1]}" -f "${scrfinish[1]}" "${scr_timelog}" "${scr_string}"
fi
