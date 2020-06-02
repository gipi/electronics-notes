`default_nettype none
`timescale 1ns/1ps

module soc(
    input wire clk,
    input wire reset
);

reg exception;
wire [31:0] cpu_to_rom_signal_data;
wire [31:0] rom_to_cpu_signal_data;
/* verilator lint_off UNUSED */
wire [31:0] signal_address;
wire wb_cyc, wb_stb, wb_stall, wb_ack, cpu_we;

cpu core(
    .clk(clk),
    .reset(reset),
    .i_exception(exception),
    .i_data(rom_to_cpu_signal_data),
    .o_data(cpu_to_rom_signal_data),
    .o_addr(signal_address), /* it addresses one word at the time */
    .o_we(cpu_we),
    .o_wb_cyc(wb_cyc),
    .o_wb_stb(wb_stb),
    .i_wb_stall(wb_stall),
    .i_wb_ack(wb_ack)
);

/*
 * Here we need a memory controller that manages the "redirection" of the
 * signals based on the address requested.
 *
 * 0xb0000000 - 0xb0007fff  bootrom
 * 0xb0008000 - 0xb000ffff  internal RAM
 * 0xc0000000 IO
 */
wire enable_bootrom, enable_internal_sram;
reg enable_internals_memory;

assign enable_bootrom = enable_internals_memory;
assign enable_internal_sram = ~enable_internals_memory;

always @(*) begin
    case (signal_address[31:16])
        16'hb000:
            case (signal_address[15])
                1'b0:
                    enable_internals_memory = 1'b1;
                1'b1:
                    enable_internals_memory = 1'b0;
            endcase
        default:
            exception = 1;
    endcase
end
wb_memory #(.ROMFILE("../modules/blockrams/boot.rom")) br(
    .clk(clk),
    .i_enable(enable_bootrom),
    .i_data(cpu_to_rom_signal_data),
    .o_data(rom_to_cpu_signal_data),
    .i_addr(signal_address[8:2]),
    .i_wb_stb(wb_stb),
    .o_wb_stall(wb_stall),
    .o_wb_ack(wb_ack),
    .i_we(0)
);

wb_memory internal_ram(
    .clk(clk),
    .i_enable(enable_internal_sram),
    .i_data(cpu_to_rom_signal_data),
    .o_data(rom_to_cpu_signal_data),
    .i_addr(signal_address[6:0] & (~3)),
    .i_wb_stb(wb_stb),
    .o_wb_stall(wb_stall),
    .o_wb_ack(wb_ack),
    .i_we(cpu_we)
);

endmodule
