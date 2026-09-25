FROM ubuntu:noble

RUN apt-get update \
&&  apt-get install -y build-essential wget curl libfontconfig1 tzdata jq git \
&&  rm -rf /var/lib/apt/lists/*

ARG TEXLIVE_MIRROR=https://mirror.ctan.org/systems/texlive/tlnet
# Install to a year-independent path so new TeX Live releases don't break PATH
ARG TEXLIVE_DIR=/usr/local/texlive
ENV MANPATH="${TEXLIVE_DIR}/texmf-dist/doc/man" \
    INFOPATH="${TEXLIVE_DIR}/texmf-dist/doc/info" \
    PATH="${PATH}:${TEXLIVE_DIR}/bin/current"

RUN mkdir /install-tl-unx \
&&  curl -sSL \
      ${TEXLIVE_MIRROR}/install-tl-unx.tar.gz \
    | tar -xzC /install-tl-unx --strip-components=1 \
    \
&&  echo "TEXDIR ${TEXLIVE_DIR}" >> /install-tl-unx/texlive.profile \
&&  echo "TEXMFLOCAL ${TEXLIVE_DIR}/texmf-local" >> /install-tl-unx/texlive.profile \
&&  echo "TEXMFSYSVAR ${TEXLIVE_DIR}/texmf-var" >> /install-tl-unx/texlive.profile \
&&  echo "TEXMFSYSCONFIG ${TEXLIVE_DIR}/texmf-config" >> /install-tl-unx/texlive.profile \
&&  echo "tlpdbopt_autobackup 0" >> /install-tl-unx/texlive.profile \
&&  echo "tlpdbopt_install_docfiles 0" >> /install-tl-unx/texlive.profile \
&&  echo "tlpdbopt_install_srcfiles 0" >> /install-tl-unx/texlive.profile \
&&  echo "selected_scheme scheme-basic" >> /install-tl-unx/texlive.profile \
    \
&&  /install-tl-unx/install-tl \
      -profile /install-tl-unx/texlive.profile \
      -repository ${TEXLIVE_MIRROR} \
&&  ln -s ${TEXLIVE_DIR}/bin/* ${TEXLIVE_DIR}/bin/current \
&&  rm -rf /install-tl-unx
RUN tlmgr install --repository ${TEXLIVE_MIRROR} \
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
      tikzfill

LABEL org.opencontainers.image.source=https://github.com/kevin-secrist/resume
LABEL org.opencontainers.image.description="Basic LaTeX image for building a resume"
