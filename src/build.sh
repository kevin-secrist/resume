#!/bin/bash
latexmk -synctex=1 -interaction=nonstopmode -file-line-error -lualatex -outdir=out secrist-resume
latexmk -synctex=1 -interaction=nonstopmode -file-line-error -lualatex -outdir=out secrist-cv
