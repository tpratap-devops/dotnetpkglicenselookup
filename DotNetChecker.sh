#!/bin/bash
#Source the properties
PROPERTY_FILE=./appl.properties
function getProperty {
   PROP_KEY=$1
   PROP_VALUE=`cat $PROPERTY_FILE | grep "$PROP_KEY" | cut -d'=' -f2`
   echo $PROP_VALUE
}
declare -a unauthorizedLicensed
declare -a apacheLincensed
declare -a ccdlLincensed
declare -a id
declare -a versionD
declare -a targetFramework

unauthorizedCount=0;
apacheCount=0;
ccdlCount=0;

STAGED_GO_FILES=$(git diff --cached --name-only | grep ".config$")
if [[ "$STAGED_GO_FILES" = "" ]]; then
    echo "no go files were stashed"
    exit 0
fi
file="packages.config"
sed -n '3,$ p' $file | while read line
do
AA=$line
AA1=$(echo "$AA" | sed -r 's/^([^"]*"){1}([^"]*).*/\2/')
AA2=$(echo "$AA" | sed -r 's/^([^"]*"){3}([^"]*).*/\2/')
AA3=$(echo "$AA" | sed -r 's/^([^"]*"){5}([^"]*).*/\2/')
echo $AA1 $AA2 $AA3
#grepForLicence1=$(jar tf "C:/GitChecker/bin/${AA1,,}.${AA2,,}.nupkg" | grep "LICENSE.*")
echo "scanning---" ${AA1,,}.${AA2,,}.nupkg
curl -sS --http1.1 https://globalcdn.nuget.org/packages/${AA1,,}.${AA2,,}.nupkg --output D:/GitChecker/bin/${AA1,,}.${AA2,,}.nupkg
grepForLicence2=$(unzip -t "D:/GitChecker/bin/${AA1,,}.${AA2,,}.nupkg" |grep LICENSE.*)
echo $grepForLicence2
if [[ "$grepForLicence2" = "" ]]; then
		echo "Not Found --> " $grepForLicence2
		#textFile=$(unzip -q -c "D:/GitChecker/bin/${AA1,,}.${AA2,,}.nupkg" WebGrease.nuspec)
		textFile=$(unzip -q -c "D:/GitChecker/bin/${AA1,,}.${AA2,,}.nupkg" WebGrease.nuspec | grep -i 'licenseurl' | cut -d '^' -f 2)
		echo $textFile
		myVar=$(grep -Po "(?<=^licenseUrl ).*" unzip -q -c "D:/GitChecker/bin/${AA1,,}.${AA2,,}.nupkg")
		echo "123" $myVar
		
else
	echo "Found --> " $grepForLicence2
fi

done

exit 1


