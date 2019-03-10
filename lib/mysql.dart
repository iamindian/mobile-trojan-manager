import 'dart:async';
import 'package:sqljocky5/sqljocky.dart';

class Mysql {
  String host, username, password, db;
  int port;
  MySqlConnection conn;
  
  Future<int> connect(_host, _port, _username, _password, _db) async {
    return await MySqlConnection.connect(new ConnectionSettings(
        host: _host,
        port: _port,
        user: _username,
        password: _password,
        db: _db)).then((_conn){
            conn = _conn;
            return 0;
        }).catchError((e){
            return 1;
        });
  }

  Future<int> close() async {
    return await conn.close().then((_) {
      return 0;
    }).catchError((e) {
      return 1;
    });
  }

  Future<int> execute(executeSQL) async {
    return conn.execute(executeSQL).then((_) {
      return 0;
    }).catchError((e) {
      return 1;
    });
  }

  Future<int> insert(sql, values) async {
    return await conn.preparedWithAll(sql, values).then((_) {
      return 0;
    }).catchError((e) {
      print(e.toString());
      return 1;
    });
  }
  
  Future<Results> read(sql) async {
    return await (await conn.execute(sql)).deStream();
  }
}
