entity Multiplicador is 
	port ( 	
	Clk: in Bit;
	A,B: in Bit_vector(3 downto 0); 
	STB: in Bit;
	Done: out Bit; 
	Result: inout Bit_vector(7 downto 0)) ;
end Multiplicador;

architecture funcional of Multiplicador is 	

component ShiftN is	 --Registro de desplazamiento -> Flanco de subida
   port (
      CLK : in Bit;
      CLR : in Bit;
      LD  : in Bit;
      SH  : in Bit;
      DIR : in Bit;
      D   : in Bit_Vector;	  --Los tamaños de los vectores se asignan cuando se los conecta a una señal con un rango declarado, inicialmente funcionan con cualquier Bit_Vector
      Q   : out Bit_Vector
   );  
end component;  

component Controller is --FSM para controlar el flujo -> Flanco de bajada
  port (
    STB, CLK, LSB, Stop : in  Bit;
    Init, Shift, Add, Done : out Bit
  );
end component;			

component Adder8 is   -- Full adder entre SRB y ACC -> Flanco de subida
	port (A, B: in Bit_Vector(7 downto 0); 
	Cin: in Bit; 
	Cout: out Bit; 
	Sum: out Bit_Vector(7 downto 0));
end component;	  


signal LSB,Stop,Shift,Init,Add : Bit;  
signal  AdderRes, Q_SRB, Q_SRA: Bit_Vector(7 downto 0);
   
begin  
	
FSM: Controller port map(STB,Clk,LSB,Stop,Init,Shift,Add,Done);
R_SRB: ShiftN port map(Clk,'0',Init,Shift,'1',B,Q_SRB);
R_SRA : ShiftN port map(Clk,'0',Init,Shift,'0',A,Q_SRA);
ADDER: Adder8 port map (Q_SRB,Result,'0',open,AdderRes);
ACC: ShiftN port map (Clk,Init,Add,'0','0',AdderRes,Result);

AsignacionSignals:
block
begin
LSB <= Q_SRA(0);
Stop <= not (Q_SRA(7) or Q_SRA(6) or Q_SRA(5) or Q_SRA(4) or Q_SRA(3) or Q_SRA(2) or Q_SRA(1) or Q_SRA(0));
end block;


end funcional;	


----------TESTBENCH------------------------------

entity Test_Driver is
end Test_Driver;	

architecture Testbench of Test_Driver is 
Signal A,B : Bit_Vector(3 downto 0);     --Entrada a SRB y SRA respectivamente 
Signal STB,Done,Clk: Bit;  				 --Entrada de arranque STB y salida de finalizacion Done + Clk para sincronizacion de todo el circuito
Signal Result: Bit_Vector(7 downto 0);   --Salida del resultado de la multiplicacion 

component Multiplicador is 
	port ( 	
	Clk: in Bit;
	A,B: in Bit_vector(3 downto 0); 
	STB: in Bit;
	Done: out Bit; 
	Result: inout Bit_vector(7 downto 0)) ;
end component; 
begin  	
A  <= "1000";
B <= "0010";
UUT: Multiplicador port map(Clk,A,B,STB,Done,Result); --Unidad bajo testeo
Inicio: process
begin 
STB <= '1' after 1 ns; 
wait for 14 ns;
STB <='0';	
wait ;
end process;
Clock: process
begin		  
	 loop
        Clk <= '0';
        wait for 6.55 ns;
        Clk <= '1';
        wait for 6.55 ns; 
	 end loop;
    end process;	 
	
end Testbench;


	
