module cluster

import node_desc_pkg::node_desc;
 
  
#(
  int NODE_COUNT = 10
)
   
(
  cluster_if.server ext_if,
  sched_if.cluster  sch_if
);
   
  genvar i;
  generate for ( i = 0; i < NODE_COUNT; ++i ) 
  begin : nodes
	node_if nif ( ext_if.clk );
	node_param_if npif ();

	node_desc ndesc = new;
	 
	node n ( 
      .ext_if( nif.node ),
	  .param_if( npif.get )
    );

	initial begin
	  assert ( ndesc.randomize() );
	  npif.total_ram = ndesc.total_ram;
	end
  end : nodes
  endgenerate

endmodule : cluster
