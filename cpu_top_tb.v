`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2026 12:35:43 PM
// Design Name: 
// Module Name: cpu_top_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module cpu_top_tb(
    );

    reg clk, reset;
    integer i;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    multi_cpu_top dut (.clk(clk), .reset(reset));

    initial begin
        reset = 1;
        @(negedge clk);
        reset = 0;
    end

    // Program: point instruction memory's $readmemh at stress_test.hex.
    // 42 instructions -> generous margin below.
    // Covers, in one continuous run:
    //   - all 10 R-type ALU ops (x3-x14)
    //   - all 9 I-type ALU ops incl. SLLI/SRLI/SRAI (x15-x22)
    //   - SW/LW integration (x23-x24)
    //   - BEQ and BNE, each via a "poison" instruction that must be
    //     skipped -- if the branch logic is broken, the poison value
    //     (999) lands in the register instead of the real one (x25,x26)
    //   - JAL with a poison-skip, checking BOTH the jump target landed
    //     correctly AND the return address it saved (x27,x28)
    //   - AUIPC feeding JALR's target register, then JALR with its own
    //     poison-skip, checking both landing and return address (x29-x31)

    initial begin
        #11; // past reset
        for (i = 0; i < 200; i = i + 1) begin
            @(negedge clk);
        end

        $display("---- Day 20 combined stress test ----");

        // R-type ALU
        check(3,  32'd255,        "ADD  x3");
        check(4,  32'd225,        "SUB  x4");
        check(5,  32'd255,        "XOR  x5");
        check(6,  32'd255,        "OR   x6");
        check(7,  32'd0,          "AND  x7");
        check(9,  32'd3840,       "SLL  x9");
        check(10, 32'd15,         "SRL  x10");
        check(12, 32'hFFFFFFFF,   "SRA  x12");
        check(13, 32'd0,          "SLT  x13");
        check(14, 32'd1,          "SLTU x14");

        // I-type ALU
        check(15, 32'd1,          "SLTI  x15");
        check(16, 32'd1,          "SLTIU x16");
        check(17, 32'd255,        "XORI  x17");
        check(18, 32'd255,        "ORI   x18");
        check(19, 32'd0,          "ANDI  x19");
        check(20, 32'd240,        "SLLI  x20");
        check(21, 32'd15,         "SRLI  x21");
        check(22, 32'hFFFFFFFF,   "SRAI  x22");

        // SW/LW integration
        check(24, 32'd170,        "LW x24 (after SW)");

        // BEQ / BNE
        check(25, 32'd111,        "x25 (BEQ took correct path, poison skipped)");
        check(26, 32'd222,        "x26 (BNE took correct path, poison skipped)");

        // JAL: landing + return address
        check(27, 32'h0000007C+4, "x27 (JAL return address)");
        check(28, 32'd55,         "x28 (JAL landed correctly, poison skipped)");

        // AUIPC + JALR: landing + return address
        check(29, 32'h00000088,   "x29 (AUIPC = its own PC)");
        check(30, 32'h0000008C+4, "x30 (JALR return address)");
        check(31, 32'd77,         "x31 (JALR landed correctly, poison skipped)");

        // Poison canaries -- these must NEVER equal 999. If any of these
        // fail, a branch/jump was NOT actually taken and fell through
        // into the instruction meant to be skipped.
        if (dut.mem.reg_arr[25] == 32'd999)
            $display("FAIL x25 == 999: BEQ did not skip its poison instruction!");
        if (dut.mem.reg_arr[26] == 32'd999)
            $display("FAIL x26 == 999: BNE did not skip its poison instruction!");
        if (dut.mem.reg_arr[28] == 32'd999)
            $display("FAIL x28 == 999: JAL did not skip its poison instruction!");
        if (dut.mem.reg_arr[31] == 32'd999)
            $display("FAIL x31 == 999: JALR did not skip its poison instruction!");
    end

    task check(input [4:0] regnum, input [31:0] expected, input [127:0] name);
        begin
            if (dut.mem.reg_arr[regnum] !== expected)
                $display("FAIL %s: got %h, expected %h", name, dut.mem.reg_arr[regnum], expected);
            else
                $display("PASS %s = %h", name, dut.mem.reg_arr[regnum]);
        end
    endtask

endmodule
