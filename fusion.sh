#!/bin/bash

function getcredentials {
  echo -n "[BitBucket username]: "
  read bbusername
  echo -n "[BitBucket password]: "
  read -s bbpassword
  echo
  # echo -n "[Azure username]: "
  # read azusername
  # echo -n "[Azure password]: "
  # read -s azpassword
  # echo
}

function runpostcreate {
  CWD=$(pwd)
  for f in hooks/postcreate/*
  do
    echo "Executing postcreate hook $f"
    ./$f
    cd $CWD
  done
}

cat << "EOF"
______   __  __     ______     __     ______     __   __
/\  ___\ /\ \/\ \   /\  ___\   /\ \   /\  __ \   /\ "-.\ \
\ \  __\ \ \ \_\ \  \ \___  \  \ \ \  \ \ \/\ \  \ \ \-.  \
\ \_\    \ \_____\  \/\_____\  \ \_\  \ \_____\  \ \_\\"\_\
 \/_/     \/_____/   \/_____/   \/_/   \/_____/   \/_/ \/_/

EOF

PROJECT=$2

if [ $1 = "create" ] && [ $# = 2 ]; then
  getcredentials

  bb create --username $bbusername --password $bbpassword --private --protocol https --scm git $PROJECT
  bb clone --username $bbusername --password $bbpassword --protocol https $bbusername $PROJECT
  azure account import *.publishsettings
  azure site create $PROJECT-dev

  runpostcreate
fi

if [ $1 = "remove" ] && [ $# = 2 ]; then
  getcredentials

  bb delete --username $bbusername --password $bbpassword $PROJECT
  azure site delete $PROJECT-dev
fi
