if [ -d '/opt/rh/devtoolset-7' ] ; then
    source /opt/rh/devtoolset-7/enable
fi

if [ -d '/opt/rh/sclo-git212' ] ; then
    source /opt/rh/sclo-git212/enable
fi
if [ -d '/opt/rh/python27' ] ; then
    source /opt/rh/python27/enable
fi

if [ -d '/opt/rh/rh-python36' ]; then
    source /opt/rh/rh-python36/enable
fi

if [ -d '/opt/rh/rh-python38' ]; then
    source /opt/rh/rh-python38/enable
fi

if [ -d '/opt/rh/rh-git218' ] ; then
    source /opt/rh/rh-git218/enable
fi
