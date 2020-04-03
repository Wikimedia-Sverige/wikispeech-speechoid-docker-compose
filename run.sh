#!/bin/bash

mkdir volumnes >> /dev/null
mkdir volumnes/wikispeech_mockup_tmp >> /dev/null
chmod a+rwx volumes/wikispeech_mockup_tmp

docker-compose up
