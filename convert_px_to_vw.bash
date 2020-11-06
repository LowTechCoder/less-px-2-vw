file="$1"
output_file="convert_px_to_vw.less"
echo -n "" > "$output_file"
sed -i -e '$a\' "$file" # add new line at eof if not there
while IFS="" read -r p
do
    if [[ "$p" == *"px"* ]] && [[ "$p" != *"line-height"* ]] && [[ "$p" != *"font"* ]] && [[ "$p" != *"*"* ]] && [[ "$p" != *"/"* ]]
	then
    
        # printf '%s\n' "$p"
        spaces=$(printf '%s' "$p" | sed 's#[a-z].*$##g')
        chars=$(echo "$p" | perl -pe 's|^.*?([a-z])|\1|')
        echo "$spaces// $chars" >> "$output_file"
        
        myarr=($p)
        pos=$(( ${#myarr[*]} - 1 ))
        last=${myarr[$pos]}
        printf "$spaces" >> "$output_file"
        for i in "${myarr[@]}"
        do
            :
            if [[ "$i" == *"px"* ]]
            then
                num=$(printf "$i" | tr -dc '0-9')
		        num2=$(bc -l <<< "$num / 1440 * 100")
                printf '%s' " " >> "$output_file"
                printf %.2f "$num2" >> "$output_file"
    	        printf '%s' "vw" >> "$output_file"
                if [[ $i != $last ]]
                then
    	            printf '%s' " " >> "$output_file"
                fi
            else
		        printf '%s' "$i" >> "$output_file"
            fi

        done
        printf ";\n" >> "$output_file"
    else
        printf '%s\n' "$p" >> "$output_file"
	fi
done < "$file"