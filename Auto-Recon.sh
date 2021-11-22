#!/bin/bash
read -p "[+] Please Enter Your Target : " TARGET
R_TAG=$(dig +short $TARGET)
read -p "[+] Please specify a wordlist path: " WORDLIST

who () {
  whois $TARGET # >> Report_logs/whois_log.txt
  sleep 5
}



#UNISCAN
uni () {
  uniscan -u $TARGET -j
  sleep 5
}

#nmap
nmapp () {

  nmap -sV  -p1-65535 -oN Report_logs/nmap_log.txt $R_TAG

}

#DIRB
dirbb () {

  dirb  https://$R_TAG $WORDLIST -o Report_logs/dirb_report.txt
}

#SUBLIST3R
sublist () {
  sudo sublist3r -o Report_logs/sub.txt -d $TARGET
  sleep 5
  for subs in $(cat sub.txt); do
    wfuzz -c -w $WORDLIST ${subs}/FUZZ
done
}

#WFUZZ_WEBCONTENT
wfuzz_a () {

  wfuzz -c -w $WORDLIST --sc 200,301 ${R_TAG}/FUZZ

}


echo "[++] Starting the WHOIS query"
who
sleep 5
whatweb
echo "[++] Starting UNISCAN"
uni
#echo "[++] Starting SUBLIST3R"
sublist
dirbb

sleep 5
nmapp
echo "[+++] Starting WFUZZ "
sleep 3
wfuzz_a
