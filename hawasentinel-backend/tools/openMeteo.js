import axios from 'axios';

function getDirectionString(degrees) {
  if (degrees >= 337.5 || degrees < 22.5) return 'N';
  if (degrees >= 22.5 && degrees < 67.5) return 'NE';
  if (degrees >= 67.5 && degrees < 112.5) return 'E';
  if (degrees >= 112.5 && degrees < 157.5) return 'SE';
  if (degrees >= 157.5 && degrees < 202.5) return 'S';
  if (degrees >= 202.5 && degrees < 247.5) return 'SW';
  if (degrees >= 247.5 && degrees < 292.5) return 'W';
  if (degrees >= 292.5 && degrees < 337.5) return 'NW';
  return '';
}

export async function getWindData() {
  try {
    const url = `https://api.open-meteo.com/v1/forecast?latitude=31.5204&longitude=74.3587&current=wind_speed_10m,wind_direction_10m`;
    const response = await axios.get(url);
    const current = response.data.current;

    const windSpeed = current.wind_speed_10m;
    const windDirection = getDirectionString(current.wind_direction_10m);

    return {
      wind_speed: windSpeed,
      wind_direction: windDirection,
      wind: `${windDirection} ${windSpeed}kmph`,
      source: "live"
    };
  } catch (error) {
    console.warn(`[Open-Meteo] API failed: ${error.message}. Returning mock.`);
    return { wind_speed: 14, wind_direction: "NE", wind: "NE 14kmph", source: "mock" };
  }
}
