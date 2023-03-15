#!/bin/bash

BUILD_DIR=$(pwd)
weights=(ExtraLight Light Regular Medium SemiBold Bold Heavy)
script_tags=(JP KR CN TW HK)
script_ids=(1 3 25 2 2)
locales=(J K SC TC HC)

# Build the region-specific subset OTFs

function build_region_otfs() {
	for weight in ${weights[@]}; do
		for index in ${!script_tags[@]}; do
			tag=${script_tags[index]}
			sid=${script_ids[index]}
			makeotf -f ../Masters/${weight}/cidfont.ps.${tag} -omitMacNames -ff ../Masters/${weight}/features.${tag} -fi ../Masters/${weight}/cidfontinfo.${tag} -mf ../FontMenuNameDB.SUBSET -r -nS -cs ${sid} -ch ../UniSourceHanSerif${tag}-UTF32-H -ci ../SourceHanSerif_${tag}_sequences.txt
			tx -cff +S ../Masters/${weight}/cidfont.ps.${tag} ../Masters/${weight}/CFF.${tag}
			sfntedit -a CFF=../Masters/${weight}/CFF.${tag} ../Masters/${weight}/SourceHanSerif${tag}-${weight}.otf
		done
	done
}

# Build the language-specific OTFs

function build_lang_otfs() {
	for weight in ${weights[@]}; do
		for index in ${!script_tags[@]}; do
			tag=${script_tags[index]}
			sid=${script_ids[index]}
			loc=${locales[index]}
			makeotf -f ../Masters/${weight}/OTC/cidfont.ps.OTC.${loc} -omitMacNames -ff ../Masters/${weight}/OTC/features.OTC.${loc} -fi ../Masters/${weight}/OTC/cidfontinfo.OTC.${loc} -mf ../FontMenuNameDB -r -nS -cs ${sid} -ch ../UniSourceHanSerif${tag}-UTF32-H -ci ../SourceHanSerif_${tag}_sequences.txt
			tx -cff +S ../Masters/${weight}/OTC/cidfont.ps.OTC.${loc} ../Masters/${weight}/OTC/CFF.OTC.${loc}
			sfntedit -a CFF=../Masters/${weight}/OTC/CFF.OTC.${loc} ../Masters/${weight}/OTC/SourceHanSerif${loc}-${weight}.otf
		done
	done
}

# Building the OTCs and Super OTC

function build_otcs() {
	for weight in ${weights[@]}; do
		cd ../Masters/${weight}/OTC
		otf2otc -t 'CFF '=0 -o SourceHanSerif-${weight}.ttc SourceHanSerifJ-${weight}.otf SourceHanSerifK-${weight}.otf SourceHanSerifSC-${weight}.otf SourceHanSerifTC-${weight}.otf SourceHanSerifHC-${weight}.otf
		sfntedit -x CFF=CFF.J SourceHanSerifJ-${weight}.otf
		cp SourceHanSerifJ-${weight}.otf SourceHanSerifJ-${weight}.otf.tmp
		cp SourceHanSerifK-${weight}.otf SourceHanSerifK-${weight}.otf.tmp
		cp SourceHanSerifSC-${weight}.otf SourceHanSerifSC-${weight}.otf.tmp
		cp SourceHanSerifTC-${weight}.otf SourceHanSerifTC-${weight}.otf.tmp
		cp SourceHanSerifHC-${weight}.otf SourceHanSerifHC-${weight}.otf.tmp
		sfntedit -a CFF=CFF.J SourceHanSerifK-${weight}.otf.tmp
		sfntedit -a CFF=CFF.J SourceHanSerifSC-${weight}.otf.tmp
		sfntedit -a CFF=CFF.J SourceHanSerifTC-${weight}.otf.tmp
		sfntedit -a CFF=CFF.J SourceHanSerifHC-${weight}.otf.tmp
		sfntedit -d DSIG SourceHanSerifJ-${weight}.otf.tmp
		sfntedit -d DSIG SourceHanSerifK-${weight}.otf.tmp
		sfntedit -d DSIG SourceHanSerifSC-${weight}.otf.tmp
		sfntedit -d DSIG SourceHanSerifTC-${weight}.otf.tmp
		sfntedit -d DSIG SourceHanSerifHC-${weight}.otf.tmp
		cd ${BUILD_DIR}
	done
	cd ../Masters
	otf2otc -o  SourceHanSerif.ttc ExtraLight/OTC/SourceHanSerifJ-ExtraLight.otf.tmp ExtraLight/OTC/SourceHanSerifK-ExtraLight.otf.tmp ExtraLight/OTC/SourceHanSerifSC-ExtraLight.otf.tmp ExtraLight/OTC/SourceHanSerifTC-ExtraLight.otf.tmp ExtraLight/OTC/SourceHanSerifHC-ExtraLight.otf.tmp Light/OTC/SourceHanSerifJ-Light.otf.tmp Light/OTC/SourceHanSerifK-Light.otf.tmp Light/OTC/SourceHanSerifSC-Light.otf.tmp Light/OTC/SourceHanSerifTC-Light.otf.tmp Light/OTC/SourceHanSerifHC-Light.otf.tmp Regular/OTC/SourceHanSerifJ-Regular.otf.tmp Regular/OTC/SourceHanSerifK-Regular.otf.tmp Regular/OTC/SourceHanSerifSC-Regular.otf.tmp Regular/OTC/SourceHanSerifTC-Regular.otf.tmp Regular/OTC/SourceHanSerifHC-Regular.otf.tmp Medium/OTC/SourceHanSerifJ-Medium.otf.tmp Medium/OTC/SourceHanSerifK-Medium.otf.tmp Medium/OTC/SourceHanSerifSC-Medium.otf.tmp Medium/OTC/SourceHanSerifTC-Medium.otf.tmp Medium/OTC/SourceHanSerifHC-Medium.otf.tmp SemiBold/OTC/SourceHanSerifJ-SemiBold.otf.tmp SemiBold/OTC/SourceHanSerifK-SemiBold.otf.tmp SemiBold/OTC/SourceHanSerifSC-SemiBold.otf.tmp SemiBold/OTC/SourceHanSerifTC-SemiBold.otf.tmp SemiBold/OTC/SourceHanSerifHC-SemiBold.otf.tmp Bold/OTC/SourceHanSerifJ-Bold.otf.tmp Bold/OTC/SourceHanSerifK-Bold.otf.tmp Bold/OTC/SourceHanSerifSC-Bold.otf.tmp Bold/OTC/SourceHanSerifTC-Bold.otf.tmp Bold/OTC/SourceHanSerifHC-Bold.otf.tmp Heavy/OTC/SourceHanSerifJ-Heavy.otf.tmp Heavy/OTC/SourceHanSerifK-Heavy.otf.tmp Heavy/OTC/SourceHanSerifSC-Heavy.otf.tmp Heavy/OTC/SourceHanSerifTC-Heavy.otf.tmp Heavy/OTC/SourceHanSerifHC-Heavy.otf.tmp
}


build_region_otfs
build_lang_otfs
build_otcs
