from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
import time
import firebase_admin
from firebase_admin import credentials, firestore
import hashlib
from urllib.parse import urljoin, urlparse

# Firebase setup
cred = credentials.Certificate("C:/Users/hussain_yousof/Desktop/afghan_cosmos/serviceAccountKey.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

BASE_URL = "https://afghancosmos.com/"
VISITED_URLS = set()
MAX_PAGES = 50  

def save_to_firestore(collection, doc_id, data):
    try:
        db.collection("afghancosmos_data").document(collection).collection("items").document(doc_id).set(data)
        print(f"ذخیره شد: {data['url']}")
    except Exception as e:
        print(f"خطا در ذخیره {data['url']}: {e}")

def crawl_home_only(url, driver):
    driver.get(url)
    time.sleep(5)  # صبر برای بارگذاری JS
    
    html = driver.page_source
    from bs4 import BeautifulSoup
    soup = BeautifulSoup(html, "html.parser")
    
    title_tag = soup.find("title")
    title = title_tag.get_text().strip() if title_tag else "بدون عنوان"
    content = soup.get_text(separator=' ').strip()
    doc_id = hashlib.md5(url.encode()).hexdigest()
    
    save_to_firestore("pages", doc_id, {
        "title": title,
        "url": url,
        "content": content,
        "timestamp": firestore.SERVER_TIMESTAMP
    })

if __name__ == "__main__":
    chrome_options = Options()
    # chrome_options.add_argument("--headless")  # در صورت نیاز فعال کن
    chrome_options.add_argument("--disable-gpu")
    chrome_options.add_argument("--no-sandbox")
    service = Service(ChromeDriverManager().install())
    driver = webdriver.Chrome(service=service, options=chrome_options)
    
    crawl_home_only(BASE_URL, driver)
    driver.quit()

