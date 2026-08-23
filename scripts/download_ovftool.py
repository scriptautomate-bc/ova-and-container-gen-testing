import sys
from playwright.sync_api import sync_playwright

def download_ovf(version):
    filename = f"VMware-ovftool-{version}-lin.x86_64.zip"
    url = "https://developer.broadcom.com/tools/open-virtualization-format-ovf-tool/latest"

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()

        print(f"Navigating to {url}...")
        page.goto(url)

        # Target the button using the precise filename attribute
        selector = f'button[href="{filename}"]'
        page.wait_for_selector(selector, timeout=30000)

        print(f"Found button for {filename}. Starting download...")
        with page.expect_download(timeout=120000) as download_info:
            page.click(selector)

        download = download_info.value
        download.save_as(filename)

        print(f"Successfully saved to {filename}")
        browser.close()

if __name__ == "__main__":
    # Use the passed argument, or default to the known 5.1.0 build
    ovf_version = sys.argv[1] if len(sys.argv) > 1 else "5.1.0-25410048"
    download_ovf(ovf_version)
