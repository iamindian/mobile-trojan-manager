import 'dart:async';
import 'package:sqljocky5/sqljocky.dart';

class Mysql {
  ConnectionSettings setting;
  MySqlConnection conn;
  ConnectionSettings getSetting(){
    if(this.setting==null)return new ConnectionSettings();
    return this.setting;
  }
  Future<List> connect(_host, _port, _username, _password, _db) async {
    this.setting = new ConnectionSettings(
        host: _host,
        port: _port,
        user: _username,
        password: _password,
        db: _db);
    return await MySqlConnection.connect(this.setting).then((_conn){
            conn = _conn;
            return [0,null];
        },onError:(e,t){
          return [1,e];
        });
  }

  Future<List> close() async {
    if(conn==null)
      return [1,'Connection not created'];
    return await conn.close().then((_) {
      return [0];
    },onError:(e,t) {
      return [1,t];
    });
  }

  Future<List> execute(executeSQL) async {
    if(conn==null)
      return [1,'Connection not created'];
    return conn.execute(executeSQL).then((_) {
      return [0];
    },onError:(e,t) {
      return [1,t];
    });
  }

  Future<List> insert(sql, values) async {
    if(conn==null)
      return [1,'Connection not created'];
    return await conn.preparedWithAll(sql, values).then((_) {
      return [0];
    },onError:(e,t) {
      return [1,t];
    });
  }
  
  Future<List> read(sql) async {
    if(conn==null)
        return [1,'Connection not created'];
    return await (await conn.execute(sql).catchError((e,t){
        return [1,'Connection not created'];
    })).deStream().then((results){
        return [0, results];
    },onError: (e,t){
        return [1, t];
    });
  }
}
