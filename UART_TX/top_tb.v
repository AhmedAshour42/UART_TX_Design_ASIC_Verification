
`timescale 1us / 1ns
module top_tb;

/// parameter  
parameter width =8;

  parameter CLK_PERIOD = 1000000 / 230400; // Period of clock in ns (1/frequency)

  // Inputs
  reg clk;
  reg rst;
  reg Data_valid;
  reg [width-1:0] P_data;
  reg Par_type;
  reg Par_en;

  // Outputs
  wire Busy;
  wire TX_out;

  // Instantiate the top module
  top  #(width) uut (
    .clk(clk),
    .rst(rst),
    .Data_valid(Data_valid),
    .P_data(P_data),
    .Par_type(Par_type),
    .Par_en(Par_en),
    .Busy(Busy),
    .TX_out(TX_out)
  );

  // Testbench variables
  integer correct = 0;
  integer wrong = 0;
  integer i = 0;
  integer k = 0;

  // Signal to check states of FSM
  wire [3:0] cs;
  reg [3:0] cs_expected;
 
  reg Tx_expected;
  reg busy_exp;
  reg parity_exp;

/* ------------------- /// to check based at current state ------------------ */

 assign cs = uut.DUT_3.current_state;

  // Clock generation
  initial begin
    clk = 0;
    forever begin
      #CLK_PERIOD clk = ~clk; 
    end
  end


  initial begin
      /* ----------------- // Dump VCD file for waveform analysis ----------------- */

    $dumpfile("top_tb.vcd");
    $dumpvars;

    // Testbench Initialization
    initialization();
    make_rst();
    check_rst();

    /* -------------------------------------------------------------------------- */
    /* First, check if all states work well                                      */
    /* -------------------------------------------------------------------------- */

    // Case 1: UART uses even parity
        Data_valid = 1;
        Par_en = 1;
        P_data = 8'b10011010;
        Par_type = 0;
        cs_expected = 3'b001;
        busy_exp = 1;
        Tx_expected = 0;

    /* ----------------------- Initial State ------------------------------------- */
    @(negedge clk);
    golden_mode(cs);

    /* ----------------------- Data Sent ---------------------------------------- */
    Data_valid = 0;
    @(negedge clk);
    golden_mode(cs);

    /* ----------------------- Stop Bit ----------------------------------------- */
    // Checking if in stop case or not
    @(negedge clk);
    golden_mode(cs);

    /* ----------------------- IDLE State --------------------------------------- */
    // Checking if in IDLE case or not
    @(negedge clk);
    golden_mode(cs);

    /* -------------------------------------------------------------------------- */
    /* End checking if all states work well                                       */
    /* -------------------------------------------------------------------------- */
     make_rst();
    // Random tests
    for (k = 0; k < 1000; k = k + 1) begin
//  random input 
      Data_valid = $random;
      Par_en = $random;
      P_data = $random;
      Par_type = $random;

      if (Data_valid) begin
                @(negedge clk);
                golden_mode(cs);
Data_valid = 0;

  //&if i parity enable is active then the process after state case 4 states 
        if (Par_en) begin
          repeat (4) begin
            // Send new data and wait 8 clocks for it to convert to serial
            @(negedge clk);
            golden_mode(cs);
          end
        end
   //&if i parity enable is not active then the process after state case 3 states 
        if (!Par_en) begin
          repeat (3) begin
            // Send new data and wait 8 clocks for it to convert to serial
            @(negedge clk);
            golden_mode(cs);
          end
        end

      end
       else
        begin
        @(negedge clk);
        check_rst();
      end
    end

    $display("Total checks: Correct = %d, Incorrect = %d", correct, wrong);
    $stop;
  end

  // Task to define the expected behavior for each state
  task golden_mode(input [3:0] cs);
  begin
    case (cs)
      0: // IDLE State
        begin
          busy_exp = 0;
          Tx_expected = 1;
          check_output(Tx_expected, busy_exp);
        end
      1: // Start Bit
        begin
          busy_exp = 1;
          Tx_expected = 0;
          check_output(Tx_expected, busy_exp);
        end
      2: // Data Bits
        begin
          repeat (7) begin
            Tx_expected = P_data[i];
            busy_exp = 1;
            check_output(Tx_expected, busy_exp);
            i = i + 1;
            @(negedge clk);
          end
          i = 0;
        end
      3: // Parity Bit
        begin
          if (Par_type) begin
            // Odd parity selected
            parity_exp = (^P_data) ? 0 : 1;
          end else begin
            // Even parity selected
            parity_exp = (^P_data) ? 1 : 0;
          end
          busy_exp = 1;
          Tx_expected = parity_exp;
          check_output(Tx_expected, busy_exp);
        end
      4: // Stop Bit
        begin
          busy_exp = 1;
          Tx_expected = 1;
          check_output(Tx_expected, busy_exp);
        end
      default: // Default State
        begin
          busy_exp = 0;
          Tx_expected = 1;
          check_output(Tx_expected, busy_exp);
        end
    endcase
  end
  endtask

  // Task to check the output against expected values
  task check_output(input Tx_expected, busy_exp);
  begin
    if (Tx_expected !== TX_out || busy_exp !== Busy) begin
      $display("Error at time %0t: Mismatch detected!", $time);
      $display("Expected: TX_out = %d, Expected Busy = %d,", Tx_expected, busy_exp);
      $display("Actual: TX_out = %d, Busy = %d, cs = %d", TX_out, Busy, cs);
      wrong = wrong + 1;
    end else begin
      correct = correct + 1;
    end
  end
  endtask

  // Task to initialize the testbench variables
  task initialization();
  begin
    Data_valid = 0;
    P_data = 55; // Initial value for P_data
    Par_en = 0;
    Par_type = 0;
  end
  endtask

  // Task to check the behavior after reset
  task check_rst();
  begin
    if (Busy !== 0 || TX_out !== 1 || cs !== 0) begin
      $display("Error at time %0t: Mismatch detected!", $time);
      $display("Error: Busy expected is %d    Busy_design equals %d", 0, Busy);
      $display("Error: TX_out expected is %d  TX_out_design equals %d", 1, TX_out);
      wrong = wrong + 1;
    end else begin
      correct = correct + 1;
    end
  end
  endtask

  // Task to generate reset signal
  task make_rst();
  begin
    rst = 0;
    @(negedge clk)
    rst = 1;
  end
  endtask
endmodule
