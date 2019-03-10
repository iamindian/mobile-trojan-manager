import "package:test/test.dart";
import "../lib/dao.dart";
void main() async {
  Dao dao = new Dao();
  setUp(() async{
      await dao.connect('host', 3306, 'username', 'password!', 'database');
  });
  
  test("test add user",() async{
    expect(await dao.addUser([['username','password',-1]]),equals(0));
  });


  test("test ls user",() async{
    List list = await dao.lsUser();
    expect(list.length,equals(1));
  });


  test("test find user",() async{
    List list = await dao.lsUser();
    expect(list.length,equals(1));
  });


  test("test del user",() async{
    expect(await dao.delUser('username'),equals(0));
  });


  tearDown(() async{
    await dao.close();
  });

}