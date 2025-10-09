const express = require("express");
const Docker = require("dockerode");
const cors = require("cors");

const app = express();
const docker = new Docker({ socketPath: "/var/run/docker.sock" });

app.use(cors());
app.use(express.json());

// Start container
app.post("/start/:name", async (req, res) => {
  try {
    const container = docker.getContainer(req.params.name);
    await container.start();
    res.json({ success: true });
  } catch (e) {
    res.status(500).json({ success: false, error: e.message });
  }
});

// Stop container
app.post("/stop/:name", async (req, res) => {
  try {
    const container = docker.getContainer(req.params.name);
    await container.stop();
    res.json({ success: true });
  } catch (e) {
    res.status(500).json({ success: false, error: e.message });
  }
});

// Health check
app.get("/status", async (req, res) => {
  try {
    const containers = await docker.listContainers({ all: true });
    const status = {};
    containers.forEach(c => { status[c.Names[0].replace("/", "")] = c.State; });
    res.json(status);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Simple onboarding endpoint
app.get("/onboarding", (req, res) => {
  res.json({
    steps: [
      "Start core services: ./mosgarage.sh",
      "Start optional modules: ./mosgarage.sh sharepoint powerapps",
      "Open dashboard at https://localhost",
      "Use Start/Stop buttons to manage modules",
      "Push changes to your Git repo for CI/CD"
    ]
  });
});

app.listen(3000, () => console.log("API running on port 3000"));
