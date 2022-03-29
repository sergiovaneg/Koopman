use std::io;

use ode_solvers::dop853::*;
use ode_solvers::*;

use rand::{distributions::Uniform, Rng};

type State = Vector2<f64>;
type Time = f64;

struct VanDerPol {
}
impl ode_solvers::System<State> for VanDerPol {
    fn system(&self, _t:Time, x:&State, dx:&mut State){
        dx[0] = 2.*x[1];
        dx[1] = -0.8*x[0] + 2.*x[1] - 10.*x[0].powi(2)*x[1];
    }
}

fn main() {
    let mut rng = rand::thread_rng();
    let range = Uniform::<f64>::new(-1.0,1.0);

    let system = VanDerPol{};
    let x0 = State::from_vec((0..2).map(|_| rng.sample(&range)).collect());

    let mut stepper = Dop853::new(system, 0., 20., 0.01, x0, 1.0e-14, 1.0e-14);
    let res = stepper.integrate();

    match res{
        Ok(stats) => println!("Stats: {}",stats),
        Err(_) => println!("Well...shit."),
    }
}