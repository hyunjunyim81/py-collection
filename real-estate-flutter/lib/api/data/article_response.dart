class ArticleResponse {
  String? code;
  bool? hasPaidPreSale;
  bool? more;
  bool? tIME;
  int? z;
  int? page;
  List<Body>? body;

  ArticleResponse(
      {this.code,
        this.hasPaidPreSale,
        this.more,
        this.tIME,
        this.z,
        this.page,
        this.body});

  ArticleResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    hasPaidPreSale = json['hasPaidPreSale'];
    more = json['more'];
    tIME = json['TIME'];
    z = json['z'];
    page = json['page'];
    if (json['body'] != null) {
      body = <Body>[];
      json['body'].forEach((v) {
        body!.add(Body.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['code'] = code;
    data['hasPaidPreSale'] = hasPaidPreSale;
    data['more'] = more;
    data['TIME'] = tIME;
    data['z'] = z;
    data['page'] = page;
    if (body != null) {
      data['body'] = body!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Body {
  String? atclNo;
  String? cortarNo;
  String? atclNm;
  String? atclStatCd;
  String? rletTpCd;
  String? uprRletTpCd;
  String? rletTpNm;
  String? tradTpCd;
  String? tradTpNm;
  String? vrfcTpCd;
  String? flrInfo;
  int? prc;
  int? rentPrc;
  String? hanPrc;
  String? spc1;
  String? spc2;
  String? direction;
  String? atclCfmYmd;
  double? lat;
  double? lng;
  String? atclFetrDesc;
  List<String>? tagList;
  String? bildNm;
  int? minute;
  int? sameAddrCnt;
  int? sameAddrDirectCnt;
  String? cpid;
  String? cpNm;
  int? cpCnt;
  String? rltrNm;
  String? directTradYn;
  int? minMviFee;
  int? maxMviFee;
  int? etRoomCnt;
  String? tradePriceHan;
  int? tradeRentPrice;
  bool? tradeCheckedByOwner;
  CpLinkVO? cpLinkVO;
  String? dtlAddrYn;
  String? dtlAddr;
  bool? isVrExposed;
  String? sameAddrHash;
  String? sameAddrMaxPrc;
  String? sameAddrMaxPrc2;
  String? sameAddrMinPrc;
  String? sameAddrMinPrc2;

  Body(
      {this.atclNo,
        this.cortarNo,
        this.atclNm,
        this.atclStatCd,
        this.rletTpCd,
        this.uprRletTpCd,
        this.rletTpNm,
        this.tradTpCd,
        this.tradTpNm,
        this.vrfcTpCd,
        this.flrInfo,
        this.prc,
        this.rentPrc,
        this.hanPrc,
        this.spc1,
        this.spc2,
        this.direction,
        this.atclCfmYmd,
        this.lat,
        this.lng,
        this.atclFetrDesc,
        this.tagList,
        this.bildNm,
        this.minute,
        this.sameAddrCnt,
        this.sameAddrDirectCnt,
        this.cpid,
        this.cpNm,
        this.cpCnt,
        this.rltrNm,
        this.directTradYn,
        this.minMviFee,
        this.maxMviFee,
        this.etRoomCnt,
        this.tradePriceHan,
        this.tradeRentPrice,
        this.tradeCheckedByOwner,
        this.cpLinkVO,
        this.dtlAddrYn,
        this.dtlAddr,
        this.isVrExposed,
        this.sameAddrHash,
        this.sameAddrMaxPrc,
        this.sameAddrMaxPrc2,
        this.sameAddrMinPrc,
        this.sameAddrMinPrc2});

  Body.fromJson(Map<String, dynamic> json) {
    atclNo = json['atclNo'];
    cortarNo = json['cortarNo'];
    atclNm = json['atclNm'];
    atclStatCd = json['atclStatCd'];
    rletTpCd = json['rletTpCd'];
    uprRletTpCd = json['uprRletTpCd'];
    rletTpNm = json['rletTpNm'];
    tradTpCd = json['tradTpCd'];
    tradTpNm = json['tradTpNm'];
    vrfcTpCd = json['vrfcTpCd'];
    flrInfo = json['flrInfo'];
    prc = json['prc'];
    rentPrc = json['rentPrc'];
    hanPrc = json['hanPrc'];
    spc1 = json['spc1'];
    spc2 = json['spc2'];
    direction = json['direction'];
    atclCfmYmd = json['atclCfmYmd'];
    lat = json['lat'];
    lng = json['lng'];
    atclFetrDesc = json['atclFetrDesc'];
    tagList = json['tagList'].cast<String>();
    bildNm = json['bildNm'];
    minute = json['minute'];
    sameAddrCnt = json['sameAddrCnt'];
    sameAddrDirectCnt = json['sameAddrDirectCnt'];
    cpid = json['cpid'];
    cpNm = json['cpNm'];
    cpCnt = json['cpCnt'];
    rltrNm = json['rltrNm'];
    directTradYn = json['directTradYn'];
    minMviFee = json['minMviFee'];
    maxMviFee = json['maxMviFee'];
    etRoomCnt = json['etRoomCnt'];
    tradePriceHan = json['tradePriceHan'];
    tradeRentPrice = json['tradeRentPrice'];
    tradeCheckedByOwner = json['tradeCheckedByOwner'];
    cpLinkVO = json['cpLinkVO'] != null
        ? CpLinkVO.fromJson(json['cpLinkVO'])
        : null;
    dtlAddrYn = json['dtlAddrYn'];
    dtlAddr = json['dtlAddr'];
    isVrExposed = json['isVrExposed'];
    sameAddrHash = json['sameAddrHash'];
    sameAddrMaxPrc = json['sameAddrMaxPrc'];
    sameAddrMaxPrc2 = json['sameAddrMaxPrc2'];
    sameAddrMinPrc = json['sameAddrMinPrc'];
    sameAddrMinPrc2 = json['sameAddrMinPrc2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['atclNo'] = this.atclNo;
    data['cortarNo'] = this.cortarNo;
    data['atclNm'] = this.atclNm;
    data['atclStatCd'] = this.atclStatCd;
    data['rletTpCd'] = this.rletTpCd;
    data['uprRletTpCd'] = this.uprRletTpCd;
    data['rletTpNm'] = this.rletTpNm;
    data['tradTpCd'] = this.tradTpCd;
    data['tradTpNm'] = this.tradTpNm;
    data['vrfcTpCd'] = this.vrfcTpCd;
    data['flrInfo'] = this.flrInfo;
    data['prc'] = this.prc;
    data['rentPrc'] = this.rentPrc;
    data['hanPrc'] = this.hanPrc;
    data['spc1'] = this.spc1;
    data['spc2'] = this.spc2;
    data['direction'] = this.direction;
    data['atclCfmYmd'] = this.atclCfmYmd;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['atclFetrDesc'] = this.atclFetrDesc;
    data['tagList'] = this.tagList;
    data['bildNm'] = this.bildNm;
    data['minute'] = this.minute;
    data['sameAddrCnt'] = this.sameAddrCnt;
    data['sameAddrDirectCnt'] = this.sameAddrDirectCnt;
    data['cpid'] = this.cpid;
    data['cpNm'] = this.cpNm;
    data['cpCnt'] = this.cpCnt;
    data['rltrNm'] = this.rltrNm;
    data['directTradYn'] = this.directTradYn;
    data['minMviFee'] = this.minMviFee;
    data['maxMviFee'] = this.maxMviFee;
    data['etRoomCnt'] = this.etRoomCnt;
    data['tradePriceHan'] = this.tradePriceHan;
    data['tradeRentPrice'] = this.tradeRentPrice;
    data['tradeCheckedByOwner'] = this.tradeCheckedByOwner;
    if (this.cpLinkVO != null) {
      data['cpLinkVO'] = this.cpLinkVO!.toJson();
    }
    data['dtlAddrYn'] = this.dtlAddrYn;
    data['dtlAddr'] = this.dtlAddr;
    data['isVrExposed'] = this.isVrExposed;
    data['sameAddrHash'] = this.sameAddrHash;
    data['sameAddrMaxPrc'] = this.sameAddrMaxPrc;
    data['sameAddrMaxPrc2'] = this.sameAddrMaxPrc2;
    data['sameAddrMinPrc'] = this.sameAddrMinPrc;
    data['sameAddrMinPrc2'] = this.sameAddrMinPrc2;
    return data;
  }
}

class CpLinkVO {
  String? cpId;
  String? mobileArticleLinkTypeCode;
  String? mobileBmsInspectPassYn;
  bool? pcArticleLinkUseAtArticleTitle;
  bool? pcArticleLinkUseAtCpName;
  bool? mobileArticleLinkUseAtArticleTitle;
  bool? mobileArticleLinkUseAtCpName;
  String? mobileArticleUrl;

  CpLinkVO(
      {this.cpId,
        this.mobileArticleLinkTypeCode,
        this.mobileBmsInspectPassYn,
        this.pcArticleLinkUseAtArticleTitle,
        this.pcArticleLinkUseAtCpName,
        this.mobileArticleLinkUseAtArticleTitle,
        this.mobileArticleLinkUseAtCpName,
        this.mobileArticleUrl});

  CpLinkVO.fromJson(Map<String, dynamic> json) {
    cpId = json['cpId'];
    mobileArticleLinkTypeCode = json['mobileArticleLinkTypeCode'];
    mobileBmsInspectPassYn = json['mobileBmsInspectPassYn'];
    pcArticleLinkUseAtArticleTitle = json['pcArticleLinkUseAtArticleTitle'];
    pcArticleLinkUseAtCpName = json['pcArticleLinkUseAtCpName'];
    mobileArticleLinkUseAtArticleTitle =
    json['mobileArticleLinkUseAtArticleTitle'];
    mobileArticleLinkUseAtCpName = json['mobileArticleLinkUseAtCpName'];
    mobileArticleUrl = json['mobileArticleUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['cpId'] = this.cpId;
    data['mobileArticleLinkTypeCode'] = this.mobileArticleLinkTypeCode;
    data['mobileBmsInspectPassYn'] = this.mobileBmsInspectPassYn;
    data['pcArticleLinkUseAtArticleTitle'] =
        this.pcArticleLinkUseAtArticleTitle;
    data['pcArticleLinkUseAtCpName'] = this.pcArticleLinkUseAtCpName;
    data['mobileArticleLinkUseAtArticleTitle'] =
        this.mobileArticleLinkUseAtArticleTitle;
    data['mobileArticleLinkUseAtCpName'] = this.mobileArticleLinkUseAtCpName;
    data['mobileArticleUrl'] = this.mobileArticleUrl;
    return data;
  }
}