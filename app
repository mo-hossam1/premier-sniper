<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <meta name="theme-color" content="#0d1117">
  <meta name="apple-mobile-web-app-capable" content="yes">
  <title>IMAX Sniper</title>
  <style>
    * { box-sizing: border-box; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; }
    body { background: #0d1117; color: #e6edf3; margin: 0; padding: 24px 18px; display: flex; flex-direction: column; gap: 18px; }
    .card { background: #161b22; border: 1px solid #30363d; border-radius: 16px; padding: 20px; box-shadow: 0 8px 24px rgba(0,0,0,0.4); }
    h1 { font-size: 22px; margin: 0 0 6px 0; display: flex; align-items: center; gap: 8px; }
    p.sub { color: #8b949e; font-size: 13px; margin: 0; }
    label { font-size: 13px; color: #8b949e; display: block; margin-bottom: 6px; margin-top: 14px; }
    input { width: 100%; padding: 12px 14px; border-radius: 10px; border: 1px solid #30363d; background: #0d1117; color: #fff; font-size: 15px; }
    button { width: 100%; margin-top: 16px; padding: 14px; border-radius: 10px; border: none; background: #238636; color: #fff; font-weight: 600; font-size: 15px; cursor: pointer; }
    button:active { transform: scale(0.98); background: #2ea043; }
    .status-row { display: flex; justify-content: space-between; align-items: center; padding: 10px 0; border-bottom: 1px solid #21262d; font-size: 14px; }
    .status-row:last-child { border-bottom: none; }
    .badge { padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; }
    .success { background: rgba(35,134,54,0.2); color: #3fb950; }
    .running { background: rgba(210,153,34,0.2); color: #d29922; }
    .fail { background: rgba(248,81,73,0.2); color: #f85149; }
  </style>
</head>
<body>

  <div class="card">
    <h1>🎯 Zayed IMAX Sniper</h1>
    <p class="sub">Premiere Americana Plaza • Auto-runs every 10m</p>

    <label>GitHub Personal Access Token (Saved locally on device)</label>
    <input type="password" id="token" placeholder="ghp_xxxxxxxxxxxx">

    <label>Target Movie to Scan Right Now</label>
    <input type="text" id="movie" value="Dune">

    <button onclick="triggerScan()">🚀 Run Instant Scan Now</button>
    <p id="msg" style="font-size:13px; color:#58a6ff; margin-top:10px; display:none;"></p>
  </div>

  <div class="card">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:10px;">
      <h2 style="font-size:16px; margin:0;">Recent Scans</h2>
      <span onclick="loadRuns()" style="color:#58a6ff; font-size:13px; cursor:pointer;">↻ Refresh</span>
    </div>
    <div id="runs">Loading latest runs...</div>
  </div>

  <script>
    const OWNER = "mo-hossam1";
    const REPO = "premier-sniper";
    const WORKFLOW_FILE = "imax_sniper.yml"; // Matches your workflow filename

    document.getElementById("token").value = localStorage.getItem("gh_token") || "";

    async function loadRuns() {
      try {
        const res = await fetch(`https://api.github.com/repos/${OWNER}/${REPO}/actions/runs?per_page=5`);
        const data = await res.json();
        const container = document.getElementById("runs");
        if (!data.workflow_runs || data.workflow_runs.length === 0) { container.innerText = "No runs found yet."; return; }
        container.innerHTML = data.workflow_runs.map(r => {
          const state = r.status === "in_progress" ? "running" : (r.conclusion === "success" ? "success" : "fail");
          const label = r.status === "in_progress" ? "Scanning..." : (r.conclusion === "success" ? "Checked ✓" : "Error");
          const time = new Date(r.created_at).toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
          return `<div class="status-row">
            <span>${r.event === 'schedule' ? '⏱️ Auto Scan' : '⚡ Manual Test'} (${time})</span>
            <span class="badge ${state}">${label}</span>
          </div>`;
        }).join("");
      } catch (e) {
        document.getElementById("runs").innerText = "Could not load recent runs.";
      }
    }

    async function triggerScan() {
      const token = document.getElementById("token").value.trim();
      const movie = document.getElementById("movie").value.trim() || "Dune";
      const msg = document.getElementById("msg");
      if (!token) { alert("Paste a GitHub Token first to trigger scans!"); return; }
      localStorage.setItem("gh_token", token);

      msg.style.display = "block";
      msg.innerText = `Triggering scan for '${movie}'...`;

      const res = await fetch(`https://api.github.com/repos/${OWNER}/${REPO}/actions/workflows/${WORKFLOW_FILE}/dispatches`, {
        method: "POST",
        headers: {
          "Authorization": `Bearer ${token}`,
          "Accept": "application/vnd.github+json"
        },
        body: JSON.stringify({ ref: "main", inputs: { test_movie: movie } })
      });

      if (res.status === 204) {
        msg.innerText = `✅ Scan launched for '${movie}'! Refreshing list in 4s...`;
        setTimeout(loadRuns, 4000);
      } else {
        msg.innerText = `❌ Failed (${res.status}). Check your token permissions or workflow filename.`;
      }
    }

    loadRuns();
  </script>
</body>
</html>
