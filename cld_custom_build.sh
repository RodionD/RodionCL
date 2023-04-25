#!/bin/bash

##
# Color  Variables
##
green='\e[32m'
blue='\e[34m'
red='\e[31m'
clear='\e[0m'
##
# Color Functions
##
ColorGreen(){
	echo -ne $green$1$clear
}
ColorBlue(){
	echo -ne $blue$1$clear
}
ColorRed(){
	echo -ne $red$1$clear
}

set_cldo() {
	CALC_DIST="cls"
	BUILD_ID="cldo"
	PROFILE_NAME="CLDO"
}

set_cldlite() {
	CALC_DIST="cld"
	BUILD_ID="cldlite"
	PROFILE_NAME="CLDLite"
}

menu(){
	echo -ne "
	Select distribution
	$(ColorGreen '1)') CLDO
	$(ColorGreen '2)') CLDLite
	$(ColorRed   '0)') Skip script
	$(ColorBlue 'Choose an option:') "

	read a
	case $a in
	    1) set_cldo ;;
	    2) set_cldlite ;;
		0) exit 0 ;;
		*) echo -e $red"Wrong option."$clear ; menu ;;
	esac
}

menu 

CALC_URL=https://mirror.yandex.ru/calculate/nightly/
GIT_URL='https://github.com/RodionD/RodionCL'

LAST_DATE=$(curl $CALC_URL | grep -o '<a .*href=.*>' | sed -e 's/<a /\n<a /g' | sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d' | tail -1)
echo "LAST DATE: ${LAST_DATE}"
LAST_NIGHTLY=$CALC_URL$LAST_DATE
echo "LAST NIGHTLY: ${LAST_NIGHTLY}"
ISO_NAME=$(curl $LAST_NIGHTLY | grep -o '<a .*href=.*>' | sed -e 's/<a /\n<a /g' | sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d' | grep "${CALC_DIST}-" | grep .iso)
echo "ISO NAME: ${ISO_NAME}"

if [[ ! -f ./$ISO_NAME ]];
then
  curl ${LAST_NIGHTLY}${ISO_NAME} -o ${ISO_NAME}
fi

read -a strarr <<< $(sudo cl-builder-update --id list | grep "*")
echo $strarr[2]

if [[ ! "${strarr[2]}" == "*${BUILD_ID}*" ]]; then
	echo "break"
	sudo cl-builder-break --id "${BUILD_ID}" --clear ON --clear-pkg ON -f || true

	echo "prepare"
	sudo cl-builder-prepare  --id "${BUILD_ID}" --iso "${ISO_NAME}" -f

	echo "update 1"
	sudo cl-builder-update --id "${BUILD_ID}" --scan ON -s -e -f

	echo "profile"
	sudo cl-builder-profile --id "${BUILD_ID}" -f --url "${GIT_URL}" "${PROFILE_NAME}"
fi

echo "update 2"
sudo cl-builder-update --id "${BUILD_ID}" --scan ON -e -f

echo "image"
sudo cl-builder-image --id "${BUILD_ID}" -f -V OFF --keep-tree OFF -c zstd --image "/var/calculate/linux/${BUILD_ID}-${LAST_DATE:: -1}-x86_64.iso"

exit 0
