import 'package:sqljocky5/sqljocky.dart';

import 'dao.dart';
import 'dart:async';

class Service {
  Dao dao;
  
  Service() {
    dao = new Dao();
  }
  ConnectionSettings getSetting(){
      return dao.getSetting();
  }
  Future<List> addUser(username, password, quota) async {
    return await dao.addUser([[username, password, quota]]);
  }
  Future<List> delUser(username) async {
    return await dao.delUser(username);
  }
  Future<List> listUser() async {
    return await dao.lsUser();
  }
  Future<List> connect(_host,_port,_username,_password,_db) async {
    return await dao.connect(_host, _port, _username, _password, _db);
  }
  Future<List> findUser(keyword) async {
      return await dao.findUser(keyword);
  }

  Future<void> close() async{
    return await dao.close();
  }
}
