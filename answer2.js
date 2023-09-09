const axios = require('axios');
const PQueue = require('p-queue');

const urls = ['https://example.com', 'https://example.org', 'https://example.net'];

const queue = new PQueue({ concurrency: 2 });

async function fetchUrl(url) {
  try {
    const response = await axios.get(url);
    console.log(`Fetched data from ${url}`);
    return response.data;
  } catch (error) {
    console.error(`Error fetching data from ${url}: ${error.message}`);
    return null;
  }
}

async function fetchAllUrls() {
  const results = await Promise.all(urls.map(url => queue.add(() => fetchUrl(url))));
  console.log('All requests completed:', results);
}

fetchAllUrls();