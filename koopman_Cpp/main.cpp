#include <string>

#include "vdp_sim.hpp"

int main(int argc, char** argv){
    std::string dir = (argc>1) ? argv[1] : "/home/sergiovaneg/Documents/Thesis/Cpp_Data/";

    vdp_sim::time period = 20.;
    vdp_sim::time ts = 1e-2;
    int n = 100;

    vdp_sim simulator{period,ts};
    simulator.generate_data(dir,n);

    return 0;
}