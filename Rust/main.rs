use ode_solvers::rk4::*;
use ode_solvers::*;

use rand::{distributions::Uniform, Rng};
use rand_distr::Normal;

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

fn main() {
    let period = 20.;
    let ts = 0.01;
    let samples = (period/ts) as i64;

    let mut rng = rand::thread_rng();
    let range = Uniform::<f64>::new(-1.,1.);
    let noise = Normal::<f64>::new(0.,1.).unwrap();

    let system = VanDerPol{u_t: (0..=samples).map(|t| (t as f64)*ts).collect(),
                            u: (0..=samples).map(|_| rng.sample(&noise)).collect()};
    let x0 = State::from_vec((0..2).map(|_| rng.sample(&range)).collect());

    let mut stepper = Rk4::new(system, 0., x0, period, ts);
    let res = stepper.integrate();

    match res{
        Ok(stats) => println!("Stats: {}",stats),
        Err(_) => println!("Well...shit."),
    }
}