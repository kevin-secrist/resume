#!/bin/bash
latexmk -synctex=1 -interaction=nonstopmode -file-line-error -lualatex -outdir=/data/out /data/src/secrist-resume
latexmk -synctex=1 -interaction=nonstopmode -file-line-error -lualatex -outdir=/data/out /data/src/secrist-cv
