// ==============================================================
// File generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2018.1
// Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
// 
// ==============================================================


`timescale 1 ns / 1 ps

`define TV_IN_in_stream0_TDATA "../tv/cdatafile/c.scurve_adder.autotvin_in_stream0_V_data_V.dat"
`define INGRESS_STATUS_in_stream0_TDATA "../tv/stream_size/stream_ingress_status_in_stream0_V_data_V.dat"
`define TV_IN_in_stream0_TKEEP "../tv/cdatafile/c.scurve_adder.autotvin_in_stream0_V_keep_V.dat"
`define INGRESS_STATUS_in_stream0_TKEEP "../tv/stream_size/stream_ingress_status_in_stream0_V_keep_V.dat"
`define TV_IN_in_stream0_TSTRB "../tv/cdatafile/c.scurve_adder.autotvin_in_stream0_V_strb_V.dat"
`define INGRESS_STATUS_in_stream0_TSTRB "../tv/stream_size/stream_ingress_status_in_stream0_V_strb_V.dat"
`define TV_IN_in_stream0_TUSER "../tv/cdatafile/c.scurve_adder.autotvin_in_stream0_V_user_V.dat"
`define INGRESS_STATUS_in_stream0_TUSER "../tv/stream_size/stream_ingress_status_in_stream0_V_user_V.dat"
`define TV_IN_in_stream0_TLAST "../tv/cdatafile/c.scurve_adder.autotvin_in_stream0_V_last_V.dat"
`define INGRESS_STATUS_in_stream0_TLAST "../tv/stream_size/stream_ingress_status_in_stream0_V_last_V.dat"
`define TV_IN_in_stream0_TID "../tv/cdatafile/c.scurve_adder.autotvin_in_stream0_V_id_V.dat"
`define INGRESS_STATUS_in_stream0_TID "../tv/stream_size/stream_ingress_status_in_stream0_V_id_V.dat"
`define TV_IN_in_stream0_TDEST "../tv/cdatafile/c.scurve_adder.autotvin_in_stream0_V_dest_V.dat"
`define INGRESS_STATUS_in_stream0_TDEST "../tv/stream_size/stream_ingress_status_in_stream0_V_dest_V.dat"

`define AUTOTB_TRANSACTION_NUM 1

