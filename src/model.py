from typing import List
from typing import Any
from dataclasses import dataclass
import json
import math

@dataclass
class NaverSearchResult:
    lat: float
    lon: float
    z: float
    cortarNo: str
    cortarNm: str
    lat_margin: float
    lon_margin: float
    btm: float
    lft: float
    top: float
    rgt: float
    rletTpCds: str
    tradTpCds: str
    
    @staticmethod
    def from_dict(obj: Any) -> 'NaverSearchResult':
        _value = obj.split("filter: {")[1].split("}")[0].replace(" ","").replace("'","")
        _lat = _value.split("lat:")[1].split(",")[0]
        _lon = _value.split("lon:")[1].split(",")[0]
        _z = _value.split("z:")[1].split(",")[0]
        _cortarNo = _value.split("cortarNo:")[1].split(",")[0]
        _cortarNm = _value.split("cortarNm:")[1].split(",")[0]
        # lat - btm : 37.550985 - 37.4331698 = 0.1178152
        # top - lat : 37.6686142 - 37.550985 = 0.1176292
        _lat_margin = 0.118

        # lon - lft : 126.849534 - 126.7389841 = 0.1105499
        # rgt - lon : 126.9600839 - 126.849534 = 0.1105499
        _lon_margin = 0.111
        _btm = float(_lat) - _lat_margin
        _lft = float(_lon) - _lon_margin
        _top = float(_lat) + _lat_margin
        _rgt = float(_lon) + _lon_margin
        _rletTpCds = 'SG'
        _tradTpCds = 'A1:B1:B2'
        
        return NaverSearchResult(_lat, _lon, _z, _cortarNo, _cortarNm, _lat_margin, _lon_margin, _btm, _lft, _top, _rgt, _rletTpCds, _tradTpCds)
        
@dataclass
class Article:
    lgeo: str
    count: int
    z: int
    lat: float
    lon: float
    psr: float
    tourExist: bool
    len_pages: int
    urls : List[str]

    @staticmethod
    def from_dict(obj: Any, searchResult: NaverSearchResult) -> 'Article':
        _lgeo = str(obj.get("lgeo"))
        _count = int(obj.get("count"))
        _z = int(obj.get("z"))
        _lat = float(obj.get("lat"))
        _lon = float(obj.get("lon"))
        _psr = float(obj.get("psr"))
        _tourExist = bool(obj.get("tourExist"))
        _len_pages = _count / 20 + 1
        _urls = []
        for idx in range(1, math.ceil(_len_pages)):
            _urls.append("https://m.land.naver.com/cluster/ajax/articleList?""itemId={}&mapKey=&lgeo={}&showR0=&" \
                "rletTpCd={}&tradTpCd={}&z={}&lat={}&""lon={}&totCnt={}&cortarNo={}&page={}"\
                .format(_lgeo, _lgeo, searchResult.rletTpCds, searchResult.tradTpCds, 
                        _z, _lat, _lon, _count, searchResult.cortarNo, idx))
            
        return Article(_lgeo, _count, _z, _lat, _lon, _psr, _tourExist, _len_pages, _urls)
            

@dataclass
class CpLinkVO:
    cpId: str
    mobileArticleLinkTypeCode: str
    mobileBmsInspectPassYn: str
    pcArticleLinkUseAtArticleTitle: bool
    pcArticleLinkUseAtCpName: bool
    mobileArticleLinkUseAtArticleTitle: bool
    mobileArticleLinkUseAtCpName: bool

    @staticmethod
    def from_dict(obj: Any) -> 'CpLinkVO':
        _cpId = str(obj.get("cpId"))
        _mobileArticleLinkTypeCode = str(obj.get("mobileArticleLinkTypeCode"))
        _mobileBmsInspectPassYn = str(obj.get("mobileBmsInspectPassYn"))
        _pcArticleLinkUseAtArticleTitle = bool(obj.get("pcArticleLinkUseAtArticleTitle"))
        _pcArticleLinkUseAtCpName = bool(obj.get("pcArticleLinkUseAtCpName"))
        _mobileArticleLinkUseAtArticleTitle = bool(obj.get("mobileArticleLinkUseAtArticleTitle"))
        _mobileArticleLinkUseAtCpName = bool(obj.get("mobileArticleLinkUseAtCpName"))
        return CpLinkVO(_cpId, _mobileArticleLinkTypeCode, _mobileBmsInspectPassYn, _pcArticleLinkUseAtArticleTitle, _pcArticleLinkUseAtCpName, _mobileArticleLinkUseAtArticleTitle, _mobileArticleLinkUseAtCpName)

