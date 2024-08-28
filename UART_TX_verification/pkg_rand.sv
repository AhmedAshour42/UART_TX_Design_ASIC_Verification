package pkg_rand;

    // UART_TX_class definition with parameterized width
    typedef enum logic [2:0] {
        IDLE = 3'b000,  // Idle state
        STR  = 3'b001,  // Start bit state
        DATA = 3'b010,  // Data transmission state
        PAR  = 3'b011,  // Parity bit state
        STP  = 3'b100   // Stop bit state
    } state_t;

    class UART_TX_class #(parameter int width = 8); // Parameterized class with default width

        // Randomized signals
        rand bit rst;                      // Reset signal
        rand bit Data_valid;               // Data valid signal
        rand bit [width-1:0] P_data;       // Data payload using parameterized width
        rand bit Par_en;                   // Parity enable signal
        rand bit par_type;                 // Parity type (odd/even)
      
        // Constraint for reset signal distribution
        constraint rst_dist {
            rst dist {0 := 10, 1 := 90};    // 10% chance of being 0, 90% chance of being 1
        }

        // Constraint for Data_valid signal distribution
        constraint Data_valid_inst {
            Data_valid dist {0 := 75, 1 := 25}; // 75% chance of being 0, 25% chance of being 1
        }

        // Constraint for P_data distribution when Data_valid is 1
        constraint P_data_inst {
            (Data_valid == 1) -> (P_data dist {
                [5:50] := 30,              // 30% chance for values between 5 and 50
                [1:3] := 15,               // 15% chance for values between 1 and 3
                [51:$] := 55               // 55% chance for values from 51 to maximum width value
            });
        }

        // Constraint for parity enable signal distribution
        constraint Par_en_inst {
            Par_en dist {0 := 25, 1 := 75}; // 25% chance of being 0, 75% chance of being 1
        }

        // Constraint for parity type distribution
        constraint par_type_inst {
            par_type dist {0 := 45, 1 := 55}; // 45% chance of being 0 (even), 55% chance of being 1 (odd)
        }

        // Coverage Group
        covergroup cov();
            // Coverpoint for Par_en signal
            par_en_cov: coverpoint Par_en iff (!rst) {
                bins ONE = {1'b1};
                bins ZERO = {1'b0};
                bins transct = (1[*2]); // Transition coverage
            }

            // Coverpoint for par_type signal
            par_type_cov: coverpoint par_type iff (!rst) {
                bins ONE = {1'b1};
                bins ZERO = {1'b0};
                bins transct = (0[*2]); // Transition coverage
            }

            // Coverpoint for Data_valid signal
            Data_valid_cov: coverpoint Data_valid {
                bins ONE = {1'b1};
                bins ZERO = {1'b0};
            }

            // Coverpoint for P_data signal
            P_data_cov: coverpoint P_data {
                bins even_data[5] = {P_data} with (item % 2 == 0); // Even data values
                bins odd_data[5]  = {P_data} with (item % 2 != 0); // Odd data values
            }

            // Cross coverage between Data_valid and P_data
            cross1: cross Data_valid_cov, P_data_cov {
                bins one_data_valid = binsof(P_data_cov) && binsof(Data_valid_cov.ONE);
            }

            // Cross coverage between Par_en and par_type
            cross2: cross par_en_cov, par_type_cov {
                bins even_parity = binsof(par_en_cov.ONE) && binsof(par_type_cov.ZERO);
                bins odd_parity  = binsof(par_en_cov.ONE) && binsof(par_type_cov.ONE);
            }

            // Cross coverage between par_type, Par_en, and P_data
            cross3: cross par_type_cov, par_en_cov, P_data_cov {
                bins even_p_data = binsof(par_en_cov.ONE) && binsof(par_type_cov.ZERO) && binsof(P_data_cov.even_data);
                bins odd_p_data  = binsof(par_en_cov.ONE) && binsof(par_type_cov.ONE) && binsof(P_data_cov.odd_data);
            }
        endgroup

        // Constructor
        function new();
            cov = new();
            // current_state = IDLE; // Initialize state to IDLE
        endfunction: new

    endclass: UART_TX_class

endpackage: pkg_rand
