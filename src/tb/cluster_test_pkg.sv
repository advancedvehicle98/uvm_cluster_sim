`include "uvm_macros.svh"


package cluster_test_pkg;

   
import uvm_pkg::*;

  
class cluster_base_test extends uvm_test;
   
  `uvm_component_utils( cluster_base_test )

  cluster_env         env;
  cluster_config      cfg;
  cluster_agent       c_agent;
  cluster_node_agents cnode_agents; 

  function new ( string name, uvm_component parent );
	super.new( name, parent );
  endfunction : new

  function void build_phase ( uvm_phase phase );
  endfunction : build_phase
   
endclass : cluster_base_test
   

endpackage : cluster_test_pkg