@dataclass
class ArticleBody:
    atclNo: str
    cortarNo: str
    atclNm: str
    atclStatCd: str
    rletTpCd: str
    uprRletTpCd: str
    rletTpNm: str
    tradTpCd: str
    tradTpNm: str
    vrfcTpCd: str
    flrInfo: str
    prc: int
    rentPrc: int
    hanPrc: str
    spc1: str
    spc2: str
    direction: str
    atclCfmYmd: str
    lat: float
    lng: float
    atclFetrDesc: str
    tagList: List[str]
    bildNm: str
    minute: int
    sameAddrCnt: int
    sameAddrDirectCnt: int
    sameAddrHash: str
    sameAddrMaxPrc: str
    sameAddrMaxPrc2: str
    sameAddrMinPrc: str
    sameAddrMinPrc2: str
    cpid: str
    cpNm: str
    cpCnt: int
    rltrNm: str
    directTradYn: str
    minMviFee: int
    maxMviFee: int
    etRoomCnt: int
    tradePriceHan: str
    tradeRentPrice: int
    tradeCheckedByOwner: bool
    cpLinkVO: CpLinkVO
    dtlAddrYn: str
    dtlAddr: str
    isVrExposed: bool

    @staticmethod
    def from_dict(obj: Any) -> 'ArticleBody':
        _atclNo = str(obj.get("atclNo"))
        _cortarNo = str(obj.get("cortarNo"))
        _atclNm = str(obj.get("atclNm"))
        _atclStatCd = str(obj.get("atclStatCd"))
        _rletTpCd = str(obj.get("rletTpCd"))
        _uprRletTpCd = str(obj.get("uprRletTpCd"))
        _rletTpNm = str(obj.get("rletTpNm"))
        _tradTpCd = str(obj.get("tradTpCd"))
        _tradTpNm = str(obj.get("tradTpNm"))
        _vrfcTpCd = str(obj.get("vrfcTpCd"))
        _flrInfo = str(obj.get("flrInfo"))
        _prc = int(obj.get("prc"))
        _rentPrc = int(obj.get("rentPrc"))
        _hanPrc = str(obj.get("hanPrc"))
        _spc1 = str(obj.get("spc1"))
        _spc2 = str(obj.get("spc2"))
        _direction = str(obj.get("direction"))
        _atclCfmYmd = str(obj.get("atclCfmYmd"))
        _lat = float(obj.get("lat"))
        _lng = float(obj.get("lng"))
        _atclFetrDesc = str(obj.get("atclFetrDesc"))
        _tagList = obj.get("tagList")#[str.from_dict(y) for y in obj.get("tagList")]
        _bildNm = str(obj.get("bildNm"))
        _minute = int(obj.get("minute"))
        _sameAddrCnt = int(obj.get("sameAddrCnt"))
        _sameAddrDirectCnt = int(obj.get("sameAddrDirectCnt"))
        _sameAddrHash = str(obj.get("sameAddrHash"))
        _sameAddrMaxPrc = str(obj.get("sameAddrMaxPrc"))
        _sameAddrMaxPrc2 = str(obj.get("sameAddrMaxPrc2"))
        _sameAddrMinPrc = str(obj.get("sameAddrMinPrc"))
        _sameAddrMinPrc2 = str(obj.get("sameAddrMinPrc2"))
        _cpid = str(obj.get("cpid"))
        _cpNm = str(obj.get("cpNm"))
        _cpCnt = int(obj.get("cpCnt"))
        _rltrNm = str(obj.get("rltrNm"))
        _directTradYn = str(obj.get("directTradYn"))
        _minMviFee = int(obj.get("minMviFee"))
        _maxMviFee = int(obj.get("maxMviFee"))
        _etRoomCnt = int(obj.get("etRoomCnt"))
        _tradePriceHan = str(obj.get("tradePriceHan"))
        _tradeRentPrice = int(obj.get("tradeRentPrice"))
        _tradeCheckedByOwner = bool(obj.get("tradeCheckedByOwner"))
        _cpLinkVO = CpLinkVO.from_dict(obj.get("cpLinkVO"))
        _dtlAddrYn = str(obj.get("dtlAddrYn"))
        _dtlAddr = str(obj.get("dtlAddr"))
        _isVrExposed = bool(obj.get("isVrExposed"))
        return ArticleBody(_atclNo, _cortarNo, _atclNm, _atclStatCd, _rletTpCd, _uprRletTpCd, _rletTpNm, _tradTpCd, _tradTpNm, _vrfcTpCd, _flrInfo, _prc, _rentPrc, _hanPrc, _spc1, _spc2, _direction, _atclCfmYmd, _lat, _lng, _atclFetrDesc, _tagList, _bildNm, _minute, _sameAddrCnt, _sameAddrDirectCnt, _sameAddrHash, _sameAddrMaxPrc, _sameAddrMaxPrc2, _sameAddrMinPrc, _sameAddrMinPrc2, _cpid, _cpNm, _cpCnt, _rltrNm, _directTradYn, _minMviFee, _maxMviFee, _etRoomCnt, _tradePriceHan, _tradeRentPrice, _tradeCheckedByOwner, _cpLinkVO, _dtlAddrYn, _dtlAddr, _isVrExposed)
