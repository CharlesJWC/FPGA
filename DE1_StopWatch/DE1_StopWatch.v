module DE1_StopWatch
(
	input clk_50M,	// 내부 클럭(50MHz) 입력 신호
	input rst,		// 타이머 초기화 신호
	input stop,
	input lap,
	
	output[6:0] segment_1m,		// 천의 자리 숫자출력
	output[6:0] segment_10s,	// 백의 자리 숫자출력
	output[6:0] segment_1s,		// 십의 자리 숫자출력
	output[6:0] segment_100ms	// 일의 자리 숫자출력
);

wire clk_40M;	// PLL회로로부터 40MHz 클럭신호 입력
reg clk_200K;
reg clk_1K;
reg clk_10;
reg clk_1;

reg[7:0] cnt_40M;	// 40MHz 클럭신호 카운트 
reg[7:0] cnt_200K;	// 200KHz 클럭신호 카운트 
reg[5:0] cnt_1K;	// 1KHz 클럭신호 카운트 
reg[2:0] cnt_10;	// 10Hz 클럭신호 카운트
reg[5:0] cnt;		// 1Hz 클럭신호 카운트 
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

my_clock_gen clock_gen	// 클럭 신호 모듈 입출력 신호 이름을 통한 매핑
(
	.areset(rst_bar),			// reset 신호 매핑
	.inclk0(clk_50M),		// 50MHz 입력 클럭신호 매핑
	.c0(clk_40M),			// 10MHz 출력 클럭신호 매핑
	.locked()				// 위상 고정 사용하지 않음
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

always @(posedge clk_40M or posedge rst_bar)	// 10MHz 클럭신호 혹은 Reset신호 상승엣지 시
begin
   if(rst_bar)	// Reset신호 발생시
   begin   
      cnt_40M <= 7'd0;	// 40MHz 클럭 카운트 초기화
      clk_200K <= 1'b0;	// 200KHz 클럭 신호 초기화
   end
   
   else 
   begin
      if(cnt_40M == 7'd99)			// 40MHz 클럭 100번 카운트 한 경우
      begin
         cnt_40M <= 7'd0;			// 40MHz 클럭 카운트 초기화 
         clk_200K <= ~clk_200K;		// 클럭신호 Toggle // 총 200번 카운트 시 한주기 클럭 발생 (200KHz 클럭)
      end
      
      else if(en_cnt) cnt_40M <= cnt_40M + 1'd1;	// 200번 미만의 경우에는 단순히 카운트
   end
end

always @(posedge clk_200K or posedge rst_bar) // 200KHz 클럭신호 혹은 Reset신호 상승엣지 시
begin 
   if(rst_bar)	// Reset신호 발생시
   begin   
      cnt_200K <= 7'd0;	// 100KHz 클럭 카운트 초기화
      clk_1K <= 1'b0;	// 1KHz 클럭 신호 초기화
   end
   else
   begin
      if(cnt_200K == 7'd99)		// 200KHz 클럭 100번 카운트 한 경우
      begin   
         cnt_200K <= 7'd0;		// 200KHz 클럭 카운트 초기화 
         clk_1K <= ~clk_1K;		// 클럭신호 Toggle // 총 200번 카운트 시 한주기 클럭 발생 (1KHz 클럭)
      end
      else
      cnt_200K <= cnt_200K + 1'd1;	// 100번 미만의 경우에는 단순히 카운트
   end
end

always @(posedge clk_1K or posedge rst_bar)	// 1KHz 클럭신호 혹은 Reset신호 상승엣지 시
begin
   if(rst_bar)	// Reset신호 발생시
   begin
      cnt_1K <= 6'd0;	// 1KHz 클럭 카운트 초기화
      clk_10 <= 1'b0;	// 10Hz 클럭 신호 초기화
   end

   else 
   begin
      if(cnt_1K == 6'd49)	// 1KHz 클럭 50번 카운트 한 경우
      begin 
         cnt_1K <= 6'd0;	// 1KHz 클럭 카운트 초기화 
         clk_10 <= ~clk_10;	// 클럭신호 Toggle // 총 100번 카운트 시 한주기 클럭 발생 (10Hz 클럭)
      end
      else cnt_1K <= cnt_1K +1'd1;	// 50번 미만의 경우에는 단순히 카운트
   end
end

always @(posedge clk_10 or posedge rst_bar) // 10Hz 클럭신호 혹은 Reset신호 상승엣지 시
begin
   if(rst_bar)	// Reset신호 발생시
   begin
      cnt_10 <= 3'd0;	// 10Hz 클럭 카운트 초기화
      clk_1 <= 1'b0;	// 1Hz 클럭 신호 초기화
   end
   else
   begin
      if(cnt_10 == 3'd4)	// 10Hz 클럭 5번 카운트 한 경우 
      begin
         cnt_10 <= 3'd0;	// 10Hz 클럭 카운트 초기화 
         clk_1 <= ~clk_1;	// 클럭신호 Toggle // 총 10번 카운트 시 한주기 클럭 발생 (1Hz 클럭)
      end
      
      else cnt_10 <= cnt_10 + 1'd1;	// 5번 미만의 경우에는 단순히 카운트
   end
end

always @(posedge clk_1 or posedge rst_bar) // 1Hz 클럭신호 혹은 Reset신호 상승엣지 시
begin
   if(rst_bar) // Reset신호 발생시
   begin
		cnt<= 6'd0;	// 1Hz 클럭 카운트 초기화  --
		m_cnt<= 4'd0; // ----------------
   end

   else 
   begin 
      if(cnt == 6'd59) 
      begin
		   cnt <= 6'd0;	// 60번 카운트 시 1Hz 클럭 초기화 (60초 = 1분)
		   if(m_cnt == 4'd9) m_cnt <= 4'd0;
		   else m_cnt <= m_cnt + 1'd1;
	  end
      else cnt <= cnt + 1'd1;		// 60번 미만의 경우 카운트
   end
end

bcd_7segment bcd_7segment_1m(digit_1m, segment_1m);
bcd_7segment bcd_7segment_10s(digit_10s, segment_10s);
bcd_7segment bcd_7segment_1s(digit_1s, segment_1s);
bcd_7segment bcd_7segment_1ms(digit_100ms, segment_100ms);

endmodule 
