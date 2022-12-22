LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity NFSR is 
 port(
  i_clk : in std_logic;
  i_rst : in std_logic;
  o_nfsr : out std_logic_vector(127 downto 0);
  check : out std_logic
  );
end NFSR;

architecture behavior of NFSR is
 signal int_nfsr : std_logic_vector (127 downto 0) := (others => '1');
 signal i_seed : std_logic_vector (127 downto 0) := x"000102030405060708090A0B00000000";
 signal temp : std_logic;
 
 begin
  o_nfsr <= int_nfsr(127 downto 0);
  check <= int_nfsr(0);
  process_nfsr : process (i_clk, i_rst) begin
   if (i_rst = '1') then
	int_nfsr <= i_seed;
   elsif rising_edge(i_clk) then
	for i in 127 downto 0 loop
	 if (i = 127) then
	  int_nfsr(127) <= '0';
	 else
	  int_nfsr(i) <= int_nfsr(i+1);
	 end if;
	end loop;
   end if;
  end process;
end behavior;