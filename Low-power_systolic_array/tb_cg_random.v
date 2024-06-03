`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/26 16:29:58
// Design Name: 
// Module Name: tb_cg_random
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


`timescale 1ns / 1ps

module tb_cg_random ();

parameter size=8, row=8, col=8, extention_factor = 4, column_length = 4;
// Inputs
reg clk;
reg reset;
wire [size-1:0] a [0:row-1];            // a[1], ... , a[N] : NxN이므로 input channel N개
wire [size-1:0] b [0:row*col-1];        // b[1] ~ b[NxN] : PE의 수만큼 선언

// Outputs
wire [2*size:0] c [0:col*(row)-1];            // c[1], ... , c[N] : NxN이므로 output channel N개

reg [row*size-1:0] a_vec;
reg [extention_factor*extention_factor*row*col*size-1:0] a_array;
reg [row*col*size-1:0] b_vec;
wire [col*(row)*(2*size+1)-1:0] c_vec;
reg [3:0] fixed_seed = 10;

genvar i;
generate 
    for(i=0;i< row; i=i+1) begin
        //assign a[i] = a_vec[(row-i)*size-1:(row-i-1)*size];
        assign a[i] = a_vec[size*(row-(i))-1:size*(row-(i+1))];
    end
endgenerate

genvar j;
generate 
    for(j=0;j< col*(row); j=j+1) begin
        integer current_col = j % col;
        integer current_row = j / col;
        //assign c[j] = c_vec[(col-j)*(2*size+1)-1:(col-j-1)*(2*size+1)];
        assign c[j] = c_vec[(2*size+1)*(row-j+1)-1:(2*size+1)*(row-j)];
    end
endgenerate

genvar k;
generate 
    for(k=0;k< row*col; k=k+1) begin
        assign b[k] = b_vec[(row*col-k)*size-1:(row*col-k-1)*size];
    end
endgenerate

// Instantiate Systolic Array
basic_pe_array_ws sa_4x4 (
.clk(clk), 
.reset(reset),
.a_vec(a_vec),                               // inputs
.b_vec(b_vec), // weights
.c_vec(c_vec)                                // outputs
);

function [row*size-1:0] gen_input (input integer cycle,input [extention_factor*extention_factor*row*col*size-1:0] original_array);
    integer i, current_row, count;
    begin
        gen_input = 0;
        for (i = 0; i < extention_factor*col ; i = i + 1) begin
            current_row = cycle - i;
            if (current_row < 0 || current_row >= extention_factor*row) begin
                gen_input = gen_input << size;
            end
            else begin
                gen_input = gen_input << size;
                gen_input = gen_input + ((original_array >> ( ( extention_factor*extention_factor*row*col-(current_row*col + i)-1)*size)) & {{(row*col-1){8'd0}}, {8'hff} });
            end
        end
    end
    
endfunction

function [extention_factor*extention_factor*col*row*size-1:0] gen_original_array(input integer n);
    integer i;
    //integer seed = $urandom;
    begin
        for (i=0; i<extention_factor*extention_factor*n; i=i+1) begin
        gen_original_array = gen_original_array << size;
            if ($urandom_range(1,255) > 204.8) begin
                gen_original_array [size-1:0] = $urandom_range(1,255);
        //$urandom(i)%255 + 1;
        //gen_original_array + (($urandom(fixed_seed)%255+1) & {{(row*col-1){8'd0}}, {8'hff}});
            end 
            else begin
                gen_original_array [size-1:0] = 0;
            end
        end
    end       
endfunction

function [col*row*size-1:0] gen_original_weight_array(input integer n);
    integer i, count_0, count_1, count_2, count_3;
    //integer seed = $urandom;
    begin
        for (i=0; i<n; i=i+1) begin
            gen_original_weight_array = gen_original_weight_array << size;
            
            if ($urandom_range(1,255) > 204.8) begin
                gen_original_weight_array [size-1:0] = $urandom_range(1,255);
            end 
        //$urandom(i)%255 + 1;
        //gen_original_array + (($urandom(fixed_seed)%255+1) & {{(row*col-1){8'd0}}, {8'hff}});
            else begin
                gen_original_weight_array [size-1:0] = 0;
            end
            
            //if (i%column_length == column_length-1 && gen_original_weight_array [(column_length)*size-1:size] == 0) begin
            //    gen_original_weight_array [size-1:0] = $urandom_range(1,255);
            //end
        end
    end    
endfunction

//---------------------아래부터 동작 시작----------------------------------

always #5 clk = ~clk; // clock 주기는 10ns
integer cycles, n;

initial begin
    // 모든 레지스터 초기화
    clk = 0;
    reset = 0;
    a_vec = 0;
    a_array = 0;
    b_vec = 0;
    cycles = 0;
    
    #5 reset = 1; // 모든 PE들 초기화
    #5 reset = 0;
    
    // 각 PE들에 weights 모두 전달
    for (n=0 ; n < 1; n = n+1) begin
        #10 b_vec = gen_original_weight_array(n+row*col);
    end
    //#10; b_vec = {8{{2{8'd1}},{2{8'd2}},{2{8'd1}},{2{8'd2}},{2{8'd3}},{2{8'd4}},{2{8'd3}},{2{8'd4}}}};
         //a_array = {16{$urandom(fixed_seed)%255+1}}; 
         //{2{{1{8'd1}},{1{8'd2}},{1{8'd4}},{1{8'd6}},{1{8'd2}},{1{8'd3}},{1{8'd5}},{1{8'd7}}}};
    for (n=0 ; n < 1; n = n+1) begin
        #10 a_array = gen_original_array(n+row*col);
    end
    
        #10 a_vec = gen_input(0, a_array);
        
        //$read_lib_saif();
        //$set_toggle_region(dut);
        //$toggle_start();
    
    for (cycles = 1; cycles < (3*extention_factor*extention_factor*col - 3); cycles = cycles + 1) begin
        #10 a_vec = gen_input(cycles, a_array);
    end
    
        //$toggle_stop();
        //$toggle_report(, 1.0e-9, "");
        
        #10 a_vec = gen_input(3*extention_factor*extention_factor*col - 2, a_array);
    #80;
    $finish;
    
end
      
endmodule
