#!/bin/bash

m_error() {
  echo $1
  exit 2
}

if [ ! -d src ]; then
  mkdir src
fi

cd src
SRC=`pwd`

if [ ! -f blubber ]; then
  wget https://releases.wikimedia.org/blubber/0.8.0/linux-amd64 -O blubber
fi
export PATH=${PATH}:${SRC}/blubber

m_process() {
  REPO=$1
  regex='([^/]+)\.git$'
  [[ ${REPO} =~ ${regex} ]]
  DIR=${BASH_REMATCH[1]}

  echo Processing ${DIR}

  if [ ! -d ${DIR} ] ; then
    if ! git clone ${REPO} ; then
      m_error "Failed to clone ${REPO}"
    fi
    cd ${DIR}
  else
    cd ${DIR}
    if ! git pull; then
      m_error "Failed to pull ${REPO}"
    fi
  fi

  if ! ./blubber-build.sh; then
    m_error "Failed to build ${DIR}"
  fi
  cd ..
}

m_process "https://gerrit.wikimedia.org/r/mediawiki/services/wikispeech/mary-tts.git"
m_process "https://gerrit.wikimedia.org/r/mediawiki/services/wikispeech/mishkal.git"
m_process "https://gerrit.wikimedia.org/r/mediawiki/services/wikispeech/pronlex.git"
m_process "https://gerrit.wikimedia.org/r/mediawiki/services/wikispeech/symbolset.git"
m_process "https://gerrit.wikimedia.org/r/mediawiki/services/wikispeech/wikispeech-server.git"
