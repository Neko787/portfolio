# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Personal portfolio website for Raven McCloud — a single-page static site built with
plain HTML and CSS. No frameworks, no build step, no JavaScript.

- Live site: https://cloud7-code.github.io/portfolio/
- Repo: Cloud7-code/portfolio (GitHub Pages, deployed from the `main` branch)
- The git repository is the `portfolio/` folder, not its parent.

## Files

- `portfolio/index.html` — the entire page: nav, hero, about, projects, and contact sections
- `portfolio/style.css` — all styling
- `portfolio/README.md` — short project overview

## Working on this project

There is no build, lint, or test tooling. To preview changes, open
`portfolio/index.html` directly in a browser. Because there's no build step,
edits appear as soon as you refresh the page.

To publish changes, commit and push to `main`; GitHub Pages redeploys automatically.

## Conventions

- **Dark theme via CSS custom properties.** All colors and the page max-width are
  defined once as variables in the `:root` block at the top of `style.css`
  (`--bg`, `--bg-card`, `--text`, `--text-muted`, `--accent`, `--heading`,
  `--max-width`). Change a color there rather than hardcoding it in individual rules.
- **CSS is organized in labeled sections** (`/* ===== Hero ===== */`, etc.) that
  mirror the HTML sections. Keep that pairing when adding new sections.
- **Responsive sizing uses `clamp()`** for headings and the project grid uses CSS
  `grid` with `auto-fit`, so layouts adapt without media queries.

## Current state

Layout is complete. The hero blurb, About paragraph, and skills list have real
content; the three project cards are still placeholder copy waiting for real
projects to link to.
