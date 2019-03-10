class User {
  String username;
  int quota;
  User({this.username, this.quota});
  static List<User> getUsers() {
    return <User>[
      User(username: 'Darren', quota: 100),
      User(username: 'Felix', quota: 100),
      User(username: 'Deekoo', quota: 100),
    ];
  }
}