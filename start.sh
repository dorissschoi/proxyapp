#!/bin/sh

root=~/prod/proxyapp
sails=`which sails`

forever start --workingDir ${root} -a -l proxyapp.log ${sails} lift --prod