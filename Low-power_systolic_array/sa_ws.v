`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/11 13:25:02
// Design Name: 
// Module Name: sa_ws
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


module basic_pe_array_ws (clk, reset, a_vec, b_vec, c_vec);

parameter size=8, row=8, col=8;
input wire clk,reset;                                               // clock, reset ��
input wire [row*size-1:0] a_vec;                            // inputs ����         8bits
input wire [row*col*size-1:0] b_vec;                // weights ����        8bits
output wire [col*(row)*(2*size+1)-1:0] c_vec;                     // outputs ����        17bits

wire [size-1:0] wa [1:row*col];       // PE�� ���� wire ����; wa:input , wc:partial sum
wire [2*size:0] wc [1:col*row];
wire [size-1:0] b [1:row*col];

genvar j;
generate
    for (j =1; j <= row; j=j+1) begin                //pe_group ����            
        assign wa[col*(j-1)+1] = a_vec[size*(row-j+1)-1:size*(row-j)];
    end
    /*
    for (j =1; j <= row*col; j=j+1) begin
        if ((j%pe_group == 1) && (j%col != 1)) begin
            assign wa[j] = wa [j-pe_group];
        end
    end
    */
endgenerate

genvar k;
generate
    for (k =1; k <= (row)*col; k=k+1) begin     //column-wise weight packing       
        if(k%col != 0) begin                        
            assign c_vec[(2*size+1)*(col*(row)-k+1)-1:(2*size+1)*(col*(row)-k)] = wc[k];
        end
        else if (k%col == 0) begin
            assign c_vec[(2*size+1)*(col*(row)-k+1)-1:(2*size+1)*(col*(row)-k)] = wc[k];
        end
    end
endgenerate

genvar n;
generate
    for (n =1; n <= row*col; n=n+1) begin
        assign b[n] = b_vec[size*(row*col-n+1)-1:size*(row*col-n)];
    end
endgenerate

genvar i;
generate 
    for (i=1; i<=row*col; i=i+1) begin: sa
        if (i < col) begin
            pe_ws pe (.clk(clk), .reset(reset), .in_a(wa[i]), .in_b(b[i]), .in_c(0), .out_a(wa[i+1]), .out_c(wc[i]));
        end    
        else if (i == col) begin
            pe_ws pe (.clk(clk), .reset(reset), .in_a(wa[i]), .in_b(b[i]), .in_c(0), .out_a(), .out_c(wc[i]));
        end        
        else if (i > col && (i)%col != 0) begin
            pe_ws pe (.clk(clk), .reset(reset), .in_a(wa[i]), .in_b(b[i]), .in_c(wc[i-row]), .out_a(wa[i+1]), .out_c(wc[i]));
        end
        else if(i%col ==0)begin
            pe_ws pe (.clk(clk), .reset(reset), .in_a(wa[i]), .in_b(b[i]), .in_c(wc[i-row]), .out_a(), .out_c(wc[i]));
        end
    end
endgenerate

endmodule
