# Technical Reference for AI Agents

This document provides quick orientation for AI agents working on this LaTeX resume project. For detailed technical information, see the linked guides in the `docs/` folder.

**IMPORTANT**: When making changes to the build system, CI/CD pipeline, template customization, or project structure, update this document and the relevant guides in `docs/` to reflect those changes.

## Developer Profile

This project is personalized for an individual, and whenever making changes to **content** make sure to reference [PROFILE.md](PROFILE.md). If that file does not exist (it is .gitignored and does not come with a fresh clone) then interview the user to develop that file before making significant content changes.

Things that should generally be included in PROFILE.md:

* Candidate Profile: biographical info/context, some examples:
  * Current title/Role
  * Years of experience
  * Current/most proficient tech stack
  * Team composition
* Strategic Goals: what the individual is trying to achieve with their resume/career.
* Strengths: themes that should be woven into the document that reflect the individual's strengths.

## Quick Project Overview

LaTeX-based resume/CV system with:
- Docker-based build (no local LaTeX installation required)
- Modular section files for easy maintenance
- Conditional compilation (resume vs CV variants from single source)
- Automated CI/CD with GitHub Actions
- Semantic versioning embedded in PDFs

## Directory Structure

```
/
├── .github/workflows/       # CI/CD automation
│   ├── main.yml            # Build, test, release pipeline
│   └── scheduled-build.yml # Weekly Docker image refresh
├── .devcontainer/          # VS Code dev container config
├── .vscode/                # VS Code LaTeX Workshop settings
├── docs/                   # Documentation guides
│   ├── resume-writing-guide.md  # MEDIC, ATS, bullet writing
│   ├── template-guide.md        # LaTeX commands and customization
│   ├── build-guide.md           # Build system and CI/CD details
│   └── screenshot.png           # Dev environment example
├── src/                    # LaTeX source files
│   ├── *.tex              # Document entry points (resume, CV)
│   ├── yaac-another-awesome-cv.cls  # Template class definition
│   ├── sections/          # Modular content sections
│   ├── fonts/             # Local font files (Source Sans Pro)
│   ├── assets/            # Images, photos
│   ├── build.sh           # Build script wrapper
│   ├── latexmkrc          # latexmk configuration
│   └── out/               # Build artifacts (git ignored)
├── Dockerfile             # LaTeX build environment
└── README.md              # Human-focused documentation
```

## Quick Start

**Local development setup:** See [README.md](README.md#local-development-setup) for Docker and VS Code configuration.

**Quick build via Docker CLI:**
```bash
docker build -t latex-build .
docker run -v $PWD:/data -w /data/src latex-build ./build.sh
```

Artifacts appear in `src/out/*.pdf`.

## Core Concepts

### Modular Section System

Content is split into separate `.tex` files in `src/sections/`:
- **Why**: Version control individual sections, easier collaboration
- **How**: Main document uses `\input{sections/filename}` to include sections
- **When to edit**: Content changes happen in section files, not main document

### Conditional Compilation

Three document variants from one codebase:

```latex
\resumetrue   % In secrist-resume.tex - brief format
\cvtrue       % In secrist-cv.tex - detailed format
\covertrue    % In secrist-cover.tex - cover letter
```

Use in section files:
```latex
\ifresume
    Brief content for resume
\fi

\ifcv
    Detailed content for CV
\fi
```

Maintains single source of truth, prevents content drift.

### Template Customization

Template: [yaac-another-awesome-cv](https://github.com/darwiin/yaac-another-awesome-cv)

For complete command reference, see [docs/template-guide.md](docs/template-guide.md).

### Build System

**Stack:** latexmk + LuaLaTeX
**Why Docker:** Consistent environment, no local TeX Live installation (~5GB)
**Build artifacts:** `src/out/` directory (git-ignored)

For compilation details, magic comments, and troubleshooting, see [docs/build-guide.md](docs/build-guide.md).

## Common Workflows

### Adding a New Section

1. Create `src/sections/newsection.tex`:
   ```latex
   \sectionTitle{New Section}{\faIcon}
   Content here...
   ```

2. Add to main document (`src/*.tex`):
   ```latex
   \input{sections/newsection}
   ```

3. Test with dev container or Docker build

### Modifying Content

1. Edit files in `src/sections/`
2. Use conditional compilation for resume vs CV variants
3. Follow MEDIC framework for metrics (see [docs/resume-writing-guide.md](docs/resume-writing-guide.md))
4. Build and verify PDF output

### Testing Changes

**VS Code Dev Container** (recommended):
- Open in VS Code → "Reopen in Container"
- Edit → Auto-build on save → PDF preview
- LaTeX Workshop extension provides IntelliSense

**Docker CLI**:
```bash
docker run -v $PWD:/data -w /data/src latex-build ./build.sh
```

## CI/CD Pipeline

**Workflow:** `.github/workflows/main.yml`

Three jobs:
1. **build-docker** - Builds image if Dockerfile changed, otherwise uses cache
2. **build-documents** - Compiles PDFs with semantic version from git commits
3. **release** - Creates GitHub release with PDF attachments (main branch only)

**Weekly maintenance:** `scheduled-build.yml` rebuilds Docker image to keep dependencies current.

For detailed pipeline documentation, see [docs/build-guide.md](docs/build-guide.md#cicd-pipeline).

## Documentation Guides

- **[Resume Writing Guide](docs/resume-writing-guide.md)** - MEDIC framework, ATS optimization, bullet writing formulas, section ordering
- **[Template Guide](docs/template-guide.md)** - LaTeX commands, document class options, font system, common gotchas
- **[Build Guide](docs/build-guide.md)** - Compilation stack, Docker setup, CI/CD pipeline, troubleshooting

## When to Update This Document

- Adding/removing major sections or features
- Changing directory structure
- Modifying build system or CI/CD pipeline
- Updating template commands or conventions
- Adding new documentation guides
