FROM ubuntu:noble

# the ubuntu image now creates a user "ubuntu" by default with UID 1000
# the USERNAME will only be used if the given UID is not already taken
ARG USERNAME=latex
ARG UID=1000
ARG GID=$UID
RUN id -g $GID &>/dev/null || groupadd --gid $GID $USERNAME \
&&  id -u $UID &>/dev/null || useradd --uid $UID --gid $GID -m $USERNAME

ARG TZ
ENV TZ="$TZ"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update \
&&  apt-get install -y build-essential wget curl libfontconfig1 tzdata \
&&  rm -rf /var/lib/apt/lists/*

ARG TEXLIVE_MIRROR=https://mirror.ctan.org/systems/texlive/tlnet
ENV MANPATH "${MANPATH}:/usr/local/texlive/2024/texmf-dist/doc/man"
ENV INFOPATH "${INFOPATH}:/usr/local/texlive/2024/texmf-dist/doc/info"
ENV PATH "${PATH}:/usr/local/texlive/2024/bin/x86_64-linux"

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

USER $UID:$GID
