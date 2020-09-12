FROM phusion/baseimage:master-amd64
ENV baseDir .

RUN apt-get update \
&&  apt-get install -y build-essential wget \
&&  rm -rf /var/lib/apt/lists/*

ARG TEXLIVE_MIRROR=http://mirror.ctan.org/systems/texlive/tlnet
ENV PATH "${PATH}:/usr/local/texlive/2020/bin/x86_64-linux"

RUN mkdir /install-tl-unx \
&&  curl -sSL \
      ${TEXLIVE_MIRROR}/install-tl-unx.tar.gz \
    | tar -xzC /install-tl-unx --strip-components=1 \
    \
&&  echo "tlpdbopt_autobackup 0" >> /install-tl-unx/texlive.profile \
&&  echo "tlpdbopt_install_docfiles 0" >> /install-tl-unx/texlive.profile \
&&  echo "tlpdbopt_install_srcfiles 0" >> /install-tl-unx/texlive.profile \
&&  echo "selected_scheme scheme-basic" >> /install-tl-unx/texlive.profile \
    \
&&  /install-tl-unx/install-tl \
      -profile /install-tl-unx/texlive.profile \
      -repository ${TEXLIVE_MIRROR} \
    \
&&  tlmgr install --repository ${TEXLIVE_MIRROR} \
      latexmk \
      texcount \
      luatexbase \
      luainputenc \
      environ \
      trimspaces \
      fontspec \
      parskip \
      xcolor \
      preprint \
      fontawesome5 \
      titlesec \
      enumitem \
      etoolbox \
      pgf \
      tcolorbox \
&&  rm -rf /install-tl-unx

ENV HOME /data
WORKDIR /data
VOLUME ["/data"]