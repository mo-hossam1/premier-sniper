# Premiere IMAX Ticket Sniper 🎯🎬

A serverless Python automation bot running on GitHub Actions that monitors **Premiere Cinemas (Americana Plaza IMAX - Sheikh Zayed)** and **Elcinema** 24/7 for advance blockbuster ticket drops.

### How It Works
* **Elcinema POS Scraper:** Uses `requests` and `BeautifulSoup4` to monitor live IMAX hall showtimes and ticket pricing tiers.
* **Headless Browser Engine:** Uses `Playwright` (Chromium) to render Premiere Cinemas' client-side JavaScript web app (`/en/cinemas/2` and `/now-showing`), bypassing empty HTML shells while filtering out `/coming-soon` placeholders.
* **Instant Mobile Alerts:** Dispatches urgent push notifications via `ntfy.sh` with one-tap deep links straight to the checkout page the moment booking opens.
* **Zero Local Resource Drain:** Runs 100% in the cloud via scheduled GitHub Actions cron workflows.
