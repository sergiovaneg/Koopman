use ode_solvers::dop853::*;
use ode_solvers::*;

use rand::{distributions::Uniform, Rng};
use rand_distr::Normal;

type State = Vector2<f64>;
type Time = f64;

struct VanDerPol {
    u_t: Vec<f64>,
    u: Vec<f64>,
    ts: f64,
}
impl ode_solvers::System<State> for VanDerPol {
    fn system(&self, t:Time, x:&State, dx:&mut State){
        let idx = self.u_t.iter().position(|&x| (x-t).abs() < self.ts/2.);
        let aux = self.u[idx.unwrap()];
        dx[0] = 2.*x[1];
        dx[1] = -0.8*x[0] + 2.*x[1] - 10.*x[0].powi(2)*x[1] + aux;
    }
}

fn main() {
    let period = 20.;
    let ts = 0.01;
    let samples = (period/ts) as i64;

    let mut rng = rand::thread_rng();
    let range = Uniform::<f64>::new(-1.,1.);
    let noise = Normal::<f64>::new(0.,1.).unwrap();

    let system = VanDerPol{u_t: (0..=samples).map(|t| (t as f64)*ts).collect(),
                            u: (0..=samples).map(|_| rng.sample(&noise)).collect(),
                            ts: ts};
    for t in &system.u{
        println!("{}",t);
    }
    let x0 = State::from_vec((0..2).map(|_| rng.sample(&range)).collect());

    let mut stepper = Dop853::new(system, 0., 20., 0.01, x0, 1.0e-14, 1.0e-14);
    let res = stepper.integrate();

    match res{
        Ok(stats) => println!("Stats: {}",stats),
        Err(_) => println!("Well...shit."),
    }
}