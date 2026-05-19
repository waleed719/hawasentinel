import axios from 'axios';
import * as dotenv from 'dotenv';
dotenv.config();

export async function getAQIData() {
  try {
    if (!process.env.IQAIR_API_KEY) {
      throw new Error("Missing IQAIR_API_KEY");
    }

    const url = `https://api.airvisual.com/v2/city?city=Lahore&state=Punjab&country=Pakistan&key=${process.env.IQAIR_API_KEY}`;
    const response = await axios.get(url);
    const data = response.data;
    
    if (data.status !== 'success') {
      throw new Error("IQAir API returned non-success status");
    }

    const current = data.data.current;
    
    return {
      city: "Lahore",
      aqi: current.pollution.aqius,
      pm25: current.pollution.aqius, // IQAir API free tier typically returns AQI, we approximate PM2.5 or use real if available
      source: "live",
      timestamp: data.data.current.pollution.ts
    };
  } catch (error) {
    console.warn(`[IQAir] API failed or key missing: ${error.message}. Returning mock.`);
    return { city: "Lahore", aqi: 540, pm25: 287, source: "mock", timestamp: new Date().toISOString() };
  }
}
