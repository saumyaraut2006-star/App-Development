

void main()async {

print("Welcome to Food Delivery App!");
print("Restaurant: Pizza Hub");


 String CustomerName = "Saumya";
 int age = 20;
 double walletBalance = 500.50;
 bool isPremiumUser = true;


 List<String> menu = ["Pizza", "Burger", "Pasta"];


Map<String, int> prices = {
  "Pizza": 299,
  "Burger": 149,
  "Pasta": 199
};

print("Menu:");

for (String item in menu) {
  print("$item - Rs ${prices[item]}");
}

print("");

OrderFood("Pizza");


print("\nOrder Details:");
print("Customer : $CustomerName");
print("Item : Pizza");
print("Price : Rs ${prices["Pizza"]}\n");

  checkBalance(walletBalance);

  //Create object
  Customer cus = Customer("Saumya",20);
  cus.displayInfo();

  //async-await
  await processPayment();

  print("\nOrder Delivered");
}

//function
void OrderFood(String item){
  print("Adding $item to the cart");
}

void checkBalance(double balance){
  if(balance>=299){
    print("Order Placed");
  }else{
    print("Insufficient Balance");
  }
  }

  //Customer object
  class Customer{
    String name;
    int age;
    Customer(this.name, this.age);
    void displayInfo(){
      print("Customer: $name");
      print("Age: $age");
    }
  }

  //Payment
  Future <void> processPayment() async{
    print("Payment Processing..");
    await Future.delayed(Duration(seconds:2));
    print("Payment Successfull");

  }



