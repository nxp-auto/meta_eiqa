#!/bin/bash

[[ $- =~ x ]] && PS4='${BASH_SOURCE}-${LINENO} : '

# Reset
ColorOff='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White

is_func() { [[ "$(declare -Ff "$1")" ]]; }

DBG=true
DBG_VAR() { $DBG && printf "\n${BYellow}[DBG]${ColorOff}: $1=${!1}\n"; }

msg_exit() { printf "$1\n"; [ -z $2 ] && exit 0 || exit $2; }

err_exit() { printf "\n${BRed}ERR${ColorOff}:$1\n"; [ -z $2 ] && exit 1 || exit $2; }

ask_yesno() { # $1 - questin
    for((;;)) do 
        read -p "$@ (y/n) ? " ack
        [ $ack = y ] && return 0
        [ $ack = n ] && return 1; 
    done
}

echo_str_dup() { yes "$2" | head -$1 | xargs | sed 's/ //g'; }

show_vars() { for v in $@; do echo $v=${!v}; done; }

valid_var() {
    if [ -z ${!1} ]; then echo "$1=<empty>"; return 1; fi
    echo "$1=${!1}"; return 0
}
 
valid_path() { # $1 : path or dir or file, $2 : -d/-f/-e
    if [ -z ${!1} ]; then echo "$1=<empty>"; return 1; fi
    eval "$1=$(realpath ${!1})"
    if [ ! $2 ${!1} ]; then echo "$1=${!1} not exist"; return 1; fi
    echo "$1=${!1}"; return 0
}

valid_file() {  # $1 : path-to-file
    if [ -z ${!1} ]; then echo "$1=<empty>"; return 1; fi
    eval "$1=$(realpath ${!1})"
    if [ ! -f ${!1} ]; then echo "$1=${!1} not exist"; return 1; fi
    echo "$1=${!1}"; return 0
}

unset_exit() { [ -z ${!1} ] && err_exit "$1 is empty\n"; echo; return 0; }
noexist_exit() { [ -e ${!1} ] || err_exit "$1 not exist\n"; echo; return 0; }

pause() {
    read -p "any key continue, e-exit : " -n 1 -s ack
    [ x$ack = xe ] && exit 0 || printf "\n\n"
}

is_uint() { case $1        in '' | *[!0-9]*              ) return 1;; esac ;}
is_int()  { case ${1#[-+]} in '' | *[!0-9]*              ) return 1;; esac ;}
is_unum() { case $1        in '' | . | *[!0-9.]* | *.*.* ) return 1;; esac ;}
is_num()  { case ${1#[-+]} in '' | . | *[!0-9.]* | *.*.* ) return 1;; esac ;}

ask_uint() {   # $1-title, $2-outvar $3-min $4-max
    while true; do
        read -p "$1 ($3-$4) : " $2
        is_uint ${!2} && [ ${!2} -ge $3 ] && [ ${!2} -le $4 ] && return 0
    done
}

select_one() {  # $1-title $2-outvar $3-"(o1 o2 o3 ...)"
    local ar cnt
    eval ar=$3;  cnt=${#ar[@]} 
    echo; for (( i=1; i<=$cnt; i++ )); do echo $i - ${ar[i-1]}; done
    ask_uint "$1" i 1 $cnt
    eval $2=${ar[i-1]}
}

check_exist() { # $@ - names of required executables
    for x in $@; do
        which $x 1>/dev/null || echo $x not installed
    done 
}

input_dir() { # $1-caption $2-saveto  $3-init
    read -p "$1 : " -e $([ -z $3 ] && echo "" || echo "-i $3") $2
}

select_dir() { # $1-caption, $2-init, output-selected dir
    yad --file-selection --directory --title="$1" --center --filename=$2 2>/dev/null && return 0 || return 1
}

input_string() { # $1-caption $2-saveto $3-init
    read -p "$1 : " -e $([ -z $3 ] && echo "" || echo "-i $3") $2
}

fm_begin() { fm_vars=""; form="yad --title '$1' --form --center --borders=12 --width=500 --num-output "; } # $1-title
fm_add_fld() { fm_vars+=" $1"; shift; form+=' --field='$@; } # $1-varname to get out, $2-field
fm_add_btn() { form+=" --button='$@'"; }
fm_add_lbl() { form+=" --field=\"$@\":LBL ''"; fm_vars+=" sp"; }
fm_add_line() { form+=" --field='':LBL ''"; fm_vars+=" sp";}
fm_pick_option() { echo ${2//^/} | cut -d'!' -f$1; } # $1 - idx, "$2"-options from above
fm_save_dic() { eval "$1[fm]=\"$form\" $1[vars]=\"$fm_vars\""; }  # $1[fm]=form, $1[vars]=fm_vars
fm_save() { eval $1='$form'; eval $2='$fm_vars'; }  # $1-fm $2-vars
fm_show() { # $1 - fm, $2 - vars
    local vars=($2)
    out=$(eval "$1"); ret=$?; $nodbg || printf "\nform="$1"\nfm_vars="${vars[@]}"\nout="$out"\n"
    oa=(); IFS='|' read -a oa <<< $(echo $out | sed -e s/TRUE/1/g -e s/FALSE/0/g)
    for i in ${!vars[@]}; do
        eval "${vars[i]}='${oa[i]}'"
    done
    return $ret
}

check_config() { # $@ - cmd
    eval "$@" 
    read -p "$1" 

}

check_work_dir() {
    [ -z $work_dir ] && err_exit "work_dir=[]"
    [ -e $work_dir ] && err_exit "The folder $work_dir exist!"
}

check_option() {
    option_file=$OPTIONS_DIR/option
    [ -f $option_file ] || err_exit "$option_file not exist"
}

select_from_array() { # $1-array
    local ar=$1 op
    for i in ${!ar[@]}; do echo "$i - ${ar[i]}"; done
    ask_uint "Seelct manifest from " op 1 ${#ar[@]}
}