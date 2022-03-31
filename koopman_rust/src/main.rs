mod vdp_sim;

fn main() {
    let period  = 20.;
    let ts      = 0.01;
    let n       = 100;
    let dir     = "/home/sergiovaneg/Documents/Thesis/Rust_Data/";

    vdp_sim::gen_data(n, period, ts, &dir);
}