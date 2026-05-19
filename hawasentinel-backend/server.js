import express from 'express';
import cors from 'cors';
import * as dotenv from 'dotenv';
import { getAQIData } from './tools/iqair.js';
import { getFiresData } from './tools/nasaFirms.js';
import { getWindData } from './tools/openMeteo.js';
import { NOV_2024_EPISODE } from './data/mockScenario.js';
import { runOrchestrator } from './agents/orchestratorAgent.js';

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

app.all('/api/simulate', async (req, res) => {
  try {
    const scenario = req.body.scenario || req.query.scenario;
    const aqi_override = req.body.aqi_override || req.query.aqi_override;
    let inputData;

    if (scenario === 'live') {
      const [aqiResult, firesResult, windResult] = await Promise.all([
        getAQIData(),
        getFiresData(),
        getWindData()
      ]);
      
      inputData = {
        city: aqiResult.city,
        aqi: aqi_override || aqiResult.aqi,
        pm25: aqiResult.pm25,
        wind: windResult.wind,
        fires: firesResult.active_fires,
        source: 'live'
      };
    } else if (scenario === 'replay') {
      return res.json({
        status: "success",
        data: NOV_2024_EPISODE
      });
    } else {
      // Default to mock
      inputData = {
        city: "Lahore",
        aqi: aqi_override || 540,
        fires: 23,
        wind: "NE 14kmph",
        source: "mock"
      };
    }

    const orchestratorResult = await runOrchestrator(inputData);
    return res.json({
      status: "success",
      data: orchestratorResult
    });

  } catch (error) {
    console.error("Simulation error:", error);
    return res.status(500).json({ error: error.message });
  }
});

app.get('/api/aqi', async (req, res) => {
  try {
    const aqiData = await getAQIData();
    const firesData = await getFiresData();
    const windData = await getWindData();
    return res.json({
      city: aqiData.city,
      aqi: aqiData.aqi,
      pm25: aqiData.pm25,
      wind: windData.wind,
      fires: firesData.active_fires,
      timestamp: aqiData.timestamp || new Date().toISOString()
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
});

app.get(['/api/health', '/health'], (req, res) => {
  res.json({
    status: "ok",
    timestamp: new Date().toISOString(),
    models: "local/qwen3:4b" // Updated based on requirements
  });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`HawaSentinel backend running on http://0.0.0.0:${PORT}`);
});
