library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MA_filter_v2_0_S00_AXI is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line

		-- Width of S_AXI data bus
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		-- Width of S_AXI address bus
		C_S_AXI_ADDR_WIDTH	: integer	:= 10
	);
	port (
		-- Users to add ports here
        interrupt:out std_logic;
        Y0_bit:out std_logic_vector(31 downto 0);
        Yi_bit:out std_logic_vector(31 downto 0);
        counter:out std_logic_vector(7 downto 0);
        controllo_slvreg240:out std_logic;
		-- User ports ends
		-- Do not modify the ports beyond this line

		-- Global Clock Signal
		S_AXI_ACLK	: in std_logic;
		-- Global Reset Signal. This Signal is Active LOW
		S_AXI_ARESETN	: in std_logic;
		-- Write address (issued by master, acceped by Slave)
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		-- Write channel Protection type. This signal indicates the
    		-- privilege and security level of the transaction, and whether
    		-- the transaction is a data access or an instruction access.
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		-- Write address valid. This signal indicates that the master signaling
    		-- valid write address and control information.
		S_AXI_AWVALID	: in std_logic;
		-- Write address ready. This signal indicates that the slave is ready
    		-- to accept an address and associated control signals.
		S_AXI_AWREADY	: out std_logic;
		-- Write data (issued by master, acceped by Slave) 
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		-- Write strobes. This signal indicates which byte lanes hold
    		-- valid data. There is one write strobe bit for each eight
    		-- bits of the write data bus.    
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		-- Write valid. This signal indicates that valid write
    		-- data and strobes are available.
		S_AXI_WVALID	: in std_logic;
		-- Write ready. This signal indicates that the slave
    		-- can accept the write data.
		S_AXI_WREADY	: out std_logic;
		-- Write response. This signal indicates the status
    		-- of the write transaction.
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		-- Write response valid. This signal indicates that the channel
    		-- is signaling a valid write response.
		S_AXI_BVALID	: out std_logic;
		-- Response ready. This signal indicates that the master
    		-- can accept a write response.
		S_AXI_BREADY	: in std_logic;
		-- Read address (issued by master, acceped by Slave)
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		-- Protection type. This signal indicates the privilege
    		-- and security level of the transaction, and whether the
    		-- transaction is a data access or an instruction access.
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		-- Read address valid. This signal indicates that the channel
    		-- is signaling valid read address and control information.
		S_AXI_ARVALID	: in std_logic;
		-- Read address ready. This signal indicates that the slave is
    		-- ready to accept an address and associated control signals.
		S_AXI_ARREADY	: out std_logic;
		-- Read data (issued by slave)
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		-- Read response. This signal indicates the status of the
    		-- read transfer.
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		-- Read valid. This signal indicates that the channel is
    		-- signaling the required read data.
		S_AXI_RVALID	: out std_logic;
		-- Read ready. This signal indicates that the master can
    		-- accept the read data and response information.
		S_AXI_RREADY	: in std_logic
	);
end MA_filter_v2_0_S00_AXI;

