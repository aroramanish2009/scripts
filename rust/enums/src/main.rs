
#[derive(Debug)]
enum IpAddr {
    V4(String),
    V6(String),
}

fn plus_one(x: Option<i32>) -> Option<i32> {
    match x {
        None => None,
        Some(i) => Some(i + 1),
    }
}

fn main() {
    let home_v4 = IpAddr::V4(String::from("127.0.0.1"));
    let home_v6 = IpAddr::V6(String::from("::1"));

    println!("Loopback IPv4 is {:?} and IPv6 is {:?}",home_v4,home_v6);
    
    let mynum = Some(5);
    let add_1 = plus_one(mynum);
    println!("The plus one for {:?} is {:?}",mynum,add_1);
}
