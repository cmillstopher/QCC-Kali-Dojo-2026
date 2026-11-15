# QCC Kali Dojo 2026 — Red Sands Exploitation Arena

Static website content for the **Kali Linux Dojo** village at **Queen City Con** (Cincinnati, Nov 13–15, 2026) — an Egyptian/desert‑themed, hands‑on space where attendees learn to customize and use the Kali Linux distribution across three stations.

**Live site (GitHub Pages):** https://cmillstopher.github.io/QCC-Kali-Dojo-2026/

## The stations

| # | Station | Theme |
|---|---------|-------|
| 01 | **The Pharaoh's Forge** | Build & customize Kali — the "ISO of Doom", bash automation, an interactive Kali setup‑script builder, terminal multiplexers |
| 02 | **The Scribe's Arsenal** | Use the tools — packet analysis, web inspection, and tooling references |
| 03 | **The Hidden Chamber** | Apply the skills against intentionally vulnerable lab targets, including a capture‑the‑flag |

## Tech

Hand‑built static HTML/CSS/JS with a shared design system (`css/red-sands.css`) — no build step, no framework. Served with nginx. Open `index.html` to browse locally.

```
index.html, connect.html, signage.html   entry / connection / signage
stations/                                 the three station landing pages
resources/                                deep-dive guides, references, and interactive tools
  pharaohs-forge/ · scribes-arsenal/ · red-sands/
assets/                                   QR codes and sample bash scripts
css/ · js/ · partials/                    design system and shared markup
```

## Notes

- **Excluded from this public repo** (see `.gitignore`): staff‑only volunteer runbooks and answer keys, the coordinator bio page, and a flag walkthrough. These were part of the live event site but are intentionally not published here.
- **Lab addresses** (`10.50.70.x`, etc.) are internal, non‑routable (RFC1918) addresses from the isolated event network — they don't reach anything outside the lab.
- All lab targets referenced are **intentionally vulnerable training VMs** used in an authorized, isolated environment.

## Adapting this for your own event

The content is wired to our specific, isolated lab. If you reuse it, these are the **event‑specific values to swap for your own**:

| Thing | Our value | Where it appears |
|---|---|---|
| Wi‑Fi SSID / passphrase | `Kali Dojo` / `qcckalidojo` | `connect.html`, `signage.html`, Wi‑Fi QR |
| Site / signage host | `10.50.70.249` | throughout; QR codes in `assets/qr/` |
| Lab target — Linux | `10.50.70.52` (Metasploitable3 Ubuntu 1404) | Chamber & Arsenal pages |
| Lab target — Windows | `10.50.70.53` (Metasploitable3 Win2k8) | Chamber pages, flag board |
| Lab target — web app | `10.50.70.54` (Hackazon) | Hackazon guide, Chamber |
| Network segmentation | VLANs 50 / 55 / 60 / 70 (infra / display / attendee / lab) | referenced in content |

These are internal, non‑routable (RFC1918) addresses on an isolated, VLAN‑segmented network with no bridge to any production or public network. Repoint them at your own lab before using.

Shared in the spirit of the community — adapt it freely for your own village or workshop.