architecture arch_imp of MA_filter_v2_0_S00_AXI is

	-- AXI4LITE signals
	signal axi_awaddr	: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal axi_awready	: std_logic;
	signal axi_wready	: std_logic;
	signal axi_bresp	: std_logic_vector(1 downto 0);
	signal axi_bvalid	: std_logic;
	signal axi_araddr	: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal axi_arready	: std_logic;
	signal axi_rdata	: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal axi_rresp	: std_logic_vector(1 downto 0);
	signal axi_rvalid	: std_logic;

	-- Example-specific design signals
	-- local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	-- ADDR_LSB is used for addressing 32/64 bit registers/memories
	-- ADDR_LSB = 2 for 32 bits (n downto 2)
	-- ADDR_LSB = 3 for 64 bits (n downto 3)
	constant ADDR_LSB  : integer := (C_S_AXI_DATA_WIDTH/32)+ 1;
	constant OPT_MEM_ADDR_BITS : integer := 7;
	------------------------------------------------
	---- Signals for user logic register space example
	--------------------------------------------------
	---- Number of Slave Registers 241
	signal slv_reg0	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg1	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg2	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg3	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg4	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg5	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg6	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg7	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg8	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg9	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg10	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg11	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg12	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg13	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg14	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg15	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg16	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg17	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg18	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg19	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg20	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg21	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg22	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg23	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg24	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg25	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg26	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg27	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg28	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg29	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg30	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg31	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg32	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg33	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg34	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg35	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg36	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg37	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg38	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg39	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg40	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg41	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg42	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg43	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg44	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg45	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg46	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg47	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg48	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg49	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg50	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg51	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg52	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg53	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg54	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg55	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg56	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg57	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg58	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg59	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg60	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg61	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg62	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg63	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg64	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg65	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg66	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg67	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg68	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg69	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg70	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg71	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg72	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg73	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg74	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg75	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg76	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg77	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg78	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg79	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg80	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg81	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg82	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg83	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg84	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg85	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg86	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg87	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg88	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg89	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg90	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg91	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg92	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg93	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg94	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg95	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg96	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg97	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg98	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg99	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg100	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg101	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg102	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg103	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg104	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg105	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg106	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg107	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg108	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg109	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg110	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg111	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg112	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg113	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg114	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg115	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg116	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg117	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg118	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg119	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg120	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg121	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg122	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg123	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg124	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg125	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg126	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg127	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg128	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg129	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg130	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg131	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg132	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg133	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg134	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg135	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg136	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg137	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg138	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg139	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg140	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg141	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg142	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg143	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg144	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg145	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg146	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg147	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg148	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg149	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg150	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg151	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg152	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg153	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg154	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg155	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg156	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg157	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg158	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg159	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg160	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg161	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg162	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg163	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg164	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg165	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg166	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg167	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg168	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg169	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg170	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg171	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg172	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg173	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg174	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg175	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg176	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg177	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg178	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg179	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg180	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg181	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg182	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg183	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg184	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg185	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg186	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg187	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg188	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg189	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg190	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg191	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg192	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg193	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg194	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg195	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg196	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg197	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg198	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg199	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg200	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg201	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg202	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg203	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg204	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg205	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg206	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg207	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg208	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg209	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg210	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg211	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg212	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg213	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg214	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg215	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg216	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg217	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg218	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg219	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg220	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg221	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg222	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg223	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg224	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg225	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg226	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg227	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg228	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg229	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg230	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg231	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg232	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg233	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg234	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg235	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg236	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg237	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg238	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg239	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg240	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg_rden	: std_logic;
	signal slv_reg_wren	: std_logic;
	signal reg_data_out	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal byte_index	: integer;
	signal aw_en	: std_logic;

    component moving_average_filters
    Port ( 
        clk,rst,en:in std_logic;
        enable_in:in std_logic;  
        c_in0:in std_logic_vector(31 downto 0);
        c_in1:in std_logic_vector(31 downto 0);
        c_in2:in std_logic_vector(31 downto 0);
        c_in3:in std_logic_vector(31 downto 0);
        c_in4:in std_logic_vector(31 downto 0);
        c_in5:in std_logic_vector(31 downto 0);
        c_in6:in std_logic_vector(31 downto 0);
        c_in7:in std_logic_vector(31 downto 0);
        c_in8:in std_logic_vector(31 downto 0);
        c_in9:in std_logic_vector(31 downto 0);
        c_in10:in std_logic_vector(31 downto 0);
        c_in11:in std_logic_vector(31 downto 0);
        c_in12:in std_logic_vector(31 downto 0);
        c_in13:in std_logic_vector(31 downto 0);
        c_in14:in std_logic_vector(31 downto 0);
        c_in15:in std_logic_vector(31 downto 0);
        c_in16:in std_logic_vector(31 downto 0);
        c_in17:in std_logic_vector(31 downto 0);
        c_in18:in std_logic_vector(31 downto 0);
        c_in19:in std_logic_vector(31 downto 0);
        c_in20:in std_logic_vector(31 downto 0);
        c_in21:in std_logic_vector(31 downto 0);
        c_in22:in std_logic_vector(31 downto 0);
        c_in23:in std_logic_vector(31 downto 0);
        c_in24:in std_logic_vector(31 downto 0);
        c_in25:in std_logic_vector(31 downto 0);
        c_in26:in std_logic_vector(31 downto 0);
        c_in27:in std_logic_vector(31 downto 0);
        c_in28:in std_logic_vector(31 downto 0);
        c_in29:in std_logic_vector(31 downto 0);
        c_in30:in std_logic_vector(31 downto 0);
        c_in31:in std_logic_vector(31 downto 0);
        c_in32:in std_logic_vector(31 downto 0);
        c_in33:in std_logic_vector(31 downto 0);
        c_in34:in std_logic_vector(31 downto 0);
        c_in35:in std_logic_vector(31 downto 0);
        c_in36:in std_logic_vector(31 downto 0);
        c_in37:in std_logic_vector(31 downto 0);
        c_in38:in std_logic_vector(31 downto 0);
        c_in39:in std_logic_vector(31 downto 0);
        c_in40:in std_logic_vector(31 downto 0);
        c_in41:in std_logic_vector(31 downto 0);
        c_in42:in std_logic_vector(31 downto 0);
        c_in43:in std_logic_vector(31 downto 0);
        c_in44:in std_logic_vector(31 downto 0);
        c_in45:in std_logic_vector(31 downto 0);
        c_in46:in std_logic_vector(31 downto 0);
        c_in47:in std_logic_vector(31 downto 0);
        c_in48:in std_logic_vector(31 downto 0);
        c_in49:in std_logic_vector(31 downto 0);
        c_in50:in std_logic_vector(31 downto 0);
        c_in51:in std_logic_vector(31 downto 0);
        c_in52:in std_logic_vector(31 downto 0);
        c_in53:in std_logic_vector(31 downto 0);
        c_in54:in std_logic_vector(31 downto 0);
        c_in55:in std_logic_vector(31 downto 0);
        c_in56:in std_logic_vector(31 downto 0);
        c_in57:in std_logic_vector(31 downto 0);
        c_in58:in std_logic_vector(31 downto 0);
        c_in59:in std_logic_vector(31 downto 0);
        c_in60:in std_logic_vector(31 downto 0);
        c_in61:in std_logic_vector(31 downto 0);
        c_in62:in std_logic_vector(31 downto 0);
        c_in63:in std_logic_vector(31 downto 0);
        c_in64:in std_logic_vector(31 downto 0);
        c_in65:in std_logic_vector(31 downto 0);
        c_in66:in std_logic_vector(31 downto 0);
        c_in67:in std_logic_vector(31 downto 0);
        c_in68:in std_logic_vector(31 downto 0);
        c_in69:in std_logic_vector(31 downto 0);
        c_in70:in std_logic_vector(31 downto 0);
        c_in71:in std_logic_vector(31 downto 0);
        c_in72:in std_logic_vector(31 downto 0);
        c_in73:in std_logic_vector(31 downto 0);
        c_in74:in std_logic_vector(31 downto 0);
        c_in75:in std_logic_vector(31 downto 0);
        c_in76:in std_logic_vector(31 downto 0);
        c_in77:in std_logic_vector(31 downto 0);
        c_in78:in std_logic_vector(31 downto 0);
        c_in79:in std_logic_vector(31 downto 0);
        c_in80:in std_logic_vector(31 downto 0);
        c_in81:in std_logic_vector(31 downto 0);
        c_in82:in std_logic_vector(31 downto 0);
        c_in83:in std_logic_vector(31 downto 0);
        c_in84:in std_logic_vector(31 downto 0);
        c_in85:in std_logic_vector(31 downto 0);
        c_in86:in std_logic_vector(31 downto 0);
        c_in87:in std_logic_vector(31 downto 0);
        c_in88:in std_logic_vector(31 downto 0);
        c_in89:in std_logic_vector(31 downto 0);
        c_in90:in std_logic_vector(31 downto 0);
        c_in91:in std_logic_vector(31 downto 0);
        c_in92:in std_logic_vector(31 downto 0);
        c_in93:in std_logic_vector(31 downto 0);
        c_in94:in std_logic_vector(31 downto 0);
        c_in95:in std_logic_vector(31 downto 0);
        c_in96:in std_logic_vector(31 downto 0);
        c_in97:in std_logic_vector(31 downto 0);
        c_in98:in std_logic_vector(31 downto 0);
        c_in99:in std_logic_vector(31 downto 0);
        c_in100:in std_logic_vector(31 downto 0);
        c_in101:in std_logic_vector(31 downto 0);
        c_in102:in std_logic_vector(31 downto 0);
        c_in103:in std_logic_vector(31 downto 0);
        c_in104:in std_logic_vector(31 downto 0);
        c_in105:in std_logic_vector(31 downto 0);
        c_in106:in std_logic_vector(31 downto 0);
        c_in107:in std_logic_vector(31 downto 0);
        c_in108:in std_logic_vector(31 downto 0);
        c_in109:in std_logic_vector(31 downto 0);
        c_in110:in std_logic_vector(31 downto 0);
        c_in111:in std_logic_vector(31 downto 0);
        c_in112:in std_logic_vector(31 downto 0);
        c_in113:in std_logic_vector(31 downto 0);
        c_in114:in std_logic_vector(31 downto 0);
        c_in115:in std_logic_vector(31 downto 0);
        c_in116:in std_logic_vector(31 downto 0);
        c_in117:in std_logic_vector(31 downto 0);
        c_in118:in std_logic_vector(31 downto 0);
        c_in119:in std_logic_vector(31 downto 0);
        c_in120:in std_logic_vector(31 downto 0);
        c_in121:in std_logic_vector(31 downto 0);
        c_in122:in std_logic_vector(31 downto 0);
        c_in123:in std_logic_vector(31 downto 0);
        c_in124:in std_logic_vector(31 downto 0);
        c_in125:in std_logic_vector(31 downto 0);
        c_in126:in std_logic_vector(31 downto 0);
        c_in127:in std_logic_vector(31 downto 0);
        c_in128:in std_logic_vector(31 downto 0);
        c_in129:in std_logic_vector(31 downto 0);
        c_in130:in std_logic_vector(31 downto 0);
        c_in131:in std_logic_vector(31 downto 0);
        c_in132:in std_logic_vector(31 downto 0);
        c_in133:in std_logic_vector(31 downto 0);
        c_in134:in std_logic_vector(31 downto 0);
        c_in135:in std_logic_vector(31 downto 0);
        c_in136:in std_logic_vector(31 downto 0);
        c_in137:in std_logic_vector(31 downto 0);
        c_in138:in std_logic_vector(31 downto 0);
        c_in139:in std_logic_vector(31 downto 0);
        c_in140:in std_logic_vector(31 downto 0);
        c_in141:in std_logic_vector(31 downto 0);
        c_in142:in std_logic_vector(31 downto 0);
        c_in143:in std_logic_vector(31 downto 0);
        c_in144:in std_logic_vector(31 downto 0);
        c_in145:in std_logic_vector(31 downto 0);
        c_in146:in std_logic_vector(31 downto 0);
        c_in147:in std_logic_vector(31 downto 0);
        c_in148:in std_logic_vector(31 downto 0);
        c_in149:in std_logic_vector(31 downto 0);
        c_in150:in std_logic_vector(31 downto 0);
        c_in151:in std_logic_vector(31 downto 0);
        c_in152:in std_logic_vector(31 downto 0);
        c_in153:in std_logic_vector(31 downto 0);
        c_in154:in std_logic_vector(31 downto 0);
        c_in155:in std_logic_vector(31 downto 0);
        c_in156:in std_logic_vector(31 downto 0);
        c_in157:in std_logic_vector(31 downto 0);
        c_in158:in std_logic_vector(31 downto 0);
        c_in159:in std_logic_vector(31 downto 0);
        c_in160:in std_logic_vector(31 downto 0);
        c_in161:in std_logic_vector(31 downto 0);
        c_in162:in std_logic_vector(31 downto 0);
        c_in163:in std_logic_vector(31 downto 0);
        c_in164:in std_logic_vector(31 downto 0);
        c_in165:in std_logic_vector(31 downto 0);
        c_in166:in std_logic_vector(31 downto 0);
        c_in167:in std_logic_vector(31 downto 0);
        c_in168:in std_logic_vector(31 downto 0);
        c_in169:in std_logic_vector(31 downto 0);
        c_in170:in std_logic_vector(31 downto 0);
        c_in171:in std_logic_vector(31 downto 0);
        c_in172:in std_logic_vector(31 downto 0);
        c_in173:in std_logic_vector(31 downto 0);
        c_in174:in std_logic_vector(31 downto 0);
        c_in175:in std_logic_vector(31 downto 0);
        c_in176:in std_logic_vector(31 downto 0);
        c_in177:in std_logic_vector(31 downto 0);
        c_in178:in std_logic_vector(31 downto 0);
        c_in179:in std_logic_vector(31 downto 0);
        c_in180:in std_logic_vector(31 downto 0);
        c_in181:in std_logic_vector(31 downto 0);
        c_in182:in std_logic_vector(31 downto 0);
        c_in183:in std_logic_vector(31 downto 0);
        c_in184:in std_logic_vector(31 downto 0);
        c_in185:in std_logic_vector(31 downto 0);
        c_in186:in std_logic_vector(31 downto 0);
        c_in187:in std_logic_vector(31 downto 0);
        c_in188:in std_logic_vector(31 downto 0);
        c_in189:in std_logic_vector(31 downto 0);
        c_in190:in std_logic_vector(31 downto 0);
        c_in191:in std_logic_vector(31 downto 0);
        c_in192:in std_logic_vector(31 downto 0);
        c_in193:in std_logic_vector(31 downto 0);
        c_in194:in std_logic_vector(31 downto 0);
        c_in195:in std_logic_vector(31 downto 0);
        c_in196:in std_logic_vector(31 downto 0);
        c_in197:in std_logic_vector(31 downto 0);
        c_in198:in std_logic_vector(31 downto 0);
        c_in199:in std_logic_vector(31 downto 0);
        c_in200:in std_logic_vector(31 downto 0);
        c_in201:in std_logic_vector(31 downto 0);
        c_in202:in std_logic_vector(31 downto 0);
        c_in203:in std_logic_vector(31 downto 0);
        c_in204:in std_logic_vector(31 downto 0);
        c_in205:in std_logic_vector(31 downto 0);
        c_in206:in std_logic_vector(31 downto 0);
        c_in207:in std_logic_vector(31 downto 0);
        c_in208:in std_logic_vector(31 downto 0);
        c_in209:in std_logic_vector(31 downto 0);
        c_in210:in std_logic_vector(31 downto 0);
        c_in211:in std_logic_vector(31 downto 0);
        c_in212:in std_logic_vector(31 downto 0);
        c_in213:in std_logic_vector(31 downto 0);
        c_in214:in std_logic_vector(31 downto 0);
        c_in215:in std_logic_vector(31 downto 0);
        c_in216:in std_logic_vector(31 downto 0);
        c_in217:in std_logic_vector(31 downto 0);
        c_in218:in std_logic_vector(31 downto 0);
        c_in219:in std_logic_vector(31 downto 0);
        c_in220:in std_logic_vector(31 downto 0);
        c_in221:in std_logic_vector(31 downto 0);
        c_in222:in std_logic_vector(31 downto 0);
        c_in223:in std_logic_vector(31 downto 0);
        c_in224:in std_logic_vector(31 downto 0);
        c_in225:in std_logic_vector(31 downto 0);
        c_in226:in std_logic_vector(31 downto 0);
        c_in227:in std_logic_vector(31 downto 0);
        c_in228:in std_logic_vector(31 downto 0);
        c_in229:in std_logic_vector(31 downto 0);
        c_in230:in std_logic_vector(31 downto 0);
        c_in231:in std_logic_vector(31 downto 0);
        c_in232:in std_logic_vector(31 downto 0);
        c_in233:in std_logic_vector(31 downto 0);
        c_in234:in std_logic_vector(31 downto 0);
        c_in235:in std_logic_vector(31 downto 0);
        c_in236:in std_logic_vector(31 downto 0);
        c_in237:in std_logic_vector(31 downto 0);
        c_in238:in std_logic_vector(31 downto 0);
        c_in239:in std_logic_vector(31 downto 0);
                 
        interrupt:out std_logic;
        counter:out std_logic_vector(7 downto 0);
        Y0_bit:out std_logic_vector(31 downto 0);
        Yi_bit:out std_logic_vector(31 downto 0);

        c_out0:out std_logic_vector(31 downto 0);
        c_out1:out std_logic_vector(31 downto 0);
        c_out2:out std_logic_vector(31 downto 0);
        c_out3:out std_logic_vector(31 downto 0);
        c_out4:out std_logic_vector(31 downto 0);
        c_out5:out std_logic_vector(31 downto 0);
        c_out6:out std_logic_vector(31 downto 0);
        c_out7:out std_logic_vector(31 downto 0);
        c_out8:out std_logic_vector(31 downto 0);
        c_out9:out std_logic_vector(31 downto 0);
        c_out10:out std_logic_vector(31 downto 0);
        c_out11:out std_logic_vector(31 downto 0);
        c_out12:out std_logic_vector(31 downto 0);
        c_out13:out std_logic_vector(31 downto 0);
        c_out14:out std_logic_vector(31 downto 0);
        c_out15:out std_logic_vector(31 downto 0);
        c_out16:out std_logic_vector(31 downto 0);
        c_out17:out std_logic_vector(31 downto 0);
        c_out18:out std_logic_vector(31 downto 0);
        c_out19:out std_logic_vector(31 downto 0);
        c_out20:out std_logic_vector(31 downto 0);
        c_out21:out std_logic_vector(31 downto 0);
        c_out22:out std_logic_vector(31 downto 0);
        c_out23:out std_logic_vector(31 downto 0);
        c_out24:out std_logic_vector(31 downto 0);
        c_out25:out std_logic_vector(31 downto 0);
        c_out26:out std_logic_vector(31 downto 0);
        c_out27:out std_logic_vector(31 downto 0);
        c_out28:out std_logic_vector(31 downto 0);
        c_out29:out std_logic_vector(31 downto 0);
        c_out30:out std_logic_vector(31 downto 0);
        c_out31:out std_logic_vector(31 downto 0);
        c_out32:out std_logic_vector(31 downto 0);
        c_out33:out std_logic_vector(31 downto 0);
        c_out34:out std_logic_vector(31 downto 0);
        c_out35:out std_logic_vector(31 downto 0);
        c_out36:out std_logic_vector(31 downto 0);
        c_out37:out std_logic_vector(31 downto 0);
        c_out38:out std_logic_vector(31 downto 0);
        c_out39:out std_logic_vector(31 downto 0);
        c_out40:out std_logic_vector(31 downto 0);
        c_out41:out std_logic_vector(31 downto 0);
        c_out42:out std_logic_vector(31 downto 0);
        c_out43:out std_logic_vector(31 downto 0);
        c_out44:out std_logic_vector(31 downto 0);
        c_out45:out std_logic_vector(31 downto 0);
        c_out46:out std_logic_vector(31 downto 0);
        c_out47:out std_logic_vector(31 downto 0);
        c_out48:out std_logic_vector(31 downto 0);
        c_out49:out std_logic_vector(31 downto 0);
        c_out50:out std_logic_vector(31 downto 0);
        c_out51:out std_logic_vector(31 downto 0);
        c_out52:out std_logic_vector(31 downto 0);
        c_out53:out std_logic_vector(31 downto 0);
        c_out54:out std_logic_vector(31 downto 0);
        c_out55:out std_logic_vector(31 downto 0);
        c_out56:out std_logic_vector(31 downto 0);
        c_out57:out std_logic_vector(31 downto 0);
        c_out58:out std_logic_vector(31 downto 0);
        c_out59:out std_logic_vector(31 downto 0);
        c_out60:out std_logic_vector(31 downto 0);
        c_out61:out std_logic_vector(31 downto 0);
        c_out62:out std_logic_vector(31 downto 0);
        c_out63:out std_logic_vector(31 downto 0);
        c_out64:out std_logic_vector(31 downto 0);
        c_out65:out std_logic_vector(31 downto 0);
        c_out66:out std_logic_vector(31 downto 0);
        c_out67:out std_logic_vector(31 downto 0);
        c_out68:out std_logic_vector(31 downto 0);
        c_out69:out std_logic_vector(31 downto 0);
        c_out70:out std_logic_vector(31 downto 0);
        c_out71:out std_logic_vector(31 downto 0);
        c_out72:out std_logic_vector(31 downto 0);
        c_out73:out std_logic_vector(31 downto 0);
        c_out74:out std_logic_vector(31 downto 0);
        c_out75:out std_logic_vector(31 downto 0);
        c_out76:out std_logic_vector(31 downto 0);
        c_out77:out std_logic_vector(31 downto 0);
        c_out78:out std_logic_vector(31 downto 0);
        c_out79:out std_logic_vector(31 downto 0);
        c_out80:out std_logic_vector(31 downto 0);
        c_out81:out std_logic_vector(31 downto 0);
        c_out82:out std_logic_vector(31 downto 0);
        c_out83:out std_logic_vector(31 downto 0);
        c_out84:out std_logic_vector(31 downto 0);
        c_out85:out std_logic_vector(31 downto 0);
        c_out86:out std_logic_vector(31 downto 0);
        c_out87:out std_logic_vector(31 downto 0);
        c_out88:out std_logic_vector(31 downto 0);
        c_out89:out std_logic_vector(31 downto 0);
        c_out90:out std_logic_vector(31 downto 0);
        c_out91:out std_logic_vector(31 downto 0);
        c_out92:out std_logic_vector(31 downto 0);
        c_out93:out std_logic_vector(31 downto 0);
        c_out94:out std_logic_vector(31 downto 0);
        c_out95:out std_logic_vector(31 downto 0);
        c_out96:out std_logic_vector(31 downto 0);
        c_out97:out std_logic_vector(31 downto 0);
        c_out98:out std_logic_vector(31 downto 0);
        c_out99:out std_logic_vector(31 downto 0);
        c_out100:out std_logic_vector(31 downto 0);
        c_out101:out std_logic_vector(31 downto 0);
        c_out102:out std_logic_vector(31 downto 0);
        c_out103:out std_logic_vector(31 downto 0);
        c_out104:out std_logic_vector(31 downto 0);
        c_out105:out std_logic_vector(31 downto 0);
        c_out106:out std_logic_vector(31 downto 0);
        c_out107:out std_logic_vector(31 downto 0);
        c_out108:out std_logic_vector(31 downto 0);
        c_out109:out std_logic_vector(31 downto 0);
        c_out110:out std_logic_vector(31 downto 0);
        c_out111:out std_logic_vector(31 downto 0);
        c_out112:out std_logic_vector(31 downto 0);
        c_out113:out std_logic_vector(31 downto 0);
        c_out114:out std_logic_vector(31 downto 0);
        c_out115:out std_logic_vector(31 downto 0);
        c_out116:out std_logic_vector(31 downto 0);
        c_out117:out std_logic_vector(31 downto 0);
        c_out118:out std_logic_vector(31 downto 0);
        c_out119:out std_logic_vector(31 downto 0);
        c_out120:out std_logic_vector(31 downto 0);
        c_out121:out std_logic_vector(31 downto 0);
        c_out122:out std_logic_vector(31 downto 0);
        c_out123:out std_logic_vector(31 downto 0);
        c_out124:out std_logic_vector(31 downto 0);
        c_out125:out std_logic_vector(31 downto 0);
        c_out126:out std_logic_vector(31 downto 0);
        c_out127:out std_logic_vector(31 downto 0);
        c_out128:out std_logic_vector(31 downto 0);
        c_out129:out std_logic_vector(31 downto 0);
        c_out130:out std_logic_vector(31 downto 0);
        c_out131:out std_logic_vector(31 downto 0);
        c_out132:out std_logic_vector(31 downto 0);
        c_out133:out std_logic_vector(31 downto 0);
        c_out134:out std_logic_vector(31 downto 0);
        c_out135:out std_logic_vector(31 downto 0);
        c_out136:out std_logic_vector(31 downto 0);
        c_out137:out std_logic_vector(31 downto 0);
        c_out138:out std_logic_vector(31 downto 0);
        c_out139:out std_logic_vector(31 downto 0);
        c_out140:out std_logic_vector(31 downto 0);
        c_out141:out std_logic_vector(31 downto 0);
        c_out142:out std_logic_vector(31 downto 0);
        c_out143:out std_logic_vector(31 downto 0);
        c_out144:out std_logic_vector(31 downto 0);
        c_out145:out std_logic_vector(31 downto 0);
        c_out146:out std_logic_vector(31 downto 0);
        c_out147:out std_logic_vector(31 downto 0);
        c_out148:out std_logic_vector(31 downto 0);
        c_out149:out std_logic_vector(31 downto 0);
        c_out150:out std_logic_vector(31 downto 0);
        c_out151:out std_logic_vector(31 downto 0);
        c_out152:out std_logic_vector(31 downto 0);
        c_out153:out std_logic_vector(31 downto 0);
        c_out154:out std_logic_vector(31 downto 0);
        c_out155:out std_logic_vector(31 downto 0);
        c_out156:out std_logic_vector(31 downto 0);
        c_out157:out std_logic_vector(31 downto 0);
        c_out158:out std_logic_vector(31 downto 0);
        c_out159:out std_logic_vector(31 downto 0);
        c_out160:out std_logic_vector(31 downto 0);
        c_out161:out std_logic_vector(31 downto 0);
        c_out162:out std_logic_vector(31 downto 0);
        c_out163:out std_logic_vector(31 downto 0);
        c_out164:out std_logic_vector(31 downto 0);
        c_out165:out std_logic_vector(31 downto 0);
        c_out166:out std_logic_vector(31 downto 0);
        c_out167:out std_logic_vector(31 downto 0);
        c_out168:out std_logic_vector(31 downto 0);
        c_out169:out std_logic_vector(31 downto 0);
        c_out170:out std_logic_vector(31 downto 0);
        c_out171:out std_logic_vector(31 downto 0);
        c_out172:out std_logic_vector(31 downto 0);
        c_out173:out std_logic_vector(31 downto 0);
        c_out174:out std_logic_vector(31 downto 0);
        c_out175:out std_logic_vector(31 downto 0);
        c_out176:out std_logic_vector(31 downto 0);
        c_out177:out std_logic_vector(31 downto 0);
        c_out178:out std_logic_vector(31 downto 0);
        c_out179:out std_logic_vector(31 downto 0);
        c_out180:out std_logic_vector(31 downto 0);
        c_out181:out std_logic_vector(31 downto 0);
        c_out182:out std_logic_vector(31 downto 0);
        c_out183:out std_logic_vector(31 downto 0);
        c_out184:out std_logic_vector(31 downto 0);
        c_out185:out std_logic_vector(31 downto 0);
        c_out186:out std_logic_vector(31 downto 0);
        c_out187:out std_logic_vector(31 downto 0);
        c_out188:out std_logic_vector(31 downto 0);
        c_out189:out std_logic_vector(31 downto 0);
        c_out190:out std_logic_vector(31 downto 0);
        c_out191:out std_logic_vector(31 downto 0);
        c_out192:out std_logic_vector(31 downto 0);
        c_out193:out std_logic_vector(31 downto 0);
        c_out194:out std_logic_vector(31 downto 0);
        c_out195:out std_logic_vector(31 downto 0);
        c_out196:out std_logic_vector(31 downto 0);
        c_out197:out std_logic_vector(31 downto 0);
        c_out198:out std_logic_vector(31 downto 0);
        c_out199:out std_logic_vector(31 downto 0);
        c_out200:out std_logic_vector(31 downto 0);
        c_out201:out std_logic_vector(31 downto 0);
        c_out202:out std_logic_vector(31 downto 0);
        c_out203:out std_logic_vector(31 downto 0);
        c_out204:out std_logic_vector(31 downto 0);
        c_out205:out std_logic_vector(31 downto 0);
        c_out206:out std_logic_vector(31 downto 0);
        c_out207:out std_logic_vector(31 downto 0);
        c_out208:out std_logic_vector(31 downto 0);
        c_out209:out std_logic_vector(31 downto 0);
        c_out210:out std_logic_vector(31 downto 0);
        c_out211:out std_logic_vector(31 downto 0);
        c_out212:out std_logic_vector(31 downto 0);
        c_out213:out std_logic_vector(31 downto 0);
        c_out214:out std_logic_vector(31 downto 0);
        c_out215:out std_logic_vector(31 downto 0);
        c_out216:out std_logic_vector(31 downto 0);
        c_out217:out std_logic_vector(31 downto 0);
        c_out218:out std_logic_vector(31 downto 0);
        c_out219:out std_logic_vector(31 downto 0);
        c_out220:out std_logic_vector(31 downto 0);
        c_out221:out std_logic_vector(31 downto 0);
        c_out222:out std_logic_vector(31 downto 0);
        c_out223:out std_logic_vector(31 downto 0);
        c_out224:out std_logic_vector(31 downto 0);
        c_out225:out std_logic_vector(31 downto 0);
        c_out226:out std_logic_vector(31 downto 0);
        c_out227:out std_logic_vector(31 downto 0);
        c_out228:out std_logic_vector(31 downto 0);
        c_out229:out std_logic_vector(31 downto 0);
        c_out230:out std_logic_vector(31 downto 0);
        c_out231:out std_logic_vector(31 downto 0);
        c_out232:out std_logic_vector(31 downto 0)
 
    );
