#!/bin/sh

DITA_DIR="DITA-OT"

if [ -f "$DITA_DIR"/tools/ant/bin/ant ] && [ ! -x "$DITA_DIR"/tools/ant/bin/ant ]; then
chmod +x "$DITA_DIR"/tools/ant/bin/ant
fi

export ANT_OPTS="-Xmx512m $ANT_OPTS"
export ANT_OPTS="$ANT_OPTS -Djavax.xml.transform.TransformerFactory=net.sf.saxon.TransformerFactoryImpl"
export ANT_HOME="$DITA_DIR"/tools/ant
export PATH="$DITA_DIR"/tools/ant/bin:"$PATH"

NEW_CLASSPATH="$DITA_DIR/lib:$DITA_DIR/lib/dost.jar:$DITA_DIR/lib/resolver.jar:$DITA_DIR/lib/icu4j.jar"
NEW_CLASSPATH="$DITA_DIR/lib/saxon/saxon9.jar:$DITA_DIR/lib/saxon/saxon9-dom.jar:$NEW_CLASSPATH"
NEW_CLASSPATH="$DITA_DIR/lib/saxon/saxon9-dom4j.jar:$DITA_DIR/lib/saxon/saxon9-jdom.jar:$NEW_CLASSPATH"
NEW_CLASSPATH="$DITA_DIR/lib/saxon/saxon9-s9api.jar:$DITA_DIR/lib/saxon/saxon9-sql.jar:$NEW_CLASSPATH"
NEW_CLASSPATH="$DITA_DIR/lib/saxon/saxon9-xom.jar:$DITA_DIR/lib/saxon/saxon9-xpath.jar:$DITA_DIR/lib/saxon/saxon9-xqj.jar:$NEW_CLASSPATH"
if test -n "$CLASSPATH"
then
export CLASSPATH="$NEW_CLASSPATH":"$CLASSPATH"
else
export CLASSPATH="$NEW_CLASSPATH"
fi

if ["$1" != ""]
then
java -jar GetImageList.jar "$1"
fi

if ["$1" != ""]
then
if ["$2" != ""]
then
ant -buildfile build.xml -Dmap.file="$1" -Dctype="$2"
else 
ant -buildfile build.xml -Dmap.file="$1" -Dctype=7
fi
else
echo "Enter two args (map path and convert type number)"
fi
