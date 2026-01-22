module mux2to1
#(
  parameter INPUT_WIDTH = 8
)
(
  input   [INPUT_WIDTH-1:0] in1 ,
  input   [INPUT_WIDTH-1:0] in2 ,
  input                     sel ,
  output  [INPUT_WIDTH-1:0] out
);

assign  out = sel ? in1 : in2 ;

endmodule
