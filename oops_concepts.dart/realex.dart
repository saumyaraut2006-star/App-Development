class User{
  String username;
  String password;

  User(this.username, this.password);

  bool login(){
    return username=="admin" && password=="1244";
  }
}

void main(){
  User user = User("admin", "1244");
  if (user.login()){
print("Login successfull");
  }else{
print("Login failed");
  }
  }
