BOOST_ROOT		=	/usr/lib/x86_64-linux-gnu
T_SERVER_PATH	=	trafficGeneratorServer/trafficGeneratorServer/trafficGeneratorServer
T_SERVER2_PATH	=	trafficGenerator/trafficServer2
T_GEN_PATH		=	trafficGenerator/trafficGenerator
all:
	cd $(T_SERVER_PATH); BOOST_ROOT=$(BOOST_ROOT) $(MAKE)
	cd $(T_GEN_PATH); BOOST_ROOT=$(BOOST_ROOT) $(MAKE)
	cd $(T_SERVER2_PATH); BOOST_ROOT=$(BOOST_ROOT) $(MAKE)
clean:
	cd $(T_SERVER_PATH); $(MAKE) clean
	cd $(T_GEN_PATH); $(MAKE) clean
	cd $(T_SERVER2_PATH); $(MAKE) clean

