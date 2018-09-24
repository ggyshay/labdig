-- receptor_fd.vhd
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;


entity receptor_fd is
    port (
        clock, reset, dado_serial, zera, conta, desloca: in STD_LOGIC;
        saida: out STD_LOGIC_VECTOR(6 downto 0);
        paridade_saida, fim: out STD_LOGIC
    );
end receptor_fd;

architecture receptor_fd of receptor_fd is
    signal D: std_logic_vector (9 downto 0);
	 signal S1, S2: std_logic_vector(3 downto 0);
	 signal s_fim std_logic;
     
	component deslocador_n
    generic (
        constant N: integer    -- numero de bits
    );
    port (
        clock, reset: in std_logic;
        carrega, desloca, entrada_serial: in std_logic; 
        dados: in std_logic_vector (N-1 downto 0);
        saida: out  std_logic_vector (N-1 downto 0)
        );
    end component;

    component contador_m
	generic (
		constant M: integer;  -- modulo do contador
		constant N: integer   -- numero de bits da sa�da
	);
    port (
        CLK, zera, conta: in STD_LOGIC;
        Q: out STD_LOGIC_VECTOR (N-1 downto 0);
        fim: out STD_LOGIC);
    end component;

    component gerador_de_paridade_n
    generic (
        constant N: integer -- numero de bits da entrada
    );
    port(
        dado:       in STD_LOGIC_VECTOR (N-1 downto 0);
        par, impar: out STD_LOGIC
    );
    end component;
	 
	 component hex7seg 
		port (x: in std_logic_Vector(3 downto 0);
				enable: in std_logic;
				hex_output: out std_logic_vector(6 downto 0)
				);
	end component;

    
begin
	U1: contador_m generic map (M => 11, N => 4) port map (clock, zera, conta, open, s_fim);
   U2: deslocador_n generic map( N => 11) port map (clock, zera, desloca, dado_serial, D);
	U3: gerador_de_paridade_n generic map(N => 7) port map (D, paridade_saida, open);
	U4: hex7seg port map(D(3 downto 0), '1', S1);
	u5: hex7seg port map('0' & D(6 downto 4), '1', S2);
	fim <= s_fim;
   saida <= S2 & S1;
end receptor_fd;

