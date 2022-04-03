#ifndef VDP_SIM_H
#define VDP_SIM_H

#include <cmath>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

#include <boost/array.hpp>

class vdp_sim
{
public:
    using input_type = boost::array<double,1>;
    using state_type = boost::array<double,2>;
    using time = double;

    vdp_sim(time _period, time _ts) :
        period{_period},
        ts{_ts}
    {
        size_t K = std::ceil(period/ts);
        u_t = std::vector<time>(K);

        double t = 0.;
        std::generate(u_t.begin(),
                    u_t.end(),
                    [&t, _ts] () {return t+=_ts;});

        u = std::vector<input_type>(K);
    }

    void generate_data(const std::string& dir, size_t n);

private:
    time period;
    time ts;

    std::vector<time> u_t;
    std::vector<input_type> u;

    std::ofstream data_stream; 

    const input_type
    interp1d(const std::vector<time>& u_t,
            const std::vector<input_type>& u,
            const time t);
};

#endif