end component;

    --Segnale per il reset
    signal rst_not:std_logic;

    --Segnali per le uscite.
    signal cout0:std_logic_vector(31 downto 0);
    signal cout1:std_logic_vector(31 downto 0);
    signal cout2:std_logic_vector(31 downto 0);
    signal cout3:std_logic_vector(31 downto 0);
    signal cout4:std_logic_vector(31 downto 0);
    signal cout5:std_logic_vector(31 downto 0);
    signal cout6:std_logic_vector(31 downto 0);
    signal cout7:std_logic_vector(31 downto 0);
    signal cout8:std_logic_vector(31 downto 0);
    signal cout9:std_logic_vector(31 downto 0);
    signal cout10:std_logic_vector(31 downto 0);
    signal cout11:std_logic_vector(31 downto 0);
    signal cout12:std_logic_vector(31 downto 0);
    signal cout13:std_logic_vector(31 downto 0);
    signal cout14:std_logic_vector(31 downto 0);
    signal cout15:std_logic_vector(31 downto 0);
    signal cout16:std_logic_vector(31 downto 0);
    signal cout17:std_logic_vector(31 downto 0);
    signal cout18:std_logic_vector(31 downto 0);
    signal cout19:std_logic_vector(31 downto 0);
    signal cout20:std_logic_vector(31 downto 0);
    signal cout21:std_logic_vector(31 downto 0);
    signal cout22:std_logic_vector(31 downto 0);
    signal cout23:std_logic_vector(31 downto 0);
    signal cout24:std_logic_vector(31 downto 0);
    signal cout25:std_logic_vector(31 downto 0);
    signal cout26:std_logic_vector(31 downto 0);
    signal cout27:std_logic_vector(31 downto 0);
    signal cout28:std_logic_vector(31 downto 0);
    signal cout29:std_logic_vector(31 downto 0);
    signal cout30:std_logic_vector(31 downto 0);
    signal cout31:std_logic_vector(31 downto 0);
    signal cout32:std_logic_vector(31 downto 0);
    signal cout33:std_logic_vector(31 downto 0);
    signal cout34:std_logic_vector(31 downto 0);
    signal cout35:std_logic_vector(31 downto 0);
    signal cout36:std_logic_vector(31 downto 0);
    signal cout37:std_logic_vector(31 downto 0);
    signal cout38:std_logic_vector(31 downto 0);
    signal cout39:std_logic_vector(31 downto 0);
    signal cout40:std_logic_vector(31 downto 0);
    signal cout41:std_logic_vector(31 downto 0);
    signal cout42:std_logic_vector(31 downto 0);
    signal cout43:std_logic_vector(31 downto 0);
    signal cout44:std_logic_vector(31 downto 0);
    signal cout45:std_logic_vector(31 downto 0);
    signal cout46:std_logic_vector(31 downto 0);
    signal cout47:std_logic_vector(31 downto 0);
    signal cout48:std_logic_vector(31 downto 0);
    signal cout49:std_logic_vector(31 downto 0);
    signal cout50:std_logic_vector(31 downto 0);
    signal cout51:std_logic_vector(31 downto 0);
    signal cout52:std_logic_vector(31 downto 0);
    signal cout53:std_logic_vector(31 downto 0);
    signal cout54:std_logic_vector(31 downto 0);
    signal cout55:std_logic_vector(31 downto 0);
    signal cout56:std_logic_vector(31 downto 0);
    signal cout57:std_logic_vector(31 downto 0);
    signal cout58:std_logic_vector(31 downto 0);
    signal cout59:std_logic_vector(31 downto 0);
    signal cout60:std_logic_vector(31 downto 0);
    signal cout61:std_logic_vector(31 downto 0);
    signal cout62:std_logic_vector(31 downto 0);
    signal cout63:std_logic_vector(31 downto 0);
    signal cout64:std_logic_vector(31 downto 0);
    signal cout65:std_logic_vector(31 downto 0);
    signal cout66:std_logic_vector(31 downto 0);
    signal cout67:std_logic_vector(31 downto 0);
    signal cout68:std_logic_vector(31 downto 0);
    signal cout69:std_logic_vector(31 downto 0);
    signal cout70:std_logic_vector(31 downto 0);
    signal cout71:std_logic_vector(31 downto 0);
    signal cout72:std_logic_vector(31 downto 0);
    signal cout73:std_logic_vector(31 downto 0);
    signal cout74:std_logic_vector(31 downto 0);
    signal cout75:std_logic_vector(31 downto 0);
    signal cout76:std_logic_vector(31 downto 0);
    signal cout77:std_logic_vector(31 downto 0);
    signal cout78:std_logic_vector(31 downto 0);
    signal cout79:std_logic_vector(31 downto 0);
    signal cout80:std_logic_vector(31 downto 0);
    signal cout81:std_logic_vector(31 downto 0);
    signal cout82:std_logic_vector(31 downto 0);
    signal cout83:std_logic_vector(31 downto 0);
    signal cout84:std_logic_vector(31 downto 0);
    signal cout85:std_logic_vector(31 downto 0);
    signal cout86:std_logic_vector(31 downto 0);
    signal cout87:std_logic_vector(31 downto 0);
    signal cout88:std_logic_vector(31 downto 0);
    signal cout89:std_logic_vector(31 downto 0);
    signal cout90:std_logic_vector(31 downto 0);
    signal cout91:std_logic_vector(31 downto 0);
    signal cout92:std_logic_vector(31 downto 0);
    signal cout93:std_logic_vector(31 downto 0);
    signal cout94:std_logic_vector(31 downto 0);
    signal cout95:std_logic_vector(31 downto 0);
    signal cout96:std_logic_vector(31 downto 0);
    signal cout97:std_logic_vector(31 downto 0);
    signal cout98:std_logic_vector(31 downto 0);
    signal cout99:std_logic_vector(31 downto 0);
    signal cout100:std_logic_vector(31 downto 0);
    signal cout101:std_logic_vector(31 downto 0);
    signal cout102:std_logic_vector(31 downto 0);
    signal cout103:std_logic_vector(31 downto 0);
    signal cout104:std_logic_vector(31 downto 0);
    signal cout105:std_logic_vector(31 downto 0);
    signal cout106:std_logic_vector(31 downto 0);
    signal cout107:std_logic_vector(31 downto 0);
    signal cout108:std_logic_vector(31 downto 0);
    signal cout109:std_logic_vector(31 downto 0);
    signal cout110:std_logic_vector(31 downto 0);
    signal cout111:std_logic_vector(31 downto 0);
    signal cout112:std_logic_vector(31 downto 0);
    signal cout113:std_logic_vector(31 downto 0);
    signal cout114:std_logic_vector(31 downto 0);
    signal cout115:std_logic_vector(31 downto 0);
    signal cout116:std_logic_vector(31 downto 0);
    signal cout117:std_logic_vector(31 downto 0);
    signal cout118:std_logic_vector(31 downto 0);
    signal cout119:std_logic_vector(31 downto 0);
    signal cout120:std_logic_vector(31 downto 0);
    signal cout121:std_logic_vector(31 downto 0);
    signal cout122:std_logic_vector(31 downto 0);
    signal cout123:std_logic_vector(31 downto 0);
    signal cout124:std_logic_vector(31 downto 0);
    signal cout125:std_logic_vector(31 downto 0);
    signal cout126:std_logic_vector(31 downto 0);
    signal cout127:std_logic_vector(31 downto 0);
    signal cout128:std_logic_vector(31 downto 0);
    signal cout129:std_logic_vector(31 downto 0);
    signal cout130:std_logic_vector(31 downto 0);
    signal cout131:std_logic_vector(31 downto 0);
    signal cout132:std_logic_vector(31 downto 0);
    signal cout133:std_logic_vector(31 downto 0);
    signal cout134:std_logic_vector(31 downto 0);
    signal cout135:std_logic_vector(31 downto 0);
    signal cout136:std_logic_vector(31 downto 0);
    signal cout137:std_logic_vector(31 downto 0);
    signal cout138:std_logic_vector(31 downto 0);
    signal cout139:std_logic_vector(31 downto 0);
    signal cout140:std_logic_vector(31 downto 0);
    signal cout141:std_logic_vector(31 downto 0);
    signal cout142:std_logic_vector(31 downto 0);
    signal cout143:std_logic_vector(31 downto 0);
    signal cout144:std_logic_vector(31 downto 0);
    signal cout145:std_logic_vector(31 downto 0);
    signal cout146:std_logic_vector(31 downto 0);
    signal cout147:std_logic_vector(31 downto 0);
    signal cout148:std_logic_vector(31 downto 0);
    signal cout149:std_logic_vector(31 downto 0);
    signal cout150:std_logic_vector(31 downto 0);
    signal cout151:std_logic_vector(31 downto 0);
    signal cout152:std_logic_vector(31 downto 0);
    signal cout153:std_logic_vector(31 downto 0);
    signal cout154:std_logic_vector(31 downto 0);
    signal cout155:std_logic_vector(31 downto 0);
    signal cout156:std_logic_vector(31 downto 0);
    signal cout157:std_logic_vector(31 downto 0);
    signal cout158:std_logic_vector(31 downto 0);
    signal cout159:std_logic_vector(31 downto 0);
    signal cout160:std_logic_vector(31 downto 0);
    signal cout161:std_logic_vector(31 downto 0);
    signal cout162:std_logic_vector(31 downto 0);
    signal cout163:std_logic_vector(31 downto 0);
    signal cout164:std_logic_vector(31 downto 0);
    signal cout165:std_logic_vector(31 downto 0);
    signal cout166:std_logic_vector(31 downto 0);
    signal cout167:std_logic_vector(31 downto 0);
    signal cout168:std_logic_vector(31 downto 0);
    signal cout169:std_logic_vector(31 downto 0);
    signal cout170:std_logic_vector(31 downto 0);
    signal cout171:std_logic_vector(31 downto 0);
    signal cout172:std_logic_vector(31 downto 0);
    signal cout173:std_logic_vector(31 downto 0);
    signal cout174:std_logic_vector(31 downto 0);
    signal cout175:std_logic_vector(31 downto 0);
    signal cout176:std_logic_vector(31 downto 0);
    signal cout177:std_logic_vector(31 downto 0);
    signal cout178:std_logic_vector(31 downto 0);
    signal cout179:std_logic_vector(31 downto 0);
    signal cout180:std_logic_vector(31 downto 0);
    signal cout181:std_logic_vector(31 downto 0);
    signal cout182:std_logic_vector(31 downto 0);
    signal cout183:std_logic_vector(31 downto 0);
    signal cout184:std_logic_vector(31 downto 0);
    signal cout185:std_logic_vector(31 downto 0);
    signal cout186:std_logic_vector(31 downto 0);
    signal cout187:std_logic_vector(31 downto 0);
    signal cout188:std_logic_vector(31 downto 0);
    signal cout189:std_logic_vector(31 downto 0);
    signal cout190:std_logic_vector(31 downto 0);
    signal cout191:std_logic_vector(31 downto 0);
    signal cout192:std_logic_vector(31 downto 0);
    signal cout193:std_logic_vector(31 downto 0);
    signal cout194:std_logic_vector(31 downto 0);
    signal cout195:std_logic_vector(31 downto 0);
    signal cout196:std_logic_vector(31 downto 0);
    signal cout197:std_logic_vector(31 downto 0);
    signal cout198:std_logic_vector(31 downto 0);
    signal cout199:std_logic_vector(31 downto 0);
    signal cout200:std_logic_vector(31 downto 0);
    signal cout201:std_logic_vector(31 downto 0);
    signal cout202:std_logic_vector(31 downto 0);
    signal cout203:std_logic_vector(31 downto 0);
    signal cout204:std_logic_vector(31 downto 0);
    signal cout205:std_logic_vector(31 downto 0);
    signal cout206:std_logic_vector(31 downto 0);
    signal cout207:std_logic_vector(31 downto 0);
    signal cout208:std_logic_vector(31 downto 0);
    signal cout209:std_logic_vector(31 downto 0);
    signal cout210:std_logic_vector(31 downto 0);
    signal cout211:std_logic_vector(31 downto 0);
    signal cout212:std_logic_vector(31 downto 0);
    signal cout213:std_logic_vector(31 downto 0);
    signal cout214:std_logic_vector(31 downto 0);
    signal cout215:std_logic_vector(31 downto 0);
    signal cout216:std_logic_vector(31 downto 0);
    signal cout217:std_logic_vector(31 downto 0);
    signal cout218:std_logic_vector(31 downto 0);
    signal cout219:std_logic_vector(31 downto 0);
    signal cout220:std_logic_vector(31 downto 0);
    signal cout221:std_logic_vector(31 downto 0);
    signal cout222:std_logic_vector(31 downto 0);
    signal cout223:std_logic_vector(31 downto 0);
    signal cout224:std_logic_vector(31 downto 0);
    signal cout225:std_logic_vector(31 downto 0);
    signal cout226:std_logic_vector(31 downto 0);
    signal cout227:std_logic_vector(31 downto 0);
    signal cout228:std_logic_vector(31 downto 0);
    signal cout229:std_logic_vector(31 downto 0);
    signal cout230:std_logic_vector(31 downto 0);
    signal cout231:std_logic_vector(31 downto 0);
    signal cout232:std_logic_vector(31 downto 0);
