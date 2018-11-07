import 'dart:convert';

class ProvinceList{
  List<Province> list = new List<Province>();

  ProvinceList.initData(){
    list.add(Province.create("广东省", "guangdongsheng" , "G"));
    list.add(Province.create("福建省", "fujianshegn" , "F"));
    list.add(Province.create("安徽省", "anhuisheng" , "A"));
    list.add(Province.create("北京市", "beijingshi" , "B"));
    list.add(Province.create("浙江省", "zhejiangsheng" , "Z"));
    list.add(Province.create("江苏省", "jiangshusheng" , "J"));
    list.add(Province.create("江西省", "jiangxisheng" , "J"));
    list.add(Province.create("吉林省", "jilinsheng" , "J"));

    list.sort((p1, p2)=>p1.letter.compareTo(p2.letter));
  }

  Province getByCode(String code){
    print("------" + list.length.toString());
    return list.firstWhere((Province item){
      return 0 == item.code.compareTo(code)?true:false;
    }, orElse: ()=>null);
  }
}

class Province{
  String name;
  String code;
  String letter;
  List<City> listCity = new List<City>();
  
  Province(){
    
  }
  Province.create(String n, String c, String l){
    name = n;
    code = c;
    letter = l;

    initCity();
  }
  
  void addCity(City city){
    bool isExits = listCity.contains(city);
    if(!isExits){
      listCity.add(city);
      listCity.sort((c1, c2)=>c1.letter.compareTo(c2.letter));
    }
  }

  void initCity(){
    listCity.add(City.create("广州", "guagnzhoushi", "G"));
    listCity.add(City.create("深圳", "shenzhen", "S"));
    listCity.add(City.create("东莞", "dongguan", "D"));
    listCity.add(City.create("佛山", "foshan", "F"));
    listCity.add(City.create("中山", "zhongshan", "Z"));
    listCity.add(City.create("珠海", "zhuhai", "Z"));
    listCity.add(City.create("肇庆", "zhaoqing", "Z"));

    listCity.sort((c1, c2)=>c1.letter.compareTo(c2.letter));
  }

  City getByCode(String code){
    return listCity.firstWhere((City item){
      return 0 == item.cityCode.compareTo(code)?true:false;
    }, orElse: ()=>null);
  }
}

class City{
  String cityName;
  String cityCode;
  String letter;

  City(){

  }

  City.create(String n, String c, String l){
    cityCode = c;
    cityName = n;
    letter = l;
  }

  String  toString(){
    return json.encode(this);
  }
}