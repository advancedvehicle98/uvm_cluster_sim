`include "uvm_macros.svh"


module tb 
#(
  parameter SCHEDULER = "NONE",
  parameter TIME_STEP = 5
);

  import uvm_pkg::*;

  bit clk;

  initial begin
	clk <= 0;
    #5ns;
	forever #5ns clk <= ! clk;
  end
   
  cluster_if cif ( clk );
  sched_if sif ( clk );
   
  cluster c ( 
    .ext_if( cif.server ),
	.sch_if( sif.cluster )
  );

  generate case ( SCHEDULER )
  default: scheduler_none s ( .ext_if( sif.scheduler ) );
  endcase endgenerate

  initial begin
	uvm_config_db#( virtual cluster_if )::set(
	  .cntxt     ( null                  ), 
      .inst_name ( "cluster_test" ), 
	  .field_name( "cof"       ), 
      .value     ( cif         )
	);

	uvm_config_db#( virtual cluster_if )::set(
	  .cntxt     ( null                  ), 
      .inst_name ( "cluster_test" ), 
	  .field_name( "cof"       ), 
      .value     ( cif         )
	);

	run_test();
  end
   
endmodule
