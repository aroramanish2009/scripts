
use std::env::args;

fn main() {
    for a in args(){
        if let Some(c) = a.chars().next() {
            println!("{} {}",a,c);
            match c {
                'w'|'W' => println!("hello {}", a),
                _=>{}
            }
        }
    }
}
