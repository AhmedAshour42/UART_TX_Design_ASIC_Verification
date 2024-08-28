`timescale 1ns/1ps

module parity_tb;

  /* ------------------------------- // Signals ------------------------------- */

parameter width =8;

  reg [width-1:0] P_data;
  
  wire Par_bit;
  reg clk, rst, Data_valid, Par_type;
  /* ------------------ // Instantiate the module under test ------------------ */
  parity uut (
    .clk(clk),
    .rst(rst),
    .Data_valid(Data_valid),
    .P_data(P_data),
    .Par_type(Par_type),
    .Par_bit(Par_bit)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever begin
      #1 clk = !clk;
    end
  end

  /* ------------------- // Reset generation and test cases ------------------- */
  initial begin
  
    rst = 0;
    Data_valid = 1;
    Par_type = 0;
    P_data = 8'b0;
    @(negedge clk);
    rst = 1;

    /* ----------------------- // Test case 1: Even Parity ---------------------- */
    $display("Test Case 1: Even Parity");
    Par_type = 0; // Even Parity
    P_data = 8'b10101010; // Data
    Data_valid = 1;
    @(negedge clk);
    $display("P_data=%b, Par_type=%b, Par_bit=%b", P_data, Par_type, Par_bit);
    Data_valid = 0;
    @(negedge clk);
    P_data = 8'b10101011; // Data
    Data_valid = 1;
    @(negedge clk);
    $display("P_data=%b, Par_type=%b, Par_bit=%b", P_data, Par_type, Par_bit);
    Data_valid = 0;
    @(negedge clk);

    /* ----------------------- // Test case 2: Odd Parity ----------------------- */
    $display("Test Case 2: Odd Parity");
    Par_type = 1; // Odd Parity
    P_data = 8'b10101010; // Data
    Data_valid = 1;
    @(negedge clk);
    $display("P_data=%b, Par_type=%b, Par_bit=%b", P_data, Par_type, Par_bit);
    Data_valid = 0;
    @(negedge clk);
    Data_valid = 1;
    P_data = 8'b10101011; // Data
    @(negedge clk);
    $display("P_data=%b, Par_type=%b, Par_bit=%b", P_data, Par_type, Par_bit);
    Data_valid = 0;
    @(negedge clk);

    /* ---------------------------- // End simulation --------------------------- */
    $stop;
  end

endmodule
