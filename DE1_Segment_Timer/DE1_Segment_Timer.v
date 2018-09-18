module DE1_Segment_Timer	// ����Ŭ���� �̿��� 7Segment Ÿ�̸� ��� ����� ��Ʈ ���� 
(
	input clk_50M,	// ���� Ŭ��(50MHz) �Է� ��ȣ
	input rst,		// Ÿ�̸� �ʱ�ȭ ��ȣ
	
	output[6:0] segment_1000,	// õ�� �ڸ� �������
	output[6:0] segment_100,	// ���� �ڸ� �������
	output[6:0] segment_10,		// ���� �ڸ� �������
	output[6:0] segment_1		// ���� �ڸ� �������
);

wire clk_10M;	// PLLȸ�ηκ��� 10MHz Ŭ����ȣ �Է�
reg clk_100K;	// ī���͸� Ȱ���� 100KHz Ŭ����ȣ
reg clk_1K;		// ī���͸� Ȱ���� 1KHz Ŭ����ȣ
reg clk_10;		// ī���͸� Ȱ���� 10Hz Ŭ����ȣ
reg clk_1;		// ī���͸� Ȱ���� 1Hz Ŭ����ȣ

reg[5:0] cnt_10M;	// 10MHz Ŭ����ȣ ī��Ʈ 
reg[5:0] cnt_100K;	// 100KHz Ŭ����ȣ ī��Ʈ 
reg[5:0] cnt_1K;	// 1KHz Ŭ����ȣ ī��Ʈ 
reg[2:0] cnt_10;	// 10Hz Ŭ����ȣ ī��Ʈ 
reg[5:0] cnt;		// 1Hz Ŭ����ȣ ī��Ʈ 
reg[5:0] m_cnt;

wire[3:0] digit_1000;	// õ�� �ڸ� ������ ����
wire[3:0] digit_100;	// ���� �ڸ� ������ ����
wire[3:0] digit_10;		// ���� �ڸ� ������ ����
wire[3:0] digit_1;		// ���� �ڸ� ������ ����

wire[9:0] mod_1000;		// õ�� �ڸ��� ������ ������
wire[6:0] mod_100;		// ���� �ڸ��� ������ ������
wire[3:0] mod_10;		// ���� �ڸ��� ������ ������

wire rst_bar; //-------------

// ---------------
//assign digit_1000 = cnt/10'd1000;					// 1000�� �ڸ��� ����
//assign mod_1000 = cnt - (digit_1000*10'd1000); 	// 1000�� �ڸ��� ���� �� ������
//assign digit_100 = mod_1000/7'd100;				// 100�� �ڸ��� ����
//assign mod_100 = mod_1000 - (digit_100*7'd100);	// 100�� �ڸ��� ���� �� ������
//assign digit_10 = mod_100/4'd10;					// 10�� �ڸ��� ����

