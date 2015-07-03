#!/bin/sh
#
# To run the server:
#
# Step 1:
#   make all
#
# Step 2:
#   OWLTOOLS_MEMORY=12G ./start-owlsim-server.sh
#
# (modifying memory as appropriate)
#
#
ONT=../src/ontology
owltools --catalog-xml $ONT/catalog-v001.xml all.owl --use-fsim  --sim-load-lcs-cache owlsim.cache --sim-load-ic-cache ic-cache.owl --start-sim-server -p 9031

