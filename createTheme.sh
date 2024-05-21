#!/usr/bin/bash

# Version 1.0.0
# @dobryinik

THEME_NAME_V="3.0.1"
THEME_NAME="themename"
ADMIN_CONTRL="admin/controller/extension/theme"
ADMIN_TEMPL="admin/view/template/extension/theme"
ADMIN_LEN="admin/language/en-gb/extension/theme"
ADMIN_LRU="admin/language/ru-ru/extension/theme"

CATALOG_CONTRL="catalog/controller"
CATALOG_THEME="catalog/view/theme"
CATALOG_SCRIPTS="catalog/view/javascript"

DATE=$(date '+%Y%m%d_%H%M%S')

DIRFILES="theme"
DIRFILES_OLD="theme_OLD"

UPLOAD=$DIRFILES/"upload"

LOG="logfile.log"

SUFF_PHP=".php"
SUFF_TWIG=".twig"


if [ '-v' == "$1" ]
  then
    version=$(cat $THEME_NAME.xml | grep -oP '(?<=<version>).*(?=</version>)')
    echo $THEME_NAME'.xml?version='$version
    echo $0'?version='$THEME_NAME_V
    exit 0
fi

if [[ -z ${1+x} && '-v' != "$1"  ]]; then 
THEME_NAME_V='undefine-'$DATE; else 
THEME_NAME_V=$1; fi
echo "[+] Set version is "$THEME_NAME_V 

echo "[+] Change version to $THEME_NAME_V in install.xml "
sed  "s/\(<version>\).*\(<\/version\)/\1$THEME_NAME_V\2/" $THEME_NAME.xml > install.xml
cp $THEME_NAME.xml $THEME_NAME.xml.bak
#mv install2.xml install.xml

cd ./sitename.local
mv ../install.xml ./


if [ ! -f ./$LOG ]; then  
  touch ./$LOG
fi
echo "[+] Start. Logfile is create" >> $LOG
 
echo "[+] Set theme name is "$THEME_NAME >> $LOG
 
echo "[+] Move '$DIRFILES' in new localion" >> $LOG
if [ -d "$DIRFILES" ]; then
  if [ ! -d "$DIRFILES_OLD" ]; then
    mkdir -v $DIRFILES_OLD >> $LOG
  fi
  if [ ! -d "$DIRFILES_OLD/$DATE" ]; then
    mkdir -v "$DIRFILES_OLD/$DATE(before-$THEME_NAME_V)" >> $LOG
  fi

  mv -v $DIRFILES/* "$DIRFILES_OLD/$DATE(before-$THEME_NAME_V)" >> $LOG

  if [ ! -d "$DIRFILES" ]; then
    mkdir -v $DIRFILES >> $LOG
  fi
fi
 
echo "[+] Create upload dirs" >> $LOG
mkdir -v -p $UPLOAD/{$ADMIN_CONTRL,$ADMIN_TEMPL,$ADMIN_LEN,$ADMIN_LRU,$CATALOG_THEME/$THEME_NAME,"$CATALOG_THEME/default/template/extension/module", "$CATALOG_CONTRL/extension/module/",$CATALOG_SCRIPTS}  >> $LOG
 
echo "[+] Copy install.xml file" >> $LOG
cp -v install.xml $DIRFILES >> $LOG
cp -v $CATALOG_SCRIPTS/"common-pionshop.js" $UPLOAD/$CATALOG_SCRIPTS/ >> $LOG

echo "[+] Copy admin files" >> $LOG
cp -v $ADMIN_CONTRL/$THEME_NAME$SUFF_PHP $UPLOAD/$ADMIN_CONTRL/ >> $LOG
cp -v $ADMIN_TEMPL/$THEME_NAME$SUFF_TWIG $UPLOAD/$ADMIN_TEMPL/ >> $LOG
cp -v $ADMIN_LEN/$THEME_NAME$SUFF_PHP $UPLOAD/$ADMIN_LEN/ >> $LOG
cp -v $ADMIN_LRU/$THEME_NAME$SUFF_PHP $UPLOAD/$ADMIN_LRU/ >> $LOG

echo "[+] Copy theme files"  >> $LOG
cp -v -R $CATALOG_THEME/$THEME_NAME/* $UPLOAD/$CATALOG_THEME/$THEME_NAME >> $LOG

# if need uncomment and change this
#echo "[+] Copy others files"  >> $LOG
#cp -v -R $CATALOG_CONTRL"/extension/module/menusm.php" $UPLOAD/$CATALOG_CONTRL"/extension/module/menusm.php" >> $LOG
#cp -v "$CATALOG_THEME/$THEME_NAME/template/extension/module/blog_footer.twig" "$UPLOAD/$CATALOG_THEME/default/template/extension/module/blog_footer.twig"  >> $LOG
#cp -v "$CATALOG_THEME/$THEME_NAME/template/extension/module/menusm.twig" "$UPLOAD/$CATALOG_THEME/default/template/extension/module/menusm.twig"  >> $LOG

echo "[+] Zip files" >> $LOG
#$(pwd) >> $LOG
cd $DIRFILES 
zip -r $THEME_NAME-$THEME_NAME_V.ocmod.zip  "upload/" "install.xml"
echo "[+] Finish. Theme is complite. " >> ../$LOG

mv ../$LOG ./ 
cd ../ 
rm ./install.xml
cd ../

sed  "s/\(THEME_NAME_V=\"\).*\(\"\)/\1$THEME_NAME_V\2/" maketheme.sh > maketheme2.sh
cp maketheme.sh maketheme.sh.bak
mv maketheme2.sh maketheme.sh

echo "[+] Change right files"
chmod 755 maketheme.sh
chmod 755 install.xml

echo "[+] Finish. Exit script!!!"

exit 0
