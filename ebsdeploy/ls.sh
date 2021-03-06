###############################
## config
## serveur BG-BI
APPSUSER=apps
APPSPWD=apps
DB_HOST=127.0.0.1
DB_PORT=1521
DB_CONNECT_DATA="SID=EBSDB"
JDBC_CONNECTION="(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=$DB_HOST)(PORT=$DB_PORT))(CONNECT_DATA=($DB_CONNECT_DATA)))"
###############################

#source env file
. /u01/install/APPS/EBSapps.env run
cd
mkdir ebsdeploy
cd ebsdeploy
rm *

#Concurrent Program
FNDLOAD_DWN_CONCPROG()
{
APPLICATION_SHORT_NAME=$1
CONCURRENT_PROGRAM_NAME=$2

 FNDLOAD $APPSUSER/$APPSPWD O Y DOWNLOAD $FND_TOP/patch/115/import/afcpprog.lct $CONCURRENT_PROGRAM_NAME".ldt" PROGRAM APPLICATION_SHORT_NAME="$APPLICATION_SHORT_NAME" CONCURRENT_PROGRAM_NAME="$CONCURRENT_PROGRAM_NAME"
 rm *.log
}

#rtf template
XMLPUB_DWN_TEMPLATE()
{
TEMPLATE_CODE=$1
DATA_TEMPLATE_CODE=$2
APPS_SHORT_NAME=$3
LANGUAGE=$4
TERRITORY=$5

 #java oracle.apps.xdo.oa.util.XDOLoader DOWNLOAD -DB_USERNAME $APPSUSER -DB_PASSWORD $APPSPWD -JDBC_CONNECTION "(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=$DB_HOST)(PORT=$DB_PORT))(CONNECT_DATA=($DB_CONNECT_DATA)))" -LOB_TYPE TEMPLATE -LOB_CODE APXSOBLX_1 -APPS_SHORT_NAME SQLAP -LANGUAGE en -TERRITORY US -lct_FILE $XDO_TOP/patch/115/import/xdotmpl.lct -LOG_FILE $LOG_FILE_NAME
 java oracle.apps.xdo.oa.util.XDOLoader DOWNLOAD \
    -DB_USERNAME $APPSUSER \
    -DB_PASSWORD $APPSPWD \
	-JDBC_CONNECTION $JDBC_CONNECTION \
	-LOB_TYPE TEMPLATE \
	-LOB_CODE $TEMPLATE_CODE \
	-APPS_SHORT_NAME $APPS_SHORT_NAME \
	-LANGUAGE $LANGUAGE \
	-TERRITORY $TERRITORY \
	-lct_FILE $XDO_TOP/patch/115/import/xdotmpl.lct \
	-LOG_FILE $LOG_FILE_NAME
	
 java oracle.apps.xdo.oa.util.XDOLoader DOWNLOAD \
    -DB_USERNAME $APPSUSER \
    -DB_PASSWORD $APPSPWD \
	-JDBC_CONNECTION $JDBC_CONNECTION \
	-LOB_TYPE DATA_TEMPLATE \
	-LOB_CODE $DATA_TEMPLATE_CODE \
	-APPS_SHORT_NAME $APPS_SHORT_NAME \
	-LANGUAGE $LANGUAGE \
	-lct_FILE $XDO_TOP/patch/115/import/xdotmpl.lct \
	-LOG_FILE $LOG_FILE_NAME
	
	# Data Definition and Associated Template
	FNDLOAD $APPSUSER/$APPSPWD O Y DOWNLOAD  \
	  $XDO_TOP/patch/115/import/xdotmpl.lct \
	  $DATA_TEMPLATE_CODE"_DD.ldt" \
	  XDO_DS_DEFINITIONS \
	  APPLICATION_SHORT_NAME=$APPS_SHORT_NAME \
	  DATA_SOURCE_CODE=$DATA_TEMPLATE_CODE \
	  TMPL_APP_SHORT_NAME=$APPS_SHORT_NAME \
	  TEMPLATE_CODE=$TEMPLATE_CODE
}



#FNDLOAD_DWN_CONCPROG FND FNDSCARU
#FNDLOAD_DWN_CONCPROG SQLAP APXTRF96
#XMLPUB_DWN_TEMPLATE APXSOBLX_1 APXSOBLX SQLAP en US
cd sql
sqlplus -S apps/apps @table1.sql
rm *.log
cd ..
zip -r ebsdeploy.zip ebsdeploy