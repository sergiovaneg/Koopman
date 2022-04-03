use ode_solvers::rk4::*;
use ode_solvers::*;

use rand::{distributions::Uniform, Rng};
use rand_distr::Normal;

use std::fs::{File,create_dir_all};
use std::io::Write;
use std::path::Path;

type State = Vector2<f64>;
type Time = f64;

struct VanDerPol {
    u_t: Vec<f64>,
    u: Vec<f64>
}
impl ode_solvers::System<State> for VanDerPol {
    fn system(&self, t:Time, x:&State, dx:&mut State){
        // Interpolation
        let aux = interpolate(&self.u_t, &self.u, t);

        dx[0] = 2.*x[1];
        dx[1] = -0.8*x[0] + 2.*x[1] - 10.*x[0].powi(2)*x[1] + aux;
    }
}

fn interpolate(x: &Vec<f64>, y: &Vec<f64>, t: f64) -> f64
{
    let i = x.iter().position(|&z| z>=t);
    let aux;
    if i==None {aux = y[y.len()-1];}
    else {
        let j = i.unwrap();
        if j==0 {aux = y[0];}
        else {
            aux = y[j-1] + ((y[j]-y[j-1])/(x[j]-x[j-1])) * (t-x[j-1]);
        }
    }

    aux
}

fn print_input(path: &Path, idx: i32, u: &Vec<f64>)
{
    let mut input_file = File::create(
        std::format!("{}input_{}.csv",path.to_str().unwrap(), idx)
    ).unwrap();

    for i in u{
        input_file.write_fmt(format_args!("{}\n", i)).unwrap();
    }
}

fn print_output(path: &Path, idx: i32, x: &Vec<Time>, y: &Vec<State>, y0: &State)
{
    let mut time_file = File::create(
        std::format!("{}time_{}.csv",path.to_str().unwrap(),idx)
    ).unwrap();
    time_file.write_fmt(format_args!("0\n")).unwrap();

    let mut state_file = File::create(
        std::format!("{}states_{}.csv",path.to_str().unwrap(),idx)
    ).unwrap();
    for j in y0{
        state_file.write_fmt(format_args!("{},", j)).unwrap();
    }
    state_file.write_fmt(format_args!("\n")).unwrap();

    for i in 1..x.len(){
        time_file.write_fmt(format_args!("{}\n", x[i])).unwrap();
        for j in &y[i]{
            state_file.write_fmt(format_args!("{},", j)).unwrap();
        }
        state_file.write_fmt(format_args!("\n")).unwrap();
    }
}

pub fn gen_data(n: i32, per: f64, ts: f64, dir: &str) {
    let samples = (per/ts) as i32;

    let mut rng = rand::thread_rng();
    let range = Uniform::<f64>::new(-1.,1.);
    let noise = Normal::<f64>::new(0.,1.).unwrap();

    let path = Path::new(dir);
    create_dir_all(path).unwrap();

    for i in 0..n {
        let system = VanDerPol{u_t: (0..=samples).map(|t| (t as f64)*ts).collect(),
                                u: (0..=samples).map(|_| rng.sample(&noise)).collect()};
        let y0 = State::from_vec((0..2).map(|_| rng.sample(&range)).collect());
        
        print_input(&path, i, &system.u);
        
        let mut stepper = Rk4::new(system, 0., y0, per, ts);
        let res = stepper.integrate();

        match res{
            Ok(stats) => {
                println!("{}", stats);
                print_output(&path, i, &stepper.x_out(), &stepper.y_out(), &y0);
            }
            Err(_) => println!("Well...shit."),
        }
    }
}