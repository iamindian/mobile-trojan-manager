import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:pointycastle/api.dart';

import 'mysql.dart';
import 'dart:async';
import 'package:sqljocky5/sqljocky.dart';
import 'package:trojan_mobile_manager/user.dart';
class Dao{
  Mysql mysql;
  Dao(){
    mysql = new Mysql();
  }
  ConnectionSettings getSetting(){
    return mysql.getSetting();
  }
  Future<List> addUser(List<List> values) async{
    Digest sha224 = new Digest('SHA-224');
    values.forEach((row){
      String str = row[0]+':'+row[1];
      row[1] = hex.encode(sha224.process(Uint8List.fromList(str.codeUnits)));
      print(row[1]);
    });
    return await mysql.insert('insert into users (username, password, quota) values(?, ?, ?);', values);
  }
  Future<List> delUser(String username) async{
    return await mysql.execute("delete from users where username='" + username + "';");
  }
  Future<List> lsUser() async{
    List r= await mysql.read('select username, quota from users;');
    if(r[0]==1){
      return r;
    }
    List list = new List();
    r[1].forEach((Row row){
       list.add(User(username:row[0], quota:row[1]));
    });
    return [0,list];
  }
  Future<List> findUser(String keyword) async{
    List r = await mysql.read("select username, quota from users where username like '%${keyword}%'");
    if(r[0]==1){
      return r;
    }
    List list = new List();
    r[1].forEach((row){
       list.add(User(username:row[0], quota:row[1]));
    });
    return [0,list];
  }
  Future<List> connect(_host,_port,_username,_password,_db) async{
    return await mysql.connect(_host, _port, _username, _password, _db);
  }
  Future<void> close() async {
    return await mysql.close();
  }
}