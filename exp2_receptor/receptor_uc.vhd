-- projeto da unidade de controle do receptor

library IEEE;
use IEEE.std_logic_1164.all;

entity receptor_uc is
    generic (
        constant N: integer := 7
    );
    port (
        CLOCK, RESET, fim, dado_serial, paridade_check:   in STD_LOGIC;
        zera_contador, pronto, desloca, conta: out STD_LOGIC
    );
end receptor_uc;

architecture receptor_uc_arch of receptor_uc is
    type State_type is (espera, recebe, final);
    signal Sreg, Snext: State_type;  -- current state and next state
begin
  process (RESET, CLOCK)
  begin
      if RESET = '1' then
          Sreg <= espera;
      elsif CLOCK'event and CLOCK = '1' then
          Sreg <= Snext; 
      end if;
  end process;

  -- next-state logic
  process (fim, Sreg) 
  begin
    case Sreg is
      when espera =>          if dado_serial='0' then Snext <= recebe;
                               else                Snext <= espera;
                               end if;
      when recebe =>          if fim='0' then Snext <= recebe;
                               else            Snext <= final;
                               end if;
      when final =>            Snext <= espera;
      when others =>           Snext <= espera;
    end case;
  end process;

   -- output logic (based on state only)
    with Sreg select  -- output logic (based on state only)
        pronto <= '1' when final, '0' when others;
    with Sreg select
        zera_contador <= '1' when espera, '0' when others;
    with Sreg select
        conta <= '1' when recebe, '0' when others;
    with Sreg select
        desloca <= '1' when recebe, '0' when others;
end receptor_uc_arch;