`default_nettype none
`timescale 1ns/1ps

module soc(
    input wire clk,
    input wire reset,
    output wire o_uart_tx
);

reg exception;
wire [31:0] cpu_to_peripherals_data;
//  FIXME
// verilator lint_off BLKANDNBLK
wire [31:0] peripherals_to_cpu_data;
/* verilator lint_off UNUSED */
wire [31:0] signal_address;
wire [1:0] data_width;
wire wb_cyc, wb_stb, wb_stall, wb_ack, cpu_we;

initial begin
    exception = 1'b0;
end

cpu core(
    .clk(clk),
    .reset(reset),
    .i_exception(exception),
    .i_data(peripherals_to_cpu_data),
    .o_data(cpu_to_peripherals_data),
    .o_wb_addr(signal_address),
    .o_wb_we(cpu_we),
    .o_wb_cyc(wb_cyc),
    .o_wb_stb(wb_stb),
    .i_wb_stl(wb_stall),
    .i_wb_ack(wb_ack),
    .o_data_width(data_width)
);

/*
 * Here we need a memory controller that manages the "redirection" of the
 * signals based on the address requested.
 *
 * 0xb0000000 - 0xb0007fff  bootrom
 * 0xb0008000 - 0xb000ffff  internal RAM
 * 0xc0000000 IO
 */
wire enable_internal, enable_bootrom, enable_sram;

assign enable_internal = 16'hb000 == signal_address[31:16];
assign enable_bootrom = enable_internal && ~signal_address[15];
assign enable_sram = enable_internal && signal_address[15];
assign exception = ~enable_internal;

parameter PATH_BOOTROM="../firmwares/bootrom.rom";

wb_memory #(.SIZE(4096),.ROMFILE(PATH_BOOTROM)) br(
    .clk(clk),
    .i_data(cpu_to_peripherals_data),
    .o_data(peripherals_to_cpu_data),
    .i_addr(signal_address[11:0]),
    .i_wb_cyc(wb_cyc),
    .i_wb_stb(wb_stb & enable_bootrom),
    .o_wb_stl(wb_stall),
    .o_wb_ack(wb_ack),
    .i_width(data_width),
    .i_we(0)
);

wb_memory #(.SIZE(4096)) internal_ram(
    .clk(clk),
    .i_data(cpu_to_peripherals_data),
    .o_data(peripherals_to_cpu_data),
    .i_addr(signal_address[11:0]),
    .i_wb_cyc(wb_cyc),
    .i_wb_stb(wb_stb & enable_sram),
    .o_wb_stl(wb_stall),
    .o_wb_ack(wb_ack),
    .i_width(data_width),
    .i_we(cpu_we)
);

/* I/O Peripherals */
wire enable_uart;
assign enable_uart = 16'hc000 == signal_address[31:16];

wb_uart uart(
    .clk(clk),
    .reset(reset),
    .i_wb_cyc(wb_cyc),
    .i_wb_stb(wb_stb & enable_uart),
    .i_wb_we(cpu_we),
    .i_wb_addr(signal_address[1:0]),
    .i_wb_data(cpu_to_peripherals_data[7:0]),
    .o_wb_ack(wb_ack),
    .o_wb_stl(wb_stall),
    .o_wb_data(peripherals_to_cpu_data[7:0]),
    .o_uart_tx(o_uart_tx)
);

endmodule
