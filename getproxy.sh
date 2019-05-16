#!/bin/bash
merah="\e[91m"
ijo="\e[92m"
kuning="\e[93m"
putih="\e[97m"
cyan="\e[96m"
bold="\e[1m"
header(){
printf "${GREEN}
         ####################################
         ####################################
         #######                      #######
         #######                      #######
         #######                      #######
         ###############      ###############
         ###############      ###############
         ###############      ###############
         ###############      ###############${RED}
         #######    ####      ####    #######
         #######    ####      ####    #######
         #######    ##############    #######
         #######    ##############    #######
         #######                      #######
         ####################################
         ####################################${NOCOLOR}
         ------------------------------------
               Proxy Grab  Checker Live
               https://tatsumi-crew.net
         ------------------------------------
"
}
header
printf "${bold}"
printf "\n${cyan}Ngambil Proxy${putih}... \n\n"

printf "${putih}[${ijo}!${putih}] ${cyan}free-proxy-list.net... "
curl -s "https://free-proxy-list.net/" | grep -Eo '<td>([0-9]{1,3}\.){3}[0-9]{1,3}<(.?*)>[0-9]{2,9}</td>' | sed 's/<td>//g' | sed 's/<\/td>/:/g' | grep -Eo '[[:alnum:]+\.]{1,15}:[0-9]{2,9}' >> proxy.tmp
printf "${ijo}DONE\n"

printf "${putih}[${ijo}!${putih}] ${cyan}www.us-proxy.org... "
curl -s "https://www.us-proxy.org/" | grep -Eo '<td>([0-9]{1,3}\.){3}[0-9]{1,3}<(.?*)>[0-9]{2,9}</td>' | sed 's/<td>//g' | sed 's/<\/td>/:/g' | grep -Eo '[[:alnum:]+\.]{1,15}:[0-9]{2,9}' >> proxy.tmp
printf "${ijo}DONE\n"

printf "${putih}[${ijo}!${putih}] ${cyan}clarketm github... "
curl -s "https://raw.githubusercontent.com/clarketm/proxy-list/master/proxy-list.txt" | sed '1,2d; $d; s/\s.*//; /^$/d' | sed 's/IP//g' >> proxy.tmp
printf "${ijo}DONE\n"

printf "${putih}[${ijo}!${putih}] ${cyan}duplichecker.com... "
curl -s "https://www.duplichecker.com/free-proxy-list.php" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}:[0-9]{2,9}' >> proxy.tmp
printf "${ijo}DONE\n"

printf "${putih}[${ijo}!${putih}] ${cyan}proxyrack.com... "
page=0; 
for off in {0..2000..100}; do 
	((page++));
	curl -s "https://www.proxyrack.com/proxyfinder/proxies.json?page=${page}&perPage=100&offset=${off}" | grep -Eo '"([0-9]{1,3}\.){3}[0-9]{1,3}","port":"[0-9]{2,9}"' | sed 's/","port":"/:/g' | sed 's/"//g' >> proxy.tmp
done
printf "${ijo}DONE\n\n"

printf "${putih}[${ijo}!${putih}] ${cyan}Removing Duplicate... "
sortir=$(cat proxy.tmp | sort | uniq >> proxy.txt)
rm proxy.tmp
printf "${ijo}DONE\n"
printf "${putih}[${ijo}+${putih}] ${cyan}Found ${kuning}$(cat proxy.txt | wc -l) ${cyan}Proxies\n\n"

printf "${putih}[${ijo}!${putih}] ${cyan}Checking Live ...\n\n"

ngirim=20
tidur=5
itung=0
nominal=0
IFS=$'\r\n' GLOBIGNORE='*' command eval 'proxi=($(cat proxy.txt))'
for (( i = 0; i <"${#proxi[@]}"; i++ )); do
	((nominal++));
	ngesend=$(expr $itung % $ngirim)
	if [[ $ngesend == 0 && $itung > 0 ]]; then
		sleep $tidur
	fi

	proxynya="${proxi[$i]}"
	ceklivenya=$(curl -s --connect-timeout 4 -x "${proxynya}" "https://pastebin.com/raw/dUK9ME2J" -L)
	if [[ $ceklivenya =~ "BULBUL" ]]; then
		echo "${proxynya}" >> proxylive.txt
		printf "${putih}[${ijo}+${putih}] $proxynya [${ijo}LIVE${putih}] (${ijo}$(cat proxylive.txt | wc -l)${putih})\n"
	else
		printf "${putih}[${merah}-${putih}] $proxynya [${merah}DIE${putih}]\n"
	fi

	((itung++));

done
rm proxy.txt
