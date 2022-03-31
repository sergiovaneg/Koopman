mod vdp_sim;

use std::env;

fn main() {
    let args    : Vec<String>   = env::args().collect();
    let dir     : &str          =
        if args.len()>=2    {&args[1]}
        else                {"/home/sergiovaneg/Documents/Thesis/Rust_Data/"};

    let period  = 20.;
    let ts      = 0.01;
    let n       = 100;

    vdp_sim::gen_data(n, period, ts, dir);
}