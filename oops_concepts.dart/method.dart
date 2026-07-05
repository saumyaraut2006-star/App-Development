class client{
  String name= " ";
  int ID= 101;


void greet(){
  print("Hello! my name is $name");

}
}

void main(){
  client abc = client();
  abc.name ="Saumya";

  abc.greet();
}