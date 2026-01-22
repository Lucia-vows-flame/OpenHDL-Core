`timescale 1ns/1ns

module mux2to1_tb();

localparam INPUT_WIDTH = 8;

// module instantiation of mux2to1
// input declaration of module mux2to1
reg  [INPUT_WIDTH-1:0] in1;
reg  [INPUT_WIDTH-1:0] in2;
reg                    sel;

// output declaration of module mux2to1
wire [INPUT_WIDTH-1:0] out;

mux2to1
#(
  .INPUT_WIDTH 	(INPUT_WIDTH  ))
u_mux2to1
(
  .in1 	(in1  ),
  .in2 	(in2  ),
  .sel 	(sel  ),
  .out 	(out  )
);

integer i, j, k, error_count;
reg [7:0] correct_out;

// generate test vectors
initial 
  begin
    error_count = 0;
    $display("=========================================================");
    $display("Starting 8-bit 2:1 mux full-range test");
    $display("Total combinations: 256(in1) * 256(in2) * 2(sel) = 131072");
    $display("=========================================================");

    for (i = 0; i < 256; i = i + 1)
      in1 = i[7:0];  // set input value for in1
      begin
        for (j = 0; j < 256; j = j + 1)
          in2 = j[7:0];  // set input value for in2
          begin
            for (k = 0; k < 2; k = k + 1)
              begin
                sel = k[0:0];  // set input value for sel
                #2;       // wait for 2ns
                correct_out = k[0:0] ? in1 : in2;  // calculate expected output
                if (out[7:0] != correct_out[7:0])
                  begin
                    $display("ERROR at time %0dns: in1=%h in2=%h sel=%b out=%h correct_out=%h", $time, in1, in2, sel, out, correct_out);
                    error_count = error_count + 1;
                  end
              end
          end
      end

      $display("=========================================================");
      if (error_count == 0)
        begin
          $display("All tests passed");
        end
      else
        begin
          $display("Total errors: %0d", error_count);
        end
      $display("End of 8-bit 2:1 mux test");
      $display("=========================================================");

      $finish;
  end

// generate waveform
initial
  begin
    $dumpfile("prj/icarus/mux2to1.vcd");
    $dumpvars(0, mux2to1_tb);
    #3000;
    $finish();
  end

endmodule