// ---------------
assign digit_1000 = m_cnt/4'd10;					// 1000�� �ڸ��� ����
assign mod_1000 = m_cnt - (digit_1000*4'd10); 	// 1000�� �ڸ��� ���� �� ������
assign digit_100 = mod_1000;

assign digit_10 = cnt/4'd10;
assign mod_10 = cnt - (digit_10*4'd10);		// 10�� �ڸ��� ���� �� ������
assign digit_1 = mod_10;						// 1�� �ڸ��� ���� 

assign rst_bar = ~rst;

my_clock_gen clock_gen	// Ŭ�� ��ȣ ��� ����� ��ȣ �̸��� ���� ����
(
	.areset(rst_bar),			// reset ��ȣ ����
	.inclk0(clk_50M),		// 50MHz �Է� Ŭ����ȣ ����
	.c0(clk_10M),			// 10MHz ��� Ŭ����ȣ ����
	.locked()				// ���� ���� ������� ����
);

always@(posedge clk_10M or posedge rst_bar)	// 10MHz Ŭ����ȣ Ȥ�� Reset��ȣ ��¿��� ��
begin
   if(rst_bar)	// Reset��ȣ �߻���
   begin   
      cnt_10M <= 6'd0;	// 10MHz Ŭ�� ī��Ʈ �ʱ�ȭ
      clk_100K <= 1'b0;	// 100KHz Ŭ�� ��ȣ �ʱ�ȭ
   end
   
   else 
   begin
      if(cnt_10M == 6'd49)			// 10MHz Ŭ�� 50�� ī��Ʈ �� ���
      begin
         cnt_10M <= 6'd0;			// 10MHz Ŭ�� ī��Ʈ �ʱ�ȭ 
         clk_100K <= ~clk_100K;		// Ŭ����ȣ Toggle // �� 100�� ī��Ʈ �� ���ֱ� Ŭ�� �߻� (100KHz Ŭ��)
      end
      
      else cnt_10M <= cnt_10M + 1'd1;	// 50�� �̸��� ��쿡�� �ܼ��� ī��Ʈ
   end
end

always@(posedge clk_100K or posedge rst_bar) // 100KHz Ŭ����ȣ Ȥ�� Reset��ȣ ��¿��� ��
begin 
   if(rst_bar)	// Reset��ȣ �߻���
   begin   
      cnt_100K <= 6'd0;	// 100KHz Ŭ�� ī��Ʈ �ʱ�ȭ
      clk_1K <= 1'b0;	// 1KHz Ŭ�� ��ȣ �ʱ�ȭ
   end
   else
   begin
      if(cnt_100K == 6'd49)		// 100KHz Ŭ�� 50�� ī��Ʈ �� ���
      begin   
         cnt_100K <= 6'd0;		// 100KHz Ŭ�� ī��Ʈ �ʱ�ȭ 
         clk_1K <= ~clk_1K;		// Ŭ����ȣ Toggle // �� 100�� ī��Ʈ �� ���ֱ� Ŭ�� �߻� (1KHz Ŭ��)
      end
      else
      cnt_100K <= cnt_100K + 1'd1;	// 50�� �̸��� ��쿡�� �ܼ��� ī��Ʈ
   end
end

always@(posedge clk_1K or posedge rst_bar)	// 1KHz Ŭ����ȣ Ȥ�� Reset��ȣ ��¿��� ��
begin
   if(rst_bar)	// Reset��ȣ �߻���
   begin
      cnt_1K <= 6'd0;	// 1KHz Ŭ�� ī��Ʈ �ʱ�ȭ
      clk_10 <= 1'b0;	// 10Hz Ŭ�� ��ȣ �ʱ�ȭ
   end

   else 
   begin
      if(cnt_1K == 6'd49)	// 1KHz Ŭ�� 50�� ī��Ʈ �� ���
      begin 
         cnt_1K <= 6'd0;	// 1KHz Ŭ�� ī��Ʈ �ʱ�ȭ 
         clk_10 <= ~clk_10;	// Ŭ����ȣ Toggle // �� 100�� ī��Ʈ �� ���ֱ� Ŭ�� �߻� (10Hz Ŭ��)
      end
      else cnt_1K <= cnt_1K +1'd1;	// 50�� �̸��� ��쿡�� �ܼ��� ī��Ʈ
   end
end

always@(posedge clk_10 or posedge rst_bar) // 10Hz Ŭ����ȣ Ȥ�� Reset��ȣ ��¿��� ��
begin
   if(rst_bar)	// Reset��ȣ �߻���
   begin
      cnt_10 <= 3'd0;	// 10Hz Ŭ�� ī��Ʈ �ʱ�ȭ
      clk_1 <= 1'b0;	// 1Hz Ŭ�� ��ȣ �ʱ�ȭ
   end
   else
   begin
      if(cnt_10 == 3'd4)	// 10Hz Ŭ�� 5�� ī��Ʈ �� ��� 
      begin
         cnt_10 <= 3'd0;	// 10Hz Ŭ�� ī��Ʈ �ʱ�ȭ 
         clk_1 <= ~clk_1;	// Ŭ����ȣ Toggle // �� 10�� ī��Ʈ �� ���ֱ� Ŭ�� �߻� (1Hz Ŭ��)
      end
      
      else cnt_10 <= cnt_10 + 1'd1;	// 5�� �̸��� ��쿡�� �ܼ��� ī��Ʈ
   end
end

always@(posedge clk_1 or posedge rst_bar) // 1Hz Ŭ����ȣ Ȥ�� Reset��ȣ ��¿��� ��
begin
   if(rst_bar) // Reset��ȣ �߻���
   begin
		cnt<= 6'd0;	// 1Hz Ŭ�� ī��Ʈ �ʱ�ȭ  --
		m_cnt<= 6'd0; // ----------------
   end

   else 
   begin 
      if(cnt == 6'd59) 
      begin
		   cnt <= 6'd0;	// 60�� ī��Ʈ �� 1Hz Ŭ�� �ʱ�ȭ (60�� = 1��)
		   if(m_cnt == 6'd59) m_cnt <= 6'd0;
		   else m_cnt <= m_cnt + 1'd1;
	  end
      else cnt <= cnt + 1'd1;		// 60�� �̸��� ��� ī��Ʈ
   end
end

// 4���� Segment ��� ��ü ���� �� �� ������ ���� ����� ��ȣ ����
bcd_7segment bcd_7segment_1000(digit_1000, segment_1000);	// õ�� �ڸ� ���� �Է� �� 7-Segment ���
bcd_7segment bcd_7segment_100(digit_100, segment_100);		// ���� �ڸ� ���� �Է� �� 7-Segment ���
bcd_7segment bcd_7segment_10(digit_10, segment_10);			// ���� �ڸ� ���� �Է� �� 7-Segment ���
bcd_7segment bcd_7segment_1(digit_1, segment_1);			// ���� �ڸ� ���� �Է� �� 7-Segment ���

endmodule 	// ����Ŭ���� �̿��� 7Segment Ÿ�̸� ��� ��� �Ϸ�
