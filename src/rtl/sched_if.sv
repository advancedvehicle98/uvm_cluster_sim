interface sched_if ( input bit clk );

  logic a;

  modport cluster ( output clk, input a );
  modport scheduler ( input clk, output a );
   
endinterface
