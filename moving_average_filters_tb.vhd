----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.10.2023 14:36:07
-- Design Name: 
-- Module Name: moving_average_filters_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
USE std.textio.all;
use IEEE.std_logic_textio.all;

entity moving_average_filters_tb is
--  Port ( );
end moving_average_filters_tb;

architecture Behavioral of moving_average_filters_tb is

    component moving_average_filters is
        Port ( 
            clk,rst,en:in std_logic;
            enable_in:in std_logic;--Questo enable mi serve a dire che sono prono a caricare i dati in parallelo dagli slv_reg.              
            

            
            --Vettori a 32 bit d'ingresso.
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
            --I tre segnali sottostanti li utilizziamo per il debug nell'ILA. 
            counter:out std_logic_vector(7 downto 0);
            Y0_bit:out std_logic_vector(31 downto 0);
            Yi_bit:out std_logic_vector(31 downto 0);

            --Vettori a 32 bit d'uscita.
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
    
    signal clk,rst,en:std_logic;
    signal enable_in:std_logic;
    
    signal c_in:integer_vector(239 downto 0);
    signal c_in0:std_logic_vector(31 downto 0);
    signal c_in1:std_logic_vector(31 downto 0);
    signal c_in2:std_logic_vector(31 downto 0);
    signal c_in3:std_logic_vector(31 downto 0);
    signal c_in4:std_logic_vector(31 downto 0);
    signal c_in5:std_logic_vector(31 downto 0);
    signal c_in6:std_logic_vector(31 downto 0);
    signal c_in7:std_logic_vector(31 downto 0);
    signal c_in8:std_logic_vector(31 downto 0);
    signal c_in9:std_logic_vector(31 downto 0);
    signal c_in10:std_logic_vector(31 downto 0);
    signal c_in11:std_logic_vector(31 downto 0);
    signal c_in12:std_logic_vector(31 downto 0);
    signal c_in13:std_logic_vector(31 downto 0);
    signal c_in14:std_logic_vector(31 downto 0);
    signal c_in15:std_logic_vector(31 downto 0);
    signal c_in16:std_logic_vector(31 downto 0);
    signal c_in17:std_logic_vector(31 downto 0);
    signal c_in18:std_logic_vector(31 downto 0);
    signal c_in19:std_logic_vector(31 downto 0);
    signal c_in20:std_logic_vector(31 downto 0);
    signal c_in21:std_logic_vector(31 downto 0);
    signal c_in22:std_logic_vector(31 downto 0);
    signal c_in23:std_logic_vector(31 downto 0);
    signal c_in24:std_logic_vector(31 downto 0);
    signal c_in25:std_logic_vector(31 downto 0);
    signal c_in26:std_logic_vector(31 downto 0);
    signal c_in27:std_logic_vector(31 downto 0);
    signal c_in28:std_logic_vector(31 downto 0);
    signal c_in29:std_logic_vector(31 downto 0);
    signal c_in30:std_logic_vector(31 downto 0);
    signal c_in31:std_logic_vector(31 downto 0);
    signal c_in32:std_logic_vector(31 downto 0);
    signal c_in33:std_logic_vector(31 downto 0);
    signal c_in34:std_logic_vector(31 downto 0);
    signal c_in35:std_logic_vector(31 downto 0);
    signal c_in36:std_logic_vector(31 downto 0);
    signal c_in37:std_logic_vector(31 downto 0);
    signal c_in38:std_logic_vector(31 downto 0);
    signal c_in39:std_logic_vector(31 downto 0);
    signal c_in40:std_logic_vector(31 downto 0);
    signal c_in41:std_logic_vector(31 downto 0);
    signal c_in42:std_logic_vector(31 downto 0);
    signal c_in43:std_logic_vector(31 downto 0);
    signal c_in44:std_logic_vector(31 downto 0);
    signal c_in45:std_logic_vector(31 downto 0);
    signal c_in46:std_logic_vector(31 downto 0);
    signal c_in47:std_logic_vector(31 downto 0);
    signal c_in48:std_logic_vector(31 downto 0);
    signal c_in49:std_logic_vector(31 downto 0);
    signal c_in50:std_logic_vector(31 downto 0);
    signal c_in51:std_logic_vector(31 downto 0);
    signal c_in52:std_logic_vector(31 downto 0);
    signal c_in53:std_logic_vector(31 downto 0);
    signal c_in54:std_logic_vector(31 downto 0);
    signal c_in55:std_logic_vector(31 downto 0);
    signal c_in56:std_logic_vector(31 downto 0);
    signal c_in57:std_logic_vector(31 downto 0);
    signal c_in58:std_logic_vector(31 downto 0);
    signal c_in59:std_logic_vector(31 downto 0);
    signal c_in60:std_logic_vector(31 downto 0);
    signal c_in61:std_logic_vector(31 downto 0);
    signal c_in62:std_logic_vector(31 downto 0);
    signal c_in63:std_logic_vector(31 downto 0);
    signal c_in64:std_logic_vector(31 downto 0);
    signal c_in65:std_logic_vector(31 downto 0);
    signal c_in66:std_logic_vector(31 downto 0);
    signal c_in67:std_logic_vector(31 downto 0);
    signal c_in68:std_logic_vector(31 downto 0);
    signal c_in69:std_logic_vector(31 downto 0);
    signal c_in70:std_logic_vector(31 downto 0);
    signal c_in71:std_logic_vector(31 downto 0);
    signal c_in72:std_logic_vector(31 downto 0);
    signal c_in73:std_logic_vector(31 downto 0);
    signal c_in74:std_logic_vector(31 downto 0);
    signal c_in75:std_logic_vector(31 downto 0);
    signal c_in76:std_logic_vector(31 downto 0);
    signal c_in77:std_logic_vector(31 downto 0);
    signal c_in78:std_logic_vector(31 downto 0);
    signal c_in79:std_logic_vector(31 downto 0);
    signal c_in80:std_logic_vector(31 downto 0);
    signal c_in81:std_logic_vector(31 downto 0);
    signal c_in82:std_logic_vector(31 downto 0);
    signal c_in83:std_logic_vector(31 downto 0);
    signal c_in84:std_logic_vector(31 downto 0);
    signal c_in85:std_logic_vector(31 downto 0);
    signal c_in86:std_logic_vector(31 downto 0);
    signal c_in87:std_logic_vector(31 downto 0);
    signal c_in88:std_logic_vector(31 downto 0);
    signal c_in89:std_logic_vector(31 downto 0);
    signal c_in90:std_logic_vector(31 downto 0);
    signal c_in91:std_logic_vector(31 downto 0);
    signal c_in92:std_logic_vector(31 downto 0);
    signal c_in93:std_logic_vector(31 downto 0);
    signal c_in94:std_logic_vector(31 downto 0);
    signal c_in95:std_logic_vector(31 downto 0);
    signal c_in96:std_logic_vector(31 downto 0);
    signal c_in97:std_logic_vector(31 downto 0);
    signal c_in98:std_logic_vector(31 downto 0);
    signal c_in99:std_logic_vector(31 downto 0);
    signal c_in100:std_logic_vector(31 downto 0);
    signal c_in101:std_logic_vector(31 downto 0);
    signal c_in102:std_logic_vector(31 downto 0);
    signal c_in103:std_logic_vector(31 downto 0);
    signal c_in104:std_logic_vector(31 downto 0);
    signal c_in105:std_logic_vector(31 downto 0);
    signal c_in106:std_logic_vector(31 downto 0);
    signal c_in107:std_logic_vector(31 downto 0);
    signal c_in108:std_logic_vector(31 downto 0);
    signal c_in109:std_logic_vector(31 downto 0);
    signal c_in110:std_logic_vector(31 downto 0);
    signal c_in111:std_logic_vector(31 downto 0);
    signal c_in112:std_logic_vector(31 downto 0);
    signal c_in113:std_logic_vector(31 downto 0);
    signal c_in114:std_logic_vector(31 downto 0);
    signal c_in115:std_logic_vector(31 downto 0);
    signal c_in116:std_logic_vector(31 downto 0);
    signal c_in117:std_logic_vector(31 downto 0);
    signal c_in118:std_logic_vector(31 downto 0);
    signal c_in119:std_logic_vector(31 downto 0);
    signal c_in120:std_logic_vector(31 downto 0);
    signal c_in121:std_logic_vector(31 downto 0);
    signal c_in122:std_logic_vector(31 downto 0);
    signal c_in123:std_logic_vector(31 downto 0);
    signal c_in124:std_logic_vector(31 downto 0);
    signal c_in125:std_logic_vector(31 downto 0);
    signal c_in126:std_logic_vector(31 downto 0);
    signal c_in127:std_logic_vector(31 downto 0);
    signal c_in128:std_logic_vector(31 downto 0);
    signal c_in129:std_logic_vector(31 downto 0);
    signal c_in130:std_logic_vector(31 downto 0);
    signal c_in131:std_logic_vector(31 downto 0);
    signal c_in132:std_logic_vector(31 downto 0);
    signal c_in133:std_logic_vector(31 downto 0);
    signal c_in134:std_logic_vector(31 downto 0);
    signal c_in135:std_logic_vector(31 downto 0);
    signal c_in136:std_logic_vector(31 downto 0);
    signal c_in137:std_logic_vector(31 downto 0);
    signal c_in138:std_logic_vector(31 downto 0);
    signal c_in139:std_logic_vector(31 downto 0);
    signal c_in140:std_logic_vector(31 downto 0);
    signal c_in141:std_logic_vector(31 downto 0);
    signal c_in142:std_logic_vector(31 downto 0);
    signal c_in143:std_logic_vector(31 downto 0);
    signal c_in144:std_logic_vector(31 downto 0);
    signal c_in145:std_logic_vector(31 downto 0);
    signal c_in146:std_logic_vector(31 downto 0);
    signal c_in147:std_logic_vector(31 downto 0);
    signal c_in148:std_logic_vector(31 downto 0);
    signal c_in149:std_logic_vector(31 downto 0);
    signal c_in150:std_logic_vector(31 downto 0);
    signal c_in151:std_logic_vector(31 downto 0);
    signal c_in152:std_logic_vector(31 downto 0);
    signal c_in153:std_logic_vector(31 downto 0);
    signal c_in154:std_logic_vector(31 downto 0);
    signal c_in155:std_logic_vector(31 downto 0);
    signal c_in156:std_logic_vector(31 downto 0);
    signal c_in157:std_logic_vector(31 downto 0);
    signal c_in158:std_logic_vector(31 downto 0);
    signal c_in159:std_logic_vector(31 downto 0);
    signal c_in160:std_logic_vector(31 downto 0);
    signal c_in161:std_logic_vector(31 downto 0);
    signal c_in162:std_logic_vector(31 downto 0);
    signal c_in163:std_logic_vector(31 downto 0);
    signal c_in164:std_logic_vector(31 downto 0);
    signal c_in165:std_logic_vector(31 downto 0);
    signal c_in166:std_logic_vector(31 downto 0);
    signal c_in167:std_logic_vector(31 downto 0);
    signal c_in168:std_logic_vector(31 downto 0);
    signal c_in169:std_logic_vector(31 downto 0);
    signal c_in170:std_logic_vector(31 downto 0);
    signal c_in171:std_logic_vector(31 downto 0);
    signal c_in172:std_logic_vector(31 downto 0);
    signal c_in173:std_logic_vector(31 downto 0);
    signal c_in174:std_logic_vector(31 downto 0);
    signal c_in175:std_logic_vector(31 downto 0);
    signal c_in176:std_logic_vector(31 downto 0);
    signal c_in177:std_logic_vector(31 downto 0);
    signal c_in178:std_logic_vector(31 downto 0);
    signal c_in179:std_logic_vector(31 downto 0);
    signal c_in180:std_logic_vector(31 downto 0);
    signal c_in181:std_logic_vector(31 downto 0);
    signal c_in182:std_logic_vector(31 downto 0);
    signal c_in183:std_logic_vector(31 downto 0);
    signal c_in184:std_logic_vector(31 downto 0);
    signal c_in185:std_logic_vector(31 downto 0);
    signal c_in186:std_logic_vector(31 downto 0);
    signal c_in187:std_logic_vector(31 downto 0);
    signal c_in188:std_logic_vector(31 downto 0);
    signal c_in189:std_logic_vector(31 downto 0);
    signal c_in190:std_logic_vector(31 downto 0);
    signal c_in191:std_logic_vector(31 downto 0);
    signal c_in192:std_logic_vector(31 downto 0);
    signal c_in193:std_logic_vector(31 downto 0);
    signal c_in194:std_logic_vector(31 downto 0);
    signal c_in195:std_logic_vector(31 downto 0);
    signal c_in196:std_logic_vector(31 downto 0);
    signal c_in197:std_logic_vector(31 downto 0);
    signal c_in198:std_logic_vector(31 downto 0);
    signal c_in199:std_logic_vector(31 downto 0);
    signal c_in200:std_logic_vector(31 downto 0);
    signal c_in201:std_logic_vector(31 downto 0);
    signal c_in202:std_logic_vector(31 downto 0);
    signal c_in203:std_logic_vector(31 downto 0);
    signal c_in204:std_logic_vector(31 downto 0);
    signal c_in205:std_logic_vector(31 downto 0);
    signal c_in206:std_logic_vector(31 downto 0);
    signal c_in207:std_logic_vector(31 downto 0);
    signal c_in208:std_logic_vector(31 downto 0);
    signal c_in209:std_logic_vector(31 downto 0);
    signal c_in210:std_logic_vector(31 downto 0);
    signal c_in211:std_logic_vector(31 downto 0);
    signal c_in212:std_logic_vector(31 downto 0);
    signal c_in213:std_logic_vector(31 downto 0);
    signal c_in214:std_logic_vector(31 downto 0);
    signal c_in215:std_logic_vector(31 downto 0);
    signal c_in216:std_logic_vector(31 downto 0);
    signal c_in217:std_logic_vector(31 downto 0);
    signal c_in218:std_logic_vector(31 downto 0);
    signal c_in219:std_logic_vector(31 downto 0);
    signal c_in220:std_logic_vector(31 downto 0);
    signal c_in221:std_logic_vector(31 downto 0);
    signal c_in222:std_logic_vector(31 downto 0);
    signal c_in223:std_logic_vector(31 downto 0);
    signal c_in224:std_logic_vector(31 downto 0);
    signal c_in225:std_logic_vector(31 downto 0);
    signal c_in226:std_logic_vector(31 downto 0);
    signal c_in227:std_logic_vector(31 downto 0);
    signal c_in228:std_logic_vector(31 downto 0);
    signal c_in229:std_logic_vector(31 downto 0);
    signal c_in230:std_logic_vector(31 downto 0);
    signal c_in231:std_logic_vector(31 downto 0);
    signal c_in232:std_logic_vector(31 downto 0);
    signal c_in233:std_logic_vector(31 downto 0);
    signal c_in234:std_logic_vector(31 downto 0);
    signal c_in235:std_logic_vector(31 downto 0);
    signal c_in236:std_logic_vector(31 downto 0);
    signal c_in237:std_logic_vector(31 downto 0);
    signal c_in238:std_logic_vector(31 downto 0);
    signal c_in239:std_logic_vector(31 downto 0);

    signal c_out:integer_vector(232 downto 0);
    signal c_out0:std_logic_vector(31 downto 0);
    signal c_out1:std_logic_vector(31 downto 0);
    signal c_out2:std_logic_vector(31 downto 0);
    signal c_out3:std_logic_vector(31 downto 0);
    signal c_out4:std_logic_vector(31 downto 0);
    signal c_out5:std_logic_vector(31 downto 0);
    signal c_out6:std_logic_vector(31 downto 0);
    signal c_out7:std_logic_vector(31 downto 0);
    signal c_out8:std_logic_vector(31 downto 0);
    signal c_out9:std_logic_vector(31 downto 0);
    signal c_out10:std_logic_vector(31 downto 0);
    signal c_out11:std_logic_vector(31 downto 0);
    signal c_out12:std_logic_vector(31 downto 0);
    signal c_out13:std_logic_vector(31 downto 0);
    signal c_out14:std_logic_vector(31 downto 0);
    signal c_out15:std_logic_vector(31 downto 0);
    signal c_out16:std_logic_vector(31 downto 0);
    signal c_out17:std_logic_vector(31 downto 0);
    signal c_out18:std_logic_vector(31 downto 0);
    signal c_out19:std_logic_vector(31 downto 0);
    signal c_out20:std_logic_vector(31 downto 0);
    signal c_out21:std_logic_vector(31 downto 0);
    signal c_out22:std_logic_vector(31 downto 0);
    signal c_out23:std_logic_vector(31 downto 0);
    signal c_out24:std_logic_vector(31 downto 0);
    signal c_out25:std_logic_vector(31 downto 0);
    signal c_out26:std_logic_vector(31 downto 0);
    signal c_out27:std_logic_vector(31 downto 0);
    signal c_out28:std_logic_vector(31 downto 0);
    signal c_out29:std_logic_vector(31 downto 0);
    signal c_out30:std_logic_vector(31 downto 0);
    signal c_out31:std_logic_vector(31 downto 0);
    signal c_out32:std_logic_vector(31 downto 0);
    signal c_out33:std_logic_vector(31 downto 0);
    signal c_out34:std_logic_vector(31 downto 0);
    signal c_out35:std_logic_vector(31 downto 0);
    signal c_out36:std_logic_vector(31 downto 0);
    signal c_out37:std_logic_vector(31 downto 0);
    signal c_out38:std_logic_vector(31 downto 0);
    signal c_out39:std_logic_vector(31 downto 0);
    signal c_out40:std_logic_vector(31 downto 0);
    signal c_out41:std_logic_vector(31 downto 0);
    signal c_out42:std_logic_vector(31 downto 0);
    signal c_out43:std_logic_vector(31 downto 0);
    signal c_out44:std_logic_vector(31 downto 0);
    signal c_out45:std_logic_vector(31 downto 0);
    signal c_out46:std_logic_vector(31 downto 0);
    signal c_out47:std_logic_vector(31 downto 0);
    signal c_out48:std_logic_vector(31 downto 0);
    signal c_out49:std_logic_vector(31 downto 0);
    signal c_out50:std_logic_vector(31 downto 0);
    signal c_out51:std_logic_vector(31 downto 0);
    signal c_out52:std_logic_vector(31 downto 0);
    signal c_out53:std_logic_vector(31 downto 0);
    signal c_out54:std_logic_vector(31 downto 0);
    signal c_out55:std_logic_vector(31 downto 0);
    signal c_out56:std_logic_vector(31 downto 0);
    signal c_out57:std_logic_vector(31 downto 0);
    signal c_out58:std_logic_vector(31 downto 0);
    signal c_out59:std_logic_vector(31 downto 0);
    signal c_out60:std_logic_vector(31 downto 0);
    signal c_out61:std_logic_vector(31 downto 0);
    signal c_out62:std_logic_vector(31 downto 0);
    signal c_out63:std_logic_vector(31 downto 0);
    signal c_out64:std_logic_vector(31 downto 0);
    signal c_out65:std_logic_vector(31 downto 0);
    signal c_out66:std_logic_vector(31 downto 0);
    signal c_out67:std_logic_vector(31 downto 0);
    signal c_out68:std_logic_vector(31 downto 0);
    signal c_out69:std_logic_vector(31 downto 0);
    signal c_out70:std_logic_vector(31 downto 0);
    signal c_out71:std_logic_vector(31 downto 0);
    signal c_out72:std_logic_vector(31 downto 0);
    signal c_out73:std_logic_vector(31 downto 0);
    signal c_out74:std_logic_vector(31 downto 0);
    signal c_out75:std_logic_vector(31 downto 0);
    signal c_out76:std_logic_vector(31 downto 0);
    signal c_out77:std_logic_vector(31 downto 0);
    signal c_out78:std_logic_vector(31 downto 0);
    signal c_out79:std_logic_vector(31 downto 0);
    signal c_out80:std_logic_vector(31 downto 0);
    signal c_out81:std_logic_vector(31 downto 0);
    signal c_out82:std_logic_vector(31 downto 0);
    signal c_out83:std_logic_vector(31 downto 0);
    signal c_out84:std_logic_vector(31 downto 0);
    signal c_out85:std_logic_vector(31 downto 0);
    signal c_out86:std_logic_vector(31 downto 0);
    signal c_out87:std_logic_vector(31 downto 0);
    signal c_out88:std_logic_vector(31 downto 0);
    signal c_out89:std_logic_vector(31 downto 0);
    signal c_out90:std_logic_vector(31 downto 0);
    signal c_out91:std_logic_vector(31 downto 0);
    signal c_out92:std_logic_vector(31 downto 0);
    signal c_out93:std_logic_vector(31 downto 0);
    signal c_out94:std_logic_vector(31 downto 0);
    signal c_out95:std_logic_vector(31 downto 0);
    signal c_out96:std_logic_vector(31 downto 0);
    signal c_out97:std_logic_vector(31 downto 0);
    signal c_out98:std_logic_vector(31 downto 0);
    signal c_out99:std_logic_vector(31 downto 0);
    signal c_out100:std_logic_vector(31 downto 0);
    signal c_out101:std_logic_vector(31 downto 0);
    signal c_out102:std_logic_vector(31 downto 0);
    signal c_out103:std_logic_vector(31 downto 0);
    signal c_out104:std_logic_vector(31 downto 0);
    signal c_out105:std_logic_vector(31 downto 0);
    signal c_out106:std_logic_vector(31 downto 0);
    signal c_out107:std_logic_vector(31 downto 0);
    signal c_out108:std_logic_vector(31 downto 0);
    signal c_out109:std_logic_vector(31 downto 0);
    signal c_out110:std_logic_vector(31 downto 0);
    signal c_out111:std_logic_vector(31 downto 0);
    signal c_out112:std_logic_vector(31 downto 0);
    signal c_out113:std_logic_vector(31 downto 0);
    signal c_out114:std_logic_vector(31 downto 0);
    signal c_out115:std_logic_vector(31 downto 0);
    signal c_out116:std_logic_vector(31 downto 0);
    signal c_out117:std_logic_vector(31 downto 0);
    signal c_out118:std_logic_vector(31 downto 0);
    signal c_out119:std_logic_vector(31 downto 0);
    signal c_out120:std_logic_vector(31 downto 0);
    signal c_out121:std_logic_vector(31 downto 0);
    signal c_out122:std_logic_vector(31 downto 0);
    signal c_out123:std_logic_vector(31 downto 0);
    signal c_out124:std_logic_vector(31 downto 0);
    signal c_out125:std_logic_vector(31 downto 0);
    signal c_out126:std_logic_vector(31 downto 0);
    signal c_out127:std_logic_vector(31 downto 0);
    signal c_out128:std_logic_vector(31 downto 0);
    signal c_out129:std_logic_vector(31 downto 0);
    signal c_out130:std_logic_vector(31 downto 0);
    signal c_out131:std_logic_vector(31 downto 0);
    signal c_out132:std_logic_vector(31 downto 0);
    signal c_out133:std_logic_vector(31 downto 0);
    signal c_out134:std_logic_vector(31 downto 0);
    signal c_out135:std_logic_vector(31 downto 0);
    signal c_out136:std_logic_vector(31 downto 0);
    signal c_out137:std_logic_vector(31 downto 0);
    signal c_out138:std_logic_vector(31 downto 0);
    signal c_out139:std_logic_vector(31 downto 0);
    signal c_out140:std_logic_vector(31 downto 0);
    signal c_out141:std_logic_vector(31 downto 0);
    signal c_out142:std_logic_vector(31 downto 0);
    signal c_out143:std_logic_vector(31 downto 0);
    signal c_out144:std_logic_vector(31 downto 0);
    signal c_out145:std_logic_vector(31 downto 0);
    signal c_out146:std_logic_vector(31 downto 0);
    signal c_out147:std_logic_vector(31 downto 0);
    signal c_out148:std_logic_vector(31 downto 0);
    signal c_out149:std_logic_vector(31 downto 0);
    signal c_out150:std_logic_vector(31 downto 0);
    signal c_out151:std_logic_vector(31 downto 0);
    signal c_out152:std_logic_vector(31 downto 0);
    signal c_out153:std_logic_vector(31 downto 0);
    signal c_out154:std_logic_vector(31 downto 0);
    signal c_out155:std_logic_vector(31 downto 0);
    signal c_out156:std_logic_vector(31 downto 0);
    signal c_out157:std_logic_vector(31 downto 0);
    signal c_out158:std_logic_vector(31 downto 0);
    signal c_out159:std_logic_vector(31 downto 0);
    signal c_out160:std_logic_vector(31 downto 0);
    signal c_out161:std_logic_vector(31 downto 0);
    signal c_out162:std_logic_vector(31 downto 0);
    signal c_out163:std_logic_vector(31 downto 0);
    signal c_out164:std_logic_vector(31 downto 0);
    signal c_out165:std_logic_vector(31 downto 0);
    signal c_out166:std_logic_vector(31 downto 0);
    signal c_out167:std_logic_vector(31 downto 0);
    signal c_out168:std_logic_vector(31 downto 0);
    signal c_out169:std_logic_vector(31 downto 0);
    signal c_out170:std_logic_vector(31 downto 0);
    signal c_out171:std_logic_vector(31 downto 0);
    signal c_out172:std_logic_vector(31 downto 0);
    signal c_out173:std_logic_vector(31 downto 0);
    signal c_out174:std_logic_vector(31 downto 0);
    signal c_out175:std_logic_vector(31 downto 0);
    signal c_out176:std_logic_vector(31 downto 0);
    signal c_out177:std_logic_vector(31 downto 0);
    signal c_out178:std_logic_vector(31 downto 0);
    signal c_out179:std_logic_vector(31 downto 0);
    signal c_out180:std_logic_vector(31 downto 0);
    signal c_out181:std_logic_vector(31 downto 0);
    signal c_out182:std_logic_vector(31 downto 0);
    signal c_out183:std_logic_vector(31 downto 0);
    signal c_out184:std_logic_vector(31 downto 0);
    signal c_out185:std_logic_vector(31 downto 0);
    signal c_out186:std_logic_vector(31 downto 0);
    signal c_out187:std_logic_vector(31 downto 0);
    signal c_out188:std_logic_vector(31 downto 0);
    signal c_out189:std_logic_vector(31 downto 0);
    signal c_out190:std_logic_vector(31 downto 0);
    signal c_out191:std_logic_vector(31 downto 0);
    signal c_out192:std_logic_vector(31 downto 0);
    signal c_out193:std_logic_vector(31 downto 0);
    signal c_out194:std_logic_vector(31 downto 0);
    signal c_out195:std_logic_vector(31 downto 0);
    signal c_out196:std_logic_vector(31 downto 0);
    signal c_out197:std_logic_vector(31 downto 0);
    signal c_out198:std_logic_vector(31 downto 0);
    signal c_out199:std_logic_vector(31 downto 0);
    signal c_out200:std_logic_vector(31 downto 0);
    signal c_out201:std_logic_vector(31 downto 0);
    signal c_out202:std_logic_vector(31 downto 0);
    signal c_out203:std_logic_vector(31 downto 0);
    signal c_out204:std_logic_vector(31 downto 0);
    signal c_out205:std_logic_vector(31 downto 0);
    signal c_out206:std_logic_vector(31 downto 0);
    signal c_out207:std_logic_vector(31 downto 0);
    signal c_out208:std_logic_vector(31 downto 0);
    signal c_out209:std_logic_vector(31 downto 0);
    signal c_out210:std_logic_vector(31 downto 0);
    signal c_out211:std_logic_vector(31 downto 0);
    signal c_out212:std_logic_vector(31 downto 0);
    signal c_out213:std_logic_vector(31 downto 0);
    signal c_out214:std_logic_vector(31 downto 0);
    signal c_out215:std_logic_vector(31 downto 0);
    signal c_out216:std_logic_vector(31 downto 0);
    signal c_out217:std_logic_vector(31 downto 0);
    signal c_out218:std_logic_vector(31 downto 0);
    signal c_out219:std_logic_vector(31 downto 0);
    signal c_out220:std_logic_vector(31 downto 0);
    signal c_out221:std_logic_vector(31 downto 0);
    signal c_out222:std_logic_vector(31 downto 0);
    signal c_out223:std_logic_vector(31 downto 0);
    signal c_out224:std_logic_vector(31 downto 0);
    signal c_out225:std_logic_vector(31 downto 0);
    signal c_out226:std_logic_vector(31 downto 0);
    signal c_out227:std_logic_vector(31 downto 0);
    signal c_out228:std_logic_vector(31 downto 0);
    signal c_out229:std_logic_vector(31 downto 0);
    signal c_out230:std_logic_vector(31 downto 0);
    signal c_out231:std_logic_vector(31 downto 0);
    signal c_out232:std_logic_vector(31 downto 0);
    
    signal interrupt:std_logic;
    signal counter:std_logic_vector(7 downto 0);
    signal Y0_bit:std_logic_vector(31 downto 0);
    signal Yi_bit:std_logic_vector(31 downto 0);
    
begin

    DUT:moving_average_filters port map(
        clk => clk,
        rst => rst,
        en => enable_in,
        enable_in => enable_in,        
        c_in0 => c_in0,
        c_in1 => c_in1,
        c_in2 => c_in2,
        c_in3 => c_in3,
        c_in4 => c_in4,
        c_in5 => c_in5,
        c_in6 => c_in6,
        c_in7 => c_in7,
        c_in8 => c_in8,
        c_in9 => c_in9,
        c_in10 => c_in10,
        c_in11 => c_in11,
        c_in12 => c_in12,
        c_in13 => c_in13,
        c_in14 => c_in14,
        c_in15 => c_in15,
        c_in16 => c_in16,
        c_in17 => c_in17,
        c_in18 => c_in18,
        c_in19 => c_in19,
        c_in20 => c_in20,
        c_in21 => c_in21,
        c_in22 => c_in22,
        c_in23 => c_in23,
        c_in24 => c_in24,
        c_in25 => c_in25,
        c_in26 => c_in26,
        c_in27 => c_in27,
        c_in28 => c_in28,
        c_in29 => c_in29,
        c_in30 => c_in30,
        c_in31 => c_in31,
        c_in32 => c_in32,
        c_in33 => c_in33,
        c_in34 => c_in34,
        c_in35 => c_in35,
        c_in36 => c_in36,
        c_in37 => c_in37,
        c_in38 => c_in38,
        c_in39 => c_in39,
        c_in40 => c_in40,
        c_in41 => c_in41,
        c_in42 => c_in42,
        c_in43 => c_in43,
        c_in44 => c_in44,
        c_in45 => c_in45,
        c_in46 => c_in46,
        c_in47 => c_in47,
        c_in48 => c_in48,
        c_in49 => c_in49,
        c_in50 => c_in50,
        c_in51 => c_in51,
        c_in52 => c_in52,
        c_in53 => c_in53,
        c_in54 => c_in54,
        c_in55 => c_in55,
        c_in56 => c_in56,
        c_in57 => c_in57,
        c_in58 => c_in58,
        c_in59 => c_in59,
        c_in60 => c_in60,
        c_in61 => c_in61,
        c_in62 => c_in62,
        c_in63 => c_in63,
        c_in64 => c_in64,
        c_in65 => c_in65,
        c_in66 => c_in66,
        c_in67 => c_in67,
        c_in68 => c_in68,
        c_in69 => c_in69,
        c_in70 => c_in70,
        c_in71 => c_in71,
        c_in72 => c_in72,
        c_in73 => c_in73,
        c_in74 => c_in74,
        c_in75 => c_in75,
        c_in76 => c_in76,
        c_in77 => c_in77,
        c_in78 => c_in78,
        c_in79 => c_in79,
        c_in80 => c_in80,
        c_in81 => c_in81,
        c_in82 => c_in82,
        c_in83 => c_in83,
        c_in84 => c_in84,
        c_in85 => c_in85,
        c_in86 => c_in86,
        c_in87 => c_in87,
        c_in88 => c_in88,
        c_in89 => c_in89,
        c_in90 => c_in90,
        c_in91 => c_in91,
        c_in92 => c_in92,
        c_in93 => c_in93,
        c_in94 => c_in94,
        c_in95 => c_in95,
        c_in96 => c_in96,
        c_in97 => c_in97,
        c_in98 => c_in98,
        c_in99 => c_in99,
        c_in100 => c_in100,
        c_in101 => c_in101,
        c_in102 => c_in102,
        c_in103 => c_in103,
        c_in104 => c_in104,
        c_in105 => c_in105,
        c_in106 => c_in106,
        c_in107 => c_in107,
        c_in108 => c_in108,
        c_in109 => c_in109,
        c_in110 => c_in110,
        c_in111 => c_in111,
        c_in112 => c_in112,
        c_in113 => c_in113,
        c_in114 => c_in114,
        c_in115 => c_in115,
        c_in116 => c_in116,
        c_in117 => c_in117,
        c_in118 => c_in118,
        c_in119 => c_in119,
        c_in120 => c_in120,
        c_in121 => c_in121,
        c_in122 => c_in122,
        c_in123 => c_in123,
        c_in124 => c_in124,
        c_in125 => c_in125,
        c_in126 => c_in126,
        c_in127 => c_in127,
        c_in128 => c_in128,
        c_in129 => c_in129,
        c_in130 => c_in130,
        c_in131 => c_in131,
        c_in132 => c_in132,
        c_in133 => c_in133,
        c_in134 => c_in134,
        c_in135 => c_in135,
        c_in136 => c_in136,
        c_in137 => c_in137,
        c_in138 => c_in138,
        c_in139 => c_in139,
        c_in140 => c_in140,
        c_in141 => c_in141,
        c_in142 => c_in142,
        c_in143 => c_in143,
        c_in144 => c_in144,
        c_in145 => c_in145,
        c_in146 => c_in146,
        c_in147 => c_in147,
        c_in148 => c_in148,
        c_in149 => c_in149,
        c_in150 => c_in150,
        c_in151 => c_in151,
        c_in152 => c_in152,
        c_in153 => c_in153,
        c_in154 => c_in154,
        c_in155 => c_in155,
        c_in156 => c_in156,
        c_in157 => c_in157,
        c_in158 => c_in158,
        c_in159 => c_in159,
        c_in160 => c_in160,
        c_in161 => c_in161,
        c_in162 => c_in162,
        c_in163 => c_in163,
        c_in164 => c_in164,
        c_in165 => c_in165,
        c_in166 => c_in166,
        c_in167 => c_in167,
        c_in168 => c_in168,
        c_in169 => c_in169,
        c_in170 => c_in170,
        c_in171 => c_in171,
        c_in172 => c_in172,
        c_in173 => c_in173,
        c_in174 => c_in174,
        c_in175 => c_in175,
        c_in176 => c_in176,
        c_in177 => c_in177,
        c_in178 => c_in178,
        c_in179 => c_in179,
        c_in180 => c_in180,
        c_in181 => c_in181,
        c_in182 => c_in182,
        c_in183 => c_in183,
        c_in184 => c_in184,
        c_in185 => c_in185,
        c_in186 => c_in186,
        c_in187 => c_in187,
        c_in188 => c_in188,
        c_in189 => c_in189,
        c_in190 => c_in190,
        c_in191 => c_in191,
        c_in192 => c_in192,
        c_in193 => c_in193,
        c_in194 => c_in194,
        c_in195 => c_in195,
        c_in196 => c_in196,
        c_in197 => c_in197,
        c_in198 => c_in198,
        c_in199 => c_in199,
        c_in200 => c_in200,
        c_in201 => c_in201,
        c_in202 => c_in202,
        c_in203 => c_in203,
        c_in204 => c_in204,
        c_in205 => c_in205,
        c_in206 => c_in206,
        c_in207 => c_in207,
        c_in208 => c_in208,
        c_in209 => c_in209,
        c_in210 => c_in210,
        c_in211 => c_in211,
        c_in212 => c_in212,
        c_in213 => c_in213,
        c_in214 => c_in214,
        c_in215 => c_in215,
        c_in216 => c_in216,
        c_in217 => c_in217,
        c_in218 => c_in218,
        c_in219 => c_in219,
        c_in220 => c_in220,
        c_in221 => c_in221,
        c_in222 => c_in222,
        c_in223 => c_in223,
        c_in224 => c_in224,
        c_in225 => c_in225,
        c_in226 => c_in226,
        c_in227 => c_in227,
        c_in228 => c_in228,
        c_in229 => c_in229,
        c_in230 => c_in230,
        c_in231 => c_in231,
        c_in232 => c_in232,
        c_in233 => c_in233,
        c_in234 => c_in234,
        c_in235 => c_in235,
        c_in236 => c_in236,
        c_in237 => c_in237,
        c_in238 => c_in238,
        c_in239 => c_in239, 
        counter => counter,
        Y0_bit => Y0_bit,
        Yi_bit => Yi_bit,  
        interrupt => interrupt,
        c_out0 => c_out0,
        c_out1 => c_out1,
        c_out2 => c_out2,
        c_out3 => c_out3,
        c_out4 => c_out4,
        c_out5 => c_out5,
        c_out6 => c_out6,
        c_out7 => c_out7,
        c_out8 => c_out8,
        c_out9 => c_out9,
        c_out10 => c_out10,
        c_out11 => c_out11,
        c_out12 => c_out12,
        c_out13 => c_out13,
        c_out14 => c_out14,
        c_out15 => c_out15,
        c_out16 => c_out16,
        c_out17 => c_out17,
        c_out18 => c_out18,
        c_out19 => c_out19,
        c_out20 => c_out20,
        c_out21 => c_out21,
        c_out22 => c_out22,
        c_out23 => c_out23,
        c_out24 => c_out24,
        c_out25 => c_out25,
        c_out26 => c_out26,
        c_out27 => c_out27,
        c_out28 => c_out28,
        c_out29 => c_out29,
        c_out30 => c_out30,
        c_out31 => c_out31,
        c_out32 => c_out32,
        c_out33 => c_out33,
        c_out34 => c_out34,
        c_out35 => c_out35,
        c_out36 => c_out36,
        c_out37 => c_out37,
        c_out38 => c_out38,
        c_out39 => c_out39,
        c_out40 => c_out40,
        c_out41 => c_out41,
        c_out42 => c_out42,
        c_out43 => c_out43,
        c_out44 => c_out44,
        c_out45 => c_out45,
        c_out46 => c_out46,
        c_out47 => c_out47,
        c_out48 => c_out48,
        c_out49 => c_out49,
        c_out50 => c_out50,
        c_out51 => c_out51,
        c_out52 => c_out52,
        c_out53 => c_out53,
        c_out54 => c_out54,
        c_out55 => c_out55,
        c_out56 => c_out56,
        c_out57 => c_out57,
        c_out58 => c_out58,
        c_out59 => c_out59,
        c_out60 => c_out60,
        c_out61 => c_out61,
        c_out62 => c_out62,
        c_out63 => c_out63,
        c_out64 => c_out64,
        c_out65 => c_out65,
        c_out66 => c_out66,
        c_out67 => c_out67,
        c_out68 => c_out68,
        c_out69 => c_out69,
        c_out70 => c_out70,
        c_out71 => c_out71,
        c_out72 => c_out72,
        c_out73 => c_out73,
        c_out74 => c_out74,
        c_out75 => c_out75,
        c_out76 => c_out76,
        c_out77 => c_out77,
        c_out78 => c_out78,
        c_out79 => c_out79,
        c_out80 => c_out80,
        c_out81 => c_out81,
        c_out82 => c_out82,
        c_out83 => c_out83,
        c_out84 => c_out84,
        c_out85 => c_out85,
        c_out86 => c_out86,
        c_out87 => c_out87,
        c_out88 => c_out88,
        c_out89 => c_out89,
        c_out90 => c_out90,
        c_out91 => c_out91,
        c_out92 => c_out92,
        c_out93 => c_out93,
        c_out94 => c_out94,
        c_out95 => c_out95,
        c_out96 => c_out96,
        c_out97 => c_out97,
        c_out98 => c_out98,
        c_out99 => c_out99,
        c_out100 => c_out100,
        c_out101 => c_out101,
        c_out102 => c_out102,
        c_out103 => c_out103,
        c_out104 => c_out104,
        c_out105 => c_out105,
        c_out106 => c_out106,
        c_out107 => c_out107,
        c_out108 => c_out108,
        c_out109 => c_out109,
        c_out110 => c_out110,
        c_out111 => c_out111,
        c_out112 => c_out112,
        c_out113 => c_out113,
        c_out114 => c_out114,
        c_out115 => c_out115,
        c_out116 => c_out116,
        c_out117 => c_out117,
        c_out118 => c_out118,
        c_out119 => c_out119,
        c_out120 => c_out120,
        c_out121 => c_out121,
        c_out122 => c_out122,
        c_out123 => c_out123,
        c_out124 => c_out124,
        c_out125 => c_out125,
        c_out126 => c_out126,
        c_out127 => c_out127,
        c_out128 => c_out128,
        c_out129 => c_out129,
        c_out130 => c_out130,
        c_out131 => c_out131,
        c_out132 => c_out132,
        c_out133 => c_out133,
        c_out134 => c_out134,
        c_out135 => c_out135,
        c_out136 => c_out136,
        c_out137 => c_out137,
        c_out138 => c_out138,
        c_out139 => c_out139,
        c_out140 => c_out140,
        c_out141 => c_out141,
        c_out142 => c_out142,
        c_out143 => c_out143,
        c_out144 => c_out144,
        c_out145 => c_out145,
        c_out146 => c_out146,
        c_out147 => c_out147,
        c_out148 => c_out148,
        c_out149 => c_out149,
        c_out150 => c_out150,
        c_out151 => c_out151,
        c_out152 => c_out152,
        c_out153 => c_out153,
        c_out154 => c_out154,
        c_out155 => c_out155,
        c_out156 => c_out156,
        c_out157 => c_out157,
        c_out158 => c_out158,
        c_out159 => c_out159,
        c_out160 => c_out160,
        c_out161 => c_out161,
        c_out162 => c_out162,
        c_out163 => c_out163,
        c_out164 => c_out164,
        c_out165 => c_out165,
        c_out166 => c_out166,
        c_out167 => c_out167,
        c_out168 => c_out168,
        c_out169 => c_out169,
        c_out170 => c_out170,
        c_out171 => c_out171,
        c_out172 => c_out172,
        c_out173 => c_out173,
        c_out174 => c_out174,
        c_out175 => c_out175,
        c_out176 => c_out176,
        c_out177 => c_out177,
        c_out178 => c_out178,
        c_out179 => c_out179,
        c_out180 => c_out180,
        c_out181 => c_out181,
        c_out182 => c_out182,
        c_out183 => c_out183,
        c_out184 => c_out184,
        c_out185 => c_out185,
        c_out186 => c_out186,
        c_out187 => c_out187,
        c_out188 => c_out188,
        c_out189 => c_out189,
        c_out190 => c_out190,
        c_out191 => c_out191,
        c_out192 => c_out192,
        c_out193 => c_out193,
        c_out194 => c_out194,
        c_out195 => c_out195,
        c_out196 => c_out196,
        c_out197 => c_out197,
        c_out198 => c_out198,
        c_out199 => c_out199,
        c_out200 => c_out200,
        c_out201 => c_out201,
        c_out202 => c_out202,
        c_out203 => c_out203,
        c_out204 => c_out204,
        c_out205 => c_out205,
        c_out206 => c_out206,
        c_out207 => c_out207,
        c_out208 => c_out208,
        c_out209 => c_out209,
        c_out210 => c_out210,
        c_out211 => c_out211,
        c_out212 => c_out212,
        c_out213 => c_out213,
        c_out214 => c_out214,
        c_out215 => c_out215,
        c_out216 => c_out216,
        c_out217 => c_out217,
        c_out218 => c_out218,
        c_out219 => c_out219,
        c_out220 => c_out220,
        c_out221 => c_out221,
        c_out222 => c_out222,
        c_out223 => c_out223,
        c_out224 => c_out224,
        c_out225 => c_out225,
        c_out226 => c_out226,
        c_out227 => c_out227,
        c_out228 => c_out228,
        c_out229 => c_out229,
        c_out230 => c_out230,
        c_out231 => c_out231,
        c_out232 => c_out232        
    );

    process
        begin
            clk<='1';
            wait for 5 ns;
            clk<='0';
            wait for 5 ns;
    end process;

    en <= '1';
    enable_in <= '0', '1' after 100 ns;
    rst <= '1', '0' after 10 ns;

    --Scrivo tutte le conversioni necessarie per fare in modo di leggere gli interi dal file e per scrivere gli interi sul file.
    --Dal file leggo degli interi e devo convertirli in std_logic_vector.
    c_in0 <= std_logic_vector(to_signed(c_in(0),32));
    c_in1 <= std_logic_vector(to_signed(c_in(1),32));
    c_in2 <= std_logic_vector(to_signed(c_in(2),32));
    c_in3 <= std_logic_vector(to_signed(c_in(3),32));
    c_in4 <= std_logic_vector(to_signed(c_in(4),32));
    c_in5 <= std_logic_vector(to_signed(c_in(5),32));
    c_in6 <= std_logic_vector(to_signed(c_in(6),32));
    c_in7 <= std_logic_vector(to_signed(c_in(7),32));
    c_in8 <= std_logic_vector(to_signed(c_in(8),32));
    c_in9 <= std_logic_vector(to_signed(c_in(9),32));
    c_in10 <= std_logic_vector(to_signed(c_in(10),32));
    c_in11 <= std_logic_vector(to_signed(c_in(11),32));
    c_in12 <= std_logic_vector(to_signed(c_in(12),32));
    c_in13 <= std_logic_vector(to_signed(c_in(13),32));
    c_in14 <= std_logic_vector(to_signed(c_in(14),32));
    c_in15 <= std_logic_vector(to_signed(c_in(15),32));
    c_in16 <= std_logic_vector(to_signed(c_in(16),32));
    c_in17 <= std_logic_vector(to_signed(c_in(17),32));
    c_in18 <= std_logic_vector(to_signed(c_in(18),32));
    c_in19 <= std_logic_vector(to_signed(c_in(19),32));
    c_in20 <= std_logic_vector(to_signed(c_in(20),32));
    c_in21 <= std_logic_vector(to_signed(c_in(21),32));
    c_in22 <= std_logic_vector(to_signed(c_in(22),32));
    c_in23 <= std_logic_vector(to_signed(c_in(23),32));
    c_in24 <= std_logic_vector(to_signed(c_in(24),32));
    c_in25 <= std_logic_vector(to_signed(c_in(25),32));
    c_in26 <= std_logic_vector(to_signed(c_in(26),32));
    c_in27 <= std_logic_vector(to_signed(c_in(27),32));
    c_in28 <= std_logic_vector(to_signed(c_in(28),32));
    c_in29 <= std_logic_vector(to_signed(c_in(29),32));
    c_in30 <= std_logic_vector(to_signed(c_in(30),32));
    c_in31 <= std_logic_vector(to_signed(c_in(31),32));
    c_in32 <= std_logic_vector(to_signed(c_in(32),32));
    c_in33 <= std_logic_vector(to_signed(c_in(33),32));
    c_in34 <= std_logic_vector(to_signed(c_in(34),32));
    c_in35 <= std_logic_vector(to_signed(c_in(35),32));
    c_in36 <= std_logic_vector(to_signed(c_in(36),32));
    c_in37 <= std_logic_vector(to_signed(c_in(37),32));
    c_in38 <= std_logic_vector(to_signed(c_in(38),32));
    c_in39 <= std_logic_vector(to_signed(c_in(39),32));
    c_in40 <= std_logic_vector(to_signed(c_in(40),32));
    c_in41 <= std_logic_vector(to_signed(c_in(41),32));
    c_in42 <= std_logic_vector(to_signed(c_in(42),32));
    c_in43 <= std_logic_vector(to_signed(c_in(43),32));
    c_in44 <= std_logic_vector(to_signed(c_in(44),32));
    c_in45 <= std_logic_vector(to_signed(c_in(45),32));
    c_in46 <= std_logic_vector(to_signed(c_in(46),32));
    c_in47 <= std_logic_vector(to_signed(c_in(47),32));
    c_in48 <= std_logic_vector(to_signed(c_in(48),32));
    c_in49 <= std_logic_vector(to_signed(c_in(49),32));
    c_in50 <= std_logic_vector(to_signed(c_in(50),32));
    c_in51 <= std_logic_vector(to_signed(c_in(51),32));
    c_in52 <= std_logic_vector(to_signed(c_in(52),32));
    c_in53 <= std_logic_vector(to_signed(c_in(53),32));
    c_in54 <= std_logic_vector(to_signed(c_in(54),32));
    c_in55 <= std_logic_vector(to_signed(c_in(55),32));
    c_in56 <= std_logic_vector(to_signed(c_in(56),32));
    c_in57 <= std_logic_vector(to_signed(c_in(57),32));
    c_in58 <= std_logic_vector(to_signed(c_in(58),32));
    c_in59 <= std_logic_vector(to_signed(c_in(59),32));
    c_in60 <= std_logic_vector(to_signed(c_in(60),32));
    c_in61 <= std_logic_vector(to_signed(c_in(61),32));
    c_in62 <= std_logic_vector(to_signed(c_in(62),32));
    c_in63 <= std_logic_vector(to_signed(c_in(63),32));
    c_in64 <= std_logic_vector(to_signed(c_in(64),32));
    c_in65 <= std_logic_vector(to_signed(c_in(65),32));
    c_in66 <= std_logic_vector(to_signed(c_in(66),32));
    c_in67 <= std_logic_vector(to_signed(c_in(67),32));
    c_in68 <= std_logic_vector(to_signed(c_in(68),32));
    c_in69 <= std_logic_vector(to_signed(c_in(69),32));
    c_in70 <= std_logic_vector(to_signed(c_in(70),32));
    c_in71 <= std_logic_vector(to_signed(c_in(71),32));
    c_in72 <= std_logic_vector(to_signed(c_in(72),32));
    c_in73 <= std_logic_vector(to_signed(c_in(73),32));
    c_in74 <= std_logic_vector(to_signed(c_in(74),32));
    c_in75 <= std_logic_vector(to_signed(c_in(75),32));
    c_in76 <= std_logic_vector(to_signed(c_in(76),32));
    c_in77 <= std_logic_vector(to_signed(c_in(77),32));
    c_in78 <= std_logic_vector(to_signed(c_in(78),32));
    c_in79 <= std_logic_vector(to_signed(c_in(79),32));
    c_in80 <= std_logic_vector(to_signed(c_in(80),32));
    c_in81 <= std_logic_vector(to_signed(c_in(81),32));
    c_in82 <= std_logic_vector(to_signed(c_in(82),32));
    c_in83 <= std_logic_vector(to_signed(c_in(83),32));
    c_in84 <= std_logic_vector(to_signed(c_in(84),32));
    c_in85 <= std_logic_vector(to_signed(c_in(85),32));
    c_in86 <= std_logic_vector(to_signed(c_in(86),32));
    c_in87 <= std_logic_vector(to_signed(c_in(87),32));
    c_in88 <= std_logic_vector(to_signed(c_in(88),32));
    c_in89 <= std_logic_vector(to_signed(c_in(89),32));
    c_in90 <= std_logic_vector(to_signed(c_in(90),32));
    c_in91 <= std_logic_vector(to_signed(c_in(91),32));
    c_in92 <= std_logic_vector(to_signed(c_in(92),32));
    c_in93 <= std_logic_vector(to_signed(c_in(93),32));
    c_in94 <= std_logic_vector(to_signed(c_in(94),32));
    c_in95 <= std_logic_vector(to_signed(c_in(95),32));
    c_in96 <= std_logic_vector(to_signed(c_in(96),32));
    c_in97 <= std_logic_vector(to_signed(c_in(97),32));
    c_in98 <= std_logic_vector(to_signed(c_in(98),32));
    c_in99 <= std_logic_vector(to_signed(c_in(99),32));
    c_in100 <= std_logic_vector(to_signed(c_in(100),32));
    c_in101 <= std_logic_vector(to_signed(c_in(101),32));
    c_in102 <= std_logic_vector(to_signed(c_in(102),32));
    c_in103 <= std_logic_vector(to_signed(c_in(103),32));
    c_in104 <= std_logic_vector(to_signed(c_in(104),32));
    c_in105 <= std_logic_vector(to_signed(c_in(105),32));
    c_in106 <= std_logic_vector(to_signed(c_in(106),32));
    c_in107 <= std_logic_vector(to_signed(c_in(107),32));
    c_in108 <= std_logic_vector(to_signed(c_in(108),32));
    c_in109 <= std_logic_vector(to_signed(c_in(109),32));
    c_in110 <= std_logic_vector(to_signed(c_in(110),32));
    c_in111 <= std_logic_vector(to_signed(c_in(111),32));
    c_in112 <= std_logic_vector(to_signed(c_in(112),32));
    c_in113 <= std_logic_vector(to_signed(c_in(113),32));
    c_in114 <= std_logic_vector(to_signed(c_in(114),32));
    c_in115 <= std_logic_vector(to_signed(c_in(115),32));
    c_in116 <= std_logic_vector(to_signed(c_in(116),32));
    c_in117 <= std_logic_vector(to_signed(c_in(117),32));
    c_in118 <= std_logic_vector(to_signed(c_in(118),32));
    c_in119 <= std_logic_vector(to_signed(c_in(119),32));
    c_in120 <= std_logic_vector(to_signed(c_in(120),32));
    c_in121 <= std_logic_vector(to_signed(c_in(121),32));
    c_in122 <= std_logic_vector(to_signed(c_in(122),32));
    c_in123 <= std_logic_vector(to_signed(c_in(123),32));
    c_in124 <= std_logic_vector(to_signed(c_in(124),32));
    c_in125 <= std_logic_vector(to_signed(c_in(125),32));
    c_in126 <= std_logic_vector(to_signed(c_in(126),32));
    c_in127 <= std_logic_vector(to_signed(c_in(127),32));
    c_in128 <= std_logic_vector(to_signed(c_in(128),32));
    c_in129 <= std_logic_vector(to_signed(c_in(129),32));
    c_in130 <= std_logic_vector(to_signed(c_in(130),32));
    c_in131 <= std_logic_vector(to_signed(c_in(131),32));
    c_in132 <= std_logic_vector(to_signed(c_in(132),32));
    c_in133 <= std_logic_vector(to_signed(c_in(133),32));
    c_in134 <= std_logic_vector(to_signed(c_in(134),32));
    c_in135 <= std_logic_vector(to_signed(c_in(135),32));
    c_in136 <= std_logic_vector(to_signed(c_in(136),32));
    c_in137 <= std_logic_vector(to_signed(c_in(137),32));
    c_in138 <= std_logic_vector(to_signed(c_in(138),32));
    c_in139 <= std_logic_vector(to_signed(c_in(139),32));
    c_in140 <= std_logic_vector(to_signed(c_in(140),32));
    c_in141 <= std_logic_vector(to_signed(c_in(141),32));
    c_in142 <= std_logic_vector(to_signed(c_in(142),32));
    c_in143 <= std_logic_vector(to_signed(c_in(143),32));
    c_in144 <= std_logic_vector(to_signed(c_in(144),32));
    c_in145 <= std_logic_vector(to_signed(c_in(145),32));
    c_in146 <= std_logic_vector(to_signed(c_in(146),32));
    c_in147 <= std_logic_vector(to_signed(c_in(147),32));
    c_in148 <= std_logic_vector(to_signed(c_in(148),32));
    c_in149 <= std_logic_vector(to_signed(c_in(149),32));
    c_in150 <= std_logic_vector(to_signed(c_in(150),32));
    c_in151 <= std_logic_vector(to_signed(c_in(151),32));
    c_in152 <= std_logic_vector(to_signed(c_in(152),32));
    c_in153 <= std_logic_vector(to_signed(c_in(153),32));
    c_in154 <= std_logic_vector(to_signed(c_in(154),32));
    c_in155 <= std_logic_vector(to_signed(c_in(155),32));
    c_in156 <= std_logic_vector(to_signed(c_in(156),32));
    c_in157 <= std_logic_vector(to_signed(c_in(157),32));
    c_in158 <= std_logic_vector(to_signed(c_in(158),32));
    c_in159 <= std_logic_vector(to_signed(c_in(159),32));
    c_in160 <= std_logic_vector(to_signed(c_in(160),32));
    c_in161 <= std_logic_vector(to_signed(c_in(161),32));
    c_in162 <= std_logic_vector(to_signed(c_in(162),32));
    c_in163 <= std_logic_vector(to_signed(c_in(163),32));
    c_in164 <= std_logic_vector(to_signed(c_in(164),32));
    c_in165 <= std_logic_vector(to_signed(c_in(165),32));
    c_in166 <= std_logic_vector(to_signed(c_in(166),32));
    c_in167 <= std_logic_vector(to_signed(c_in(167),32));
    c_in168 <= std_logic_vector(to_signed(c_in(168),32));
    c_in169 <= std_logic_vector(to_signed(c_in(169),32));
    c_in170 <= std_logic_vector(to_signed(c_in(170),32));
    c_in171 <= std_logic_vector(to_signed(c_in(171),32));
    c_in172 <= std_logic_vector(to_signed(c_in(172),32));
    c_in173 <= std_logic_vector(to_signed(c_in(173),32));
    c_in174 <= std_logic_vector(to_signed(c_in(174),32));
    c_in175 <= std_logic_vector(to_signed(c_in(175),32));
    c_in176 <= std_logic_vector(to_signed(c_in(176),32));
    c_in177 <= std_logic_vector(to_signed(c_in(177),32));
    c_in178 <= std_logic_vector(to_signed(c_in(178),32));
    c_in179 <= std_logic_vector(to_signed(c_in(179),32));
    c_in180 <= std_logic_vector(to_signed(c_in(180),32));
    c_in181 <= std_logic_vector(to_signed(c_in(181),32));
    c_in182 <= std_logic_vector(to_signed(c_in(182),32));
    c_in183 <= std_logic_vector(to_signed(c_in(183),32));
    c_in184 <= std_logic_vector(to_signed(c_in(184),32));
    c_in185 <= std_logic_vector(to_signed(c_in(185),32));
    c_in186 <= std_logic_vector(to_signed(c_in(186),32));
    c_in187 <= std_logic_vector(to_signed(c_in(187),32));
    c_in188 <= std_logic_vector(to_signed(c_in(188),32));
    c_in189 <= std_logic_vector(to_signed(c_in(189),32));
    c_in190 <= std_logic_vector(to_signed(c_in(190),32));
    c_in191 <= std_logic_vector(to_signed(c_in(191),32));
    c_in192 <= std_logic_vector(to_signed(c_in(192),32));
    c_in193 <= std_logic_vector(to_signed(c_in(193),32));
    c_in194 <= std_logic_vector(to_signed(c_in(194),32));
    c_in195 <= std_logic_vector(to_signed(c_in(195),32));
    c_in196 <= std_logic_vector(to_signed(c_in(196),32));
    c_in197 <= std_logic_vector(to_signed(c_in(197),32));
    c_in198 <= std_logic_vector(to_signed(c_in(198),32));
    c_in199 <= std_logic_vector(to_signed(c_in(199),32));
    c_in200 <= std_logic_vector(to_signed(c_in(200),32));
    c_in201 <= std_logic_vector(to_signed(c_in(201),32));
    c_in202 <= std_logic_vector(to_signed(c_in(202),32));
    c_in203 <= std_logic_vector(to_signed(c_in(203),32));
    c_in204 <= std_logic_vector(to_signed(c_in(204),32));
    c_in205 <= std_logic_vector(to_signed(c_in(205),32));
    c_in206 <= std_logic_vector(to_signed(c_in(206),32));
    c_in207 <= std_logic_vector(to_signed(c_in(207),32));
    c_in208 <= std_logic_vector(to_signed(c_in(208),32));
    c_in209 <= std_logic_vector(to_signed(c_in(209),32));
    c_in210 <= std_logic_vector(to_signed(c_in(210),32));
    c_in211 <= std_logic_vector(to_signed(c_in(211),32));
    c_in212 <= std_logic_vector(to_signed(c_in(212),32));
    c_in213 <= std_logic_vector(to_signed(c_in(213),32));
    c_in214 <= std_logic_vector(to_signed(c_in(214),32));
    c_in215 <= std_logic_vector(to_signed(c_in(215),32));
    c_in216 <= std_logic_vector(to_signed(c_in(216),32));
    c_in217 <= std_logic_vector(to_signed(c_in(217),32));
    c_in218 <= std_logic_vector(to_signed(c_in(218),32));
    c_in219 <= std_logic_vector(to_signed(c_in(219),32));
    c_in220 <= std_logic_vector(to_signed(c_in(220),32));
    c_in221 <= std_logic_vector(to_signed(c_in(221),32));
    c_in222 <= std_logic_vector(to_signed(c_in(222),32));
    c_in223 <= std_logic_vector(to_signed(c_in(223),32));
    c_in224 <= std_logic_vector(to_signed(c_in(224),32));
    c_in225 <= std_logic_vector(to_signed(c_in(225),32));
    c_in226 <= std_logic_vector(to_signed(c_in(226),32));
    c_in227 <= std_logic_vector(to_signed(c_in(227),32));
    c_in228 <= std_logic_vector(to_signed(c_in(228),32));
    c_in229 <= std_logic_vector(to_signed(c_in(229),32));
    c_in230 <= std_logic_vector(to_signed(c_in(230),32));
    c_in231 <= std_logic_vector(to_signed(c_in(231),32));
    c_in232 <= std_logic_vector(to_signed(c_in(232),32));
    c_in233 <= std_logic_vector(to_signed(c_in(233),32));
    c_in234 <= std_logic_vector(to_signed(c_in(234),32));
    c_in235 <= std_logic_vector(to_signed(c_in(235),32));
    c_in236 <= std_logic_vector(to_signed(c_in(236),32));
    c_in237 <= std_logic_vector(to_signed(c_in(237),32));
    c_in238 <= std_logic_vector(to_signed(c_in(238),32));
    c_in239 <= std_logic_vector(to_signed(c_in(239),32));
 
    --Il mio sistema mi processa i risultati in std_logic_vector ma io voglio scriverli sul file come interi.
    c_out(0) <= to_integer(signed(c_out0));
    c_out(1) <= to_integer(signed(c_out1));
    c_out(2) <= to_integer(signed(c_out2));
    c_out(3) <= to_integer(signed(c_out3));
    c_out(4) <= to_integer(signed(c_out4));
    c_out(5) <= to_integer(signed(c_out5));
    c_out(6) <= to_integer(signed(c_out6));
    c_out(7) <= to_integer(signed(c_out7));
    c_out(8) <= to_integer(signed(c_out8));
    c_out(9) <= to_integer(signed(c_out9));
    c_out(10) <= to_integer(signed(c_out10));
    c_out(11) <= to_integer(signed(c_out11));
    c_out(12) <= to_integer(signed(c_out12));
    c_out(13) <= to_integer(signed(c_out13));
    c_out(14) <= to_integer(signed(c_out14));
    c_out(15) <= to_integer(signed(c_out15));
    c_out(16) <= to_integer(signed(c_out16));
    c_out(17) <= to_integer(signed(c_out17));
    c_out(18) <= to_integer(signed(c_out18));
    c_out(19) <= to_integer(signed(c_out19));
    c_out(20) <= to_integer(signed(c_out20));
    c_out(21) <= to_integer(signed(c_out21));
    c_out(22) <= to_integer(signed(c_out22));
    c_out(23) <= to_integer(signed(c_out23));
    c_out(24) <= to_integer(signed(c_out24));
    c_out(25) <= to_integer(signed(c_out25));
    c_out(26) <= to_integer(signed(c_out26));
    c_out(27) <= to_integer(signed(c_out27));
    c_out(28) <= to_integer(signed(c_out28));
    c_out(29) <= to_integer(signed(c_out29));
    c_out(30) <= to_integer(signed(c_out30));
    c_out(31) <= to_integer(signed(c_out31));
    c_out(32) <= to_integer(signed(c_out32));
    c_out(33) <= to_integer(signed(c_out33));
    c_out(34) <= to_integer(signed(c_out34));
    c_out(35) <= to_integer(signed(c_out35));
    c_out(36) <= to_integer(signed(c_out36));
    c_out(37) <= to_integer(signed(c_out37));
    c_out(38) <= to_integer(signed(c_out38));
    c_out(39) <= to_integer(signed(c_out39));
    c_out(40) <= to_integer(signed(c_out40));
    c_out(41) <= to_integer(signed(c_out41));
    c_out(42) <= to_integer(signed(c_out42));
    c_out(43) <= to_integer(signed(c_out43));
    c_out(44) <= to_integer(signed(c_out44));
    c_out(45) <= to_integer(signed(c_out45));
    c_out(46) <= to_integer(signed(c_out46));
    c_out(47) <= to_integer(signed(c_out47));
    c_out(48) <= to_integer(signed(c_out48));
    c_out(49) <= to_integer(signed(c_out49));
    c_out(50) <= to_integer(signed(c_out50));
    c_out(51) <= to_integer(signed(c_out51));
    c_out(52) <= to_integer(signed(c_out52));
    c_out(53) <= to_integer(signed(c_out53));
    c_out(54) <= to_integer(signed(c_out54));
    c_out(55) <= to_integer(signed(c_out55));
    c_out(56) <= to_integer(signed(c_out56));
    c_out(57) <= to_integer(signed(c_out57));
    c_out(58) <= to_integer(signed(c_out58));
    c_out(59) <= to_integer(signed(c_out59));
    c_out(60) <= to_integer(signed(c_out60));
    c_out(61) <= to_integer(signed(c_out61));
    c_out(62) <= to_integer(signed(c_out62));
    c_out(63) <= to_integer(signed(c_out63));
    c_out(64) <= to_integer(signed(c_out64));
    c_out(65) <= to_integer(signed(c_out65));
    c_out(66) <= to_integer(signed(c_out66));
    c_out(67) <= to_integer(signed(c_out67));
    c_out(68) <= to_integer(signed(c_out68));
    c_out(69) <= to_integer(signed(c_out69));
    c_out(70) <= to_integer(signed(c_out70));
    c_out(71) <= to_integer(signed(c_out71));
    c_out(72) <= to_integer(signed(c_out72));
    c_out(73) <= to_integer(signed(c_out73));
    c_out(74) <= to_integer(signed(c_out74));
    c_out(75) <= to_integer(signed(c_out75));
    c_out(76) <= to_integer(signed(c_out76));
    c_out(77) <= to_integer(signed(c_out77));
    c_out(78) <= to_integer(signed(c_out78));
    c_out(79) <= to_integer(signed(c_out79));
    c_out(80) <= to_integer(signed(c_out80));
    c_out(81) <= to_integer(signed(c_out81));
    c_out(82) <= to_integer(signed(c_out82));
    c_out(83) <= to_integer(signed(c_out83));
    c_out(84) <= to_integer(signed(c_out84));
    c_out(85) <= to_integer(signed(c_out85));
    c_out(86) <= to_integer(signed(c_out86));
    c_out(87) <= to_integer(signed(c_out87));
    c_out(88) <= to_integer(signed(c_out88));
    c_out(89) <= to_integer(signed(c_out89));
    c_out(90) <= to_integer(signed(c_out90));
    c_out(91) <= to_integer(signed(c_out91));
    c_out(92) <= to_integer(signed(c_out92));
    c_out(93) <= to_integer(signed(c_out93));
    c_out(94) <= to_integer(signed(c_out94));
    c_out(95) <= to_integer(signed(c_out95));
    c_out(96) <= to_integer(signed(c_out96));
    c_out(97) <= to_integer(signed(c_out97));
    c_out(98) <= to_integer(signed(c_out98));
    c_out(99) <= to_integer(signed(c_out99));
    c_out(100) <= to_integer(signed(c_out100));
    c_out(101) <= to_integer(signed(c_out101));
    c_out(102) <= to_integer(signed(c_out102));
    c_out(103) <= to_integer(signed(c_out103));
    c_out(104) <= to_integer(signed(c_out104));
    c_out(105) <= to_integer(signed(c_out105));
    c_out(106) <= to_integer(signed(c_out106));
    c_out(107) <= to_integer(signed(c_out107));
    c_out(108) <= to_integer(signed(c_out108));
    c_out(109) <= to_integer(signed(c_out109));
    c_out(110) <= to_integer(signed(c_out110));
    c_out(111) <= to_integer(signed(c_out111));
    c_out(112) <= to_integer(signed(c_out112));
    c_out(113) <= to_integer(signed(c_out113));
    c_out(114) <= to_integer(signed(c_out114));
    c_out(115) <= to_integer(signed(c_out115));
    c_out(116) <= to_integer(signed(c_out116));
    c_out(117) <= to_integer(signed(c_out117));
    c_out(118) <= to_integer(signed(c_out118));
    c_out(119) <= to_integer(signed(c_out119));
    c_out(120) <= to_integer(signed(c_out120));
    c_out(121) <= to_integer(signed(c_out121));
    c_out(122) <= to_integer(signed(c_out122));
    c_out(123) <= to_integer(signed(c_out123));
    c_out(124) <= to_integer(signed(c_out124));
    c_out(125) <= to_integer(signed(c_out125));
    c_out(126) <= to_integer(signed(c_out126));
    c_out(127) <= to_integer(signed(c_out127));
    c_out(128) <= to_integer(signed(c_out128));
    c_out(129) <= to_integer(signed(c_out129));
    c_out(130) <= to_integer(signed(c_out130));
    c_out(131) <= to_integer(signed(c_out131));
    c_out(132) <= to_integer(signed(c_out132));
    c_out(133) <= to_integer(signed(c_out133));
    c_out(134) <= to_integer(signed(c_out134));
    c_out(135) <= to_integer(signed(c_out135));
    c_out(136) <= to_integer(signed(c_out136));
    c_out(137) <= to_integer(signed(c_out137));
    c_out(138) <= to_integer(signed(c_out138));
    c_out(139) <= to_integer(signed(c_out139));
    c_out(140) <= to_integer(signed(c_out140));
    c_out(141) <= to_integer(signed(c_out141));
    c_out(142) <= to_integer(signed(c_out142));
    c_out(143) <= to_integer(signed(c_out143));
    c_out(144) <= to_integer(signed(c_out144));
    c_out(145) <= to_integer(signed(c_out145));
    c_out(146) <= to_integer(signed(c_out146));
    c_out(147) <= to_integer(signed(c_out147));
    c_out(148) <= to_integer(signed(c_out148));
    c_out(149) <= to_integer(signed(c_out149));
    c_out(150) <= to_integer(signed(c_out150));
    c_out(151) <= to_integer(signed(c_out151));
    c_out(152) <= to_integer(signed(c_out152));
    c_out(153) <= to_integer(signed(c_out153));
    c_out(154) <= to_integer(signed(c_out154));
    c_out(155) <= to_integer(signed(c_out155));
    c_out(156) <= to_integer(signed(c_out156));
    c_out(157) <= to_integer(signed(c_out157));
    c_out(158) <= to_integer(signed(c_out158));
    c_out(159) <= to_integer(signed(c_out159));
    c_out(160) <= to_integer(signed(c_out160));
    c_out(161) <= to_integer(signed(c_out161));
    c_out(162) <= to_integer(signed(c_out162));
    c_out(163) <= to_integer(signed(c_out163));
    c_out(164) <= to_integer(signed(c_out164));
    c_out(165) <= to_integer(signed(c_out165));
    c_out(166) <= to_integer(signed(c_out166));
    c_out(167) <= to_integer(signed(c_out167));
    c_out(168) <= to_integer(signed(c_out168));
    c_out(169) <= to_integer(signed(c_out169));
    c_out(170) <= to_integer(signed(c_out170));
    c_out(171) <= to_integer(signed(c_out171));
    c_out(172) <= to_integer(signed(c_out172));
    c_out(173) <= to_integer(signed(c_out173));
    c_out(174) <= to_integer(signed(c_out174));
    c_out(175) <= to_integer(signed(c_out175));
    c_out(176) <= to_integer(signed(c_out176));
    c_out(177) <= to_integer(signed(c_out177));
    c_out(178) <= to_integer(signed(c_out178));
    c_out(179) <= to_integer(signed(c_out179));
    c_out(180) <= to_integer(signed(c_out180));
    c_out(181) <= to_integer(signed(c_out181));
    c_out(182) <= to_integer(signed(c_out182));
    c_out(183) <= to_integer(signed(c_out183));
    c_out(184) <= to_integer(signed(c_out184));
    c_out(185) <= to_integer(signed(c_out185));
    c_out(186) <= to_integer(signed(c_out186));
    c_out(187) <= to_integer(signed(c_out187));
    c_out(188) <= to_integer(signed(c_out188));
    c_out(189) <= to_integer(signed(c_out189));
    c_out(190) <= to_integer(signed(c_out190));
    c_out(191) <= to_integer(signed(c_out191));
    c_out(192) <= to_integer(signed(c_out192));
    c_out(193) <= to_integer(signed(c_out193));
    c_out(194) <= to_integer(signed(c_out194));
    c_out(195) <= to_integer(signed(c_out195));
    c_out(196) <= to_integer(signed(c_out196));
    c_out(197) <= to_integer(signed(c_out197));
    c_out(198) <= to_integer(signed(c_out198));
    c_out(199) <= to_integer(signed(c_out199));
    c_out(200) <= to_integer(signed(c_out200));
    c_out(201) <= to_integer(signed(c_out201));
    c_out(202) <= to_integer(signed(c_out202));
    c_out(203) <= to_integer(signed(c_out203));
    c_out(204) <= to_integer(signed(c_out204));
    c_out(205) <= to_integer(signed(c_out205));
    c_out(206) <= to_integer(signed(c_out206));
    c_out(207) <= to_integer(signed(c_out207));
    c_out(208) <= to_integer(signed(c_out208));
    c_out(209) <= to_integer(signed(c_out209));
    c_out(210) <= to_integer(signed(c_out210));
    c_out(211) <= to_integer(signed(c_out211));
    c_out(212) <= to_integer(signed(c_out212));
    c_out(213) <= to_integer(signed(c_out213));
    c_out(214) <= to_integer(signed(c_out214));
    c_out(215) <= to_integer(signed(c_out215));
    c_out(216) <= to_integer(signed(c_out216));
    c_out(217) <= to_integer(signed(c_out217));
    c_out(218) <= to_integer(signed(c_out218));
    c_out(219) <= to_integer(signed(c_out219));
    c_out(220) <= to_integer(signed(c_out220));
    c_out(221) <= to_integer(signed(c_out221));
    c_out(222) <= to_integer(signed(c_out222));
    c_out(223) <= to_integer(signed(c_out223));
    c_out(224) <= to_integer(signed(c_out224));
    c_out(225) <= to_integer(signed(c_out225));
    c_out(226) <= to_integer(signed(c_out226));
    c_out(227) <= to_integer(signed(c_out227));
    c_out(228) <= to_integer(signed(c_out228));
    c_out(229) <= to_integer(signed(c_out229));
    c_out(230) <= to_integer(signed(c_out230));
    c_out(231) <= to_integer(signed(c_out231));
    c_out(232) <= to_integer(signed(c_out232));
 

read_file:
    process
        file stim_file : text open READ_MODE is "C:\Users\loren\OneDrive\Documenti\MATLAB\Fond. Controlli\Sinusoide_noise.txt";
        variable ILine : LINE;
        variable In_c : integer_vector(239 downto 0); 
        begin
            readline(stim_file, ILine);

            for i in In_c'range loop
                read(ILine, In_c(239-i));    
            end loop;

            for i in c_in'range loop
                c_in(239-i) <= In_c(239-i);
            end loop;        

            wait for 100 ns;
    end process read_file;


  write_file:
      process is file output_file : TEXT open WRITE_MODE is "C:\Users\loren\OneDrive\Documenti\MATLAB\Fond. Controlli\Media_mobile_file.txt";
      variable OLine : LINE;    
          begin
              wait for 2450 ns;
        
              for i in c_out'range loop                                     
                  write(OLine, c_out(232-i));            
                  writeline(output_file, OLine);                  
              end loop;                                         
          file_close(output_file);        
      end process write_file;



end Behavioral;
