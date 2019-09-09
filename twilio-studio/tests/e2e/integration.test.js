const assert = require('assert');
const { DateTime } = require('luxon');
const WebScrapper = require('../../assets/web-scraper.private');

function expectValidDate(date) {
  return [
    !DateTime.fromFormat(date, 'MM/dd/yyyy').invalid,
    `expected: date string in MM/dd/yyyy format
    got: ${date}` 
  ];
}

async function tests() {
  (function expect_web_scraper_with_c4k_url() {
    const C4K_SITE_URL = 'https://www.ctcare4kids.com/provider-information/status/';
    const webscraper = new WebScrapper(C4K_SITE_URL);

    (async function when_properly_init() {
      await webscraper.init();

      (function for_getRedeterminationsProcessingStatusDates_to_return_a_valid_date() {
        const date = webscraper.getRedeterminationsProcessingStatusDates();

        function expectation(testValue) {
          return expectValidDate(testValue);
        }

        try {
          assert(...expectation(date));
        } catch (err) {
          console.error(err);
        }
      })();

      (function for_getSupportingDocumentsProcessingStatusDates_to_return_a_valid_start_date() {
        const date = webscraper.getSupportingDocumentsProcessingStatusDates();
        const startDate = date.split(" – ")[0]; // this is a – not a -
        
        function expectation(testValue) {
          return expectValidDate(testValue);
        }

        try {
          assert(...expectation(startDate));
        } catch (err) {
          console.error(err);
        }
      })();

      (function for_getSupportingDocumentsProcessingStatusDates_to_return_a_valid_end_date() {
        const date = webscraper.getSupportingDocumentsProcessingStatusDates();
        const endDate = date.split(" – ")[1]; // this is a – not a -
        
        function expectation(testValue) {
          return expectValidDate(testValue);
        }

        try {
          assert(...expectation(endDate));
        } catch (err) {
          console.error(err);
        }
      })();
    })();
  })();
}

(async () => {
  await tests();
})();
