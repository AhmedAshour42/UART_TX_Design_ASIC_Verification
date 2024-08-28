import pkg_rand::*;

module top_tb(UART_TX_INTF.TEST top_tb_intf); 

    parameter CLK_PERIOD = 1000000 / 230400; // Period of clock in ns (1/frequency)

    UART_TX_class UART_Tx;

    // Testbench variables
    integer correct = 0;
    integer wrong = 0;
    integer i = 0;
    integer k = 0;

    // Signal to check states of FSM
    wire [2:0] cs;
    state_t cs_expected;

    logic Tx_expected;
    logic busy_exp;
    logic parity_exp;

   assign cs =tops.DUT_3.current_state;  // Assuming the state signal is in FSM module
    //assign cs = top_tb_intf.current_state;  // Access FSM state via interface

    // Clock generation
/* //   initial begin
        top_tb_intf.clk = 0;
        forever begin
            #CLK_PERIOD top_tb_intf.clk = ~top_tb_intf.clk; 
        end
    //end
*/
    // Testbench procedure
    initial begin
        // Dump VCD file for waveform analysis
        $dumpfile("top_tb.vcd");
        $dumpvars;
        UART_Tx = new();

        // Testbench Initialization
        initialization();
        make_rst();
        check_rst();

        // Case 1: UART uses even parity
        top_tb_intf.Data_valid = 1;
        top_tb_intf.Par_en = 1;
        top_tb_intf.P_data = 8'b10011010;
        top_tb_intf.Par_type = 0;
        cs_expected = STR;
        busy_exp = 1;
        Tx_expected = 0;

        @(negedge top_tb_intf.clk);
        golden_mode(cs);

        top_tb_intf.Data_valid = 0;
        @(negedge top_tb_intf.clk);
        golden_mode(cs);

        @(negedge top_tb_intf.clk);
        golden_mode(cs);

        @(negedge top_tb_intf.clk);
        golden_mode(cs);

        make_rst();

        // Random tests
        for (k = 0; k < 100000; k++) begin
            assert(UART_Tx.randomize());
            top_tb_intf.rst = UART_Tx.rst;
            top_tb_intf.Data_valid = UART_Tx.Data_valid;
            top_tb_intf.Par_en = UART_Tx.Par_en;
            top_tb_intf.P_data = UART_Tx.P_data;
            top_tb_intf.Par_type = UART_Tx.par_type;
            UART_Tx.cov.sample();

            if (top_tb_intf.Data_valid) begin
                @(negedge top_tb_intf.clk);
                golden_mode(cs);
                top_tb_intf.Data_valid = 0;

                if (top_tb_intf.Par_en) begin
                    repeat (4) begin
                        @(negedge top_tb_intf.clk);
                        golden_mode(cs);
                    end
                end else begin
                    repeat (3) begin
                        @(negedge top_tb_intf.clk);
                        golden_mode(cs);
                    end
                end
            end else begin
                @(negedge top_tb_intf.clk);
                check_rst();
            end
        end

        $display("Total checks: Correct = %d, Incorrect = %d", correct, wrong);
        $stop;
    end

    task golden_mode(input [2:0] cs);
    begin
        case (cs)
            IDLE: begin
                busy_exp = 0;
                Tx_expected = 1;
                check_output(Tx_expected, busy_exp);
            end
            STR: begin
                busy_exp = 1;
                Tx_expected = 0;
                check_output(Tx_expected, busy_exp);
            end
            DATA: begin
                repeat (7) begin
                    Tx_expected = top_tb_intf.P_data[i];
                    busy_exp = 1;
                    check_output(Tx_expected, busy_exp);
                    i = i + 1;
                    @(negedge top_tb_intf.clk);
                end
                i = 0;
            end
            PAR: begin
                if (top_tb_intf.Par_type) begin
                    parity_exp = (^top_tb_intf.P_data) ? 0 : 1;
                end else begin
                    parity_exp = (^top_tb_intf.P_data) ? 1 : 0;
                end
                busy_exp = 1;
                Tx_expected = parity_exp;
                check_output(Tx_expected, busy_exp);
            end
            STP: begin
                busy_exp = 1;
                Tx_expected = 1;
                check_output(Tx_expected, busy_exp);
            end
            default: begin
                busy_exp = 0;
                Tx_expected = 1;
                check_output(Tx_expected, busy_exp);
            end
        endcase
    end
    endtask

    task check_output(input Tx_expected, busy_exp);
    begin
        if (Tx_expected !== top_tb_intf.TX_out || busy_exp !== top_tb_intf.Busy) begin
            $display("Error at time %0t: Mismatch detected!", $time);
            $display("Expected: TX_out = %d, Expected Busy = %d,", Tx_expected, busy_exp);
            $display("Actual: TX_out = %d, Busy = %d, cs = %d", top_tb_intf.TX_out, top_tb_intf.Busy, cs);
            wrong = wrong + 1;
        end else begin
            correct = correct + 1;
        end
    end
    endtask

    task initialization();
    begin
        top_tb_intf.Data_valid = 0;
        top_tb_intf.P_data = 55;
        top_tb_intf.Par_en = 0;
        top_tb_intf.Par_type = 0;
    end
    endtask

    task check_rst();
    begin
        if (top_tb_intf.Busy !== 0 || top_tb_intf.TX_out !== 1 || cs !== 0) begin
            $display("Error at time %0t: Mismatch detected!", $time);
            $display("Error: Busy expected is %d    Busy_design equals %d", 0, top_tb_intf.Busy);
            $display("Error: TX_out expected is %d  TX_out_design equals %d", 1, top_tb_intf.TX_out);
            wrong = wrong + 1;
        end else begin
            correct = correct + 1;
        end
    end
    endtask

    task make_rst();
    begin
        top_tb_intf.rst = 0;
        @(negedge top_tb_intf.clk)
        top_tb_intf.rst = 1;
    end
    endtask
endmodule
