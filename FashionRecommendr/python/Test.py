import google.generativeai as genai
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.options import Options
import requests
import numpy
import math

def final(hip1, hip2, shoulder, height, age, gender):
    import re
    def calculate_hip(hip1, hip2):
        a = hip1/2
        b = hip2/2


        c = 4*(math.pow((numpy.pi/2), (b/a)))*a
        return c

    waist = calculate_hip(hip1=hip1, hip2=hip2)

    def setup_driver():
        chrome_options = Options()
        # Remove headless option for testing
        chrome_options.add_argument("--headless")  # Comment this line
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_argument("--disable-dev-shm-usage")
        chrome_options.add_argument("--window-size=1280,800")
        service = Service(ChromeDriverManager().install())
        driver = webdriver.Chrome(service=service, options=chrome_options)
        return driver



    def remove_parentheses(text):
        return re.sub(r'\(.*?\)', '', text)


    # Set up your API key
    GOOGLE_API_KEY = 'AIzaSyDiBbMeQqp0ATTFmyHn6JJSujK3vV0-dcY'

    genai.configure(api_key=GOOGLE_API_KEY)
    model = genai.GenerativeModel('gemini-1.5-flash')

    response = model.generate_content(f"""
    I am looking for clothing recommendations that suit a {gender} with the following measurements:
    - Waist circumference: {waist} cm
    - Shoulder Length: {shoulder} cm
    - Height: {height} cm
    - Age: {age} years

    Please provide the recommendations in the following format:

    Top-Wear:
    - List of recommended top-wear items

    Bottom-Wear:
    - List of recommended bottom-wear items

    Fabric-Type:
    - List of recommended fabric types

    *Make sure to not include anything other than the Top-wear, bottom-wear and fabric type. Nothing else. Also give me only 3 from each category. Do not include any additional information just the type of clothes suitable
    Only use the following subheadings:
        Top-Wear:, Bottom-Wear:, Fabric-Type:

    """)

    final_response = model.generate_content(f""" 
        This is the response I got from an AI entity:
        {response}

        I want you to give me one string that just has the items in the following way:
        Given that this is the response:
        **Top-Wear:**
        - ghd
        - asd
        - gad

        **Bottom-Wear:**
        - afs
        - sad
        - asd

        **Fabric-Type:**
        - xyz
        - abc
        - def

        This should be your modified response:
        Top-Wear: ghd, asd, gad; Bottom-Wear: afs, sad, asd; Fabric-Type: xyz, abc, def

        Please dont add anything other than this string in your response.
    """)

    print("Raw response: ", final_response.text)


    def remove_parentheses(text):
        return re.sub(r'\(.*?\)', '', text)

    def remove_spaces(text):
        return "\n".join(line.replace(" ", "") for line in text.splitlines())

    # cleaned_text = response.text.replace("**", "")
    # cleaned_text = remove_parentheses(cleaned_text)
    # cleaned_text = remove_spaces(cleaned_text)
    # print("Cleaned response from Gemini:")
    # print(cleaned_text)

    # Parsing function
    import re

    def parse_response(response_text):
        Top_Wear = []


        res = response_text.split("Fabric-Type:", 1)
        Fabric_Types = res[1]

        new_text_1 = response_text.replace(("FabricType:" + Fabric_Types), "")

        res = new_text_1.split("Bottom-Wear:", 1)
        Bottom_Wear = res[1]

        new_text_2 = response_text.replace(("Bottom-Wear:" + Bottom_Wear), "")

        res = new_text_2.split("Top-Wear:", 1)
        Top_Wear = res[1]

        return Fabric_Types, Bottom_Wear, Top_Wear

    def convert_string_to_arrays(input_str):
        import re
        categories = {}

        parts = input_str.split(';')


        for part in parts:

            category, items = part.split(':')
            category = category.strip()
            items = items.strip()


            item_list = [item.strip() for item in items.split(',')]


            categories[category] = item_list


        top_wear = categories.get('Top-Wear', [])
        bottom_wear = categories.get('Bottom-Wear', [])
        fabric_type = categories.get('Fabric-Type', [])

        return top_wear, bottom_wear, fabric_type

    a1, a2, a3 = convert_string_to_arrays(final_response.text)



    def search_amazon_selenium(query):
        driver = setup_driver()
        driver.get(f"https://www.amazon.com/s?k={query}")

        results = []
        try:
            WebDriverWait(driver, 1).until(
                EC.presence_of_all_elements_located((By.CSS_SELECTOR, 'div.s-main-slot div.s-result-item'))
            )
            items = driver.find_elements(By.CSS_SELECTOR, 'div.s-main-slot div.s-result-item')

            # Limit to the first 3 items
            for item in items[:2]:
                try:
                    link = item.find_element(By.CSS_SELECTOR, 'a.a-link-normal').get_attribute('href')
                    thumbnail = item.find_element(By.CSS_SELECTOR, 'img.s-image').get_attribute('src')
                    results.append((link, thumbnail))
                except Exception as e:
                    print(f"Error processing item: {e}")
                    continue

        except Exception as e:
            print(f"Search failed: {e}")

        finally:
            driver.quit()

        return results


    def remove_elements(arr, value):
        return [element for element in arr if element != value]

    
    categories = {
        'Top-Wear': a1,
        'Bottom-Wear': a2,
        'Fabric-Type': a3,
    }


    # Search for recommended clothing items
    links = []
    thumbnails = []

    # Iterate through the parsed categories and perform searches
    for category, items in categories.items():
        if category in ["Top-Wear", "Bottom-Wear"]:
            for item in items:
                for fabric in categories["Fabric-Type"]:
                    query = f"{fabric} {item} for {gender}"
                    print(f"Searching for: {query}")
                    try:
                        search_results = search_amazon_selenium(query)
                        for link, thumbnail in search_results:
                            links.append(link)
                            thumbnails.append(thumbnail)
                    except Exception as e:
                        print(f"Error during search: {e}")

    print("\nLinks:")
    for link in links:
        print(link)

    print("\nThumbnails:")
    for thumbnail in thumbnails:
        print(thumbnail)

    with open('/Users/pavanadipuram/Workspace/Shrithan/Boost-Hacks-2/app/assets/image_urls.txt', 'w') as file:
        for url in thumbnails:
            file.write(url + '\n')
    
    with open('/Users/pavanadipuram/Workspace/Shrithan/Boost-Hacks-2/app/assets/links.txt', 'w') as file:
        for link in links:
            file.write(link + '\n')
