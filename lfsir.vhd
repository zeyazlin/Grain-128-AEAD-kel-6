LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity LFSR is 
 port(
  i_clk : in std_logic;
  i_rst : in std_logic;
  o_lfsr : out std_logic_vector(127 downto 0);
  check : out std_logic
  );
end LFSR;

architecture behavior of LFSR is
 signal int_lfsr : std_logic_vector (127 downto 0) := (others => '1');
 signal i_seed : std_logic_vector (127 downto 0) := x"000102030405060708090A0B00000000";
 signal temp : std_logic;
 
 begin
  o_lfsr <= int_lfsr(127 downto 0);
  check <= int_lfsr(0);
  process_lfsr : process (i_clk, i_rst) begin
   if (i_rst = '1') then
	int_lfsr <= i_seed;
   elsif rising_edge(i_clk) then
	for i in 127 downto 0 loop
	 if (i = 127) then
	  int_lfsr(127) <= int_lfsr(0) xor int_lfsr(7) xor int_lfsr(38) xor int_lfsr(70) xor int_lfsr(81) xor int_lfsr(96);
	 else
	  int_lfsr(i) <= int_lfsr(i+1);
	 end if;
	end loop;
   end if;
  end process;
end behavior;