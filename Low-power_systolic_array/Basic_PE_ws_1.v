module pe_ws(clk,reset,in_a,in_b,in_c,out_a,out_c); // module instantiation

parameter size=8;                 // input�� ��Ʈ ���� 8bits���� ����
input wire reset,clk;                   // reset, clock ��
input wire [size-1:0] in_a,in_b;   // input A,B data size, wire
input wire [2*size:0] in_c;  
output wire [2*size:0] out_c;       // output C data size, reg
output wire [size-1:0] out_a; // output A, B data size, reg
reg [2*size:0] reg_c;
reg [size-1:0] reg_a, reg_b;

 always @(posedge clk)begin           
    if(reset) begin                     // reset��, ��� PE output 0���� �ʱ�ȭ 
      /*
      out_a<=0;                          // output A, C = 0
      out_c<=0;
      */
      reg_a <= 0;
      reg_b <= 0;
      reg_c <= 0;
    end
    else begin                          //clock posedge ��, output C�� 2 �Է��� ���� ���� ����
      /*
      out_a<=in_a;
      out_c<=in_c+in_a*in_b;            //output A�� input A�� shift�� ��
      */
      reg_a <= in_a;
      reg_b <= in_b;
      reg_c <= in_c;
    end
 end
    assign out_a = reg_a;
    assign out_c = reg_a*reg_b + reg_c;
 
endmodule