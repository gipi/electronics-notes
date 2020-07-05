/*
 * UART TRANSMITTER MODULE
 *
 * To transmit you need to set the i_data line and i_start in order to begin the
 * transmission; when is completed the signal o_done is raised. When o_done is
 * not raised is not possible to start the communication. o_done is set logic
 * false when the transmission is started.
 */
`default_nettype none
`timescale 1ns/1ps

module uart_tx(
    input wire reset,
    input wire clk,
    input wire [7:0] i_data,
    input wire i_start,
    output reg o_tx,
    output reg o_done
);


localparam [2:0] IDLE  = 0,
                START = 1,
                DATA  = 2,
                STOP  = 3;

reg [2:0] state;
reg [7:0] data;
reg [3:0] counter;

initial begin
    //state = IDLE;
    //o_tx = 1'b1;
end


always @(posedge clk)
begin
    if (~reset) begin
        state <= IDLE;
        o_tx <= 1'b1;
        o_done <= 1'b0;
    end
    else 
        begin
        case (state)
            IDLE:
            begin
                if (i_start)
                begin
                    state <= START;
                    o_done <= 1'b0;
                    o_tx <= 1'b0;
                    data <= i_data;
                end
            end
            START:
            begin
                counter <= 1;
                o_tx <= data[0];
                data <= data >> 1;
                state <= DATA;
            end
            DATA:
            begin
                if (counter == 4'h7)
                begin
                    state <= STOP;
                end
                o_tx <= data[0];
                data <= data >> 1;
                counter <= counter + 1;
            end
            STOP:
            begin
                o_tx <= 1'b1;
                o_done <= 1'b1;
                state <= IDLE;
            end
            default:
                begin
                end
        endcase
    end
end


endmodule
