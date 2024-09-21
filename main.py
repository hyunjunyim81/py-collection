from selenium import webdriver
from selenium.webdriver.common.keys import Keys


print('asd')

# declare variable to store the URL to be visited
base_url="https://www.amazon.in"
# declare variable to store search term
search_term="Foundation of Software Testing by Dorothy Graham and Rex Black"
# -- Pre - Condition --
# declare and initialize driver variable
driver=webdriver.Chrome(executable_path="C:/D/PyWorkspace/amazon/drivers/chromedriver.exe")
# browser should be loaded in maximized window
driver.maximize_window()
# driver should wait implicitly for a given duration, for the element under consideration to load.
# to enforce this setting we will use builtin implicitly_wait() function of our 'driver' object.
driver.implicitly_wait(10) #10 is in seconds
# to load a given URL in browser window
driver.get(base_url)
# test whether correct URL/ Web Site has been loaded or not
assert "Amazon" in driver.title
# -- Steps --
# to enter search term, we need to locate the search textbox
searchTextBox=driver.find_element_by_id("twotabsearchtextbox")
# to clear any text in the search textbox
searchTextBox.clear()
# to enter the search term in the search textbox via send_keys() function
searchTextBox.send_keys(search_term)
# to search for the entered search term
searchTextBox.send_keys(Keys.RETURN)
# to verify if the search results page loaded
assert f"Amazon.in:{search_term}" in driver.title
# to verify if the search results page contains any results or no results were found.
assert "No results found." not in driver.page_source
# -- Post - Condition --
# to close the browser
driver.close()
