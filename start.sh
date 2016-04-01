#!/bin/sh

root=~/git/proxyapp
sails=`which sails`

forever start --workingDir ${root} -a -l proxyapp.log ${sails} lift --dev