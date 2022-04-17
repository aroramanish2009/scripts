

fn main() {
    loop10();
    forloop();
    array_loop();
}

fn loop10(){
    let mut n = 0;
    let mut m = 0;
    'outer: loop {
        n += 1;
        println!("current value of n: {}",n);
        loop {
           m += 1;
           if n == m {
                println!("N & M values match ");
                break;
           }
        }
        if n >= 2 {
            break 'outer;
        }
    }
}
fn forloop(){
    for n in 0..5 {
        println!("say it {} times",n);
    }
}

fn array_loop(){
    let mut v = Vec::new();
    v.push(4);
    v.push(5);
    v.push(10);
    
    let b = vec![3,5,6,7,8];

    for n in v {
        println!("{}",n);
    }
    for n in b {
        println!("{}",n);
    }
}
