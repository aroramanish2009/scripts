
fn main() {
    let b = highest(4,2,8);
    let c = justmath(5, 9);
    println!("{} is highest",b);
    println!("{} is value of c",c);

}

fn highest(a:i32,b : u32, c : i8)->i32 {
    let mut res = a;
    if b as i32 > res {
        res = b as i32;
    }
    
    if c as i32 > res {
        res = c as i32;
    }

    res
}

fn justmath(a:i32, b:i32)->i32 {
    let mut c = a + b;
    c = c % 4;
    c = c / 2;
    c += 1;

    c
}
