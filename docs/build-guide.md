# Build System Guide

## Environment Variables

```latex
\getenv{VERSION}  % Reads $VERSION from shell
```

Used for embedding build version in footer.

## Docker Build

**Why:**
- Consistent environment
- Avoids TeX Live installation (~5GB)
- Identical CI/CD and local toolchain

**Configuration:**
- Base: Ubuntu noble
- TeX Live 2025, `scheme-basic`
- Selective package installation
- Volume mount: `/data`

**Artifacts in `src/out/` (git-ignored):**
- `.pdf` - Final documents
- `.log` - Compilation logs
- `.aux`, `.fls`, `.out` - LaTeX auxiliary
- `.synctex.gz` - Source mapping

## Local Development

### VS Code Dev Container (recommended)
1. Install Docker, VS Code, Remote-Containers extension
2. Open project
3. Accept "Reopen in Container"
4. Edit → auto-build → PDF preview

### Docker CLI
```bash
docker build -t latex-build .
docker run -v $PWD:/data -w /data/src latex-build ./build.sh
```

## CI/CD Pipeline

### main.yml

**Triggers:** PRs, pushes to `main`

**Jobs:**

**1. build-docker**
- Checks if `Dockerfile` changed vs `main`
- Changed: builds and pushes to GHCR
- Unchanged: uses cached `latest`

**2. build-documents**
- Pulls Docker image
- Extracts semantic version from commits
- Runs `./build.sh` with `VERSION` env var
- Uploads PDFs and logs (7-day retention)

**3. release** (`main` only)
- Downloads PDFs
- Creates GitHub Release (semantic version tag)
- Attaches PDFs
- Generates release notes

### scheduled-build.yml

**Trigger:** Weekly (Tuesday 16:00 UTC)

**Purpose:**
- Rebuilds Docker image with latest TeX Live
- Prevents dependency drift

### Docker Images

**Registry:** GitHub Container Registry (GHCR)

**Tags:**
- `latest` - Most recent build
- `<git-sha>` - Specific commit

**Selective packages:**
- Minimal install vs full 5GB
- See `Dockerfile` for list

**Caching:**
- GitHub Actions Docker layer cache
- Invalidates on `Dockerfile` changes

## Build Failures

**Missing package `foo.sty`**
- Add to `Dockerfile`: `tlmgr install foo`

**File not found**
- Check path relative to `src/`
- `\input{}` excludes `src/` prefix
- Verify file exists

**Font not found**
- Use `localFont` option
- Check `src/fonts/` for `.otf` files
- Verify fontspec installed

**PDF not generated**
- Check `src/out/*.log`
- Search: `! LaTeX Error:` or `! Undefined control sequence`

**Build hangs**
- Verify `interaction=nonstopmode` in magic comments
- Without it, LaTeX waits for input on errors

## Versioning

Git commit → Conventional commits → Semantic version → `VERSION` → LaTeX footer

**Format:**
- `feat:` - Minor bump
- `fix:` - Patch bump
- `BREAKING CHANGE:` - Major bump
