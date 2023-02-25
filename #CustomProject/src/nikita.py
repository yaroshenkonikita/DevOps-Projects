from selenium import webdriver
import selenium.common.exceptions as seleniumExceptions
from selenium.webdriver.common.by import By
import time, requests

# ====================Variables====================
LOGIN="login"
PASSWORD="password"
TARGETLINK="www.a.com"
TARGETXPATH='//span[contains(text(), "Available")]'
BOT_API="1:A"
USER_TG_ID="1"
MESSAGE="Available%20Target"
# =================================================

chrome_options = webdriver.ChromeOptions()

chrome_options.add_argument('--headless')
chrome_options.add_argument('--disable-gpu')
chrome_options.add_argument('--ignore-certificate-errors')
chrome_options.add_argument('--no-sandbox')

driver = webdriver.Chrome(options=chrome_options)
driver.get(TARGETLINK)
login = driver.find_element(By.CSS_SELECTOR, "input[name='username']").send_keys(LOGIN)
password = driver.find_element(By.CSS_SELECTOR, "input[name='password']").send_keys(PASSWORD)

driver.find_element(By.CSS_SELECTOR, "button[type='submit']").click()


n = 1
while True:
    drivertmp = driver
    try:
        drivertmp.refresh()
        time.sleep(2)
        url = drivertmp.current_url
        print("check - " + url)
        try:
            button = drivertmp.find_element(By.XPATH, TARGETXPATH)
            requests.get('https://api.telegram.org/bot'BOT_API'/sendMessage?chat_id='USER_TG_ID'&text='MESSAGE)
            # break
        except:
            print("Not found:", n)
            n += 1

    except Exception as e:
        print("try refresh fail:", e)
        driver = webdriver.Chrome(options=chrome_options)
        driver.get(TARGETLINK)
        login = driver.find_element(By.CSS_SELECTOR, "input[name='username']").send_keys(LOGIN)
        password = driver.find_element(By.CSS_SELECTOR, "input[name='password']").send_keys(PASSWORD)

        driver.find_element(By.CSS_SELECTOR, "button[type='submit']").click()
