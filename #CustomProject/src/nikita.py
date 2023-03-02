from selenium import webdriver
import selenium.common.exceptions as seleniumExceptions
from selenium.webdriver.common.by import By
import time, requests

# ====================Variables====================
LOGIN=""
PASSWORD=""
TARGETLINK=""
TARGETXPATH='//span[contains(text(), "Available")]'
BOT_API=""
USER_TG_ID=""
MESSAGE="I%20found%20it!"
# =================================================

chrome_options = webdriver.ChromeOptions()

chrome_options.add_argument('--headless')
chrome_options.add_argument('--disable-gpu')
chrome_options.add_argument('--ignore-certificate-errors')
chrome_options.add_argument('--no-sandbox')
chrome_options.add_argument('--disable-dev-shm-usage')

browser = webdriver.Chrome(options=chrome_options)

n = 1
while True:
    try:
        browser.refresh()
        time.sleep(2)
        url = browser.current_url
        if (url != TARGETLINK):
            raise Exception("Session closed")
        print("check - " + url)
    except:
        browser.get(TARGETLINK)
        login = browser.find_element(By.CSS_SELECTOR, "input[name='username']").send_keys(LOGIN)
        password = browser.find_element(By.CSS_SELECTOR, "input[name='password']").send_keys(PASSWORD)
        browser.find_element(By.CSS_SELECTOR, "button[type='submit']").click()
    try:
        button = browser.find_element(By.XPATH, TARGETXPATH)
        requests.get('https://api.telegram.org/bot' + BOT_API + '/sendMessage?chat_id=' + USER_TG_ID + '&text=' + MESSAGE)
        # break
    except:
        print("Not found:", n)
        n += 1

