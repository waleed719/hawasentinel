import axios from 'axios';
import * as dotenv from 'dotenv';
dotenv.config();

export async function getFiresData() {
  try {
    if (!process.env.FIRMS_API_KEY) {
      throw new Error("Missing FIRMS_API_KEY");
    }

    const url = `https://firms.modaps.eosdis.nasa.gov/api/country/csv/${process.env.FIRMS_API_KEY}/VIIRS_SNPP_NRT/PAK/1`;
    const response = await axios.get(url);
    const csvData = response.data;

    // Simple parsing to count number of fires (lines in CSV minus header)
    const lines = csvData.split('\n').filter(line => line.trim().length > 0);
    const fireCount = Math.max(0, lines.length - 1); // Subtract 1 for header

    return {
      active_fires: fireCount,
      source: "live"
    };
  } catch (error) {
    console.warn(`[NASA FIRMS] API failed or key missing: ${error.message}. Returning mock.`);
    return { active_fires: 23, source: "mock" };
  }
}
