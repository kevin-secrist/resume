# Technical Reference for AI Agents

This document provides comprehensive technical context for AI agents working on this LaTeX resume project. It focuses on generic, broadly useful information about the build system, template, and CI/CD infrastructure.

**IMPORTANT**: When making changes to the build system, CI/CD pipeline, template customization, or project structure, update this document to reflect those changes. Keep it accurate and in sync with the actual codebase.

## Project Architecture

### Directory Structure

```
/
├── .github/workflows/       # CI/CD automation
│   ├── main.yml            # Build, test, release pipeline
│   └── scheduled-build.yml # Weekly Docker image refresh
├── .devcontainer/          # VS Code dev container config
├── .vscode/                # VS Code LaTeX Workshop settings
├── src/                    # LaTeX source files
│   ├── *.tex              # Document entry points (resume, CV, cover letter)
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

### Modular Section System

Content is split into separate `.tex` files in `src/sections/`:
- **Why**: Enables version control of individual sections, easier collaboration
- **How**: Main document uses `\input{sections/filename}` to include sections
- **When to edit**: Content changes happen in section files, not main document

Build artifacts in `src/out/` are git-ignored but contain:
- `.pdf` - Final compiled documents
- `.log` - Compilation logs for debugging
- `.aux`, `.fls`, `.out` - LaTeX auxiliary files
- `.synctex.gz` - Editor source-to-PDF mapping for dev containers

### Versioning Flow

Git commit → Semantic versioning extraction → Environment variable `VERSION` → Footer in PDF

## Build System

### Compilation Stack

**latexmk + LuaLaTeX workflow:**

1. `latexmk` reads configuration from `latexmkrc` and magic comments in `.tex` files
2. Executes LuaLaTeX engine with specific flags
3. Automatically reruns compilation for cross-references
4. Outputs to `src/out/` directory

**Why LuaLaTeX over pdfLaTeX:**
- Better Unicode support (required for special characters)
- Access to Lua scripting (`\directlua` for environment variables)
- Native system font loading via fontspec

### Magic Comments

Top of each `.tex` document:
```latex
% !TEX TS-program = latexmk
% !TEX options = -synctex=1 -interaction=nonstopmode -file-line-error -lualatex -outdir=out
```

- `synctex=1`: Enables editor forward/inverse search (click PDF → jump to source)
- `interaction=nonstopmode`: Non-interactive mode for CI/CD (doesn't pause on errors)
- `file-line-error`: Error format includes file path and line number
- `lualatex`: Specifies LuaLaTeX engine
- `outdir=out`: Build artifacts go to `src/out/` subdirectory

### Conditional Compilation

Three document variants from one codebase:

```latex
\resumetrue   % Enables resume-specific content
\cvtrue       % Enables CV-specific content
\covertrue    % Enables cover letter-specific content
```

**Usage in content files:**
```latex
\ifresume
    Brief bullet point for resume
\fi

\ifcv
    Detailed explanation for CV
\fi

% Or inline:
\resumeonly{Short version} \cvonly{Long version}
```

**Why**: Maintain single source of truth, avoid content drift between variants

### Environment Variables

```latex
\getenv{VERSION}  % Access shell environment variables
```

Used in footer to embed build version from CI/CD semantic versioning.

### Docker Build (Recommended)

**Why Docker:**
- Eliminates "works on my machine" - consistent LaTeX environment
- Avoids complex TeX Live installation (~5GB)
- CI/CD and local builds use identical toolchain

**When NOT to use Docker:**
- You won't - native builds fail due to missing packages (intentional)

## LaTeX Template System (YAAC)

**Template**: [yaac-another-awesome-cv](https://github.com/darwiin/yaac-another-awesome-cv)
**File**: `src/yaac-another-awesome-cv.cls`

### Document Class Options

```latex
\documentclass[localFont,alternative,compact]{yaac-another-awesome-cv}
```

**Options explained:**

| Option | Purpose | When to use |
|--------|---------|-------------|
| `localFont` | Load fonts from `fonts/` directory instead of system fonts | Always (CI/CD environments lack font installation) |
| `alternative` | Use alternate header layout with centered name | Current project uses this |
| `compact` | Reduce vertical spacing between entries | When content exceeds 1-2 pages |
| `10pt`/`11pt`/`12pt` | Font size | Not used (defaults to 10pt) |
| `showLinks` | Display URLs in PDF | Only for print versions |
| `green`/`red`/`indigo`/`orange`/`monochrome` | Accent color | Not used (defaults to blue) |

### Essential Commands

**Header/Contact Information:**
```latex
\name{First}{Last}
\tagline{Professional title}
\photo[circular]{2.5cm}{assets/profile.jpg}

