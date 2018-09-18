module DE1_StopWatch
(
	input clk_50M,	// ���� Ŭ��(50MHz) �Է� ��ȣ
	input rst,		// Ÿ�̸� �ʱ�ȭ ��ȣ
	input stop,
	input lap,
	
	output[6:0] segment_1m,		// õ�� �ڸ� �������
	output[6:0] segment_10s,	// ���� �ڸ� �������
	output[6:0] segment_1s,		// ���� �ڸ� �������
	output[6:0] segment_100ms	// ���� �ڸ� �������
);

wire clk_40M;	// PLLȸ�ηκ��� 40MHz Ŭ����ȣ �Է�
reg clk_200K;
reg clk_1K;
reg clk_10;
reg clk_1;

reg[7:0] cnt_40M;	// 40MHz Ŭ����ȣ ī��Ʈ 
reg[7:0] cnt_200K;	// 200KHz Ŭ����ȣ ī��Ʈ 
reg[5:0] cnt_1K;	// 1KHz Ŭ����ȣ ī��Ʈ 
reg[2:0] cnt_10;	// 10Hz Ŭ����ȣ ī��Ʈ
reg[5:0] cnt;		// 1Hz Ŭ����ȣ ī��Ʈ 
reg[3:0] m_cnt;		//

reg en_cnt;
reg en_update;

wire[3:0] digit_1m;
wire[3:0] digit_10s;
wire[3:0] digit_1s;
wire[3:0] digit_100ms;

reg[3:0] pre_1m;
reg[3:0] pre_10s;
reg[3:0] pre_1s;
reg[3:0] pre_1ms;

wire[3:0] mod_10s;

wire rst_bar;

assign digit_1m = en_update ? m_cnt : pre_1m;
assign digit_10s = en_update ? cnt/4'd10 : pre_10s;
assign mod_10s = cnt - (digit_10s*4'd10);
assign digit_1s = en_update ? mod_10s : pre_1s;
assign digit_100ms = en_update ? cnt_10 : pre_1ms;

assign rst_bar = ~rst;

my_clock_gen clock_gen	// Ŭ�� ��ȣ ��� ����� ��ȣ �̸��� ���� ����
(
	.areset(rst_bar),			// reset ��ȣ ����
	.inclk0(clk_50M),		// 50MHz �Է� Ŭ����ȣ ����
	.c0(clk_40M),			// 10MHz ��� Ŭ����ȣ ����
	.locked()				// ���� ���� ������� ����
);

initial
begin
	en_cnt = 1;
	en_update = 1;
	pre_1m = 0;
	pre_10s = 0;
	pre_1s = 0;
	pre_1ms = 0;
end

always @(negedge en_update)
begin
	pre_1m <= m_cnt;
	pre_10s <= cnt/4'd10;
	//pre_1s <= mod_10s;
	pre_1s <= cnt%4'd10;
	pre_1ms <= cnt_10;
end

always @(negedge lap)
begin
	en_update <= ~en_update;
end

always @(negedge stop)
begin
	en_cnt <= ~en_cnt;
end

always @(posedge clk_40M or posedge rst_bar)	// 10MHz Ŭ����ȣ Ȥ�� Reset��ȣ ��¿��� ��
begin
   if(rst_bar)	// Reset��ȣ �߻���
   begin   
      cnt_40M <= 7'd0;	// 40MHz Ŭ�� ī��Ʈ �ʱ�ȭ
      clk_200K <= 1'b0;	// 200KHz Ŭ�� ��ȣ �ʱ�ȭ
   end
   
   else 
   begin
      if(cnt_40M == 7'd99)			// 40MHz Ŭ�� 100�� ī��Ʈ �� ���
      begin
         cnt_40M <= 7'd0;			// 40MHz Ŭ�� ī��Ʈ �ʱ�ȭ 
         clk_200K <= ~clk_200K;		// Ŭ����ȣ Toggle // �� 200�� ī��Ʈ �� ���ֱ� Ŭ�� �߻� (200KHz Ŭ��)
      end
      
      else if(en_cnt) cnt_40M <= cnt_40M + 1'd1;	// 200�� �̸��� ��쿡�� �ܼ��� ī��Ʈ
   end
end

always @(posedge clk_200K or posedge rst_bar) // 200KHz Ŭ����ȣ Ȥ�� Reset��ȣ ��¿��� ��
begin 
   if(rst_bar)	// Reset��ȣ �߻���
   begin   
      cnt_200K <= 7'd0;	// 100KHz Ŭ�� ī��Ʈ �ʱ�ȭ
      clk_1K <= 1'b0;	// 1KHz Ŭ�� ��ȣ �ʱ�ȭ
   end
   else
   begin
      if(cnt_200K == 7'd99)		// 200KHz Ŭ�� 100�� ī��Ʈ �� ���
      begin   
         cnt_200K <= 7'd0;		// 200KHz Ŭ�� ī��Ʈ �ʱ�ȭ 
         clk_1K <= ~clk_1K;		// Ŭ����ȣ Toggle // �� 200�� ī��Ʈ �� ���ֱ� Ŭ�� �߻� (1KHz Ŭ��)
      end
      else
      cnt_200K <= cnt_200K + 1'd1;	// 100�� �̸��� ��쿡�� �ܼ��� ī��Ʈ
   end
end

always @(posedge clk_1K or posedge rst_bar)	// 1KHz Ŭ����ȣ Ȥ�� Reset��ȣ ��¿��� ��
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

always @(posedge clk_10 or posedge rst_bar) // 10Hz Ŭ����ȣ Ȥ�� Reset��ȣ ��¿��� ��
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

always @(posedge clk_1 or posedge rst_bar) // 1Hz Ŭ����ȣ Ȥ�� Reset��ȣ ��¿��� ��
begin
   if(rst_bar) // Reset��ȣ �߻���
   begin
		cnt<= 6'd0;	// 1Hz Ŭ�� ī��Ʈ �ʱ�ȭ  --
		m_cnt<= 4'd0; // ----------------
   end

   else 
   begin 
      if(cnt == 6'd59) 
      begin
		   cnt <= 6'd0;	// 60�� ī��Ʈ �� 1Hz Ŭ�� �ʱ�ȭ (60�� = 1��)
		   if(m_cnt == 4'd9) m_cnt <= 4'd0;
		   else m_cnt <= m_cnt + 1'd1;
	  end
      else cnt <= cnt + 1'd1;		// 60�� �̸��� ��� ī��Ʈ
   end
end

bcd_7segment bcd_7segment_1m(digit_1m, segment_1m);
bcd_7segment bcd_7segment_10s(digit_10s, segment_10s);
bcd_7segment bcd_7segment_1s(digit_1s, segment_1s);
bcd_7segment bcd_7segment_1ms(digit_100ms, segment_100ms);

endmodule 