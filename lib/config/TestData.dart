import 'package:flutter/material.dart';

const Color greyColor = const Color(0xFFE8E8E8);

Map<String, String> HEADERS = {
  "User-Agent":"Mozilla/5.0 (Linux; Android 8.1.0; Redmi 6 Build/O11019; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/62.0.3202.84 Mobile Safari/537.36 hap/1.1/xiaomi com.miui.hybrid/1.1.0.2 com.VIP.VIPQuickAPP/1.6.0.20180914",
  "Content-Type":"application/json; charset=utf-8",
  "Accept-Encoding":"gzip"
};

const String VIP_TOPMENU_URL = "http://rap2api.taobao.org/app/mock/8325/VIP_TOP_MENU";
const Map<String, String> VIP_TOPMENU_BODY = {"version": "v1.0.0", "channel": "00001", "token": "11111111111"};
const String VIP_TOPMAINCATE_URL = "http://rap2api.taobao.org/app/mock/8325/VIP_MAINHOME_CATE";
const Map<String, String> VIP_TOPMAINCATE_BODY = {"version": "v1.0.0", "channel": "00001", "token": "11111111111"};
const String VIP_MAINHOME_LETOUT_URL = "http://rap2api.taobao.org/app/mock/8325/VIP_MAINHOME_LETOUT";
const Map<String, String> VIP_MAINHOME_LETOUT_BODY = {"version": "v1.0.0", "channel": "00001", "token": "11111111111"};


/**
 * 字母导航
 */
const List<String> listLetter = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "#"];

/**
 * 抽屉
 */
const List drawerList = [{"name":"女装", "pic":"http://b.appsimg.com/2017/05/24/42/1495596063896.png"},
{"name":"鞋包","pic":"http://b.appsimg.com/2017/05/17/529/1495013156455.png"},
{"name":"男装", "pic":"http://b.appsimg.com/2017/05/18/261/1495112210179.png"},
{"name":"运动户外", "pic":"http://b.appsimg.com/2017/05/17/190/1495013200402.png"},
{"name":"母婴", "pic":"http://b.appsimg.com/2017/05/17/110/1495013217504.png"},
{"name":"美妆", "pic":"http://b.appsimg.com/2017/05/17/628/1495013246128.png"},
{"name":"家居家纺", "pic":"http://b.appsimg.com/2017/07/14/149/1500002216626.png"},
{"name":"数码家电", "pic":"http://b.appsimg.com/upload/momin/2018/01/02/9/1514888066921.png"},
{"name":"大家电", "pic":"http://b.appsimg.com/2017/08/08/324/1502159315729.png"},
{"name":"家具家装", "pic":"http://b.appsimg.com/2017/07/13/924/1499937377194.png"},
{"name":"手表配饰", "pic":"http://b.appsimg.com/2017/05/17/125/1495016395304.png"},
{"name":"男女内衣", "pic":"http://b.appsimg.com/2017/09/27/879/1506497529473.png"},
{"name":"唯品国际", "pic":"http://b.appsimg.com/2017/05/17/743/1495013413522.png"},
{"name":"唯风尚", "pic":"http://b.appsimg.com/2017/05/17/580/1495013458396.png"},
{"name":"唯品·奢", "pic":"http://b.appsimg.com/2017/05/17/347/1495013475742.png"},
{"name":"唯品优选", "pic":"http://b.appsimg.com/2017/11/20/540/1511177379710.png"},
{"name":"生活超市", "pic":"http://b.appsimg.com/2017/05/17/695/1495013525105.png"},
{"name":"唯品医药", "pic":"http://b.appsimg.com/upload/momin/2018/01/25/126/1516873545752.png"},
{"name":"唯品金融", "pic":"http://b.appsimg.com/2017/05/17/820/1495013565276.png"},
];

const List listAdFlow = [
  "http://h2a.appsimg.com/a.appsimg.com/upload/flow/2018/10/10/92/15391543960211.jpg",
  "http://h2a.appsimg.com/a.appsimg.com/upload/flow/2018/10/11/30/15392282415790.jpg",
  "http://h2a.appsimg.com/a.appsimg.com/upload/flow/2018/10/10/49/15391629610538.jpg",
];

const List<String> listSearchWordT = ["手机", "苹果手机", "华为手机", "PIX", "Nexus", ];

const List listRight = [{"name":"会员俱乐部", "des":"签到领10元劵"}, {"name":"我的公益", "des":"走路也能做公益"},
{"name":"唯品金融", "des":"我的小金库"},{"name":"我的口碑", "des":"填口碑赢唯品币"},];

const List listVIPAPPSetting = [{"name":"账号与安全", "des":""}, {"name":"唯品客服", "des":""},
{"name":"关于唯品会", "des":""}];



