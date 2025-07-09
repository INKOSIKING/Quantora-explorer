const puppeteer = require('puppeteer');
const assert = require('assert');

async function test_search_fuzz() {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();
    await page.goto('https://explorer.yourdomain.com');
    await page.type('input[aria-label="Search Query"]', "'; DROP TABLE --");
    await page.keyboard.press('Enter');
    await page.waitForTimeout(500);
    assert(await page.$('table') !== null);
    await browser.close();
}

async function test_contract_upload() {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();
    await page.goto('https://explorer.yourdomain.com/contract/verify');
    await page.waitForSelector('input[type="file"]');
    // Simulate file upload (edge cases: large, invalid, malicious source)
    // ...omitted for brevity
    await browser.close();
}

async function test_deep_links() {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();
    await page.goto('https://explorer.yourdomain.com/tx/0x123...');
    assert((await page.title()).includes('Transaction'));
    await browser.close();
}

async function test_browser_matrix() {
    const browsers = ['chrome', 'firefox'];
    for (const browserType of browsers) {
        const browser = await puppeteer.launch({product: browserType});
        const page = await browser.newPage();
        await page.goto('https://explorer.yourdomain.com');
        assert(await page.$('header') !== null);
        await browser.close();
    }
}

(async () => {
    await test_search_fuzz();
    await test_contract_upload();
    await test_deep_links();
    await test_browser_matrix();
    console.log("Explorer E2E tests complete.");
})();