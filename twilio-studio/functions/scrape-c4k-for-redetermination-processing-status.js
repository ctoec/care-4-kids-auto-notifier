const SITE_URL = "https://www.ctcare4kids.com/provider-information/status/";

exports.handler = async function(context, event, callback) {
  const webscraperPath = Runtime.getAssets()['/web-scraper.js'].path;
  const WebScraper = require(webscraperPath);
  const webscraper = new WebScraper(SITE_URL);
  await webscraper.init();
  const redeterminationsProcessingStatusDates = webscraper.getRedeterminationsProcessingStatusDates();
  callback(null, redeterminationsProcessingStatusDates);
};
