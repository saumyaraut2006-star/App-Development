class user {
  String name;
  String email;

// constructor- special method/function which is same as class name and is used to initialise the object
  
  user(this.name, this.email); //constructor
  

}
void main(){
  user abc = user("Saumya","abc@gmail.com" );

  print("abc.email");

}