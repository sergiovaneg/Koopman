#include "vdp_sim.hpp"

#include <algorithm>
#include <boost/numeric/odeint.hpp>

const vdp_sim::input_type
vdp_sim::interp1d(const std::vector<time>& u_t,
                const std::vector<input_type>& u,
                const time t)
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
        vdp_sim::input_type result;
        vdp_sim::time dt = u_t[idx]-u_t[idx-1];
        for(size_t i=0; i < result.size(); ++i)
            result[i] = u[idx-1][i]
                + ((u[idx][i]-u[idx-1][i])/dt)
                    *(t-(u_t[idx]-u[idx-1][i]));
    }
}

void
vdp_sim::generate_data(const std::string& dir, int n)
{

}