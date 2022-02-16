# what's devbox

devbox helps you to initialize c++ development enviroment quickly

## 1 

modify env.sh to your github name and email

```
USER_NAME="your github name"
USER_EMAIL="your github emal"
```

## 2

use `set_env_ubuntu.sh` to complete following steps

* install git vim
* install build-esssential
* git config
* generate gpg key

`Note` You must run `git config --global user.signingkey $YOUR_GPG_KEY` manually

## 3

use docker image to compile your c++ project

