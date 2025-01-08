# Professional Resume

![Built with LaTeX](https://img.shields.io/static/v1?label=Built%20With&message=LaTeX&color=008080&style=for-the-badge&logo=latex)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/kevin-secrist/resume?style=for-the-badge)
![GitHub Release Date](https://img.shields.io/github/release-date/kevin-secrist/resume?style=for-the-badge)

This project started as a proof of concept to compare templates for Microsoft Word and LaTeX templates. In the past when I have used LaTeX I was always very satisfied with the result, and I think the additional benefits of source control and CI/CD made this option very compelling.

# GitHub Codespace Support

This repo takes advantage of [dev containers](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/introduction-to-dev-containers), which natively works with [GitHub Codespaces](https://docs.github.com/en/codespaces/overview) allowing me to develop the project within a browser quite easily for quick changes.

# Local Development Setup

Building a LaTeX project locally normally requires a LaTeX environment which can be relatively painful to setup and there are numerous ways to do it incorrectly. I've found it much easier to run LaTeX within a container and follow the installation steps of other projects and developers who use LaTeX much more seriously.

Instead, for this project you only need to install a few things:

* Docker
* VS Code
* Visual Studio Code Remote - Containers Extension (optional)

That's basically it. There's more detailed documentation about using [remote containers within VS Code](https://code.visualstudio.com/docs/remote/containers) that may be helpful for setup. Once everything is installed, VS Code will pull a [Docker image](https://github.com/kevin-secrist/resume/pkgs/container/latex) (based on the [`Dockerfile`](Dockerfile)) and run a container locally based on the arguments in [`devcontainer.json`](.devcontainer/devcontainer.json). This includes the automatic installation of a VS Code server and LaTeX Workshop extension inside the container for syntax highighting, intellisense, automatic builds, and PDF previews.

The `Dockerfile` is set up to mount a volume at `/data`, and the `devcontainer.json` specifies arguments to mount the workspace within the container. Build artifacts are dropped into `/data/out`.

If you prefer to develop without VS Code, or without the containers extension, you can run `docker` commands directly to build the result. The results/artifacts will be in the `out` directory.

```bash
docker build -t latex-build .
docker run -v $PWD:/data -w /data/src latex-build ./build.sh
```

# CI/CD

This repo is set up to automatically build PRs, and release the newly built artifacts on merge to `main`. See [.github](.github) for the workflow definitions. New docker images are only built/pushed in PRs if the `Dockerfile` differs from what's in the `main` branch, allowing for a quick dev cycle when not developing locally (like when making changes directly in GitHub - this repo is for a document after all).

# Screenshot

This is what it looks like to develop locally, using the Dev Container in VS Code. On save, the file is rebuilt and automatically refreshed (thanks to the `james-yu.latex-workshop` extension).

![screenshot](./docs/screenshot.png)

# Inspirations

Some of the ideas for how to create my Dockerfile came from the [Overleaf](https://github.com/overleaf/overleaf) project as well as [blang/latex-docker](https://github.com/blang/latex-docker). I also recommend [Overleaf](https://www.overleaf.com/) for getting started writing LaTeX documents without requiring a complicated local setup - and they also allow you to self-host with Docker which can be very convenient.

The resume template itself comes from [darwiin/yaac-another-awesome-cv](https://github.com/darwiin/yaac-another-awesome-cv) which provides a LaTeX class and was an amazing starting point for my resume.