#!/bin/bash
  
##
# Set variables
##
CALC_URL='https://mirror.yandex.ru/calculate/release/'
GIT_URL='https://github.com/RodionD/RodionCL'
IF_BREAK=0

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

##
# Set variables
##
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

##
# Show main_menu
##
main_menu(){
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
	    3) set_cldlwc ;;
		0) exit 0 ;;
		*) echo -e $red"Wrong option."$clear ; main_menu ;;
	esac
}

##
# Show break_menu
##
break_menu(){
	echo "break_menu"
	echo -ne "
	$(ColorGreen 'u)') Update current build
	$(ColorRed   'b)') Break current build and recreate build
	$(ColorBlue 'Choose an option:') "

	read a
	case $a in
	    u) IF_BREAK=0 ;;
	    b) IF_BREAK=1 ;;
		*) echo -e $red"Wrong option."$clear ; break_menu ;;
	esac
}

##
# Call main_menu
##
main_menu 

## Find last available nightly data
echo "w3m -dump $CALC_URL | grep -v 'Index' | grep '/' | tail -1 | cut -d ' ' -f 1"
LAST_DATE=$(w3m -dump ${CALC_URL} | grep -v 'Index' | grep '/' | tail -1 | cut -d ' ' -f 1)
echo $(ColorGreen "LAST DATE: ${LAST_DATE}")

## Last nigtly URL
LAST_NIGHTLY=$CALC_URL$LAST_DATE
echo $(ColorGreen "LAST NIGHTLY: ${LAST_NIGHTLY}")

## Last nightly ISO URL
echo "w3m -dump $LAST_NIGHTLY | grep ${CALC_DIST}- | grep '.iso' | cut -d ' ' -f 1"
ISO_NAME=$(w3m -dump $LAST_NIGHTLY | grep ${CALC_DIST}- | grep ".iso" | cut -d ' ' -f 1)
echo $(ColorGreen "ISO NAME: ${ISO_NAME}")

## Download last nightly ISO if not exist
download_iso() {
	if [[ ! -f ./$ISO_NAME ]];
	then           -
		echo $(ColorGreen 'Download fresh ISO')
		echo "curl ${LAST_NIGHTLY}${ISO_NAME} -o ${ISO_NAME}"
		curl ${LAST_NIGHTLY}${ISO_NAME} -o $ISO_NAME
		echo $(ColorGreen 'ISO is downloaded')
	else
		echo $(ColorGreen 'ISO is downloaded')
	fi
}

## Prepare new build steps
prepare_steps() {
	## Prepare new build
	echo $(ColorGreen 'Prepare new build')
	echo "cl-builder-prepare  --id ${BUILD_ID} --iso ${ISO_NAME} -f"
	sudo cl-builder-prepare  --id "${BUILD_ID}" --iso "${ISO_NAME}" -f

	## First build update without update package, only portage tree and overlays
	echo $(ColorGreen 'First build update without update package, only portage tree and overlays')
	echo "cl-builder-update --id ${BUILD_ID} --scan ON -s -e -f"
	sudo cl-builder-update --id "${BUILD_ID}" --scan ON -s -e -f

	## Change profile to nessesary
	echo $(ColorGreen 'Change profile to nessesary')
	echo "cl-builder-profile --id ${BUILD_ID} -u -f --url ${GIT_URL} ${PROFILE_NAME}"
	sudo cl-builder-profile --id "${BUILD_ID}" -u -f --url "${GIT_URL}" "${PROFILE_NAME}"
}

## Update current build and build iso steps
update_steps() {
	## Second build update with new profile
	echo $(ColorGreen 'Second build update with new profile')
	echo "cl-builder-update --id ${BUILD_ID} --scan ON --check-repos ON --force-egencache -e -f"
	sudo cl-builder-update --id "${BUILD_ID}" --scan ON -e -f

	## Build image
	echo $(ColorGreen 'Build image')
	echo "cl-builder-image --id ${BUILD_ID} -f -V OFF --keep-tree OFF -c zstd --image /var/calculate/linux/${BUILD_ID}-${LAST_DATE:: -1}-x86_64.iso"
	##sudo cl-builder-image --id "${BUILD_ID}" -f -V OFF --keep-tree OFF -c zstd --image "/var/calculate/linux/${BUILD_ID}-${LAST_DATE:: -1}-x86_64.iso"
}

break_step() {
	## Break current build
	echo $(ColorGreen 'Break current build')
	echo "cl-builder-break --id ${BUILD_ID} --clear ON --clear-pkg ON -f || true"
	sudo cl-builder-break --id "${BUILD_ID}" --clear ON --clear-pkg ON -f || true
}
              
## Read active cl build id
echo "cl-builder-update --id list | tail -n +2 | grep ${BUILD_ID} | xargs echo -n"
IFS=' '
read -ra strarr <<< $(sudo cl-builder-update --id list | tail -n +2 | grep $BUILD_ID | xargs echo -n)

if [ ! -z "$strarr" ]; then
	echo "Build with this ID exist"

	if [ ${strarr[-1]::1} == '(' ]; then
		echo $(ColorRed 'Current build is illegal')
		## Break current build
		break_step

		## Download last nightly ISO if not exist
		download_iso

		## Prepare new build steps
		prepare_steps
	else
		## Get if break
		break_menu
		if [ $IF_BREAK == '1' ]; then
			## Break current build
			break_step

			## Download last nightly ISO if not exist
			download_iso

			## Prepare new build steps
			prepare_steps
		fi
	fi
	
	## Update current build and build iso steps
	update_steps
else
	echo "Build with this ID not exist"
	## Download last nightly ISO if not exist
	download_iso

	## Prepare new build steps
	prepare_steps

	## Update current build and build iso steps
	update_steps
fi

exit 0
