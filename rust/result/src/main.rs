use std::collections::HashMap;


fn main() {
    println!("Hello, world!");

    let mut hm = HashMap::new();

    hm.insert(3, "Hello");
    hm.insert(5, "world");

    let r = match hm.get(&3) {
        Some(v)=>v,
        _=>"NOTHING",
    };

    println!("{}",r);
}