begin

   controllo_slvreg240 <= slv_reg240(0);

	-- I/O Connections assignments

	S_AXI_AWREADY	<= axi_awready;
	S_AXI_WREADY	<= axi_wready;
	S_AXI_BRESP	<= axi_bresp;
	S_AXI_BVALID	<= axi_bvalid;
	S_AXI_ARREADY	<= axi_arready;
	S_AXI_RDATA	<= axi_rdata;
	S_AXI_RRESP	<= axi_rresp;
	S_AXI_RVALID	<= axi_rvalid;
	-- Implement axi_awready generation
	-- axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	-- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	-- de-asserted when reset is low.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awready <= '0';
	      aw_en <= '1';
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and aw_en = '1') then
	        -- slave is ready to accept write address when
	        -- there is a valid write address and write data
	        -- on the write address and data bus. This design 
	        -- expects no outstanding transactions. 
	           axi_awready <= '1';
	           aw_en <= '0';
	        elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then
	           aw_en <= '1';
	           axi_awready <= '0';
	      else
	        axi_awready <= '0';
	      end if;
	    end if;
	  end if;
	end process;

	-- Implement axi_awaddr latching
	-- This process is used to latch the address when both 
	-- S_AXI_AWVALID and S_AXI_WVALID are valid. 

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awaddr <= (others => '0');
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and aw_en = '1') then
	        -- Write Address latching
	        axi_awaddr <= S_AXI_AWADDR;
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_wready generation
	-- axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	-- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	-- de-asserted when reset is low. 

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_wready <= '0';
	    else
	      if (axi_wready = '0' and S_AXI_WVALID = '1' and S_AXI_AWVALID = '1' and aw_en = '1') then
	          -- slave is ready to accept write data when 
	          -- there is a valid write address and write data
	          -- on the write address and data bus. This design 
	          -- expects no outstanding transactions.           
	          axi_wready <= '1';
	      else
	        axi_wready <= '0';
	      end if;
	    end if;
	  end if;
	end process; 

	-- Implement memory mapped register select and write logic generation
	-- The write data is accepted and written to memory mapped registers when
	-- axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	-- select byte enables of slave registers while writing.
	-- These registers are cleared when reset (active low) is applied.
	-- Slave register write enable is asserted when valid address and data are available
	-- and the slave is ready to accept the write address and write data.
	slv_reg_wren <= axi_wready and S_AXI_WVALID and axi_awready and S_AXI_AWVALID ;

	process (S_AXI_ACLK)
	variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0); 
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      slv_reg0 <= (others => '0');
	      slv_reg1 <= (others => '0');
	      slv_reg2 <= (others => '0');
	      slv_reg3 <= (others => '0');
	      slv_reg4 <= (others => '0');
	      slv_reg5 <= (others => '0');
	      slv_reg6 <= (others => '0');
	      slv_reg7 <= (others => '0');
	      slv_reg8 <= (others => '0');
	      slv_reg9 <= (others => '0');
	      slv_reg10 <= (others => '0');
	      slv_reg11 <= (others => '0');
	      slv_reg12 <= (others => '0');
	      slv_reg13 <= (others => '0');
	      slv_reg14 <= (others => '0');
	      slv_reg15 <= (others => '0');
	      slv_reg16 <= (others => '0');
	      slv_reg17 <= (others => '0');
	      slv_reg18 <= (others => '0');
	      slv_reg19 <= (others => '0');
	      slv_reg20 <= (others => '0');
	      slv_reg21 <= (others => '0');
	      slv_reg22 <= (others => '0');
	      slv_reg23 <= (others => '0');
	      slv_reg24 <= (others => '0');
	      slv_reg25 <= (others => '0');
	      slv_reg26 <= (others => '0');
	      slv_reg27 <= (others => '0');
	      slv_reg28 <= (others => '0');
	      slv_reg29 <= (others => '0');
	      slv_reg30 <= (others => '0');
	      slv_reg31 <= (others => '0');
	      slv_reg32 <= (others => '0');
	      slv_reg33 <= (others => '0');
	      slv_reg34 <= (others => '0');
	      slv_reg35 <= (others => '0');
	      slv_reg36 <= (others => '0');
	      slv_reg37 <= (others => '0');
	      slv_reg38 <= (others => '0');
	      slv_reg39 <= (others => '0');
	      slv_reg40 <= (others => '0');
	      slv_reg41 <= (others => '0');
	      slv_reg42 <= (others => '0');
	      slv_reg43 <= (others => '0');
	      slv_reg44 <= (others => '0');
	      slv_reg45 <= (others => '0');
	      slv_reg46 <= (others => '0');
	      slv_reg47 <= (others => '0');
	      slv_reg48 <= (others => '0');
	      slv_reg49 <= (others => '0');
	      slv_reg50 <= (others => '0');
	      slv_reg51 <= (others => '0');
	      slv_reg52 <= (others => '0');
	      slv_reg53 <= (others => '0');
	      slv_reg54 <= (others => '0');
	      slv_reg55 <= (others => '0');
	      slv_reg56 <= (others => '0');
	      slv_reg57 <= (others => '0');
	      slv_reg58 <= (others => '0');
	      slv_reg59 <= (others => '0');
	      slv_reg60 <= (others => '0');
	      slv_reg61 <= (others => '0');
	      slv_reg62 <= (others => '0');
	      slv_reg63 <= (others => '0');
	      slv_reg64 <= (others => '0');
	      slv_reg65 <= (others => '0');
	      slv_reg66 <= (others => '0');
	      slv_reg67 <= (others => '0');
	      slv_reg68 <= (others => '0');
	      slv_reg69 <= (others => '0');
	      slv_reg70 <= (others => '0');
	      slv_reg71 <= (others => '0');
	      slv_reg72 <= (others => '0');
	      slv_reg73 <= (others => '0');
	      slv_reg74 <= (others => '0');
	      slv_reg75 <= (others => '0');
	      slv_reg76 <= (others => '0');
	      slv_reg77 <= (others => '0');
	      slv_reg78 <= (others => '0');
	      slv_reg79 <= (others => '0');
	      slv_reg80 <= (others => '0');
	      slv_reg81 <= (others => '0');
	      slv_reg82 <= (others => '0');
	      slv_reg83 <= (others => '0');
	      slv_reg84 <= (others => '0');
	      slv_reg85 <= (others => '0');
	      slv_reg86 <= (others => '0');
	      slv_reg87 <= (others => '0');
	      slv_reg88 <= (others => '0');
	      slv_reg89 <= (others => '0');
	      slv_reg90 <= (others => '0');
	      slv_reg91 <= (others => '0');
	      slv_reg92 <= (others => '0');
	      slv_reg93 <= (others => '0');
	      slv_reg94 <= (others => '0');
	      slv_reg95 <= (others => '0');
	      slv_reg96 <= (others => '0');
	      slv_reg97 <= (others => '0');
	      slv_reg98 <= (others => '0');
	      slv_reg99 <= (others => '0');
	      slv_reg100 <= (others => '0');
	      slv_reg101 <= (others => '0');
	      slv_reg102 <= (others => '0');
	      slv_reg103 <= (others => '0');
	      slv_reg104 <= (others => '0');
	      slv_reg105 <= (others => '0');
	      slv_reg106 <= (others => '0');
	      slv_reg107 <= (others => '0');
	      slv_reg108 <= (others => '0');
	      slv_reg109 <= (others => '0');
	      slv_reg110 <= (others => '0');
	      slv_reg111 <= (others => '0');
	      slv_reg112 <= (others => '0');
	      slv_reg113 <= (others => '0');
	      slv_reg114 <= (others => '0');
	      slv_reg115 <= (others => '0');
	      slv_reg116 <= (others => '0');
	      slv_reg117 <= (others => '0');
	      slv_reg118 <= (others => '0');
	      slv_reg119 <= (others => '0');
	      slv_reg120 <= (others => '0');
	      slv_reg121 <= (others => '0');
	      slv_reg122 <= (others => '0');
	      slv_reg123 <= (others => '0');
	      slv_reg124 <= (others => '0');
	      slv_reg125 <= (others => '0');
	      slv_reg126 <= (others => '0');
	      slv_reg127 <= (others => '0');
	      slv_reg128 <= (others => '0');
	      slv_reg129 <= (others => '0');
	      slv_reg130 <= (others => '0');
	      slv_reg131 <= (others => '0');
	      slv_reg132 <= (others => '0');
	      slv_reg133 <= (others => '0');
	      slv_reg134 <= (others => '0');
	      slv_reg135 <= (others => '0');
	      slv_reg136 <= (others => '0');
	      slv_reg137 <= (others => '0');
	      slv_reg138 <= (others => '0');
	      slv_reg139 <= (others => '0');
	      slv_reg140 <= (others => '0');
	      slv_reg141 <= (others => '0');
	      slv_reg142 <= (others => '0');
	      slv_reg143 <= (others => '0');
	      slv_reg144 <= (others => '0');
	      slv_reg145 <= (others => '0');
	      slv_reg146 <= (others => '0');
	      slv_reg147 <= (others => '0');
	      slv_reg148 <= (others => '0');
	      slv_reg149 <= (others => '0');
	      slv_reg150 <= (others => '0');
	      slv_reg151 <= (others => '0');
	      slv_reg152 <= (others => '0');
	      slv_reg153 <= (others => '0');
	      slv_reg154 <= (others => '0');
	      slv_reg155 <= (others => '0');
	      slv_reg156 <= (others => '0');
	      slv_reg157 <= (others => '0');
	      slv_reg158 <= (others => '0');
	      slv_reg159 <= (others => '0');
	      slv_reg160 <= (others => '0');
	      slv_reg161 <= (others => '0');
	      slv_reg162 <= (others => '0');
	      slv_reg163 <= (others => '0');
	      slv_reg164 <= (others => '0');
	      slv_reg165 <= (others => '0');
	      slv_reg166 <= (others => '0');
	      slv_reg167 <= (others => '0');
	      slv_reg168 <= (others => '0');
	      slv_reg169 <= (others => '0');
	      slv_reg170 <= (others => '0');
	      slv_reg171 <= (others => '0');
	      slv_reg172 <= (others => '0');
	      slv_reg173 <= (others => '0');
	      slv_reg174 <= (others => '0');
	      slv_reg175 <= (others => '0');
	      slv_reg176 <= (others => '0');
	      slv_reg177 <= (others => '0');
	      slv_reg178 <= (others => '0');
	      slv_reg179 <= (others => '0');
	      slv_reg180 <= (others => '0');
	      slv_reg181 <= (others => '0');
	      slv_reg182 <= (others => '0');
	      slv_reg183 <= (others => '0');
	      slv_reg184 <= (others => '0');
	      slv_reg185 <= (others => '0');
	      slv_reg186 <= (others => '0');
	      slv_reg187 <= (others => '0');
	      slv_reg188 <= (others => '0');
	      slv_reg189 <= (others => '0');
	      slv_reg190 <= (others => '0');
	      slv_reg191 <= (others => '0');
	      slv_reg192 <= (others => '0');
	      slv_reg193 <= (others => '0');
	      slv_reg194 <= (others => '0');
	      slv_reg195 <= (others => '0');
	      slv_reg196 <= (others => '0');
	      slv_reg197 <= (others => '0');
	      slv_reg198 <= (others => '0');
	      slv_reg199 <= (others => '0');
	      slv_reg200 <= (others => '0');
	      slv_reg201 <= (others => '0');
	      slv_reg202 <= (others => '0');
	      slv_reg203 <= (others => '0');
	      slv_reg204 <= (others => '0');
	      slv_reg205 <= (others => '0');
	      slv_reg206 <= (others => '0');
	      slv_reg207 <= (others => '0');
	      slv_reg208 <= (others => '0');
	      slv_reg209 <= (others => '0');
	      slv_reg210 <= (others => '0');
	      slv_reg211 <= (others => '0');
	      slv_reg212 <= (others => '0');
	      slv_reg213 <= (others => '0');
	      slv_reg214 <= (others => '0');
	      slv_reg215 <= (others => '0');
	      slv_reg216 <= (others => '0');
	      slv_reg217 <= (others => '0');
	      slv_reg218 <= (others => '0');
	      slv_reg219 <= (others => '0');
	      slv_reg220 <= (others => '0');
	      slv_reg221 <= (others => '0');
	      slv_reg222 <= (others => '0');
	      slv_reg223 <= (others => '0');
	      slv_reg224 <= (others => '0');
	      slv_reg225 <= (others => '0');
	      slv_reg226 <= (others => '0');
	      slv_reg227 <= (others => '0');
	      slv_reg228 <= (others => '0');
	      slv_reg229 <= (others => '0');
	      slv_reg230 <= (others => '0');
	      slv_reg231 <= (others => '0');
	      slv_reg232 <= (others => '0');
	      slv_reg233 <= (others => '0');
	      slv_reg234 <= (others => '0');
	      slv_reg235 <= (others => '0');
	      slv_reg236 <= (others => '0');
	      slv_reg237 <= (others => '0');
	      slv_reg238 <= (others => '0');
	      slv_reg239 <= (others => '0');
	      slv_reg240 <= (others => '0');
	    else
	      loc_addr := axi_awaddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
	      if (slv_reg_wren = '1') then
	        case loc_addr is
	          when b"00000000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 0
	                slv_reg0(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00000001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 1
	                slv_reg1(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00000010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 2
	                slv_reg2(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00000011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 3
	                slv_reg3(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00000100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 4
	                slv_reg4(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00000101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 5
	                slv_reg5(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00000110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 6
	                slv_reg6(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00000111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 7
	                slv_reg7(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00001000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 8
	                slv_reg8(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00001001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 9
	                slv_reg9(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00001010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 10
	                slv_reg10(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00001011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 11
	                slv_reg11(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00001100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 12
	                slv_reg12(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00001101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 13
	                slv_reg13(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00001110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 14
	                slv_reg14(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00001111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 15
	                slv_reg15(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00010000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 16
	                slv_reg16(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00010001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 17
	                slv_reg17(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00010010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 18
	                slv_reg18(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00010011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 19
	                slv_reg19(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00010100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 20
	                slv_reg20(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00010101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 21
	                slv_reg21(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00010110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 22
	                slv_reg22(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00010111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 23
	                slv_reg23(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00011000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 24
	                slv_reg24(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00011001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 25
	                slv_reg25(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00011010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 26
	                slv_reg26(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00011011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 27
	                slv_reg27(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00011100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 28
	                slv_reg28(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00011101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 29
	                slv_reg29(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00011110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 30
	                slv_reg30(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00011111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 31
	                slv_reg31(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00100000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 32
	                slv_reg32(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00100001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 33
	                slv_reg33(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00100010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 34
	                slv_reg34(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00100011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 35
	                slv_reg35(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00100100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 36
	                slv_reg36(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00100101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 37
	                slv_reg37(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00100110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 38
	                slv_reg38(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00100111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 39
	                slv_reg39(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00101000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 40
	                slv_reg40(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00101001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 41
	                slv_reg41(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00101010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 42
	                slv_reg42(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00101011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 43
	                slv_reg43(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00101100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 44
	                slv_reg44(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00101101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 45
	                slv_reg45(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00101110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 46
	                slv_reg46(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00101111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 47
	                slv_reg47(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00110000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 48
	                slv_reg48(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00110001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 49
	                slv_reg49(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00110010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 50
	                slv_reg50(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00110011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 51
	                slv_reg51(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00110100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 52
	                slv_reg52(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00110101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 53
	                slv_reg53(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00110110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 54
	                slv_reg54(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00110111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 55
	                slv_reg55(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00111000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 56
	                slv_reg56(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00111001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 57
	                slv_reg57(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00111010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 58
	                slv_reg58(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00111011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 59
	                slv_reg59(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00111100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 60
	                slv_reg60(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00111101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 61
	                slv_reg61(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00111110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 62
	                slv_reg62(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"00111111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 63
	                slv_reg63(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01000000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 64
	                slv_reg64(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01000001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 65
	                slv_reg65(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01000010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 66
	                slv_reg66(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01000011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 67
	                slv_reg67(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01000100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 68
	                slv_reg68(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01000101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 69
	                slv_reg69(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01000110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 70
	                slv_reg70(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01000111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 71
	                slv_reg71(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01001000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 72
	                slv_reg72(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01001001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 73
	                slv_reg73(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01001010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 74
	                slv_reg74(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01001011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 75
	                slv_reg75(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01001100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 76
	                slv_reg76(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01001101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 77
	                slv_reg77(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01001110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 78
	                slv_reg78(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01001111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 79
	                slv_reg79(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01010000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 80
	                slv_reg80(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01010001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 81
	                slv_reg81(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01010010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 82
	                slv_reg82(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01010011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 83
	                slv_reg83(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01010100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 84
	                slv_reg84(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01010101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 85
	                slv_reg85(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01010110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 86
	                slv_reg86(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01010111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 87
	                slv_reg87(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01011000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 88
	                slv_reg88(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01011001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 89
	                slv_reg89(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01011010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 90
	                slv_reg90(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01011011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 91
	                slv_reg91(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01011100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 92
	                slv_reg92(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01011101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 93
	                slv_reg93(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01011110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 94
	                slv_reg94(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01011111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 95
	                slv_reg95(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01100000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 96
	                slv_reg96(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01100001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 97
	                slv_reg97(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01100010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 98
	                slv_reg98(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01100011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 99
	                slv_reg99(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01100100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 100
	                slv_reg100(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01100101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 101
	                slv_reg101(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01100110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 102
	                slv_reg102(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01100111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 103
	                slv_reg103(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01101000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 104
	                slv_reg104(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01101001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 105
	                slv_reg105(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01101010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 106
	                slv_reg106(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01101011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 107
	                slv_reg107(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01101100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 108
	                slv_reg108(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01101101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 109
	                slv_reg109(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01101110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 110
	                slv_reg110(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01101111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 111
	                slv_reg111(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01110000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 112
	                slv_reg112(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01110001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 113
	                slv_reg113(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01110010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 114
	                slv_reg114(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01110011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 115
	                slv_reg115(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01110100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 116
	                slv_reg116(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01110101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 117
	                slv_reg117(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01110110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 118
	                slv_reg118(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01110111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 119
	                slv_reg119(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01111000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 120
	                slv_reg120(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01111001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 121
	                slv_reg121(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01111010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 122
	                slv_reg122(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01111011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 123
	                slv_reg123(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01111100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 124
	                slv_reg124(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01111101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 125
	                slv_reg125(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01111110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 126
	                slv_reg126(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"01111111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 127
	                slv_reg127(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10000000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 128
	                slv_reg128(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10000001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 129
	                slv_reg129(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10000010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 130
	                slv_reg130(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10000011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 131
	                slv_reg131(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10000100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 132
	                slv_reg132(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10000101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 133
	                slv_reg133(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10000110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 134
	                slv_reg134(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10000111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 135
	                slv_reg135(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10001000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 136
	                slv_reg136(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10001001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 137
	                slv_reg137(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10001010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 138
	                slv_reg138(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10001011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 139
	                slv_reg139(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10001100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 140
	                slv_reg140(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10001101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 141
	                slv_reg141(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10001110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 142
	                slv_reg142(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10001111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 143
	                slv_reg143(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10010000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 144
	                slv_reg144(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10010001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 145
	                slv_reg145(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10010010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 146
	                slv_reg146(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10010011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 147
	                slv_reg147(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10010100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 148
	                slv_reg148(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10010101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 149
	                slv_reg149(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10010110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 150
	                slv_reg150(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10010111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 151
	                slv_reg151(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10011000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 152
	                slv_reg152(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10011001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 153
	                slv_reg153(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10011010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 154
	                slv_reg154(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10011011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 155
	                slv_reg155(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10011100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 156
	                slv_reg156(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10011101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 157
	                slv_reg157(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10011110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 158
	                slv_reg158(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10011111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 159
	                slv_reg159(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10100000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 160
	                slv_reg160(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10100001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 161
	                slv_reg161(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10100010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 162
	                slv_reg162(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10100011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 163
	                slv_reg163(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10100100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 164
	                slv_reg164(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10100101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 165
	                slv_reg165(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10100110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 166
	                slv_reg166(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10100111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 167
	                slv_reg167(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10101000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 168
	                slv_reg168(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10101001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 169
	                slv_reg169(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10101010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 170
	                slv_reg170(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10101011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 171
	                slv_reg171(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10101100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 172
	                slv_reg172(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10101101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 173
	                slv_reg173(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10101110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 174
	                slv_reg174(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10101111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 175
	                slv_reg175(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10110000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 176
	                slv_reg176(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10110001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 177
	                slv_reg177(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10110010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 178
	                slv_reg178(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10110011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 179
	                slv_reg179(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10110100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 180
	                slv_reg180(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10110101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 181
	                slv_reg181(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10110110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 182
	                slv_reg182(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10110111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 183
	                slv_reg183(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10111000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 184
	                slv_reg184(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10111001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 185
	                slv_reg185(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10111010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 186
	                slv_reg186(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10111011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 187
	                slv_reg187(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10111100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 188
	                slv_reg188(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10111101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 189
	                slv_reg189(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10111110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 190
	                slv_reg190(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"10111111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 191
	                slv_reg191(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11000000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 192
	                slv_reg192(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11000001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 193
	                slv_reg193(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11000010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 194
	                slv_reg194(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11000011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 195
	                slv_reg195(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11000100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 196
	                slv_reg196(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11000101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 197
	                slv_reg197(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11000110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 198
	                slv_reg198(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11000111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 199
	                slv_reg199(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11001000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 200
	                slv_reg200(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11001001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 201
	                slv_reg201(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11001010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 202
	                slv_reg202(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11001011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 203
	                slv_reg203(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11001100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 204
	                slv_reg204(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11001101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 205
	                slv_reg205(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11001110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 206
	                slv_reg206(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11001111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 207
	                slv_reg207(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11010000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 208
	                slv_reg208(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11010001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 209
	                slv_reg209(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11010010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 210
	                slv_reg210(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11010011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 211
	                slv_reg211(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11010100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 212
	                slv_reg212(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11010101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 213
	                slv_reg213(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11010110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 214
	                slv_reg214(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11010111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 215
	                slv_reg215(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11011000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 216
	                slv_reg216(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11011001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 217
	                slv_reg217(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11011010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 218
	                slv_reg218(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11011011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 219
	                slv_reg219(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11011100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 220
	                slv_reg220(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11011101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 221
	                slv_reg221(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11011110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 222
	                slv_reg222(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11011111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 223
	                slv_reg223(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11100000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 224
	                slv_reg224(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11100001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 225
	                slv_reg225(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11100010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 226
	                slv_reg226(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11100011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 227
	                slv_reg227(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11100100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 228
	                slv_reg228(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11100101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 229
	                slv_reg229(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11100110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 230
	                slv_reg230(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11100111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 231
	                slv_reg231(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11101000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 232
	                slv_reg232(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11101001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 233
	                slv_reg233(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11101010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 234
	                slv_reg234(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11101011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 235
	                slv_reg235(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11101100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 236
	                slv_reg236(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11101101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 237
	                slv_reg237(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11101110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 238
	                slv_reg238(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11101111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 239
	                slv_reg239(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"11110000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 240
	                slv_reg240(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when others =>
	            slv_reg0 <= slv_reg0;
	            slv_reg1 <= slv_reg1;
	            slv_reg2 <= slv_reg2;
	            slv_reg3 <= slv_reg3;
	            slv_reg4 <= slv_reg4;
	            slv_reg5 <= slv_reg5;
	            slv_reg6 <= slv_reg6;
	            slv_reg7 <= slv_reg7;
	            slv_reg8 <= slv_reg8;
	            slv_reg9 <= slv_reg9;
	            slv_reg10 <= slv_reg10;
	            slv_reg11 <= slv_reg11;
	            slv_reg12 <= slv_reg12;
	            slv_reg13 <= slv_reg13;
	            slv_reg14 <= slv_reg14;
	            slv_reg15 <= slv_reg15;
	            slv_reg16 <= slv_reg16;
	            slv_reg17 <= slv_reg17;
	            slv_reg18 <= slv_reg18;
	            slv_reg19 <= slv_reg19;
	            slv_reg20 <= slv_reg20;
	            slv_reg21 <= slv_reg21;
	            slv_reg22 <= slv_reg22;
	            slv_reg23 <= slv_reg23;
	            slv_reg24 <= slv_reg24;
	            slv_reg25 <= slv_reg25;
	            slv_reg26 <= slv_reg26;
	            slv_reg27 <= slv_reg27;
	            slv_reg28 <= slv_reg28;
	            slv_reg29 <= slv_reg29;
	            slv_reg30 <= slv_reg30;
	            slv_reg31 <= slv_reg31;
	            slv_reg32 <= slv_reg32;
	            slv_reg33 <= slv_reg33;
	            slv_reg34 <= slv_reg34;
	            slv_reg35 <= slv_reg35;
	            slv_reg36 <= slv_reg36;
	            slv_reg37 <= slv_reg37;
	            slv_reg38 <= slv_reg38;
	            slv_reg39 <= slv_reg39;
	            slv_reg40 <= slv_reg40;
	            slv_reg41 <= slv_reg41;
	            slv_reg42 <= slv_reg42;
	            slv_reg43 <= slv_reg43;
	            slv_reg44 <= slv_reg44;
	            slv_reg45 <= slv_reg45;
	            slv_reg46 <= slv_reg46;
	            slv_reg47 <= slv_reg47;
	            slv_reg48 <= slv_reg48;
	            slv_reg49 <= slv_reg49;
	            slv_reg50 <= slv_reg50;
	            slv_reg51 <= slv_reg51;
	            slv_reg52 <= slv_reg52;
	            slv_reg53 <= slv_reg53;
	            slv_reg54 <= slv_reg54;
	            slv_reg55 <= slv_reg55;
	            slv_reg56 <= slv_reg56;
	            slv_reg57 <= slv_reg57;
	            slv_reg58 <= slv_reg58;
	            slv_reg59 <= slv_reg59;
	            slv_reg60 <= slv_reg60;
	            slv_reg61 <= slv_reg61;
	            slv_reg62 <= slv_reg62;
	            slv_reg63 <= slv_reg63;
	            slv_reg64 <= slv_reg64;
	            slv_reg65 <= slv_reg65;
	            slv_reg66 <= slv_reg66;
	            slv_reg67 <= slv_reg67;
	            slv_reg68 <= slv_reg68;
	            slv_reg69 <= slv_reg69;
	            slv_reg70 <= slv_reg70;
	            slv_reg71 <= slv_reg71;
	            slv_reg72 <= slv_reg72;
	            slv_reg73 <= slv_reg73;
	            slv_reg74 <= slv_reg74;
	            slv_reg75 <= slv_reg75;
	            slv_reg76 <= slv_reg76;
	            slv_reg77 <= slv_reg77;
	            slv_reg78 <= slv_reg78;
	            slv_reg79 <= slv_reg79;
	            slv_reg80 <= slv_reg80;
	            slv_reg81 <= slv_reg81;
	            slv_reg82 <= slv_reg82;
	            slv_reg83 <= slv_reg83;
	            slv_reg84 <= slv_reg84;
	            slv_reg85 <= slv_reg85;
	            slv_reg86 <= slv_reg86;
	            slv_reg87 <= slv_reg87;
	            slv_reg88 <= slv_reg88;
	            slv_reg89 <= slv_reg89;
	            slv_reg90 <= slv_reg90;
	            slv_reg91 <= slv_reg91;
	            slv_reg92 <= slv_reg92;
	            slv_reg93 <= slv_reg93;
	            slv_reg94 <= slv_reg94;
	            slv_reg95 <= slv_reg95;
	            slv_reg96 <= slv_reg96;
	            slv_reg97 <= slv_reg97;
	            slv_reg98 <= slv_reg98;
	            slv_reg99 <= slv_reg99;
	            slv_reg100 <= slv_reg100;
	            slv_reg101 <= slv_reg101;
	            slv_reg102 <= slv_reg102;
	            slv_reg103 <= slv_reg103;
	            slv_reg104 <= slv_reg104;
	            slv_reg105 <= slv_reg105;
	            slv_reg106 <= slv_reg106;
	            slv_reg107 <= slv_reg107;
	            slv_reg108 <= slv_reg108;
	            slv_reg109 <= slv_reg109;
	            slv_reg110 <= slv_reg110;
	            slv_reg111 <= slv_reg111;
	            slv_reg112 <= slv_reg112;
	            slv_reg113 <= slv_reg113;
	            slv_reg114 <= slv_reg114;
	            slv_reg115 <= slv_reg115;
	            slv_reg116 <= slv_reg116;
	            slv_reg117 <= slv_reg117;
	            slv_reg118 <= slv_reg118;
	            slv_reg119 <= slv_reg119;
	            slv_reg120 <= slv_reg120;
	            slv_reg121 <= slv_reg121;
	            slv_reg122 <= slv_reg122;
	            slv_reg123 <= slv_reg123;
	            slv_reg124 <= slv_reg124;
	            slv_reg125 <= slv_reg125;
	            slv_reg126 <= slv_reg126;
	            slv_reg127 <= slv_reg127;
	            slv_reg128 <= slv_reg128;
	            slv_reg129 <= slv_reg129;
	            slv_reg130 <= slv_reg130;
	            slv_reg131 <= slv_reg131;
	            slv_reg132 <= slv_reg132;
	            slv_reg133 <= slv_reg133;
	            slv_reg134 <= slv_reg134;
	            slv_reg135 <= slv_reg135;
	            slv_reg136 <= slv_reg136;
	            slv_reg137 <= slv_reg137;
	            slv_reg138 <= slv_reg138;
	            slv_reg139 <= slv_reg139;
	            slv_reg140 <= slv_reg140;
	            slv_reg141 <= slv_reg141;
	            slv_reg142 <= slv_reg142;
	            slv_reg143 <= slv_reg143;
	            slv_reg144 <= slv_reg144;
	            slv_reg145 <= slv_reg145;
	            slv_reg146 <= slv_reg146;
	            slv_reg147 <= slv_reg147;
	            slv_reg148 <= slv_reg148;
	            slv_reg149 <= slv_reg149;
	            slv_reg150 <= slv_reg150;
	            slv_reg151 <= slv_reg151;
	            slv_reg152 <= slv_reg152;
	            slv_reg153 <= slv_reg153;
	            slv_reg154 <= slv_reg154;
	            slv_reg155 <= slv_reg155;
	            slv_reg156 <= slv_reg156;
	            slv_reg157 <= slv_reg157;
	            slv_reg158 <= slv_reg158;
	            slv_reg159 <= slv_reg159;
	            slv_reg160 <= slv_reg160;
	            slv_reg161 <= slv_reg161;
	            slv_reg162 <= slv_reg162;
	            slv_reg163 <= slv_reg163;
	            slv_reg164 <= slv_reg164;
	            slv_reg165 <= slv_reg165;
	            slv_reg166 <= slv_reg166;
	            slv_reg167 <= slv_reg167;
	            slv_reg168 <= slv_reg168;
	            slv_reg169 <= slv_reg169;
	            slv_reg170 <= slv_reg170;
	            slv_reg171 <= slv_reg171;
	            slv_reg172 <= slv_reg172;
	            slv_reg173 <= slv_reg173;
	            slv_reg174 <= slv_reg174;
	            slv_reg175 <= slv_reg175;
	            slv_reg176 <= slv_reg176;
	            slv_reg177 <= slv_reg177;
	            slv_reg178 <= slv_reg178;
	            slv_reg179 <= slv_reg179;
	            slv_reg180 <= slv_reg180;
	            slv_reg181 <= slv_reg181;
	            slv_reg182 <= slv_reg182;
	            slv_reg183 <= slv_reg183;
	            slv_reg184 <= slv_reg184;
	            slv_reg185 <= slv_reg185;
	            slv_reg186 <= slv_reg186;
	            slv_reg187 <= slv_reg187;
	            slv_reg188 <= slv_reg188;
	            slv_reg189 <= slv_reg189;
	            slv_reg190 <= slv_reg190;
	            slv_reg191 <= slv_reg191;
	            slv_reg192 <= slv_reg192;
	            slv_reg193 <= slv_reg193;
	            slv_reg194 <= slv_reg194;
	            slv_reg195 <= slv_reg195;
	            slv_reg196 <= slv_reg196;
	            slv_reg197 <= slv_reg197;
	            slv_reg198 <= slv_reg198;
	            slv_reg199 <= slv_reg199;
	            slv_reg200 <= slv_reg200;
	            slv_reg201 <= slv_reg201;
	            slv_reg202 <= slv_reg202;
	            slv_reg203 <= slv_reg203;
	            slv_reg204 <= slv_reg204;
	            slv_reg205 <= slv_reg205;
	            slv_reg206 <= slv_reg206;
	            slv_reg207 <= slv_reg207;
	            slv_reg208 <= slv_reg208;
	            slv_reg209 <= slv_reg209;
	            slv_reg210 <= slv_reg210;
	            slv_reg211 <= slv_reg211;
	            slv_reg212 <= slv_reg212;
	            slv_reg213 <= slv_reg213;
	            slv_reg214 <= slv_reg214;
	            slv_reg215 <= slv_reg215;
	            slv_reg216 <= slv_reg216;
	            slv_reg217 <= slv_reg217;
	            slv_reg218 <= slv_reg218;
	            slv_reg219 <= slv_reg219;
	            slv_reg220 <= slv_reg220;
	            slv_reg221 <= slv_reg221;
	            slv_reg222 <= slv_reg222;
	            slv_reg223 <= slv_reg223;
	            slv_reg224 <= slv_reg224;
	            slv_reg225 <= slv_reg225;
	            slv_reg226 <= slv_reg226;
	            slv_reg227 <= slv_reg227;
	            slv_reg228 <= slv_reg228;
	            slv_reg229 <= slv_reg229;
	            slv_reg230 <= slv_reg230;
	            slv_reg231 <= slv_reg231;
	            slv_reg232 <= slv_reg232;
	            slv_reg233 <= slv_reg233;
	            slv_reg234 <= slv_reg234;
	            slv_reg235 <= slv_reg235;
	            slv_reg236 <= slv_reg236;
	            slv_reg237 <= slv_reg237;
	            slv_reg238 <= slv_reg238;
	            slv_reg239 <= slv_reg239;
	            slv_reg240 <= slv_reg240;
	        end case;
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement write response logic generation
	-- The write response and response valid signals are asserted by the slave 
	-- when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	-- This marks the acceptance of address and indicates the status of 
	-- write transaction.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_bvalid  <= '0';
	      axi_bresp   <= "00"; --need to work more on the responses
	    else
	      if (axi_awready = '1' and S_AXI_AWVALID = '1' and axi_wready = '1' and S_AXI_WVALID = '1' and axi_bvalid = '0'  ) then
	        axi_bvalid <= '1';
	        axi_bresp  <= "00"; 
	      elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then   --check if bready is asserted while bvalid is high)
	        axi_bvalid <= '0';                                 -- (there is a possibility that bready is always asserted high)
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_arready generation
	-- axi_arready is asserted for one S_AXI_ACLK clock cycle when
	-- S_AXI_ARVALID is asserted. axi_awready is 
	-- de-asserted when reset (active low) is asserted. 
	-- The read address is also latched when S_AXI_ARVALID is 
	-- asserted. axi_araddr is reset to zero on reset assertion.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_arready <= '0';
	      axi_araddr  <= (others => '1');
	    else
	      if (axi_arready = '0' and S_AXI_ARVALID = '1') then
	        -- indicates that the slave has acceped the valid read address
	        axi_arready <= '1';
	        -- Read Address latching 
	        axi_araddr  <= S_AXI_ARADDR;           
	      else
	        axi_arready <= '0';
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_arvalid generation
	-- axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
	-- S_AXI_ARVALID and axi_arready are asserted. The slave registers 
	-- data are available on the axi_rdata bus at this instance. The 
	-- assertion of axi_rvalid marks the validity of read data on the 
	-- bus and axi_rresp indicates the status of read transaction.axi_rvalid 
	-- is deasserted on reset (active low). axi_rresp and axi_rdata are 
	-- cleared to zero on reset (active low).  
	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then
	    if S_AXI_ARESETN = '0' then
	      axi_rvalid <= '0';
	      axi_rresp  <= "00";
	    else
	      if (axi_arready = '1' and S_AXI_ARVALID = '1' and axi_rvalid = '0') then
	        -- Valid read data is available at the read data bus
	        axi_rvalid <= '1';
	        axi_rresp  <= "00"; -- 'OKAY' response
	      elsif (axi_rvalid = '1' and S_AXI_RREADY = '1') then
	        -- Read data is accepted by the master
	        axi_rvalid <= '0';
	      end if;            
	    end if;
	  end if;
	end process;

	-- Implement memory mapped register select and read logic generation
	-- Slave register read enable is asserted when valid address is available
	-- and the slave is ready to accept the read address.
	slv_reg_rden <= axi_arready and S_AXI_ARVALID and (not axi_rvalid) ;

	process (cout0, cout1, cout2, cout3, cout4, cout5, cout6, cout7, cout8, cout9, cout10, cout11, cout12, cout13, cout14, cout15, cout16, cout17, cout18, cout19, cout20, cout21, cout22, cout23, cout24, cout25, cout26, cout27, cout28, cout29, cout30, cout31, cout32, cout33, cout34, cout35, cout36, cout37, cout38, cout39, cout40, cout41, cout42, cout43, cout44, cout45, cout46, cout47, cout48, cout49, cout50, cout51, cout52, cout53, cout54, cout55, cout56, cout57, cout58, cout59, cout60, cout61, cout62, cout63, cout64, cout65, cout66, cout67, cout68, cout69, cout70, cout71, cout72, cout73, cout74, cout75, cout76, cout77, cout78, cout79, cout80, cout81, cout82, cout83, cout84, cout85, cout86, cout87, cout88, cout89, cout90, cout91, cout92, cout93, cout94, cout95, cout96, cout97, cout98, cout99, cout100, cout101, cout102, cout103, cout104, cout105, cout106, cout107, cout108, cout109, cout110, cout111, cout112, cout113, cout114, cout115, cout116, cout117, cout118, cout119, cout120, cout121, cout122, cout123, cout124, cout125, cout126, cout127, cout128, cout129, cout130, cout131, cout132, cout133, cout134, cout135, cout136, cout137, cout138, cout139, cout140, cout141, cout142, cout143, cout144, cout145, cout146, cout147, cout148, cout149, cout150, cout151, cout152, cout153, cout154, cout155, cout156, cout157, cout158, cout159, cout160, cout161, cout162, cout163, cout164, cout165, cout166, cout167, cout168, cout169, cout170, cout171, cout172, cout173, cout174, cout175, cout176, cout177, cout178, cout179, cout180, cout181, cout182, cout183, cout184, cout185, cout186, cout187, cout188, cout189, cout190, cout191, cout192, cout193, cout194, cout195, cout196, cout197, cout198, cout199, cout200, cout201, cout202, cout203, cout204, cout205, cout206, cout207, cout208, cout209, cout210, cout211, cout212, cout213, cout214, cout215, cout216, cout217, cout218, cout219, cout220, cout221, cout222, cout223, cout224, cout225, cout226, cout227, cout228, cout229, cout230, cout231, cout232, slv_reg233, slv_reg234, slv_reg235, slv_reg236, slv_reg237, slv_reg238, slv_reg239, slv_reg240, axi_araddr, S_AXI_ARESETN, slv_reg_rden)
	variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0);
	begin
	    -- Address decoding for reading registers
	    loc_addr := axi_araddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
	    case loc_addr is
	      when b"00000000" =>
          reg_data_out <= cout0;
          when b"00000001" =>
          reg_data_out <= cout1;
          when b"00000010" =>
          reg_data_out <= cout2;
          when b"00000011" =>
          reg_data_out <= cout3;
          when b"00000100" =>
          reg_data_out <= cout4;
          when b"00000101" =>
          reg_data_out <= cout5;
          when b"00000110" =>
          reg_data_out <= cout6;
          when b"00000111" =>
          reg_data_out <= cout7;
          when b"00001000" =>
          reg_data_out <= cout8;
          when b"00001001" =>
          reg_data_out <= cout9;
          when b"00001010" =>
          reg_data_out <= cout10;
          when b"00001011" =>
          reg_data_out <= cout11;
          when b"00001100" =>
          reg_data_out <= cout12;
          when b"00001101" =>
          reg_data_out <= cout13;
          when b"00001110" =>
          reg_data_out <= cout14;
          when b"00001111" =>
          reg_data_out <= cout15;
          when b"00010000" =>
          reg_data_out <= cout16;
          when b"00010001" =>
          reg_data_out <= cout17;
          when b"00010010" =>
          reg_data_out <= cout18;
          when b"00010011" =>
          reg_data_out <= cout19;
          when b"00010100" =>
          reg_data_out <= cout20;
          when b"00010101" =>
          reg_data_out <= cout21;
          when b"00010110" =>
          reg_data_out <= cout22;
          when b"00010111" =>
          reg_data_out <= cout23;
          when b"00011000" =>
          reg_data_out <= cout24;
          when b"00011001" =>
          reg_data_out <= cout25;
          when b"00011010" =>
          reg_data_out <= cout26;
          when b"00011011" =>
          reg_data_out <= cout27;
          when b"00011100" =>
          reg_data_out <= cout28;
          when b"00011101" =>
          reg_data_out <= cout29;
          when b"00011110" =>
          reg_data_out <= cout30;
          when b"00011111" =>
          reg_data_out <= cout31;
          when b"00100000" =>
          reg_data_out <= cout32;
          when b"00100001" =>
          reg_data_out <= cout33;
          when b"00100010" =>
          reg_data_out <= cout34;
          when b"00100011" =>
          reg_data_out <= cout35;
          when b"00100100" =>
          reg_data_out <= cout36;
          when b"00100101" =>
          reg_data_out <= cout37;
          when b"00100110" =>
          reg_data_out <= cout38;
          when b"00100111" =>
          reg_data_out <= cout39;
          when b"00101000" =>
          reg_data_out <= cout40;
          when b"00101001" =>
          reg_data_out <= cout41;
          when b"00101010" =>
          reg_data_out <= cout42;
          when b"00101011" =>
          reg_data_out <= cout43;
          when b"00101100" =>
          reg_data_out <= cout44;
          when b"00101101" =>
          reg_data_out <= cout45;
          when b"00101110" =>
          reg_data_out <= cout46;
          when b"00101111" =>
          reg_data_out <= cout47;
          when b"00110000" =>
          reg_data_out <= cout48;
          when b"00110001" =>
          reg_data_out <= cout49;
          when b"00110010" =>
          reg_data_out <= cout50;
          when b"00110011" =>
          reg_data_out <= cout51;
          when b"00110100" =>
          reg_data_out <= cout52;
          when b"00110101" =>
          reg_data_out <= cout53;
          when b"00110110" =>
          reg_data_out <= cout54;
          when b"00110111" =>
          reg_data_out <= cout55;
          when b"00111000" =>
          reg_data_out <= cout56;
          when b"00111001" =>
          reg_data_out <= cout57;
          when b"00111010" =>
          reg_data_out <= cout58;
          when b"00111011" =>
          reg_data_out <= cout59;
          when b"00111100" =>
          reg_data_out <= cout60;
          when b"00111101" =>
          reg_data_out <= cout61;
          when b"00111110" =>
          reg_data_out <= cout62;
          when b"00111111" =>
          reg_data_out <= cout63;
          when b"01000000" =>
          reg_data_out <= cout64;
          when b"01000001" =>
          reg_data_out <= cout65;
          when b"01000010" =>
          reg_data_out <= cout66;
          when b"01000011" =>
          reg_data_out <= cout67;
          when b"01000100" =>
          reg_data_out <= cout68;
          when b"01000101" =>
          reg_data_out <= cout69;
          when b"01000110" =>
          reg_data_out <= cout70;
          when b"01000111" =>
          reg_data_out <= cout71;
          when b"01001000" =>
          reg_data_out <= cout72;
          when b"01001001" =>
          reg_data_out <= cout73;
          when b"01001010" =>
          reg_data_out <= cout74;
          when b"01001011" =>
          reg_data_out <= cout75;
          when b"01001100" =>
          reg_data_out <= cout76;
          when b"01001101" =>
          reg_data_out <= cout77;
          when b"01001110" =>
          reg_data_out <= cout78;
          when b"01001111" =>
          reg_data_out <= cout79;
          when b"01010000" =>
          reg_data_out <= cout80;
          when b"01010001" =>
          reg_data_out <= cout81;
          when b"01010010" =>
          reg_data_out <= cout82;
          when b"01010011" =>
          reg_data_out <= cout83;
          when b"01010100" =>
          reg_data_out <= cout84;
          when b"01010101" =>
          reg_data_out <= cout85;
          when b"01010110" =>
          reg_data_out <= cout86;
          when b"01010111" =>
          reg_data_out <= cout87;
          when b"01011000" =>
          reg_data_out <= cout88;
          when b"01011001" =>
          reg_data_out <= cout89;
          when b"01011010" =>
          reg_data_out <= cout90;
          when b"01011011" =>
          reg_data_out <= cout91;
          when b"01011100" =>
          reg_data_out <= cout92;
          when b"01011101" =>
          reg_data_out <= cout93;
          when b"01011110" =>
          reg_data_out <= cout94;
          when b"01011111" =>
          reg_data_out <= cout95;
          when b"01100000" =>
          reg_data_out <= cout96;
          when b"01100001" =>
          reg_data_out <= cout97;
          when b"01100010" =>
          reg_data_out <= cout98;
          when b"01100011" =>
          reg_data_out <= cout99;
          when b"01100100" =>
          reg_data_out <= cout100;
          when b"01100101" =>
          reg_data_out <= cout101;
          when b"01100110" =>
          reg_data_out <= cout102;
          when b"01100111" =>
          reg_data_out <= cout103;
          when b"01101000" =>
          reg_data_out <= cout104;
          when b"01101001" =>
          reg_data_out <= cout105;
          when b"01101010" =>
          reg_data_out <= cout106;
          when b"01101011" =>
          reg_data_out <= cout107;
          when b"01101100" =>
          reg_data_out <= cout108;
          when b"01101101" =>
          reg_data_out <= cout109;
          when b"01101110" =>
          reg_data_out <= cout110;
          when b"01101111" =>
          reg_data_out <= cout111;
          when b"01110000" =>
          reg_data_out <= cout112;
          when b"01110001" =>
          reg_data_out <= cout113;
          when b"01110010" =>
          reg_data_out <= cout114;
          when b"01110011" =>
          reg_data_out <= cout115;
          when b"01110100" =>
          reg_data_out <= cout116;
          when b"01110101" =>
          reg_data_out <= cout117;
          when b"01110110" =>
          reg_data_out <= cout118;
          when b"01110111" =>
          reg_data_out <= cout119;
          when b"01111000" =>
          reg_data_out <= cout120;
          when b"01111001" =>
          reg_data_out <= cout121;
          when b"01111010" =>
          reg_data_out <= cout122;
          when b"01111011" =>
          reg_data_out <= cout123;
          when b"01111100" =>
          reg_data_out <= cout124;
          when b"01111101" =>
          reg_data_out <= cout125;
          when b"01111110" =>
          reg_data_out <= cout126;
          when b"01111111" =>
          reg_data_out <= cout127;
          when b"10000000" =>
          reg_data_out <= cout128;
          when b"10000001" =>
          reg_data_out <= cout129;
          when b"10000010" =>
          reg_data_out <= cout130;
          when b"10000011" =>
          reg_data_out <= cout131;
          when b"10000100" =>
          reg_data_out <= cout132;
          when b"10000101" =>
          reg_data_out <= cout133;
          when b"10000110" =>
          reg_data_out <= cout134;
          when b"10000111" =>
          reg_data_out <= cout135;
          when b"10001000" =>
          reg_data_out <= cout136;
          when b"10001001" =>
          reg_data_out <= cout137;
          when b"10001010" =>
          reg_data_out <= cout138;
          when b"10001011" =>
          reg_data_out <= cout139;
          when b"10001100" =>
          reg_data_out <= cout140;
          when b"10001101" =>
          reg_data_out <= cout141;
          when b"10001110" =>
          reg_data_out <= cout142;
          when b"10001111" =>
          reg_data_out <= cout143;
          when b"10010000" =>
          reg_data_out <= cout144;
          when b"10010001" =>
          reg_data_out <= cout145;
          when b"10010010" =>
          reg_data_out <= cout146;
          when b"10010011" =>
          reg_data_out <= cout147;
          when b"10010100" =>
          reg_data_out <= cout148;
          when b"10010101" =>
          reg_data_out <= cout149;
          when b"10010110" =>
          reg_data_out <= cout150;
          when b"10010111" =>
          reg_data_out <= cout151;
          when b"10011000" =>
          reg_data_out <= cout152;
          when b"10011001" =>
          reg_data_out <= cout153;
          when b"10011010" =>
          reg_data_out <= cout154;
          when b"10011011" =>
          reg_data_out <= cout155;
          when b"10011100" =>
          reg_data_out <= cout156;
          when b"10011101" =>
          reg_data_out <= cout157;
          when b"10011110" =>
          reg_data_out <= cout158;
          when b"10011111" =>
          reg_data_out <= cout159;
          when b"10100000" =>
          reg_data_out <= cout160;
          when b"10100001" =>
          reg_data_out <= cout161;
          when b"10100010" =>
          reg_data_out <= cout162;
          when b"10100011" =>
          reg_data_out <= cout163;
          when b"10100100" =>
          reg_data_out <= cout164;
          when b"10100101" =>
          reg_data_out <= cout165;
          when b"10100110" =>
          reg_data_out <= cout166;
          when b"10100111" =>
          reg_data_out <= cout167;
          when b"10101000" =>
          reg_data_out <= cout168;
          when b"10101001" =>
          reg_data_out <= cout169;
          when b"10101010" =>
          reg_data_out <= cout170;
          when b"10101011" =>
          reg_data_out <= cout171;
          when b"10101100" =>
          reg_data_out <= cout172;
          when b"10101101" =>
          reg_data_out <= cout173;
          when b"10101110" =>
          reg_data_out <= cout174;
          when b"10101111" =>
          reg_data_out <= cout175;
          when b"10110000" =>
          reg_data_out <= cout176;
          when b"10110001" =>
          reg_data_out <= cout177;
          when b"10110010" =>
          reg_data_out <= cout178;
          when b"10110011" =>
          reg_data_out <= cout179;
          when b"10110100" =>
          reg_data_out <= cout180;
          when b"10110101" =>
          reg_data_out <= cout181;
          when b"10110110" =>
          reg_data_out <= cout182;
          when b"10110111" =>
          reg_data_out <= cout183;
          when b"10111000" =>
          reg_data_out <= cout184;
          when b"10111001" =>
          reg_data_out <= cout185;
          when b"10111010" =>
          reg_data_out <= cout186;
          when b"10111011" =>
          reg_data_out <= cout187;
          when b"10111100" =>
          reg_data_out <= cout188;
          when b"10111101" =>
          reg_data_out <= cout189;
          when b"10111110" =>
          reg_data_out <= cout190;
          when b"10111111" =>
          reg_data_out <= cout191;
          when b"11000000" =>
          reg_data_out <= cout192;
          when b"11000001" =>
          reg_data_out <= cout193;
          when b"11000010" =>
          reg_data_out <= cout194;
          when b"11000011" =>
          reg_data_out <= cout195;
          when b"11000100" =>
          reg_data_out <= cout196;
          when b"11000101" =>
          reg_data_out <= cout197;
          when b"11000110" =>
          reg_data_out <= cout198;
          when b"11000111" =>
          reg_data_out <= cout199;
          when b"11001000" =>
          reg_data_out <= cout200;
          when b"11001001" =>
          reg_data_out <= cout201;
          when b"11001010" =>
          reg_data_out <= cout202;
          when b"11001011" =>
          reg_data_out <= cout203;
          when b"11001100" =>
          reg_data_out <= cout204;
          when b"11001101" =>
          reg_data_out <= cout205;
          when b"11001110" =>
          reg_data_out <= cout206;
          when b"11001111" =>
          reg_data_out <= cout207;
          when b"11010000" =>
          reg_data_out <= cout208;
          when b"11010001" =>
          reg_data_out <= cout209;
          when b"11010010" =>
          reg_data_out <= cout210;
          when b"11010011" =>
          reg_data_out <= cout211;
          when b"11010100" =>
          reg_data_out <= cout212;
          when b"11010101" =>
          reg_data_out <= cout213;
          when b"11010110" =>
          reg_data_out <= cout214;
          when b"11010111" =>
          reg_data_out <= cout215;
          when b"11011000" =>
          reg_data_out <= cout216;
          when b"11011001" =>
          reg_data_out <= cout217;
          when b"11011010" =>
          reg_data_out <= cout218;
          when b"11011011" =>
          reg_data_out <= cout219;
          when b"11011100" =>
          reg_data_out <= cout220;
          when b"11011101" =>
          reg_data_out <= cout221;
          when b"11011110" =>
          reg_data_out <= cout222;
          when b"11011111" =>
          reg_data_out <= cout223;
          when b"11100000" =>
          reg_data_out <= cout224;
          when b"11100001" =>
          reg_data_out <= cout225;
          when b"11100010" =>
          reg_data_out <= cout226;
          when b"11100011" =>
          reg_data_out <= cout227;
          when b"11100100" =>
          reg_data_out <= cout228;
          when b"11100101" =>
          reg_data_out <= cout229;
          when b"11100110" =>
          reg_data_out <= cout230;
          when b"11100111" =>
          reg_data_out <= cout231;
          when b"11101000" =>
          reg_data_out <= cout232;
	      when b"11101001" =>
	        reg_data_out <= slv_reg233;
	      when b"11101010" =>
	        reg_data_out <= slv_reg234;
	      when b"11101011" =>
	        reg_data_out <= slv_reg235;
	      when b"11101100" =>
	        reg_data_out <= slv_reg236;
	      when b"11101101" =>
	        reg_data_out <= slv_reg237;
	      when b"11101110" =>
	        reg_data_out <= slv_reg238;
	      when b"11101111" =>
	        reg_data_out <= slv_reg239;
	      when b"11110000" =>
	        reg_data_out <= slv_reg240;
	      when others =>
	        reg_data_out  <= (others => '0');
	    end case;
	end process; 

	-- Output register or memory read data
	process( S_AXI_ACLK ) is
	begin
	  if (rising_edge (S_AXI_ACLK)) then
	    if ( S_AXI_ARESETN = '0' ) then
	      axi_rdata  <= (others => '0');
	    else
	      if (slv_reg_rden = '1') then
	        -- When there is a valid read address (S_AXI_ARVALID) with 
	        -- acceptance of read address by the slave (axi_arready), 
	        -- output the read dada 
	        -- Read address mux
	          axi_rdata <= reg_data_out;     -- register read data
	      end if;   
	    end if;
	  end if;
	end process;


	-- Add user logic here

	    moving_average_filters_ist:moving_average_filters 
    Port map ( 
        clk => S_AXI_ACLK,
        rst => rst_not,--Segnale sopra definito. 
        en => slv_reg240(0),
        enable_in => slv_reg240(0), 
        --Collego gli ingressi della mia IP agli slv_reg.                          
        c_in0 => slv_reg0,
        c_in1 => slv_reg1,
        c_in2 => slv_reg2,
        c_in3 => slv_reg3,
        c_in4 => slv_reg4,
        c_in5 => slv_reg5,
        c_in6 => slv_reg6,
        c_in7 => slv_reg7,
        c_in8 => slv_reg8,
        c_in9 => slv_reg9,
        c_in10 => slv_reg10,
        c_in11 => slv_reg11,
        c_in12 => slv_reg12,
        c_in13 => slv_reg13,
        c_in14 => slv_reg14,
        c_in15 => slv_reg15,
        c_in16 => slv_reg16,
        c_in17 => slv_reg17,
        c_in18 => slv_reg18,
        c_in19 => slv_reg19,
        c_in20 => slv_reg20,
        c_in21 => slv_reg21,
        c_in22 => slv_reg22,
        c_in23 => slv_reg23,
        c_in24 => slv_reg24,
        c_in25 => slv_reg25,
        c_in26 => slv_reg26,
        c_in27 => slv_reg27,
        c_in28 => slv_reg28,
        c_in29 => slv_reg29,
        c_in30 => slv_reg30,
        c_in31 => slv_reg31,
        c_in32 => slv_reg32,
        c_in33 => slv_reg33,
        c_in34 => slv_reg34,
        c_in35 => slv_reg35,
        c_in36 => slv_reg36,
        c_in37 => slv_reg37,
        c_in38 => slv_reg38,
        c_in39 => slv_reg39,
        c_in40 => slv_reg40,
        c_in41 => slv_reg41,
        c_in42 => slv_reg42,
        c_in43 => slv_reg43,
        c_in44 => slv_reg44,
        c_in45 => slv_reg45,
        c_in46 => slv_reg46,
        c_in47 => slv_reg47,
        c_in48 => slv_reg48,
        c_in49 => slv_reg49,
        c_in50 => slv_reg50,
        c_in51 => slv_reg51,
        c_in52 => slv_reg52,
        c_in53 => slv_reg53,
        c_in54 => slv_reg54,
        c_in55 => slv_reg55,
        c_in56 => slv_reg56,
        c_in57 => slv_reg57,
        c_in58 => slv_reg58,
        c_in59 => slv_reg59,
        c_in60 => slv_reg60,
        c_in61 => slv_reg61,
        c_in62 => slv_reg62,
        c_in63 => slv_reg63,
        c_in64 => slv_reg64,
        c_in65 => slv_reg65,
        c_in66 => slv_reg66,
        c_in67 => slv_reg67,
        c_in68 => slv_reg68,
        c_in69 => slv_reg69,
        c_in70 => slv_reg70,
        c_in71 => slv_reg71,
        c_in72 => slv_reg72,
        c_in73 => slv_reg73,
        c_in74 => slv_reg74,
        c_in75 => slv_reg75,
        c_in76 => slv_reg76,
        c_in77 => slv_reg77,
        c_in78 => slv_reg78,
        c_in79 => slv_reg79,
        c_in80 => slv_reg80,
        c_in81 => slv_reg81,
        c_in82 => slv_reg82,
        c_in83 => slv_reg83,
        c_in84 => slv_reg84,
        c_in85 => slv_reg85,
        c_in86 => slv_reg86,
        c_in87 => slv_reg87,
        c_in88 => slv_reg88,
        c_in89 => slv_reg89,
        c_in90 => slv_reg90,
        c_in91 => slv_reg91,
        c_in92 => slv_reg92,
        c_in93 => slv_reg93,
        c_in94 => slv_reg94,
        c_in95 => slv_reg95,
        c_in96 => slv_reg96,
        c_in97 => slv_reg97,
        c_in98 => slv_reg98,
        c_in99 => slv_reg99,
        c_in100 => slv_reg100,
        c_in101 => slv_reg101,
        c_in102 => slv_reg102,
        c_in103 => slv_reg103,
        c_in104 => slv_reg104,
        c_in105 => slv_reg105,
        c_in106 => slv_reg106,
        c_in107 => slv_reg107,
        c_in108 => slv_reg108,
        c_in109 => slv_reg109,
        c_in110 => slv_reg110,
        c_in111 => slv_reg111,
        c_in112 => slv_reg112,
        c_in113 => slv_reg113,
        c_in114 => slv_reg114,
        c_in115 => slv_reg115,
        c_in116 => slv_reg116,
        c_in117 => slv_reg117,
        c_in118 => slv_reg118,
        c_in119 => slv_reg119,
        c_in120 => slv_reg120,
        c_in121 => slv_reg121,
        c_in122 => slv_reg122,
        c_in123 => slv_reg123,
        c_in124 => slv_reg124,
        c_in125 => slv_reg125,
        c_in126 => slv_reg126,
        c_in127 => slv_reg127,
        c_in128 => slv_reg128,
        c_in129 => slv_reg129,
        c_in130 => slv_reg130,
        c_in131 => slv_reg131,
        c_in132 => slv_reg132,
        c_in133 => slv_reg133,
        c_in134 => slv_reg134,
        c_in135 => slv_reg135,
        c_in136 => slv_reg136,
        c_in137 => slv_reg137,
        c_in138 => slv_reg138,
        c_in139 => slv_reg139,
        c_in140 => slv_reg140,
        c_in141 => slv_reg141,
        c_in142 => slv_reg142,
        c_in143 => slv_reg143,
        c_in144 => slv_reg144,
        c_in145 => slv_reg145,
        c_in146 => slv_reg146,
        c_in147 => slv_reg147,
        c_in148 => slv_reg148,
        c_in149 => slv_reg149,
        c_in150 => slv_reg150,
        c_in151 => slv_reg151,
        c_in152 => slv_reg152,
        c_in153 => slv_reg153,
        c_in154 => slv_reg154,
        c_in155 => slv_reg155,
        c_in156 => slv_reg156,
        c_in157 => slv_reg157,
        c_in158 => slv_reg158,
        c_in159 => slv_reg159,
        c_in160 => slv_reg160,
        c_in161 => slv_reg161,
        c_in162 => slv_reg162,
        c_in163 => slv_reg163,
        c_in164 => slv_reg164,
        c_in165 => slv_reg165,
        c_in166 => slv_reg166,
        c_in167 => slv_reg167,
        c_in168 => slv_reg168,
        c_in169 => slv_reg169,
        c_in170 => slv_reg170,
        c_in171 => slv_reg171,
        c_in172 => slv_reg172,
        c_in173 => slv_reg173,
        c_in174 => slv_reg174,
        c_in175 => slv_reg175,
        c_in176 => slv_reg176,
        c_in177 => slv_reg177,
        c_in178 => slv_reg178,
        c_in179 => slv_reg179,
        c_in180 => slv_reg180,
        c_in181 => slv_reg181,
        c_in182 => slv_reg182,
        c_in183 => slv_reg183,
        c_in184 => slv_reg184,
        c_in185 => slv_reg185,
        c_in186 => slv_reg186,
        c_in187 => slv_reg187,
        c_in188 => slv_reg188,
        c_in189 => slv_reg189,
        c_in190 => slv_reg190,
        c_in191 => slv_reg191,
        c_in192 => slv_reg192,
        c_in193 => slv_reg193,
        c_in194 => slv_reg194,
        c_in195 => slv_reg195,
        c_in196 => slv_reg196,
        c_in197 => slv_reg197,
        c_in198 => slv_reg198,
        c_in199 => slv_reg199,
        c_in200 => slv_reg200,
        c_in201 => slv_reg201,
        c_in202 => slv_reg202,
        c_in203 => slv_reg203,
        c_in204 => slv_reg204,
        c_in205 => slv_reg205,
        c_in206 => slv_reg206,
        c_in207 => slv_reg207,
        c_in208 => slv_reg208,
        c_in209 => slv_reg209,
        c_in210 => slv_reg210,
        c_in211 => slv_reg211,
        c_in212 => slv_reg212,
        c_in213 => slv_reg213,
        c_in214 => slv_reg214,
        c_in215 => slv_reg215,
        c_in216 => slv_reg216,
        c_in217 => slv_reg217,
        c_in218 => slv_reg218,
        c_in219 => slv_reg219,
        c_in220 => slv_reg220,
        c_in221 => slv_reg221,
        c_in222 => slv_reg222,
        c_in223 => slv_reg223,
        c_in224 => slv_reg224,
        c_in225 => slv_reg225,
        c_in226 => slv_reg226,
        c_in227 => slv_reg227,
        c_in228 => slv_reg228,
        c_in229 => slv_reg229,
        c_in230 => slv_reg230,
        c_in231 => slv_reg231,
        c_in232 => slv_reg232,
        c_in233 => slv_reg233,
        c_in234 => slv_reg234,
        c_in235 => slv_reg235,
        c_in236 => slv_reg236,
        c_in237 => slv_reg237,
        c_in238 => slv_reg238,
        c_in239 => slv_reg239,                 
        interrupt => interrupt,
        counter => counter,
        Y0_bit => Y0_bit,
        Yi_bit => Yi_bit,
        --Collego le uscite della mia IP a dei segnali d'uscita creati apposta. 
        c_out0 => cout0,
        c_out1 => cout1,
        c_out2 => cout2,
        c_out3 => cout3,
        c_out4 => cout4,
        c_out5 => cout5,
        c_out6 => cout6,
        c_out7 => cout7,
        c_out8 => cout8,
        c_out9 => cout9,
        c_out10 => cout10,
        c_out11 => cout11,
        c_out12 => cout12,
        c_out13 => cout13,
        c_out14 => cout14,
        c_out15 => cout15,
        c_out16 => cout16,
        c_out17 => cout17,
        c_out18 => cout18,
        c_out19 => cout19,
        c_out20 => cout20,
        c_out21 => cout21,
        c_out22 => cout22,
        c_out23 => cout23,
        c_out24 => cout24,
        c_out25 => cout25,
        c_out26 => cout26,
        c_out27 => cout27,
        c_out28 => cout28,
        c_out29 => cout29,
        c_out30 => cout30,
        c_out31 => cout31,
        c_out32 => cout32,
        c_out33 => cout33,
        c_out34 => cout34,
        c_out35 => cout35,
        c_out36 => cout36,
        c_out37 => cout37,
        c_out38 => cout38,
        c_out39 => cout39,
        c_out40 => cout40,
        c_out41 => cout41,
        c_out42 => cout42,
        c_out43 => cout43,
        c_out44 => cout44,
        c_out45 => cout45,
        c_out46 => cout46,
        c_out47 => cout47,
        c_out48 => cout48,
        c_out49 => cout49,
        c_out50 => cout50,
        c_out51 => cout51,
        c_out52 => cout52,
        c_out53 => cout53,
        c_out54 => cout54,
        c_out55 => cout55,
        c_out56 => cout56,
        c_out57 => cout57,
        c_out58 => cout58,
        c_out59 => cout59,
        c_out60 => cout60,
        c_out61 => cout61,
        c_out62 => cout62,
        c_out63 => cout63,
        c_out64 => cout64,
        c_out65 => cout65,
        c_out66 => cout66,
        c_out67 => cout67,
        c_out68 => cout68,
        c_out69 => cout69,
        c_out70 => cout70,
        c_out71 => cout71,
        c_out72 => cout72,
        c_out73 => cout73,
        c_out74 => cout74,
        c_out75 => cout75,
        c_out76 => cout76,
        c_out77 => cout77,
        c_out78 => cout78,
        c_out79 => cout79,
        c_out80 => cout80,
        c_out81 => cout81,
        c_out82 => cout82,
        c_out83 => cout83,
        c_out84 => cout84,
        c_out85 => cout85,
        c_out86 => cout86,
        c_out87 => cout87,
        c_out88 => cout88,
        c_out89 => cout89,
        c_out90 => cout90,
        c_out91 => cout91,
        c_out92 => cout92,
        c_out93 => cout93,
        c_out94 => cout94,
        c_out95 => cout95,
        c_out96 => cout96,
        c_out97 => cout97,
        c_out98 => cout98,
        c_out99 => cout99,
        c_out100 => cout100,
        c_out101 => cout101,
        c_out102 => cout102,
        c_out103 => cout103,
        c_out104 => cout104,
        c_out105 => cout105,
        c_out106 => cout106,
        c_out107 => cout107,
        c_out108 => cout108,
        c_out109 => cout109,
        c_out110 => cout110,
        c_out111 => cout111,
        c_out112 => cout112,
        c_out113 => cout113,
        c_out114 => cout114,
        c_out115 => cout115,
        c_out116 => cout116,
        c_out117 => cout117,
        c_out118 => cout118,
        c_out119 => cout119,
        c_out120 => cout120,
        c_out121 => cout121,
        c_out122 => cout122,
        c_out123 => cout123,
        c_out124 => cout124,
        c_out125 => cout125,
        c_out126 => cout126,
        c_out127 => cout127,
        c_out128 => cout128,
        c_out129 => cout129,
        c_out130 => cout130,
        c_out131 => cout131,
        c_out132 => cout132,
        c_out133 => cout133,
        c_out134 => cout134,
        c_out135 => cout135,
        c_out136 => cout136,
        c_out137 => cout137,
        c_out138 => cout138,
        c_out139 => cout139,
        c_out140 => cout140,
        c_out141 => cout141,
        c_out142 => cout142,
        c_out143 => cout143,
        c_out144 => cout144,
        c_out145 => cout145,
        c_out146 => cout146,
        c_out147 => cout147,
        c_out148 => cout148,
        c_out149 => cout149,
        c_out150 => cout150,
        c_out151 => cout151,
        c_out152 => cout152,
        c_out153 => cout153,
        c_out154 => cout154,
        c_out155 => cout155,
        c_out156 => cout156,
        c_out157 => cout157,
        c_out158 => cout158,
        c_out159 => cout159,
        c_out160 => cout160,
        c_out161 => cout161,
        c_out162 => cout162,
        c_out163 => cout163,
        c_out164 => cout164,
        c_out165 => cout165,
        c_out166 => cout166,
        c_out167 => cout167,
        c_out168 => cout168,
        c_out169 => cout169,
        c_out170 => cout170,
        c_out171 => cout171,
        c_out172 => cout172,
        c_out173 => cout173,
        c_out174 => cout174,
        c_out175 => cout175,
        c_out176 => cout176,
        c_out177 => cout177,
        c_out178 => cout178,
        c_out179 => cout179,
        c_out180 => cout180,
        c_out181 => cout181,
        c_out182 => cout182,
        c_out183 => cout183,
        c_out184 => cout184,
        c_out185 => cout185,
        c_out186 => cout186,
        c_out187 => cout187,
        c_out188 => cout188,
        c_out189 => cout189,
        c_out190 => cout190,
        c_out191 => cout191,
        c_out192 => cout192,
        c_out193 => cout193,
        c_out194 => cout194,
        c_out195 => cout195,
        c_out196 => cout196,
        c_out197 => cout197,
        c_out198 => cout198,
        c_out199 => cout199,
        c_out200 => cout200,
        c_out201 => cout201,
        c_out202 => cout202,
        c_out203 => cout203,
        c_out204 => cout204,
        c_out205 => cout205,
        c_out206 => cout206,
        c_out207 => cout207,
        c_out208 => cout208,
        c_out209 => cout209,
        c_out210 => cout210,
        c_out211 => cout211,
        c_out212 => cout212,
        c_out213 => cout213,
        c_out214 => cout214,
        c_out215 => cout215,
        c_out216 => cout216,
        c_out217 => cout217,
        c_out218 => cout218,
        c_out219 => cout219,
        c_out220 => cout220,
        c_out221 => cout221,
        c_out222 => cout222,
        c_out223 => cout223,
        c_out224 => cout224,
        c_out225 => cout225,
        c_out226 => cout226,
        c_out227 => cout227,
        c_out228 => cout228,
        c_out229 => cout229,
        c_out230 => cout230,
        c_out231 => cout231,
        c_out232 => cout232 
    );
	-- User logic ends
    rst_not <= not(S_AXI_ARESETN);

end arch_imp;
