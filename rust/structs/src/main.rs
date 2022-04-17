
struct User{
    name:String,
    age:i32,
    height:i32,
    shoesize:i32,
}

impl User{
    fn simple_string(&self)->String{
        format!("{} - {} - {}cm - shoe:{}",self.name,self.age,self.height,self.shoesize)
    }

    fn grow(&mut self,h:i32){
        self.height += h;
    }
}

fn main() {
    let mut u = User{
        name:"John".to_string(),
        age:33,
        height:250,
        shoesize:10,
    };
    
    u.grow(20);
    println!("User is {}",u.simple_string());
}
