# LaTeX Template Guide

## Document Class Options

```latex
\documentclass[localFont,alternative,compact]{yaac-another-awesome-cv}
```

| Option | Purpose |
|--------|---------|
| `localFont` | Load fonts from `fonts/` directory (required for CI/CD) |
| `alternative` | Centered name in header |
| `compact` | Reduced vertical spacing |
| `10pt`/`11pt`/`12pt` | Font size (default: 10pt) |
| `showLinks` | Display URLs in PDF |
| `green`/`red`/`indigo`/`orange`/`monochrome` | Accent color (default: blue) |

## Essential Commands

### Header

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

### Section Headers

```latex
\sectionTitle{Section Name}{\faIcon}
```

FontAwesome 5 icons (`\fa` prefix):
- `\faSuitcase` - Experience
- `\faGraduationCap` - Education
- `\faLaptop` - Projects
- `\faTasks` - Skills
- `\faHome` - Remote
- `\faBuilding` - On-site

### Experience

```latex
\begin{experiences}
  \experience
    {End Date}           % "Present", "January 2024"
    {Job Title}
    {Company Name}
    {Start Date}
    {
        \begin{itemize}
            \item Achievement with metrics
            \item Another accomplishment
        \end{itemize}
    }
    {Technology, Tags, Separated, By, Commas}
    {Location Type}      % "\faHome\ Remote" or "\faBuilding\ On-site"
  \emptySeparator
\end{experiences}
```

**Requirements:**
- `\emptySeparator` between entries
- 7th parameter required (even if empty)
- Limit technology tags to 8-10

### Projects

```latex
\begin{projects}
    \project
        {Project Name}
        {Date Range}
        {URL or empty}
        {Description}
        {Tech, Stack}
\end{projects}
```

### Skills

```latex
\begin{keywords}
    \keywordsentry{Category}{Keyword1, Keyword2, Keyword3}
    \keywordsentry{Languages}{\textbf{JavaScript}, TypeScript, Python}
\end{keywords}
```

Use `\textbf{}` to highlight primary skills.

### Technology Tags

```latex
\cvtag{Docker} \cvtag{Kubernetes} \cvtag{AWS}
```

## Conditional Compilation

```latex
% Main document
\resumetrue   % resume.tex
\cvtrue       % cv.tex

% Section files
\ifresume
    Brief content
\fi

\ifcv
    Detailed content
\fi

% Inline
\resumeonly{Short} \cvonly{Long version}
```

## Font System

Source Sans Pro from `src/fonts/`:
- Requires `localFont` option
- Loads `.otf` files from local directory
- Consistent across build environments
- Without `localFont`: system fonts (not recommended)

## Common Issues

1. **Missing `\emptySeparator`**: Add between all experience entries
2. **Long bullets**: Break into multiple bullets (2-3 lines max)
3. **Tag overflow**: Limit to 8-10 tags per entry
4. **Icon not found**: Use `\fa` prefix, not `\icon`
5. **Missing 7th parameter**: Experience requires location (or empty `{}`)
6. **Path errors**: Paths relative to main document, exclude `src/` prefix

## Customization

**File:** `src/yaac-another-awesome-cv.cls`
