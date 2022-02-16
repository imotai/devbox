if [ -d /depends/thirdparty/bin ]; then
    export PATH=/depends/thirdparty/bin:$PATH
fi

if [ -d /depends/thirdparty/jdk ] ; then
    export JAVA_HOME=/depends/thirdparty/jdk
    export PATH=$JAVA_HOME/bin:$PATH
fi

if [ -d /opt/maven/bin ]; then
    export PATH=/opt/maven/bin:$PATH
fi
