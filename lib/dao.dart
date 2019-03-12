import 'mysql.dart';
import 'dart:async';
import 'package:sqljocky5/sqljocky.dart';
import 'package:trojan_mobile_manager/user.dart';
class Dao{
  Mysql mysql;
  Dao(){
    mysql = new Mysql();
  }
  Future<int> addUser(List<List> values) async{
    return await mysql.insert('insert into users (username, password, quota) values(?, ?, ?);', values);
  }
  Future<int> delUser(String username) async{
    return await mysql.execute("delete from users where username='" + username + "';");
  }
  Future<List> lsUser() async{
    Results results = await mysql.read('select username, quota from users;');
    List list = new List();
    results.forEach((Row row){
       list.add(User(username:row[0], quota:row[1]));
    });
    return list;
  }
  Future<List> findUser(String keyword) async{
    Results results = await mysql.read("select username, quota from users where username like '%${keyword}%'");
    List list = new List();
    results.forEach((row){
       list.add(User(username:row[0], quota:row[1]));
    });
    return list;
  }
  Future<int> connect(_host,_port,_username,_password,_db) async{
    return await mysql.connect(_host, _port, _username, _password, _db);
  }
  Future<void> close() async {
    return await mysql.close();
  }
}