\socialinfo{
    \email{address@domain.com}
    \linkedin{username}
    \github{username}
    \smartphone{+1-555-1234}
    \address{City, State}
}
```

**Section Headers:**
```latex
\sectionTitle{Section Name}{\faIcon}
% Example: \sectionTitle{Experience}{\faSuitcase}
```
- Uses FontAwesome 5 icons (`\fa` prefix)
- Common icons: `\faSuitcase`, `\faGraduationCap`, `\faLaptop`, `\faTasks`

**Experience Entries:**
```latex
\experience
    {End Date}           % "Present", "Jan 2024", etc.
    {Job Title}
    {Company Name}
    {Start Date}
    {
        Bullet point descriptions here.
        Can use multiple paragraphs.
    }
    {Technology, Tags, Go, Here}
```

**Project Entries:**
```latex
\project
    {Project Name}
    {Date Range}
    {URL or leave empty}
    {Description of the project and impact}
    {Tech, Stack, Listed, Here}
```

**Skills/Keywords:**
```latex
\begin{keywords}
    \keywordsentry{Category}{Keyword1, Keyword2, Keyword3}
    \keywordsentry{Languages}{JavaScript, Python, Go}
\end{keywords}
```

**Technology Tags:**
```latex
\cvtag{Docker} \cvtag{Kubernetes} \cvtag{AWS}
```
- Renders as colored tags/badges in the output

### Font System

**Source Sans Pro** loaded from `src/fonts/`:
- When `localFont` option: loads from local directory
- Otherwise: uses system-installed fonts (not recommended)
- Why: Consistent typography across all build environments

### Common Gotchas

1. **Missing `\emptySeparator`**: Add between entries to maintain spacing
2. **Long bullet points**: Break into multiple shorter bullets for readability
3. **Technology tags overflow**: Limit to 8-10 tags per entry
4. **Icon not found**: Ensure FontAwesome 5 package installed, use `\fa` prefix

## CI/CD Pipeline

### main.yml Workflow

**Triggers**: Pull requests, pushes to `main`

**Three-job pipeline:**

1. **build-docker**
   - Checks if `Dockerfile` differs from `main` branch
   - If changed: builds and pushes new image to GitHub Container Registry
   - If unchanged: skips build, uses cached `latest` image
   - **Why**: Speeds up PRs when only content changes (90% of commits)

2. **build-documents** (depends on build-docker)
   - Pulls Docker image (`ghcr.io/<owner>/latex:latest` or SHA-tagged)
   - Extracts semantic version from git commits
   - Runs `./build.sh` inside container
   - Uploads PDFs and logs as GitHub artifacts
   - **Environment**: `VERSION` variable passed to LaTeX for footer

3. **release** (only on `main` branch)
   - Downloads PDF artifacts
   - Creates GitHub Release with semantic version tag (e.g., `v1.2.3`)
   - Attaches PDFs to release
   - Generates release notes from commits

### scheduled-build.yml Workflow

**Trigger**: Cron schedule (weekly, Tuesday 16:00 UTC)

**Purpose**:
- Rebuilds Docker image with latest TeX Live packages
- Prevents dependency drift
- Catches breaking changes early

**When to modify**: If weekly is too frequent/infrequent

### Docker Image Strategy

**Registry**: GitHub Container Registry (GHCR)
**Base image**: Ubuntu noble (LTS)
**TeX Live**: 2025 with minimal `scheme-basic`

**Selective package installation** (avoids 5GB full TeX Live):
- Only installs packages actually used by template
- See `Dockerfile` for full list

**Caching**:
- GitHub Actions Docker layer cache
- Dramatically speeds up image rebuilds

## Making Changes

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

3. Test locally with dev container or Docker build

### Modifying Template Styles

**File**: `src/yaac-another-awesome-cv.cls`

**Common modifications:**
- Line ~75: Geometry (margins, page size)
- Line ~150-200: Color definitions
- Line ~250-300: Section title formatting
- Line ~400+: Environment definitions (experience, projects, etc.)

**Testing**: Build after each change, check PDF output

### Testing Locally

**Option 1: VS Code Dev Container** (recommended)
- Open in VS Code
- "Reopen in Container" prompt
- Edit → Auto-build on save → PDF preview
- Uses LaTeX Workshop extension

**Option 2: Docker CLI**
```bash
docker build -t latex-build .
docker run -v $PWD:/data -w /data/src latex-build ./build.sh
open src/out/filename.pdf  # macOS
```

**Option 3: Native LaTeX**
- Don't. Missing packages will fail.

### Common Build Failures

**Error: Missing package `foo.sty`**
- Solution: Add package to `Dockerfile` via `tlmgr install foo`
- Or: Use Docker instead of native build

**Error: File not found**
- Check path relative to `src/` directory
- Ensure `\input{}` path doesn't include `src/` prefix

**Error: Font not found**
- Ensure `localFont` option used
- Check `fonts/` directory contains `.otf` files

**PDF not generated:**
- Check `src/out/*.log` for errors
- Look for `! LaTeX Error:` lines

