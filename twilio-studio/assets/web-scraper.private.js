const axios = require('axios');
const cheerio = require('cheerio');

class WebScraper {
  constructor(siteUrl) {
    this.siteUrl = siteUrl;
  }

  async init() {
    const response = await this.fetch();
    this.$ = this.processResponse(response);
  }

  async fetch() {
    return await axios.get(this.siteUrl);
  };

  processResponse(response) {
    return cheerio.load(response.data);
  }

  initGuard() {
    if (!this.$) {
      throw new Error("Please run init() before calling this method.");
    }
  }

  getRedeterminationsProcessingStatusDates() {
    this.initGuard();
    return this.$('main div ul li:nth-child(2) b span span').text().trim();
  }

  getSupportingDocumentsProcessingStatusDates() {
    this.initGuard();
    return this.$('main div ul li:nth-child(3) b span span').text().trim();
  }
}

module.exports = WebScraper;