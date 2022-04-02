#ifndef VDP_SIM_H
#define VDP_SIM_H

#include <iostream>
#include <vector>
#include <string>

#include <boost/array.hpp>

class vdp_sim
{
public:
    using input_type = boost::array<double,1>;
    using state_type = boost::array<double,2>;
    using time = double;

    vdp_sim(time _period, time _ts) :
        period{_period},
        ts{_ts} {};

    void generate_data(const std::string& dir, int n);

private:
    time period;
    time ts;

    std::vector<time> u_t;
    std::vector<input_type> u;

    const input_type
    interp1d(const std::vector<time>& u_t,
            const std::vector<input_type>& u,
            const time t);

    void
    VanDerPol(const state_type &x,
            state_type &dxdt,
            double t);
};

#endif