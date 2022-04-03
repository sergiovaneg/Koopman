#include "vdp_sim.hpp"

#include <algorithm>
#include <filesystem>
#include <random>

#include <boost/numeric/odeint.hpp>

const vdp_sim::input_type
vdp_sim::interp1d(const std::vector<time>& u_t,
                const std::vector<input_type>& u,
                time t)
{
    const auto it = std::lower_bound(u_t.cbegin(),
                            u_t.cend(),
                            t);
    if (it==u_t.cend())
        return u.back();
    else if (it==u_t.cbegin())
        return u.front();
    else{
        const auto idx = std::distance(u_t.cbegin(),it);
        input_type result;
        time dt = u_t[idx]-u_t[idx-1];

        for(size_t i=0; i < result.size(); ++i)
            result[i] = u[idx-1][i]
                + ((u[idx][i]-u[idx-1][i])/dt)
                    *(t-u_t[idx-1]);
        
        return result;
    }
}

void
vdp_sim::generate_data(const std::string& dir, size_t n)
{
    std::random_device rd;
    std::mt19937 gen(rd());
    std::normal_distribution<> noise{0., 1.};
    std::uniform_real_distribution<> initial{-1.,1.};

    boost::numeric::odeint::runge_kutta4<state_type> stepper;
    auto vdp =
        [this](const state_type &x,
                state_type &dxdt,
                time t)
        {
            input_type aux = interp1d(u_t, u, t);

            dxdt[0] = 2.*x[1];
            dxdt[1] = -0.8*x[0] + 2.*x[1]
                    - 10.*x[0]*x[0]*x[1] + aux[0];
        };

    std::filesystem::create_directory(dir);

    auto print_step =
        [this](const state_type& x, const double t)
        {
            data_stream << t << ",";
            for(const auto& e : x)
                data_stream << e << ",";
            data_stream << std::endl;
        };

    for(size_t i=0; i<n; ++i){
        std::generate(u.begin(),
                    u.end(),
                    [&noise,&gen]() {
                        input_type aux;
                        for(auto& e : aux)
                            e = noise(gen);
                        return aux;
                    });
    
        data_stream.open(dir+"Input_"+std::to_string(i)+".csv");
        for(size_t j=0; j<u.size(); ++j){
            data_stream << u_t[j] << ",";
            for(const auto& e : u[j])
                data_stream << e << ",";
            data_stream << std::endl;
        }
        data_stream.close();

        state_type x0;
        std::generate(x0.begin(),x0.end(),
            [&initial, &gen](){return initial(gen);});

        data_stream.open(
            dir+"Output_"+std::to_string(i)+".csv");
        boost::numeric::odeint::
            integrate_const(stepper,
                            vdp,
                            x0,
                            0.0,
                            period,
                            ts,
                            print_step);
        data_stream.close();
    }
}