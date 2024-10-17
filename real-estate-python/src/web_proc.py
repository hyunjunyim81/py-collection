import requests
from bs4 import BeautifulSoup
import json

import src.user_agent as UA
import src.model as Model

#import parse.naver_real_estate as nparser

class WebProc:
    def __init__(self):
        pass
    
    def run(self):
        self.searchResult = self.searchResult(gu='강남구', dong='대치동')
        if self.searchResult is None:
            print('searchResult is empty - error')
            return
        
        self.articles = self.clusterList(self.searchResult)
        if len(self.articles) == 0:
            print('articles is empty - error')
            return
        
        self.articleList(self.articles)
        
    
    def searchResult(self, gu, dong):
        self.searchUrl = "https://m.land.naver.com/search/result/{}".format(F'{gu} {dong}')
        response = requests.get(self.searchUrl, headers=UA.defaultHeaders)
        response.raise_for_status()
        print(F'{self.searchUrl} : {response.status_code} ')
        soup = (BeautifulSoup(response.text, "html.parser"))
        #print(soup.prettify())
        
        #INSTALL_PATH = os.path.dirname(sys.argv[0])
        #self.dump(os.path.join(INSTALL_PATH, 'search_result.dump'), soup.prettify())
        searchResult = None
        scripts = soup.findAll('script')
        for script in scripts:
            if script.string is None:
                continue
            if script.string.__contains__("filter:"):
                #print(script.string)
                searchResult = Model.NaverSearchResult.from_dict(script.string)
                break
        
        print('searchResult complete')
        return searchResult
        
    def clusterList(self, searchResult):
        # self.remakedURL = "https://m.land.naver.com/cluster/clusterList?view=atcl&cortarNo={}&rletTpCd={}&tradTpCd={}&z={}&lat={}&lon={}&btm={}&lft={}&top={}&rgt={}".format(
        #     searchResult.cortarNo, searchResult.rletTpCds, searchResult.tradTpCds, 
        #     searchResult.z, searchResult.lat, searchResult.lon, 
        #     searchResult.btm, searchResult.lft, searchResult.top, searchResult.rgt)
        
        self.clusterURL = 'https://m.land.naver.com/cluster/clusterList?view=atcl&cortarNo=1168010600&rletTpCd=SG%3ASMS&tradTpCd=A1%3AB1&z=14&lat=37.49911&lon=127.065463&btm=37.4755795&lft=127.0500135&top=37.5226331&rgt=127.0809125&pCortarNo=14_1168010600&addon=COMPLEX&bAddon=COMPLEX&isOnlyIsale=false'

        response = requests.get(self.clusterURL,  headers=UA.defaultHeaders)
        json_str = json.loads(json.dumps(response.json()))
        articles = []
        for jsonObject in json_str['data']['ARTICLE']:
            articles.append(Model.Article.from_dict(jsonObject, searchResult))
            #print(F'{jsonObject} :')
        
        #print(F'{self.clusterURL} : {json_str} ')    
        return articles
        
    def articleList(self, articles):
        self.articleInfoList = []
        for article in articles:
            for url in article.urls:
                response = requests.get(url,  headers=UA.defaultHeaders)
                json_str = json.loads(json.dumps(response.json()))
                print(F'{url} : {json_str} ')
                for jsonObject in json_str['body']:
                    self.articleInfoList.append(Model.ArticleBody.from_dict(jsonObject))
                
                
        print(F'articleList complete')
                
        