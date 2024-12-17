import 'package:final_project/Models/user.dart';
import 'package:mysql1/mysql1.dart';

var _conn;


Future<void> connectToMyDB() async {
  var settings = new ConnectionSettings(
      host: '10.0.2.2',
      port: 3306,
      user: 'root',
      db: 'ahmad12'
  );
  _conn = await MySqlConnection.connect(settings);
}



Future<void> showUsers() async {

  connectToMyDB();

  // Query the database using a parameterized query
  var results = await _conn.query(
    'select * from users',);
  for (var row in results) {
    print('userID: ${row[0]}, firstName: ${row[1]} lastName: ${row[2]}');
  }
}




Future<void> insertUser(user user) async {

  connectToMyDB();

  var result = await _conn.query(
      'insert into users (firstName, password, secondName,email,phoneNumber,userTypeID) values (?, ?,?,?,?,?)',
      [user.firstName, user.password,user.secondName,user.email,user.phoneNumber,user.userTypeID]);
  // var result = await _conn.query(query);
  // print(query);
  print('Inserted row id=${result.insertId}');


  //////////


  //  // Query the database using a parameterized query
  // var results = await _conn.query(
  //      'select * from users where userID = ?', [6]);  // [result.insertId]
  //  for (var row in results) {
  //   print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
  // }
  //
  // // Update some data
  // await _conn.query('update users set firstName=? where userID=?', ['Bob', 5]);
  //
  //  // Query again database using a parameterized query
  //  var results2 = await _conn.query(
  //      'select * from users where userID = ?', [result.insertId]);
  //  for (var row in results2) {
  //   print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
  // }
  //

  //Finally, close the connection
  await _conn.close();

}