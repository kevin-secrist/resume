# Professional Resume

![Built with LaTeX](https://img.shields.io/static/v1?label=Built%20With&message=LaTeX&color=008080&style=for-the-badge&logo=latex)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/kevin-secrist/resume?style=for-the-badge)
![GitHub Release Date](https://img.shields.io/github/release-date/kevin-secrist/resume?style=for-the-badge)

This project started as a proof of concept to compare templates for Microsoft Word and LaTeX templates. In the past when I have used LaTeX I was always very satisfied with the result, and I think the additional benefits of source control and CI/CD made this option very compelling.

# Local Development Setup

Building a LaTeX project locally normally requires a LaTeX environment which can be relatively painful to setup and there are numerous ways to do it incorrectly. I've found it much easier to run LaTeX within a container and follow the installation steps of other projects and developers who use LaTeX much more seriously.

Instead, for this project you only need to install a few things:

* Docker for Windows or Linux
* VS Code
* Visual Studio Code Remote - Containers Extension (optional)

That's basically it. There's more detailed documentation about using [remote containers within VS Code](https://code.visualstudio.com/docs/remote/containers) that may be helpful for setup. Once everything is installed, VS Code can build a Docker image and run a container locally based on the [`Dockerfile`](Dockerfile) and [`devcontainer.json`](.devcontainer/devcontainer.json). This includes the installation of a VS Code server and LaTeX Workshop extension inside the container for syntax highighting, intellisense, automatic builds, and PDF previews.

The `Dockerfile` is set up to mount a volume at `/data`, and the `devcontainer.json` specifies arguments to mount the workspace within the container. Build artifacts are dropped into `/data/out`.

If you prefer to develop without VS Code, or without the containers extension, you can run `docker` commands directly to build the result. The results/artifacts will be in the `out` directory.

```bash
docker build -t latex-build .
docker run -v $PWD:/data -w /data/src latex-build ./build.sh
```

# Inspirations

Some of the ideas for how to create my Dockerfile came from the [Overleaf](https://github.com/overleaf/overleaf) project as well as [blang/latex-docker](https://github.com/blang/latex-docker). I also recommend [Overleaf](https://www.overleaf.com/) for getting started writing LaTeX documents without requiring a complicated local setup - and they also allow you to self-host with Docker which can be very convenient.

The resume template itself comes from [darwiin/yaac-another-awesome-cv](https://github.com/darwiin/yaac-another-awesome-cv) which provides a LaTeX class and was an amazing starting point for my resume.