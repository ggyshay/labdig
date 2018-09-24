-- tx_serial_base.vhd
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;


entity exp2_receptor_sem_tick is
    port (
        clock, reset: in std_logic;
        dado_recebido: in std_logic_vector(6 downto 0);
		  paridade_ok: std_logic;
		  pronto: std_logic;
    );
end exp2_receptor_sem_tick;

architecture arch_exp2_receptor_sem_tick of arch_exp2_receptor_sem_tick is
    signal s_zera, s_conta, s_carrega, s_desloca, s_fim: std_logic;
     
    component receptor_uc port (
        CLOCK, RESET, fim, dado_serial, paridade_check: in STD_LOGIC;
        zera_contador, pronto, desloca, conta: out STD_LOGIC
    );
    end component;

    component receptor_fd port (
        clock, reset, dado_serial, zera, conta, desloca: in STD_LOGIC;
        saida: out STD_LOGIC_VECTOR(6 downto 0);
        paridade_saida: out STD_LOGIC
	 );
      
begin

    -- sinais reset e partida mapeados na GPIO
    U1: receptor_uc port map (clock, reset, s_fim, dados_serial,
                               s_paridade_check, s_zera_contador, pronto, s_desloca, s_conta);
    U2: receptor_fd port map (clock, reset, dados_serial, s_zera, s_conta, s_desloca, s_saida, 
                               s_paridade_saida);

end arch_exp2_receptor_sem_tick;

