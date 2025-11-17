entity Controller is
  port (
    STB, CLK, LSB, Stop : in  Bit;
    Init, Shift, Add, Done : out Bit
  );
end Controller;

architecture FSM of Controller is
  type States is (InitS, CheckS, AddS, ShiftS, EndS);
  signal State : States := EndS;
begin

  -- Drive control outputs based upon State
  Init  <= '1' when State = InitS  else '0';
  Add   <= '1' when State = AddS   else '0';
  Shift <= '1' when State = ShiftS else '0';
  Done  <= '1' when State = EndS   else '0';

  -- Determine Next State from control inputs
  StateMachine: process (CLK)
  begin
    if CLK'Event and CLK = '0' then
      case State is
        when InitS =>
          State <= CheckS;

        when CheckS =>
          if LSB = '1' then
            State <= AddS;
          elsif Stop = '0' then
            State <= ShiftS;
          else
            State <= EndS;
          end if;

        when AddS =>
          State <= ShiftS;

        when ShiftS =>
          State <= CheckS;

        when EndS =>
          if STB = '1' then
            State <= InitS;
          end if;
      end case;
    end if;
  end process;
end FSM;

------------------------------Testbench------------------------

entity Test_Controller is end;

architecture Driver of Test_Controller is
  component Controller
    port (
      STB, CLK, LSB, Stop : in  Bit;
      Init, Shift, Add, Done : out Bit
    );
  end component;

  signal STB, LSB, Done, Init, Shift, Add, Stop : Bit;
  signal CLK, ENA : Bit := '1';

begin
  UUT: Controller port map (STB, CLK, LSB, Stop, Init, Shift, Add, Done);

  Clock:  CLK <= not (CLK and ENA) after 10 ns;
  Enable: ENA <= '0' after 500 ns;

  Stimulus: process
    variable Val : Bit_Vector(7 downto 0);
  begin
    wait until CLK'Event and CLK = '1';
    STB <= '1', '0' after 20 ns;
    Val := "01110101";

    loop
      LSB <= Val(0);
      Stop <= not (Val(7) or Val(6) or Val(5) or Val(4) or
                   Val(3) or Val(2) or Val(1) or Val(0));
      wait until CLK'Event and CLK = '1';
      exit when Done = '1';
      if Shift = '1' then
        Val := '0' & Val(7 downto 1);
      end if;
    end loop;

    wait;
  end process;
end Driver;
