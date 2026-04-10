interface cluster_if( input bit clk );

  logic a;
  
  modport client ( output clk, input a );
  modport server ( input clk, output a );
   
endinterface
