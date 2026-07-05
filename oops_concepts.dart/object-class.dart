class user{

  String name ="";
  int ID = 101;
}
void main(){
  user user1= user();
  user1.name = "Saumya";
  user1.ID = 102;

  print(user1.name);
  print(user1.ID);


  user user2= user();
  user2.name = "Manas";
  
  print(user2.name);
}