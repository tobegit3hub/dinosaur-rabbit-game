# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A self-contained HTML5 canvas game for a 5-year-old: a dinosaur catches 6 rabbits, then fireworks celebrate. Everything — markup, CSS, and JavaScript — lives in a single `index.html` with **no build step, no dependencies, no tests, no linter**. The game must run by simply opening the file in a browser, and it works offline.

## Commands

- **Play locally:** open `index.html` directly (double-click), or `python3 -m http.server` and browse to it. There is no dev server, bundler, or watch mode.
- **Deploy:** `./deploy-overseas.sh` — see Deployment below.
- **Automation hook:** append `?debug=1` to the URL to expose `window.__dinoGame` (`state`, `dino`, `rabbits`, `startGame`, `startAutoGame`, `setAuto`, `catchRabbit`, `showWin`, `field`, `sound`, `fireworks`) for driving the game from a console or script.

## File Layout

- `index.html` — current game (all source).
- `v1/index.html` — frozen backup (2026-11-01), the version *before* the timer feature. Do not edit; it exists for reference/rollback.
- `screenshots/` — preview images (not used by the game).
- `DEPLOY.md`, `deploy-overseas.sh` — EdgeOne Pages deployment.

## Architecture (all inside one IIFE in `index.html`)

**State machine:** `state.mode` is one of `title` → `playing` → `celebrating` → `win`. `update()` branches on it; `celebrating` is a ~0.95s dinosaur cheer before the `showWin()` overlay and fireworks appear.

**Game loop:** `requestAnimationFrame` drives `loop(now)` → `update(dt)` + `render()`, with `dt` clamped to 50ms. Rendering is 2D canvas only.

**Coordinate system:** `resize()` computes a scale factor `S` (from viewport, clamped 0.62–1.22), a playable `field` rect, and `horizon`. All game logic and drawing sizes are multiplied by `S` so the game scales across phones/tablets/desktop. Scenery is generated with a seeded RNG (`mulberry32`) so the background is stable across resizes.

**Entities:** `dino` (player), `rabbits` (exactly 6, spawned at fixed fractional slots, flee when the dino is within 300*S), plus `particles` (hearts/stars/poof), `bubble` (speech bubbles), and `scene` (clouds, flowers, bushes, butterflies — decorative). Actors are drawn y-sorted for depth (`render()`).

**Input:** pointer events (drag or tap-to-move), keyboard (arrows/WASD; Space/Enter starts; `R` restarts; `M` mutes). Any manual input cancels auto-play. Catch detection is distance-based in `checkCatch()` (radius ~60*S); catching the 6th rabbit sets `finishTime` and enters `celebrating`.

**Auto-play:** `updateDino()` steers toward the nearest rabbit (with light velocity lead) at `DINO_SPEED * 0.55`, retargeting every 0.9s. Toggled by the HUD pill or the title-screen "自动玩一次" button.

**Audio:** fully synthesized via WebAudio (`Sound` object) — no audio files. `blip()` plays tones; the background music is an 8-bar loop scheduled with a lookahead timer. Music stops on tab hide (`visibilitychange`) and on win. Mute state persists in `localStorage` (`dino-rabbit-muted`).

**Fireworks:** a second canvas (`#fireworks`) with its own high-frequency loop (`fwLoop`), rocket/spark/flash arrays, only active on the win screen.

## Deployment notes

Deploys to Tencent EdgeOne Pages (overseas area, project `dinosaur-rabbit-overseas`). Two non-obvious constraints, both handled by `deploy-overseas.sh` — don't bypass it:

- `edgeone makers deploy .` packs the directory name into the zip, so the site serves at `/dinosaur-rabbit/` and the root 404s. The script builds a temp zip with `index.html` at the root.
- The script excludes `v1/`, `screenshots/`, `DEPLOY.md`, and `deploy-overseas.sh` from the upload.

`*.edgeone.dev` returns **401 on Chinese-mainland networks** — this is expected behavior for overseas-area project domains, not a failed deploy. `DEPLOY.md` contains an outdated `cd` path; the repo now lives at this working directory.
