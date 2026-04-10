config cluster_config;
   
  design tb_lib.tb;
  default liblist tb_lib rtl_lib;

  localparam SCHEDULER = "NONE";
  localparam TIME_STEP = 5;

  instance tb use #(
	.SCHEDULER( SCHEDULER ),
	.TIME_STEP( TIME_STEP )
  );
   
  localparam NODE_COUNT = 10;

  instance tb.c use #(
    .NODE_COUNT( NODE_COUNT )
  );

  
   
endconfig
