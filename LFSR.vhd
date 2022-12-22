LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity LFSR is 
 port(
  i_clk : in std_logic;
  i_rst : in std_logic;
  o_lfsr : out std_logic_vector(0 to 127);
  o_nfsr : out std_logic_vector(0 to 127);
  o_ho	: buffer std_logic;
  o_yt : buffer std_logic;
  o_cip : out std_logic_vector (0 to 63);
   o_cip1 : out std_logic_vector (0 to 63);
    o_cip2 : out std_logic_vector (0 to 63);
  check_z : out std_logic_vector (63 downto 0);
  check_zi : out std_logic_vector (63 downto 0)
  );
end LFSR;

architecture behavior of LFSR is
 signal int_lfsr : std_logic_vector (0 to 127) := (others => '1');
 signal int_nfsr : std_logic_vector (0 to 127) := (others => '1');
 signal i_key : std_logic_vector (0 to 127) := x"000102030405060708090a0b0c0d0e0f";
 signal i_nonce : std_logic_vector (0 to 127) := x"000102030405060708090a0b" & B"11111111111111111111111111111110";
 signal temp_lfsr : std_logic;
 signal temp_nfsr : std_logic;
 signal i_yt : std_logic;
 signal i_ho : std_logic;
 signal count : integer := -1;
 signal i_a0 : std_logic_vector (63 downto 0);
 signal i_r0 : std_logic_vector (63 downto 0);
 signal i_z : std_logic_vector (63 downto 0):= (others => '0');
 signal i_zi : std_logic_vector (63 downto 0):= (others => '0');
 signal int_cip : std_logic_vector (0 to 63) := (others => '0');
 signal int_cip1 : std_logic_vector (0 to 63) := (others => '0');
 signal int_cip2 : std_logic_vector (0 to 63) := (others => '0');
 signal int_mes : std_logic_vector (0 to 63) := x"0001020304050607";
 
 begin
  o_lfsr <= int_lfsr(0 to 127);
  o_nfsr <= int_nfsr(0 to 127);
  o_cip <= int_cip(0 to 63);
  o_cip1 <= int_cip(0 to 63);
  o_cip2 <= int_cip(0 to 63);
  check_z <= i_z(63 downto 0);
  check_zi <= i_zi (63 downto 0);
  o_ho <= i_ho;
  o_yt <= i_yt;
  
  
  process (i_clk, i_rst, count) 
  begin
   
   if (i_rst = '1') then
	count <= -1;
	int_lfsr <= i_nonce;
	int_nfsr <= i_key;
   
   elsif rising_edge(i_clk) then
   
    if rising_edge(i_clk) then
    count <= count + 1;
   end if;
    i_ho <= (int_nfsr(12) and int_lfsr(8)) xor (int_lfsr(13) and int_lfsr(20)) xor (int_nfsr(95) and int_lfsr(42)) xor (int_lfsr(60) and int_lfsr(79)) xor (int_nfsr(12) and int_nfsr(95) and int_lfsr(94));
    i_yt <= i_ho xor int_lfsr(93) xor int_nfsr(2) xor int_nfsr(15) xor int_nfsr(36) xor int_nfsr(45) xor int_nfsr(64) xor int_nfsr(73) xor int_nfsr(89);
    if rising_edge(i_clk) then -- z 
		if(count mod 2 = 0) then
			i_z((count)/2) <= i_yt;
        elsif ( count mod 2 = 1) then
			i_zi((count-1)/2) <= i_yt;
		end if;
   end if;	
	if count <= 319 then -- t <= 319
     
     temp_lfsr <= int_lfsr(0) xor int_lfsr(7) xor int_lfsr(38) xor int_lfsr(70) xor int_lfsr(81) xor int_lfsr(96) xor i_yt;
	 temp_nfsr <= int_lfsr(0) xor int_nfsr(0) xor int_nfsr(26) xor int_nfsr(56) xor int_nfsr(91) xor int_nfsr(96) xor (int_nfsr(3) AND int_nfsr(67)) xor (int_nfsr(11) AND int_nfsr(13)) xor (int_nfsr(17) AND int_nfsr(18)) xor (int_nfsr(27) AND int_nfsr(59)) xor (int_nfsr(40) AND int_nfsr(48)) xor (int_nfsr(61) AND int_nfsr(65)) xor (int_nfsr(68) AND int_nfsr(84)) xor (int_nfsr(22) AND int_nfsr(24) AND int_nfsr(25)) xor (int_nfsr(70) AND int_nfsr(78) AND int_nfsr(82)) xor (int_nfsr(88) AND int_nfsr(92) AND int_nfsr(93) AND int_nfsr(95)) xor i_yt;
	  
	 for i in 0 to 126 loop
	   int_lfsr(i) <= int_lfsr(i+1);
	   int_nfsr(i) <= int_nfsr(i+1);
	 end loop;
	 
	 int_lfsr(127) <= temp_lfsr;
	 int_nfsr(127) <= temp_nfsr;
	      
    end if;
    
    if (count > 319 and count <= 383) then
     temp_lfsr <= int_lfsr(0) xor int_lfsr(7) xor int_lfsr(38) xor int_lfsr(70) xor int_lfsr(81) xor int_lfsr(96) xor i_yt xor i_key(count-256);
	 temp_nfsr <= int_lfsr(0) xor int_nfsr(0) xor int_nfsr(26) xor int_nfsr(56) xor int_nfsr(91) xor int_nfsr(96) xor (int_nfsr(3) AND int_nfsr(67)) xor (int_nfsr(11) AND int_nfsr(13)) xor (int_nfsr(17) AND int_nfsr(18)) xor (int_nfsr(27) AND int_nfsr(59)) xor (int_nfsr(40) AND int_nfsr(48)) xor (int_nfsr(61) AND int_nfsr(65)) xor (int_nfsr(68) AND int_nfsr(84)) xor (int_nfsr(22) AND int_nfsr(24) AND int_nfsr(25)) xor (int_nfsr(70) AND int_nfsr(78) AND int_nfsr(82)) xor (int_nfsr(88) AND int_nfsr(92) AND int_nfsr(93) AND int_nfsr(95)) xor i_yt xor i_key(count-320);
	  
	 for i in 0 to 126 loop
	   int_lfsr(i) <= int_lfsr(i+1);
	   int_nfsr(i) <= int_nfsr(i+1);
	 end loop;
	 
	 int_lfsr(127) <= temp_lfsr;
	 int_nfsr(127) <= temp_nfsr;
	 
    end if;
    
    if (count > 383 and count <= 511) then
     temp_lfsr <= int_lfsr(0) xor int_lfsr(7) xor int_lfsr(38) xor int_lfsr(70) xor int_lfsr(81) xor int_lfsr(96);
	 temp_nfsr <= int_lfsr(0) xor int_nfsr(0) xor int_nfsr(26) xor int_nfsr(56) xor int_nfsr(91) xor int_nfsr(96) xor (int_nfsr(3) AND int_nfsr(67)) xor (int_nfsr(11) AND int_nfsr(13)) xor (int_nfsr(17) AND int_nfsr(18)) xor (int_nfsr(27) AND int_nfsr(59)) xor (int_nfsr(40) AND int_nfsr(48)) xor (int_nfsr(61) AND int_nfsr(65)) xor (int_nfsr(68) AND int_nfsr(84)) xor (int_nfsr(22) AND int_nfsr(24) AND int_nfsr(25)) xor (int_nfsr(70) AND int_nfsr(78) AND int_nfsr(82)) xor (int_nfsr(88) AND int_nfsr(92) AND int_nfsr(93) AND int_nfsr(95));
	  
     for i in 0 to 126 loop
	   int_lfsr(i) <= int_lfsr(i+1);
	   int_nfsr(i) <= int_nfsr(i+1);
	 end loop;
	 
	 int_lfsr(127) <= temp_lfsr;
	 int_nfsr(127) <= temp_nfsr;
	 
    end if;
    
   end if;
  end process;
 
  process (i_clk, count) 
  begin
   
  if rising_edge(i_clk) then
   if (count >= 384) and (count <= 447) then
    for j in 0 to 63 loop
     i_a0(j) <= i_yt;
    end loop;
   elsif (count >= 448) and (count <= 511) then
    for k in 0 to 63 loop
     i_r0(k) <= i_yt;
    end loop;
   end if;
  end if;
  end process;
  
  process (i_clk,count)
  begin 
  
  end process;
  
  process (i_clk, count) 
  begin 
  
  end process; 

  
  process (i_clk, count) 
  begin 
	  if rising_edge(i_clk) and (count = 510) then
	   for m in 0 to 63 loop
		int_cip(m) <= int_mes(m) xor i_z(m);
	   end loop;
	  end if;
   
  end process;
  process (i_clk, count) 
  begin 
	  if rising_edge(i_clk) and (count = 511) then
	   for m in 0 to 63 loop
		int_cip1(m) <= int_mes(m) xor i_z(m);
	   end loop;
	  end if;
   
  end process;
  process (i_clk, count) 
  begin 
	  if rising_edge(i_clk) and (count = 512) then
	   for m in 0 to 63 loop
		int_cip2(m) <= int_mes(m) xor i_z(m);
	   end loop;
	  end if;
   
  end process;

end behavior;