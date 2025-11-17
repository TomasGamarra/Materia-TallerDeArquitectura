entity DFF is port ( Preset : in Bit; Clear : in Bit; Clock : in Bit; Data : in Bit; Q : out Bit; QBar : out Bit ); 
end DFF;  

architecture flujodedatos of DFF is   

signal A, B, C, D : Bit;
signal Qint, QbarInt : Bit;  

begin
A <= not (Preset and D and B) after 1 ns;
B <= not (A and Clear and Clock) after 1 ns; 
C <= not (B and Clock and D) after 1 ns; 
D <= not (C and Clear and Data) after 1 ns; 
Qint <= not (Preset and B and QbarInt) after 1 ns; 
QbarInt <= not (Qint and Clear and C) after 1 ns; 
Q <= Qint; 
QBar <= QbarInt;   

end flujodedatos;		

entity Test_DFF is end Test_DFF;

architecture Driver of Test_DFF is
    component DFF
        port (
            Preset, Clear, Clock, Data : in Bit;
            Q, Qbar                    : out Bit
        );
    end component;


    -- Señales

    signal Preset, Clear : Bit := '1';
    signal Clock, Data, Q, QBar : Bit;


    -- Constantes de temporización

    constant Tsetup : time := 1000 ps;  -- tiempo de setup antes del flanco
    constant Thold  : time := 1000 ps;  -- tiempo de hold después del flanco	  
	constant TClk : time := 2002 ps;

begin
    UUT: DFF
        port map (Preset, Clear, Clock, Data, Q, QBar);


    -- Clock fijo de 2002 ps

    ClockGen: process
    begin
        Clock <= '0';
        wait for (TClk/2) ;  -- mitad de periodo
        Clock <= '1';
        wait for (TClk/2) ;  -- mitad de periodo
    end process;


    -- Estímulos de prueba

    Stimulus: process
    begin
        -- chequeo de preset y clear		
        --Clear <= '0' after 1 ns; 
       -- wait for 1001 ps;
       -- Clear <= '1'; 
       -- wait for 5 ns;

       -- Clear <= '0'; wait for 5 ns;
      --  Clear <= '1'; wait for 5 ns;

        -- interaccion de preset y clear
      --  Preset <= '0'; Clear <= '0'; wait for 5 ns;
      --  Preset <= '1'; Clear <= '1'; wait for 5 ns;

        -- limpiar
        Clear <= '0', '1' after 5 ns; wait for 10 ns;

        -- chequeo de datos con setup y hold
        wait until Clock = '1';          -- esperar flanco de subida	
		wait until Clock = '0';
        Data <= '1' after TClk/2 - Tsetup;       -- setup: Data estable antes del flanco
        wait for TClk/2 + Thold;                  -- hold: mantener Data después del flanco
        Data <= '0';

        -- limpiar
       -- Clear <= '0', '1' after 5 ns; wait for 10 ns;

        -- interaccion de preset y clock
      --  Data   <= '0';
       -- Preset <= '0', '1' after 10 ns;
      --  wait for 10 ns;

        wait; -- termina la simulación
    end process;

end Driver;
