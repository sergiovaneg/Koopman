CXX			= g++
CC			= g++
CXXFLAGS	= -g -Wall
SRCS		= main.cpp vdp_sim.cpp
OBJS		= $(SRCS:.cpp=.o)
HEADERS		= $(wildcard *.hpp)
EXEC		= main
.PHONY		= all

all: $(EXEC)

clean:
	$(RM) $(EXEC) $(OBJS)

$(EXEC): $(OBJS)
$(OBJS): $(SRCS) $(HEADERS)