module AESL_axi_s_in_stream0 (
    input clk,
    input reset,
    output [16 - 1:0] TRAN_in_stream0_TDATA,
    output [2 - 1:0] TRAN_in_stream0_TKEEP,
    output [2 - 1:0] TRAN_in_stream0_TSTRB,
    output [2 - 1:0] TRAN_in_stream0_TUSER,
    output TRAN_in_stream0_TLAST,
    output [5 - 1:0] TRAN_in_stream0_TID,
    output [6 - 1:0] TRAN_in_stream0_TDEST,
    output TRAN_in_stream0_TVALID,
    input TRAN_in_stream0_TREADY,
    input ready,
    input done,
    output [31:0] transaction);

    wire TRAN_in_stream0_TVALID_temp;
    wire in_stream0_TDATA_full;
    wire in_stream0_TDATA_empty;
    reg in_stream0_TDATA_write_en;
    reg [16 - 1:0] in_stream0_TDATA_write_data;
    reg in_stream0_TDATA_read_en;
    wire [16 - 1:0] in_stream0_TDATA_read_data;
    
    fifo #(960, 16) fifo_in_stream0_TDATA (
        .reset(1'b0),
        .write_clock(clk),
        .write_en(in_stream0_TDATA_write_en),
        .write_data(in_stream0_TDATA_write_data),
        .read_clock(clk),
        .read_en(in_stream0_TDATA_read_en),
        .read_data(in_stream0_TDATA_read_data),
        .full(in_stream0_TDATA_full),
        .empty(in_stream0_TDATA_empty));
    
    always @ (*) begin
        in_stream0_TDATA_write_en <= 0;
        in_stream0_TDATA_read_en <= TRAN_in_stream0_TREADY & TRAN_in_stream0_TVALID;
    end
    
    assign TRAN_in_stream0_TDATA = in_stream0_TDATA_read_data;
    wire in_stream0_TKEEP_full;
    wire in_stream0_TKEEP_empty;
    reg in_stream0_TKEEP_write_en;
    reg [2 - 1:0] in_stream0_TKEEP_write_data;
    reg in_stream0_TKEEP_read_en;
    wire [2 - 1:0] in_stream0_TKEEP_read_data;
    
    fifo #(960, 2) fifo_in_stream0_TKEEP (
        .reset(1'b0),
        .write_clock(clk),
        .write_en(in_stream0_TKEEP_write_en),
        .write_data(in_stream0_TKEEP_write_data),
        .read_clock(clk),
        .read_en(in_stream0_TKEEP_read_en),
        .read_data(in_stream0_TKEEP_read_data),
        .full(in_stream0_TKEEP_full),
        .empty(in_stream0_TKEEP_empty));
    
    always @ (*) begin
        in_stream0_TKEEP_write_en <= 0;
        in_stream0_TKEEP_read_en <= TRAN_in_stream0_TREADY & TRAN_in_stream0_TVALID;
    end
    
    assign TRAN_in_stream0_TKEEP = in_stream0_TKEEP_read_data;
    wire in_stream0_TSTRB_full;
    wire in_stream0_TSTRB_empty;
    reg in_stream0_TSTRB_write_en;
    reg [2 - 1:0] in_stream0_TSTRB_write_data;
    reg in_stream0_TSTRB_read_en;
    wire [2 - 1:0] in_stream0_TSTRB_read_data;
    
    fifo #(960, 2) fifo_in_stream0_TSTRB (
        .reset(1'b0),
        .write_clock(clk),
        .write_en(in_stream0_TSTRB_write_en),
        .write_data(in_stream0_TSTRB_write_data),
        .read_clock(clk),
        .read_en(in_stream0_TSTRB_read_en),
        .read_data(in_stream0_TSTRB_read_data),
        .full(in_stream0_TSTRB_full),
        .empty(in_stream0_TSTRB_empty));
    
    always @ (*) begin
        in_stream0_TSTRB_write_en <= 0;
        in_stream0_TSTRB_read_en <= TRAN_in_stream0_TREADY & TRAN_in_stream0_TVALID;
    end
    
    assign TRAN_in_stream0_TSTRB = in_stream0_TSTRB_read_data;
    wire in_stream0_TUSER_full;
    wire in_stream0_TUSER_empty;
    reg in_stream0_TUSER_write_en;
    reg [2 - 1:0] in_stream0_TUSER_write_data;
    reg in_stream0_TUSER_read_en;
    wire [2 - 1:0] in_stream0_TUSER_read_data;
    
    fifo #(960, 2) fifo_in_stream0_TUSER (
        .reset(1'b0),
        .write_clock(clk),
        .write_en(in_stream0_TUSER_write_en),
        .write_data(in_stream0_TUSER_write_data),
        .read_clock(clk),
        .read_en(in_stream0_TUSER_read_en),
        .read_data(in_stream0_TUSER_read_data),
        .full(in_stream0_TUSER_full),
        .empty(in_stream0_TUSER_empty));
    
    always @ (*) begin
        in_stream0_TUSER_write_en <= 0;
        in_stream0_TUSER_read_en <= TRAN_in_stream0_TREADY & TRAN_in_stream0_TVALID;
    end
    
    assign TRAN_in_stream0_TUSER = in_stream0_TUSER_read_data;
    wire in_stream0_TLAST_full;
    wire in_stream0_TLAST_empty;
    reg in_stream0_TLAST_write_en;
    reg [1 - 1:0] in_stream0_TLAST_write_data;
    reg in_stream0_TLAST_read_en;
    wire [1 - 1:0] in_stream0_TLAST_read_data;
    
    fifo #(960, 1) fifo_in_stream0_TLAST (
        .reset(1'b0),
        .write_clock(clk),
        .write_en(in_stream0_TLAST_write_en),
        .write_data(in_stream0_TLAST_write_data),
        .read_clock(clk),
        .read_en(in_stream0_TLAST_read_en),
        .read_data(in_stream0_TLAST_read_data),
        .full(in_stream0_TLAST_full),
        .empty(in_stream0_TLAST_empty));
    
    always @ (*) begin
        in_stream0_TLAST_write_en <= 0;
        in_stream0_TLAST_read_en <= TRAN_in_stream0_TREADY & TRAN_in_stream0_TVALID;
    end
    
    assign TRAN_in_stream0_TLAST = in_stream0_TLAST_read_data;
    wire in_stream0_TID_full;
    wire in_stream0_TID_empty;
    reg in_stream0_TID_write_en;
    reg [5 - 1:0] in_stream0_TID_write_data;
    reg in_stream0_TID_read_en;
    wire [5 - 1:0] in_stream0_TID_read_data;
    
    fifo #(960, 5) fifo_in_stream0_TID (
        .reset(1'b0),
        .write_clock(clk),
        .write_en(in_stream0_TID_write_en),
        .write_data(in_stream0_TID_write_data),
        .read_clock(clk),
        .read_en(in_stream0_TID_read_en),
        .read_data(in_stream0_TID_read_data),
        .full(in_stream0_TID_full),
        .empty(in_stream0_TID_empty));
    
    always @ (*) begin
        in_stream0_TID_write_en <= 0;
        in_stream0_TID_read_en <= TRAN_in_stream0_TREADY & TRAN_in_stream0_TVALID;
    end
    
    assign TRAN_in_stream0_TID = in_stream0_TID_read_data;
    wire in_stream0_TDEST_full;
    wire in_stream0_TDEST_empty;
    reg in_stream0_TDEST_write_en;
    reg [6 - 1:0] in_stream0_TDEST_write_data;
    reg in_stream0_TDEST_read_en;
    wire [6 - 1:0] in_stream0_TDEST_read_data;
    
    fifo #(960, 6) fifo_in_stream0_TDEST (
        .reset(1'b0),
        .write_clock(clk),
        .write_en(in_stream0_TDEST_write_en),
        .write_data(in_stream0_TDEST_write_data),
        .read_clock(clk),
        .read_en(in_stream0_TDEST_read_en),
        .read_data(in_stream0_TDEST_read_data),
        .full(in_stream0_TDEST_full),
        .empty(in_stream0_TDEST_empty));
    
    always @ (*) begin
        in_stream0_TDEST_write_en <= 0;
        in_stream0_TDEST_read_en <= TRAN_in_stream0_TREADY & TRAN_in_stream0_TVALID;
    end
    
    assign TRAN_in_stream0_TDEST = in_stream0_TDEST_read_data;
    assign TRAN_in_stream0_TVALID = TRAN_in_stream0_TVALID_temp;

    
    reg in_stream0_TDATA_valid = 0; // ingress buffer indicator: in_stream0_TDATA
    reg in_stream0_TKEEP_valid = 0; // ingress buffer indicator: in_stream0_TKEEP
    reg in_stream0_TSTRB_valid = 0; // ingress buffer indicator: in_stream0_TSTRB
    reg in_stream0_TUSER_valid = 0; // ingress buffer indicator: in_stream0_TUSER
    reg in_stream0_TLAST_valid = 0; // ingress buffer indicator: in_stream0_TLAST
    reg in_stream0_TID_valid = 0; // ingress buffer indicator: in_stream0_TID
    reg in_stream0_TDEST_valid = 0; // ingress buffer indicator: in_stream0_TDEST
    
    assign TRAN_in_stream0_TVALID_temp = ~(in_stream0_TDATA_empty || in_stream0_TKEEP_empty || in_stream0_TSTRB_empty || in_stream0_TUSER_empty || in_stream0_TLAST_empty || in_stream0_TID_empty || in_stream0_TDEST_empty) || (in_stream0_TDATA_valid && in_stream0_TKEEP_valid && in_stream0_TSTRB_valid && in_stream0_TUSER_valid && in_stream0_TLAST_valid && in_stream0_TID_valid && in_stream0_TDEST_valid);
    
    function is_blank_char(input [7:0] in_char);
        if (in_char == " " || in_char == "\011" || in_char == "\012" || in_char == "\015") begin
            is_blank_char = 1;
        end else begin
            is_blank_char = 0;
        end
    endfunction
    
    function [199:0] read_token(input integer fp);
        integer ret;
        begin
            read_token = "";
                    ret = 0;
                    ret = $fscanf(fp,"%s",read_token);
        end
    endfunction
    
    function [199:0] rm_0x(input [199:0] token);
        reg [199:0] token_tmp;
        integer i;
        begin
            token_tmp = "";
            for (i = 0; token[15:0] != "0x"; token = token >> 8) begin
                token_tmp = (token[7:0] << (8 * i)) | token_tmp;
                i = i + 1;
            end
            rm_0x = token_tmp;
        end
    endfunction
    
    reg [31:0] transaction_load_in_stream0_TDATA;
    
    assign transaction = transaction_load_in_stream0_TDATA;
    
    initial begin : AXI_stream_driver_in_stream0_TDATA
        integer fp;
        reg [199:0] token;
        reg [16 - 1:0] data;
        reg [199:0] data_integer;
        integer fp_ingress_status;
        reg [199:0] token_ingress_status;
        reg [31:0] ingress_status;
        reg [8 * 5:1] str;
        integer ret;
        
        transaction_load_in_stream0_TDATA = 0;
        fifo_in_stream0_TDATA.clear();
        wait (reset === 1);
        fp = $fopen(`TV_IN_in_stream0_TDATA, "r");
        if (fp == 0) begin // Failed to open file
            $display("ERROR: Failed to open file \"%s\"!", `TV_IN_in_stream0_TDATA);
            $finish;
        end
        fp_ingress_status = $fopen(`INGRESS_STATUS_in_stream0_TDATA, "r");
        if (fp_ingress_status == 0) begin // Failed to open file
            $display("ERROR: Failed to open file \"%s\"!", `INGRESS_STATUS_in_stream0_TDATA);
            $finish;
        end
        token = read_token(fp);
        token_ingress_status = read_token(fp_ingress_status);
        if (token != "[[[runtime]]]") begin
            $display("ERROR: token %s != [[[runtime]]]", token);
            $finish;
        end
        token = read_token(fp); // read 1st "[[transaction]]"
        token_ingress_status = read_token(fp_ingress_status);
        forever begin
            @ (negedge clk);
            if (ready == 1) begin
                if (token != "[[[/runtime]]]") begin
                    if (token != "[[transaction]]") begin
                        $display("ERROR: token %s != [[[transaction]]]", token);
                        $finish;
                    end
                    token = read_token(fp); // skip transaction number
                    token_ingress_status = read_token(fp_ingress_status); // skip transaction number
                    token_ingress_status = read_token(fp_ingress_status); // load ingress status at beginning of transaction
                    fifo_in_stream0_TDATA.clear();
                    token = read_token(fp);
                    ret = $sscanf(token_ingress_status, "%d", ingress_status);
                    token_ingress_status = read_token(fp_ingress_status);
                    while (token != "[[/transaction]]") begin
                        if (fifo_in_stream0_TDATA.full) begin
                            $display("ERROR: FIFO is full");
                            $finish;
                        end
                        ret = $sscanf(rm_0x(token), "%x", data_integer);
                        data = data_integer;
                        fifo_in_stream0_TDATA.push(data);
                        token = read_token(fp);
                        ret = $sscanf(token_ingress_status, "%d", ingress_status);
                        token_ingress_status = read_token(fp_ingress_status);
                    end
                    in_stream0_TDATA_valid = (ingress_status > 0);
                    token = read_token(fp);
                    token_ingress_status = read_token(fp_ingress_status);
                    fifo_in_stream0_TDATA.snapshot();
                end else begin
                    fifo_in_stream0_TDATA.restore();
                    if (fp != 0) begin
                        $fclose(fp);
                        fp = 0;
                    end
                    if (fp_ingress_status != 0) begin
                        $fclose(fp_ingress_status);
                        fp_ingress_status = 0;
                    end
                end
                transaction_load_in_stream0_TDATA = transaction_load_in_stream0_TDATA + 1;
            end
        end
    end
    
    reg [31:0] transaction_load_in_stream0_TKEEP;
    
    initial begin : AXI_stream_driver_in_stream0_TKEEP
        integer fp;
        reg [199:0] token;
        reg [2 - 1:0] data;
        reg [199:0] data_integer;
        integer fp_ingress_status;
        reg [199:0] token_ingress_status;
        reg [31:0] ingress_status;
        reg [8 * 5:1] str;
        integer ret;
        
        transaction_load_in_stream0_TKEEP = 0;
        fifo_in_stream0_TKEEP.clear();
        wait (reset === 1);
        fp = $fopen(`TV_IN_in_stream0_TKEEP, "r");
        if (fp == 0) begin // Failed to open file
            $display("ERROR: Failed to open file \"%s\"!", `TV_IN_in_stream0_TKEEP);
            $finish;
        end
        fp_ingress_status = $fopen(`INGRESS_STATUS_in_stream0_TKEEP, "r");
        if (fp_ingress_status == 0) begin // Failed to open file
            $display("ERROR: Failed to open file \"%s\"!", `INGRESS_STATUS_in_stream0_TKEEP);
            $finish;
        end
        token = read_token(fp);
        token_ingress_status = read_token(fp_ingress_status);
        if (token != "[[[runtime]]]") begin
            $display("ERROR: token %s != [[[runtime]]]", token);
            $finish;
        end
        token = read_token(fp); // read 1st "[[transaction]]"
        token_ingress_status = read_token(fp_ingress_status);
        forever begin
            @ (negedge clk);
            if (ready == 1) begin
                if (token != "[[[/runtime]]]") begin
                    if (token != "[[transaction]]") begin
                        $display("ERROR: token %s != [[[transaction]]]", token);
                        $finish;
                    end
                    token = read_token(fp); // skip transaction number
                    token_ingress_status = read_token(fp_ingress_status); // skip transaction number
                    token_ingress_status = read_token(fp_ingress_status); // load ingress status at beginning of transaction
                    fifo_in_stream0_TKEEP.clear();
                    token = read_token(fp);
                    ret = $sscanf(token_ingress_status, "%d", ingress_status);
                    token_ingress_status = read_token(fp_ingress_status);
                    while (token != "[[/transaction]]") begin
                        if (fifo_in_stream0_TKEEP.full) begin
                            $display("ERROR: FIFO is full");
                            $finish;
                        end
                        ret = $sscanf(rm_0x(token), "%x", data_integer);
                        data = data_integer;
                        fifo_in_stream0_TKEEP.push(data);
                        token = read_token(fp);
                        ret = $sscanf(token_ingress_status, "%d", ingress_status);
                        token_ingress_status = read_token(fp_ingress_status);
                    end
                    in_stream0_TKEEP_valid = (ingress_status > 0);
                    token = read_token(fp);
                    token_ingress_status = read_token(fp_ingress_status);
                    fifo_in_stream0_TKEEP.snapshot();
                end else begin
                    fifo_in_stream0_TKEEP.restore();
                    if (fp != 0) begin
                        $fclose(fp);
                        fp = 0;
                    end
                    if (fp_ingress_status != 0) begin
                        $fclose(fp_ingress_status);
                        fp_ingress_status = 0;
                    end
                end
                transaction_load_in_stream0_TKEEP = transaction_load_in_stream0_TKEEP + 1;
            end
        end
    end
    
    reg [31:0] transaction_load_in_stream0_TSTRB;
    
    initial begin : AXI_stream_driver_in_stream0_TSTRB
        integer fp;
        reg [199:0] token;
        reg [2 - 1:0] data;
        reg [199:0] data_integer;
        integer fp_ingress_status;
        reg [199:0] token_ingress_status;
        reg [31:0] ingress_status;
        reg [8 * 5:1] str;
        integer ret;
        
        transaction_load_in_stream0_TSTRB = 0;
        fifo_in_stream0_TSTRB.clear();
        wait (reset === 1);
        fp = $fopen(`TV_IN_in_stream0_TSTRB, "r");
        if (fp == 0) begin // Failed to open file
            $display("ERROR: Failed to open file \"%s\"!", `TV_IN_in_stream0_TSTRB);
            $finish;
        end
        fp_ingress_status = $fopen(`INGRESS_STATUS_in_stream0_TSTRB, "r");
        if (fp_ingress_status == 0) begin // Failed to open file
            $display("ERROR: Failed to open file \"%s\"!", `INGRESS_STATUS_in_stream0_TSTRB);
            $finish;
        end
        token = read_token(fp);
        token_ingress_status = read_token(fp_ingress_status);
        if (token != "[[[runtime]]]") begin
            $display("ERROR: token %s != [[[runtime]]]", token);
            $finish;
        end
        token = read_token(fp); // read 1st "[[transaction]]"
        token_ingress_status = read_token(fp_ingress_status);
        forever begin
            @ (negedge clk);
            if (ready == 1) begin
                if (token != "[[[/runtime]]]") begin
                    if (token != "[[transaction]]") begin
                        $display("ERROR: token %s != [[[transaction]]]", token);
                        $finish;
                    end
                    token = read_token(fp); // skip transaction number
                    token_ingress_status = read_token(fp_ingress_status); // skip transaction number
                    token_ingress_status = read_token(fp_ingress_status); // load ingress status at beginning of transaction
                    fifo_in_stream0_TSTRB.clear();
                    token = read_token(fp);
                    ret = $sscanf(token_ingress_status, "%d", ingress_status);
                    token_ingress_status = read_token(fp_ingress_status);
                    while (token != "[[/transaction]]") begin
                        if (fifo_in_stream0_TSTRB.full) begin
                            $display("ERROR: FIFO is full");
                            $finish;
                        end
                        ret = $sscanf(rm_0x(token), "%x", data_integer);
                        data = data_integer;
                        fifo_in_stream0_TSTRB.push(data);
                        token = read_token(fp);
                        ret = $sscanf(token_ingress_status, "%d", ingress_status);
                        token_ingress_status = read_token(fp_ingress_status);
                    end
                    in_stream0_TSTRB_valid = (ingress_status > 0);
                    token = read_token(fp);
                    token_ingress_status = read_token(fp_ingress_status);
                    fifo_in_stream0_TSTRB.snapshot();
                end else begin
                    fifo_in_stream0_TSTRB.restore();
                    if (fp != 0) begin
                        $fclose(fp);
                        fp = 0;
                    end
                    if (fp_ingress_status != 0) begin
                        $fclose(fp_ingress_status);
                        fp_ingress_status = 0;
                    end
                end
                transaction_load_in_stream0_TSTRB = transaction_load_in_stream0_TSTRB + 1;
            end
        end
    end
    
    reg [31:0] transaction_load_in_stream0_TUSER;
    
    initial begin : AXI_stream_driver_in_stream0_TUSER
        integer fp;
        reg [199:0] token;
        reg [2 - 1:0] data;
        reg [199:0] data_integer;
        integer fp_ingress_status;
        reg [199:0] token_ingress_status;
        reg [31:0] ingress_status;
        reg [8 * 5:1] str;
        integer ret;
        
        transaction_load_in_stream0_TUSER = 0;
        fifo_in_stream0_TUSER.clear();
        wait (reset === 1);
        fp = $fopen(`TV_IN_in_stream0_TUSER, "r");
        if (fp == 0) begin // Failed to open file
            $display("ERROR: Failed to open file \"%s\"!", `TV_IN_in_stream0_TUSER);
            $finish;
        end
        fp_ingress_status = $fopen(`INGRESS_STATUS_in_stream0_TUSER, "r");
        if (fp_ingress_status == 0) begin // Failed to open file
            $display("ERROR: Failed to open file \"%s\"!", `INGRESS_STATUS_in_stream0_TUSER);
            $finish;
        end
        token = read_token(fp);
        token_ingress_status = read_token(fp_ingress_status);
        if (token != "[[[runtime]]]") begin
            $display("ERROR: token %s != [[[runtime]]]", token);
            $finish;
        end
        token = read_token(fp); // read 1st "[[transaction]]"
        token_ingress_status = read_token(fp_ingress_status);
        forever begin
            @ (negedge clk);
            if (ready == 1) begin
                if (token != "[[[/runtime]]]") begin
                    if (token != "[[transaction]]") begin
                        $display("ERROR: token %s != [[[transaction]]]", token);
                        $finish;
                    end
                    token = read_token(fp); // skip transaction number
                    token_ingress_status = read_token(fp_ingress_status); // skip transaction number
                    token_ingress_status = read_token(fp_ingress_status); // load ingress status at beginning of transaction
                    fifo_in_stream0_TUSER.clear();
                    token = read_token(fp);
                    ret = $sscanf(token_ingress_status, "%d", ingress_status);
                    token_ingress_status = read_token(fp_ingress_status);
                    while (token != "[[/transaction]]") begin
                        if (fifo_in_stream0_TUSER.full) begin
                            $display("ERROR: FIFO is full");
                            $finish;
                        end
                        ret = $sscanf(rm_0x(token), "%x", data_integer);
                        data = data_integer;
                        fifo_in_stream0_TUSER.push(data);
                        token = read_token(fp);
                        ret = $sscanf(token_ingress_status, "%d", ingress_status);
                        token_ingress_status = read_token(fp_ingress_status);
                    end
                    in_stream0_TUSER_valid = (ingress_status > 0);
                    token = read_token(fp);
                    token_ingress_status = read_token(fp_ingress_status);
                    fifo_in_stream0_TUSER.snapshot();
                end else begin
                    fifo_in_stream0_TUSER.restore();
                    if (fp != 0) begin
                        $fclose(fp);
                        fp = 0;
                    end
                    if (fp_ingress_status != 0) begin
                        $fclose(fp_ingress_status);
                        fp_ingress_status = 0;
                    end
                end
                transaction_load_in_stream0_TUSER = transaction_load_in_stream0_TUSER + 1;
            end
        end
    end
    
    reg [31:0] transaction_load_in_stream0_TLAST;
    
    initial begin : AXI_stream_driver_in_stream0_TLAST
        integer fp;
        reg [199:0] token;
        reg [1 - 1:0] data;
        reg [199:0] data_integer;
        integer fp_ingress_status;
        reg [199:0] token_ingress_status;
        reg [31:0] ingress_status;
        reg [8 * 5:1] str;
        integer ret;
        
        transaction_load_in_stream0_TLAST = 0;
        fifo_in_stream0_TLAST.clear();
        wait (reset === 1);
        fp = $fopen(`TV_IN_in_stream0_TLAST, "r");
        if (fp == 0) begin // Failed to open file
            $display("ERROR: Failed to open file \"%s\"!", `TV_IN_in_stream0_TLAST);
            $finish;
        end
        fp_ingress_status = $fopen(`INGRESS_STATUS_in_stream0_TLAST, "r");
        if (fp_ingress_status == 0) begin // Failed to open file
            $display("ERROR: Failed to open file \"%s\"!", `INGRESS_STATUS_in_stream0_TLAST);
            $finish;
        end
        token = read_token(fp);
        token_ingress_status = read_token(fp_ingress_status);
        if (token != "[[[runtime]]]") begin
            $display("ERROR: token %s != [[[runtime]]]", token);
            $finish;
        end
        token = read_token(fp); // read 1st "[[transaction]]"
        token_ingress_status = read_token(fp_ingress_status);
        forever begin
            @ (negedge clk);
            if (ready == 1) begin
                if (token != "[[[/runtime]]]") begin
                    if (token != "[[transaction]]") begin
                        $display("ERROR: token %s != [[[transaction]]]", token);
                        $finish;
                    end
                    token = read_token(fp); // skip transaction number
                    token_ingress_status = read_token(fp_ingress_status); // skip transaction number
                    token_ingress_status = read_token(fp_ingress_status); // load ingress status at beginning of transaction
                    fifo_in_stream0_TLAST.clear();
                    token = read_token(fp);
                    ret = $sscanf(token_ingress_status, "%d", ingress_status);
                    token_ingress_status = read_token(fp_ingress_status);
                    while (token != "[[/transaction]]") begin
                        if (fifo_in_stream0_TLAST.full) begin
                            $display("ERROR: FIFO is full");
                            $finish;
                        end
                        ret = $sscanf(rm_0x(token), "%x", data_integer);
                        data = data_integer;
                        fifo_in_stream0_TLAST.push(data);
                        token = read_token(fp);
                        ret = $sscanf(token_ingress_status, "%d", ingress_status);
                        token_ingress_status = read_token(fp_ingress_status);
                    end
                    in_stream0_TLAST_valid = (ingress_status > 0);
                    token = read_token(fp);
                    token_ingress_status = read_token(fp_ingress_status);
                    fifo_in_stream0_TLAST.snapshot();
                end else begin
                    fifo_in_stream0_TLAST.restore();
                    if (fp != 0) begin
                        $fclose(fp);
                        fp = 0;
                    end
                    if (fp_ingress_status != 0) begin
                        $fclose(fp_ingress_status);
                        fp_ingress_status = 0;
                    end
                end
                transaction_load_in_stream0_TLAST = transaction_load_in_stream0_TLAST + 1;
            end
        end
    end
    
    reg [31:0] transaction_load_in_stream0_TID;
    
    initial begin : AXI_stream_driver_in_stream0_TID
        integer fp;
        reg [199:0] token;
        reg [5 - 1:0] data;
        reg [199:0] data_integer;
        integer fp_ingress_status;
        reg [199:0] token_ingress_status;
        reg [31:0] ingress_status;
        reg [8 * 5:1] str;
        integer ret;
        
        transaction_load_in_stream0_TID = 0;
        fifo_in_stream0_TID.clear();
        wait (reset === 1);
        fp = $fopen(`TV_IN_in_stream0_TID, "r");
        if (fp == 0) begin // Failed to open file
            $display("ERROR: Failed to open file \"%s\"!", `TV_IN_in_stream0_TID);
            $finish;
        end
        fp_ingress_status = $fopen(`INGRESS_STATUS_in_stream0_TID, "r");
        if (fp_ingress_status == 0) begin // Failed to open file
            $display("ERROR: Failed to open file \"%s\"!", `INGRESS_STATUS_in_stream0_TID);
            $finish;
        end
        token = read_token(fp);
        token_ingress_status = read_token(fp_ingress_status);
        if (token != "[[[runtime]]]") begin
            $display("ERROR: token %s != [[[runtime]]]", token);
            $finish;
        end
        token = read_token(fp); // read 1st "[[transaction]]"
        token_ingress_status = read_token(fp_ingress_status);
        forever begin
            @ (negedge clk);
            if (ready == 1) begin
                if (token != "[[[/runtime]]]") begin
                    if (token != "[[transaction]]") begin
                        $display("ERROR: token %s != [[[transaction]]]", token);
                        $finish;
                    end
                    token = read_token(fp); // skip transaction number
                    token_ingress_status = read_token(fp_ingress_status); // skip transaction number
                    token_ingress_status = read_token(fp_ingress_status); // load ingress status at beginning of transaction
                    fifo_in_stream0_TID.clear();
                    token = read_token(fp);
                    ret = $sscanf(token_ingress_status, "%d", ingress_status);
                    token_ingress_status = read_token(fp_ingress_status);
                    while (token != "[[/transaction]]") begin
                        if (fifo_in_stream0_TID.full) begin
                            $display("ERROR: FIFO is full");
                            $finish;
                        end
                        ret = $sscanf(rm_0x(token), "%x", data_integer);
                        data = data_integer;
                        fifo_in_stream0_TID.push(data);
                        token = read_token(fp);
                        ret = $sscanf(token_ingress_status, "%d", ingress_status);
                        token_ingress_status = read_token(fp_ingress_status);
                    end
                    in_stream0_TID_valid = (ingress_status > 0);
                    token = read_token(fp);
                    token_ingress_status = read_token(fp_ingress_status);
                    fifo_in_stream0_TID.snapshot();
                end else begin
                    fifo_in_stream0_TID.restore();
                    if (fp != 0) begin
                        $fclose(fp);
                        fp = 0;
                    end
                    if (fp_ingress_status != 0) begin
                        $fclose(fp_ingress_status);
                        fp_ingress_status = 0;
                    end
                end
                transaction_load_in_stream0_TID = transaction_load_in_stream0_TID + 1;
            end
        end
    end
    
    reg [31:0] transaction_load_in_stream0_TDEST;
    
    initial begin : AXI_stream_driver_in_stream0_TDEST
        integer fp;
        reg [199:0] token;
        reg [6 - 1:0] data;
        reg [199:0] data_integer;
        integer fp_ingress_status;
        reg [199:0] token_ingress_status;
        reg [31:0] ingress_status;
        reg [8 * 5:1] str;
        integer ret;
        
        transaction_load_in_stream0_TDEST = 0;
        fifo_in_stream0_TDEST.clear();
        wait (reset === 1);
        fp = $fopen(`TV_IN_in_stream0_TDEST, "r");
        if (fp == 0) begin // Failed to open file
            $display("ERROR: Failed to open file \"%s\"!", `TV_IN_in_stream0_TDEST);
            $finish;
        end
        fp_ingress_status = $fopen(`INGRESS_STATUS_in_stream0_TDEST, "r");
        if (fp_ingress_status == 0) begin // Failed to open file
            $display("ERROR: Failed to open file \"%s\"!", `INGRESS_STATUS_in_stream0_TDEST);
            $finish;
        end
        token = read_token(fp);
        token_ingress_status = read_token(fp_ingress_status);
        if (token != "[[[runtime]]]") begin
            $display("ERROR: token %s != [[[runtime]]]", token);
            $finish;
        end
        token = read_token(fp); // read 1st "[[transaction]]"
        token_ingress_status = read_token(fp_ingress_status);
        forever begin
            @ (negedge clk);
            if (ready == 1) begin
                if (token != "[[[/runtime]]]") begin
                    if (token != "[[transaction]]") begin
                        $display("ERROR: token %s != [[[transaction]]]", token);
                        $finish;
                    end
                    token = read_token(fp); // skip transaction number
                    token_ingress_status = read_token(fp_ingress_status); // skip transaction number
                    token_ingress_status = read_token(fp_ingress_status); // load ingress status at beginning of transaction
                    fifo_in_stream0_TDEST.clear();
                    token = read_token(fp);
                    ret = $sscanf(token_ingress_status, "%d", ingress_status);
                    token_ingress_status = read_token(fp_ingress_status);
                    while (token != "[[/transaction]]") begin
                        if (fifo_in_stream0_TDEST.full) begin
                            $display("ERROR: FIFO is full");
                            $finish;
                        end
                        ret = $sscanf(rm_0x(token), "%x", data_integer);
                        data = data_integer;
                        fifo_in_stream0_TDEST.push(data);
                        token = read_token(fp);
                        ret = $sscanf(token_ingress_status, "%d", ingress_status);
                        token_ingress_status = read_token(fp_ingress_status);
                    end
                    in_stream0_TDEST_valid = (ingress_status > 0);
                    token = read_token(fp);
                    token_ingress_status = read_token(fp_ingress_status);
                    fifo_in_stream0_TDEST.snapshot();
                end else begin
                    fifo_in_stream0_TDEST.restore();
                    if (fp != 0) begin
                        $fclose(fp);
                        fp = 0;
                    end
                    if (fp_ingress_status != 0) begin
                        $fclose(fp_ingress_status);
                        fp_ingress_status = 0;
                    end
                end
                transaction_load_in_stream0_TDEST = transaction_load_in_stream0_TDEST + 1;
            end
        end
    end

endmodule