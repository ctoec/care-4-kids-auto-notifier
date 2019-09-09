const axios = require('axios');
const cheerio = require('cheerio');

class WebScraper {
  constructor(siteUrl) {
    this.siteUrl = siteUrl;
  }

  async init() {
    const response = await this.fetch();
    this.$ = this.loadSite(response);
  }

  async fetch() {
    return await axios.get(this.siteUrl);
  };

  loadSite(response) {
    return cheerio.load(response.data);
  }

  getRedeterminationsProcessingStatusDates() {
    return this.$('main div ul li:nth-child(2) b span span').text().trim();
  }

  getSupportingDocumentsProcessingStatusDates() {
    return this.$('main div ul li:nth-child(3) b span span').text().trim();
  }
}

module.exports = WebScraper;