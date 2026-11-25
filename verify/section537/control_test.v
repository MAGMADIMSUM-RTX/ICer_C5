// Self-checking controller testbench.
`timescale 1ns/1ps

`define HLT 3'b000
`define SKZ 3'b001
`define ADD 3'b010
`define AND 3'b011
`define XOR 3'b100
`define LDA 3'b101
`define STO 3'b110
`define JMP 3'b111

module control_test;

reg       clk, rst_, zero;
reg [2:0] opcode;
wire      rd, wr, ld_ir, ld_ac, ld_pc, inc_pc, halt, data_e, sel;
integer   errors;
integer st, op, z;

`ifdef GATE
control_pad c1(
`else
control c1(
`endif
    .rd(rd), .wr(wr), .ld_ir(ld_ir), .ld_ac(ld_ac), .ld_pc(ld_pc),
    .inc_pc(inc_pc), .halt(halt), .data_e(data_e), .sel(sel),
    .opcode(opcode), .zero(zero), .clk(clk), .rst_(rst_)
);

`ifdef GATE
initial $sdf_annotate(`SDF_FILE, c1);
`endif

initial clk = 0;
always #10 clk = ~clk;

task check;
    input [2:0] st;
    input [2:0] op;
    input       z;
    reg         sel_e, rd_e, wr_e, ld_ir_e, ld_ac_e, ld_pc_e, inc_pc_e, halt_e, data_e_e;
    reg         alu_op;
    begin
        alu_op = (op==`ADD) | (op==`AND) | (op==`XOR) | (op==`LDA);
        case ( st )
            0: begin sel_e=1;rd_e=0;ld_ir_e=0;inc_pc_e=0;halt_e=0;ld_pc_e=0;data_e_e=0;ld_ac_e=0;wr_e=0; end
            1: begin sel_e=1;rd_e=1;ld_ir_e=0;inc_pc_e=0;halt_e=0;ld_pc_e=0;data_e_e=0;ld_ac_e=0;wr_e=0; end
            2: begin sel_e=1;rd_e=1;ld_ir_e=1;inc_pc_e=0;halt_e=0;ld_pc_e=0;data_e_e=0;ld_ac_e=0;wr_e=0; end
            3: begin sel_e=1;rd_e=1;ld_ir_e=1;inc_pc_e=0;halt_e=0;ld_pc_e=0;data_e_e=0;ld_ac_e=0;wr_e=0; end
            4: begin sel_e=0;rd_e=0;ld_ir_e=0;inc_pc_e=1;halt_e=(op==`HLT);ld_pc_e=0;data_e_e=0;ld_ac_e=0;wr_e=0; end
            5: begin sel_e=0;rd_e=alu_op;ld_ir_e=0;inc_pc_e=0;halt_e=0;ld_pc_e=0;data_e_e=0;ld_ac_e=0;wr_e=0; end
            6: begin sel_e=0;rd_e=alu_op;ld_ir_e=0;inc_pc_e=(op==`SKZ)&z;halt_e=0;ld_pc_e=(op==`JMP);data_e_e=~alu_op;ld_ac_e=0;wr_e=0; end
            7: begin sel_e=0;rd_e=alu_op;ld_ir_e=0;inc_pc_e=((op==`SKZ)&z)|(op==`JMP);halt_e=0;ld_pc_e=(op==`JMP);data_e_e=~alu_op;ld_ac_e=alu_op;wr_e=(op==`STO); end
        endcase
        if ( {sel,rd,wr,ld_ir,ld_ac,ld_pc,inc_pc,halt,data_e} !==
             {sel_e,rd_e,wr_e,ld_ir_e,ld_ac_e,ld_pc_e,inc_pc_e,halt_e,data_e_e} )
        begin
            $display("FAIL st=%0d op=%b z=%b got(s,rd,wr,li,la,lp,pc,halt,de)=%b,%b,%b,%b,%b,%b,%b,%b,%b",
                     st, op, z, sel,rd,wr,ld_ir,ld_ac,ld_pc,inc_pc,halt,data_e);
            $display("       exp=%b,%b,%b,%b,%b,%b,%b,%b,%b",
                     sel_e,rd_e,wr_e,ld_ir_e,ld_ac_e,ld_pc_e,inc_pc_e,halt_e,data_e_e);
            errors = errors + 1;
        end
    end
endtask

initial begin
    errors = 0;
    rst_ = 1;
    opcode = 0;
    zero = 0;
    for (op = 0; op < 8; op = op + 1) begin
        for (z = 0; z < 2; z = z + 1) begin
            @(negedge clk);
            #2;
            rst_ = 0;
            opcode = op[2:0];
            zero = z[0];
            @(negedge clk);
            #2 rst_ = 1;
            #5 check(0, opcode, zero);
            for (st = 1; st < 8; st = st + 1) begin
                @(posedge clk);
                #8 check(st[2:0], opcode, zero);
            end
            @(posedge clk);
            #8 check(0, opcode, zero);
        end
    end
    if (errors != 0) $fatal(1, "control_test failed: %0d errors", errors);
    $display("PASS: control_test, 144 checks");
    $finish;
end
endmodule
