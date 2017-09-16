%{
	#include<stdio.h>
	#include<string.h>
	#include<math.h>
	#include"y.tab.h"
	#include"hdr.h"

	int regno1=-1,regno2=-1,loc=0;
	int sym_count=0,fref=0;
	char locctr[8];
	struct symtable symtab[20];
	struct for_ref_table forward_ref[6];
	/*opcode,noopcode, {flag,bin,leng}{flag,bin,leng}{flag,bin,leng}*/
	//only for add r8-r8 , r16-r16 , r8-imm8 ,r16-imm16 , reg8-mem8 , mem8-reg8 , reg16-mem16 , mem16-reg16 not implementing mem-imm as of now

	struct optable optab[MAX_LEN]={	{"add",8,0,"000000",2,1,"000000",2,2,"100000",3,3,"100000",4,4,"000000",2,5,"000000",2,6,"000000",2,7,"000000",2},
					{"sub",8,0,"001010",2,1,"001010",2,2,"100000",3,3,"100000",4,4,"001010",2,5,"001010",2,6,"001010",2,7,"001010",2},
					{"adc",8,0,"000100",2,1,"000100",2,2,"100000",3,3,"100000",4,4,"000100",2,5,"000100",2,6,"000100",2,7,"000100",2},
					{"ssb",8,0,"000110",2,1,"000110",2,2,"100000",3,3,"100000",4,4,"000110",2,5,"000110",2,6,"000110",2,7,"000110",2},
					{"cmp",8,0,"001110",2,1,"001110",2,2,"100000",3,3,"100000",4,4,"001110",2,5,"001110",2,6,"001110",2,7,"001110",2},
					{"and",8,0,"001000",2,1,"001000",2,2,"1000000",3,3,"1000000",4,4,"001000",2,5,"001000",2,6,"001000",2,7,"001000",2},
					{"or" ,8,0,"000010",2,1,"000010",2,2,"1000000",3,3,"1000000",4,4,"000010",2,5,"000010",2,6,"000010",2,7,"000010",2},
					{"xor",8,0,"001100",2,1,"001100",2,2,"1000000",3,3,"1000000",4,4,"001100",2,5,"001100",2,6,"001100",2,7,"001100",2},
					{"mov",10,0,"100010",2,1,"100010",2,2,"1100011",3,3,"1100011",4,4,"100010",2,5,"100010",2,6,"100010",2,7,"100010",2,10,"10001100",2,11,"10001110",2},
					
					{"mul",2,8,"1111011",2,9,"1111011",2},
					{"div",2,8,"1111011",2,9,"1111011",2},
					{"neg",2,8,"1111011",2,9,"1111011",2},
					{"not",2,8,"1111011",2,9,"1111011",2},
					{"lahf",1,12,"10011111",1},
					{"sahf",1,12,"10011110",1},
					{"pushf",1,12,"10011100",1},
					{"popf",1,12,"10011101",1},
					{"aaa",1,12,"00110111",1},
					{"daa",1,12,"00100111",1},
					{"aas",1,12,"00111111",1},
					{"das",1,12,"00101111",1},
					{"cbw",1,12,"10011000",1},
					{"cwd",1,12,"10011001",1},
					{"into",1,12,"11001110",1},
					{"aaa",1,12,"00110111",1},
					{"clc",1,12,"11111000",1},
					{"cmc",1,12,"11110101",1},
					{"stc",1,12,"11111001",1},
					{"cld",1,12,"11111100",1},
					{"std",1,12,"11111101",1},
					{"cli",1,12,"11111010",1},
					{"sti",1,12,"11111011",1},
					{"hlt",1,12,"11110100",1},
					{"int",1,12,"11001101",1},

					{"je", 1,13,"01110100",2},
					{"jg", 1,13,"01110100",2},
					{"jl", 1,13,"01111100",2},
					{"jnge", 1,13,"01111100",2},
					{"jle", 1,13,"01111110",2},
					{"jng", 1,13,"01111110",2},
					{"jb", 1,13,"01110010",2},
					{"jnae", 1,13,"01110010",2},
					{"jbe", 1,13,"01110110",2},
					{"jna", 1,13,"01110110",2},
					{"jp", 1,13,"01111010",2},
					{"jpe", 1,13,"01111010",2},
					{"jo", 1,13,"01110000",2},
					{"js", 1,13,"01111000",2},
					{"jne", 1,13,"01110101",2},
					{"jnz", 1,13,"01110101",2},
					{"jnl", 1,13,"01111101",2},
					{"jge", 1,13,"01111101",2},
					{"jnle", 1,13,"01111111",2},
					{"jg", 1,13,"01111111",2},
					{"jnb", 1,13,"01110011",2},
					{"jae", 1,13,"01110011",2},
					{"jnbe", 1,13,"01110111",2},
					{"ja", 1,13,"01110111",2},
					{"jnp", 1,13,"01111011",2},
					{"jpo", 1,13,"01111011",2},
					{"jno", 1,13,"01110001",2},
					{"jns", 1,13,"01111001",2},
					{"loop", 1,13,"11100010",2},
					{"loopz", 1,13,"11100001",2},
					{"loope", 1,13,"11100001",2},
					{"loopnz", 1,13,"11100000",2},
					{"loopne", 1,13,"11100000",2},
					{"jcxz", 1,13,"11001101",2}

				};  
	

	void dec2bin()
	{
		int decdata=atoi(data);//char to decimal
		int l=strlen(data);
		int bit,k,pos;
		char abit;
		if(decdata<=255)
		{
		   databin[8]='\0';
		   pos=7;
		}
		else
		{
		   databin[16]='\0';
		   pos=15;
		}
		while(decdata!=0)
		{
			bit = decdata%2;
			decdata = decdata/2;
			//convert int bit to char bit
			abit=(bit==1)?'1':'0';
			//mov abit to char array
			databin[pos--]=abit;
		}
		for(k=0;k<=pos;k++)
		{
			databin[k]='0';

		}
	}


	void hex2bin()
	{
		int l=strlen(data),lo,index;
		char code[5];
		if(l==1||l==3)
		{
			strcpy(databin,"0000");
		}

		lo=strlen(databin);    //stores length of obj
		for(index=0;data[index]!='\0';index++)
		{
			switch(data[index])
			{
				case '0':strcpy(code,"0000");break;
				case '1':strcpy(code,"0001");break;
				case '2':strcpy(code,"0010");break;
				case '3':strcpy(code,"0011");break;
				case '4':strcpy(code,"0100");break;
				case '5':strcpy(code,"0101");break;
				case '6':strcpy(code,"0110");break;
				case '7':strcpy(code,"0111");break;
				case '8':strcpy(code,"1000");break;
				case '9':strcpy(code,"1001");break;
				case 'a':strcpy(code,"1010");break;
				case 'b':strcpy(code,"1011");break;
				case 'c':strcpy(code,"1100");break;
				case 'd':strcpy(code,"1101");break;
				case 'e':strcpy(code,"1110");break;
				case 'f':strcpy(code,"1111");break;

			}
			strcat(databin,code);
		}
	
	}

	void decorhex2bin()
	{
		strcpy(databin,"\0");
		int l=strlen(data);
		if(data[l-1]=='h')
		{
			printf("Hexadecimal\n");
			//remove h and put '\0';
			data[l-1]='\0';
			hex2bin();
		}
		else
		{
			printf("Decimal\n");
			dec2bin();
		}
	}




	void get_regno(int n,char *reg)
	{
		switch(n)
		{
			case 0:strcpy(reg,"000");break;
			case 1:strcpy(reg,"001");break;
			case 2:strcpy(reg,"010");break;
			case 3:strcpy(reg,"011");break;
			case 4:strcpy(reg,"100");break;
			case 5:strcpy(reg,"101");break;
			case 6:strcpy(reg,"110");break;
			case 7:strcpy(reg,"111");break;
		}
	}


	void get_objcode7()
	{
		char idv[4],reg[4];
		/*find w*/
		if(flag_bit==2||flag_bit==8)
			strcat(object_code,"0"); //w=0 for 8 bits
		else if(flag_bit==3||flag_bit==9)
			strcat(object_code,"1"); //w=1 for 16 bit
		/*find mod*/
		/*we use register mode so mod value is always 11*/
		strcat(object_code,"11");
		/*find the inst dependent value*/
		get_regno(instno,idv);
		strcat(object_code,idv);
		/*find r/m value*/
		get_regno(regno2,reg);
		strcat(object_code,reg);

	}

	void find_missing_codes(struct node temp)
	{
		/*node has = char opcode[10];   char bin_eqv[8];  int regflag;      char mod[2];     char rbm[3];    char reg[3];      char data[20];*/
		/*flag_bit can be used*/
		char s[2],d[2],w[2],mod[3],reg[4],dbi[4];
		int l=strlen(temp.bin_eqv);
		/*based on the length of the opcode switch to appropiate case*/
		switch(l)
		{	
			case 6: 					//valid for reg-reg for all in add,sub,xor etc.....and reg-imm for only add not xor,or,and
				if(flag_bit==0||flag_bit==1)		//0 or 1 means reg-reg
				{	/*This case is for reg to reg instructions*/ 
					/* format is = xxxxxxdw mmregr/m */
					/*For this format d is always 1 as we are moving data to the first register*/
					/*w=0 for 8 bit and w=1 for 16 bit*/
					strcpy(object_code,temp.bin_eqv);
					strcpy(d,"1");
					if(flag_bit == reg16_reg16)
						strcpy(w,"1");
					else if(flag_bit == reg8_reg8)
						strcpy(w,"0");
					else;
					strcat(object_code,d);
					strcat(object_code,w);
					//first eight bit is ready....
					/*we found out d and w...now we have to find mode reg and r/m....*/
					/*we know flag_bit indicates reg16 or reg8.....and we have code of regs stored in regn01 and regno2..*/
				
					/*we use register mode....so mm=11*/
					strcpy(mod,"11");
					strcat(object_code,mod);
					/*find the first register code regno1*/
					get_regno(regno1,reg);
					strcat(object_code,reg);
					/*find the 2nd register code regno2*/
					get_regno(regno2,reg);
					strcat(object_code,reg);
				}
				else if(flag_bit==2||flag_bit==3)		//2 or 3 means reg-imm
				{
					/*This case is for reg to imm instructions*/
					/* format is = xxxxxxsw mmregr/m data data*/ /*here reg is fixed value and depends on opcode*/
					/*s bit is 0 for .....*/
					strcpy(object_code,temp.bin_eqv);
					strcpy(s,"0");
					strcat(object_code,s);
					/*object code has now 7 bits*/
					/*call a function get_objcode to get other details like w,mod,inst dependent value,r/m*/
					get_objcode7();
					/*append databin to object_code*/
					strcat(object_code,databin);
				}
				else if(flag_bit>=4&&flag_bit<=7)     //4,5,6,7 indicates reg-mem or mem reg operations
				{
					/* Format xxxxxxdw mm reg r/m */
					strcpy(object_code,temp.bin_eqv);
					/*finding d for ( reg-mem   d = 1 )   else 0*/
					if(flag_bit==4||flag_bit==6)
						strcpy(d,"1");
					else
						strcpy(d,"0");
					if(flag_bit==4||flag_bit==5)
						strcpy(w,"0");
					else
						strcpy(w,"1");
					strcat(object_code,d);
					strcat(object_code,w);
					/*To find mm reg r/m */
					strcpy(mod,"00");
					strcat(object_code,mod);
					/*reg number is stored in regno2.....so get the register number and append to object_code*/
					get_regno(regno2,reg);
					strcat(object_code,reg);
					/*r/m value depends on the addressing mode for [bx] r/m =111*/
					get_regno(addmodno,dbi);
					strcat(object_code,dbi);
					
					/*we are done with reg-mem inst but if dierct address is used [1234h] then we need to add hex value for that*/
					/*we can use either dir_add_flag or addmodno to compare*/
					if(dir_add_flag==1)
					{
						//clear databin
						strcpy(databin,"");
						//add direct address value....
						/*modify data value---->  lower byte then higher byte*/
						data[5]='\0';data[0]=data[3];data[3]=data[2];data[2]=data[1];data[1]=data[4];data[4]='h';
						/*find out binary value of data and store in char array*/
						/*Data dec/hex is available in global data array*/
						decorhex2bin();
						//binary data is in data bin
						printf("bin = %s\n",databin);
						strcat(object_code,databin);
					}
				}



				break;
			case 7:			//
				/*if opcode = and or xor -----> 7w mod---r/m data data*/
				/*if opcode = mul div    -----> 7w mod---r/m*/
				/*if acc-imm is implemented then add,adc,sub,ssb,cmp,and,or,xor -------> 7w data data*/
				if(flag_bit==2||flag_bit==3)			//2 or 3 means reg-imm for and or xor
				{
					strcpy(object_code,temp.bin_eqv);
					get_objcode7();
					/*append databin to object_code*/
					strcat(object_code,databin);
				}
				else if(flag_bit==8||flag_bit==9)				//8 or 9 indicates mul div neg not inst
				{
					strcpy(object_code,temp.bin_eqv);
					get_objcode7();
					
					
				}
				break;

			case 8:
				/*This case will cover all mov segreg-reg , type1 , jump instructions*/
				if(flag_bit==10||flag_bit==11)
				{
					strcpy(object_code,temp.bin_eqv);
					//first eight bit is ready....
					/*we know flag_bit indicates reg16.....and we have code of regs stored in regn01 and regno2..*/
				
					/*we use register mode....so mm=11*/
					strcpy(mod,"11");
					strcat(object_code,mod);
					/*find the segment register.... code in segreg*/
					get_regno(segreg,reg);
					strcat(object_code,reg);
					/*find the 16 bit register... code regno2*/
					get_regno(regno2,reg);
					strcat(object_code,reg);
					printf("segreg = %s",object_code);
				}
				else if(flag_bit == 12)
				{
					/*copy opcode directly*/
					strcpy(object_code,temp.bin_eqv);
				}
				else if(flag_bit == 13)   //for jump instructions
				{
					strcpy(object_code,temp.bin_eqv);
					//first eight bit is ready....now we need to find 8-bit displacement
					search_symtab();
					/*we got the displacement in binary.... it is in displace array*/
					strcat(object_code,displace);
					
				}
				break;
				
		}
				
	}
	 
	int search_optab2(char *opcode,int flag_bit) //returns -1 if opcode is not found
	{
		int i,j;
		for(i=0;i<MAX_LEN;i++)
		{
			if(strcmp(optab[i].opcode,opcode)==0)
			{
				/*you can use if else loop to check flag _bit....for type1 inst*/
				for(j=0;j<optab[i].n_o_opcode;j++)
				{
					if(optab[i].info[j].flag==flag_bit)
					{
						struct node temp;
						strcpy(temp.opcode,opcode);
						strcpy(temp.bin_eqv,optab[i].info[j].bin_eqv);
						temp.regflag=reg_flag;
						find_missing_codes(temp);
						printf("\n\nobject code = %s\n\n",object_code);
						break;
						
					}
				}
			}
		}
	}

	void find_locctr(int loc)
	{
		/*decimal to hex conversion*/
		/*First convert decimal to 16 bit binary then to hexadecimal*/
		int x=loc,bit,pos,k;
		char abit;
		locctr_bin[16]='\0';
		pos=15;
		while(x!=0)
		{
			bit = x%2;
			x = x/2;
			//convert int bit to char bit
			abit=(bit==1)?'1':'0';
			//mov abit to char array
			locctr_bin[pos--]=abit;
		}
		for(k=0;k<=pos;k++)
		{
			locctr_bin[k]='0';

		}
		/*locctr_bin has binary value of location counter...convert into hex*/
		get_hex_obj(0);
		/*now locctr has hexadecimal value*/
	}

	void get_hex_obj(int flag)
	{
		char ch[2],nibble[5],c;
		int r,place_val=0,dec_val=0,k=0,x,i;
		if(flag==1)
			strcpy(hex_obj,"");
		else
			strcpy(locctr,"");
		/*create nibbles from obj_code or locctr_bin*/
		//printf("\n\nfunction is visited\n\n");
		//printf("IN FUNCTION OBJ = %s\n",object_code);
		if(flag==1)
			c=object_code[0];
		else
			c=locctr_bin[0];
		for(i=0;c!='\0';)
		{
			
			nibble[k++]=(flag==1)?object_code[i]:locctr_bin[i];
			//printf("\n\tnibble[%d] = %c\n",k-1,nibble[k-1]);
			if(k==4)
			{
				nibble[k]='\0';
				printf("\nNIBBLE is %s\n",nibble);
				k=0;
				place_val=0,dec_val=0;
				x=atoi(nibble);
				//convert to decimal
				while(x!=0)
				{
					r=x%10;
					x=x/10;
					dec_val+=(int)(pow(2.0,(float)place_val))*r;
					place_val++;
				}
				if(dec_val<=9)
				{
					ch[0]=dec_val+48;
					ch[1]='\0';
					//printf("hexval  is = %s\n",ch);
					//strcat(hex_obj,ch);
				}
				else
				{
					ch[0]=dec_val-9+64;
					ch[1]='\0';
					//strcat(hex_obj,ch);
					//printf("hexval  is = %s\n",ch);
				}
				if(flag==1)
					strcat(hex_obj,ch);
				else
					strcat(locctr,ch);
			}
			i++;
			if(flag==1)
				c=object_code[i];
			else
				c=locctr_bin[i];
		}
		if(flag==1)
			strcat(hex_obj,"\0");	
		else
			strcat(locctr,"h\0");
		
	}


	int enter_symtab()
	{
		int i;
		for(i=0;i<sym_count;i++)
		{
			if(strcmp(symtab[i].symbol,symbol)==0)
			{
				printf("Duplicate symbol\n");
				return 0;
			}
		}	
		/*Enter the symbol into the SYMTAB*/
		strcpy(symtab[i].symbol,symbol);
		symtab[i].address=loc;
		sym_count++;
		printf("symbol  = %s\naddress = %d\nsymval = %d\n",symtab[i].symbol,symtab[i].address,sym_count);
	}
	
	int search_symtab()
	{
		/*while searching for label in symtab....if we get the value of label then we find the displacement.....
		  else we will put xxxxxxxx in displace array*/
		int i,t_loc,x,bit,pos,k,index;
		char abit;
		for(i=0;i<sym_count;i++)
		{
			if(strcmp(symtab[i].symbol,symbol)==0)
			{
				disp = loc + 2 - symtab[i].address;//displacement in decimal
				/*convert into 8-bit binary*/
				x=disp;
				displace[8]='\0';
				pos=7;
				while(x!=0)
				{
					bit = x%2;
					x = x/2;
					//convert int bit to char bit
					abit=(bit==1)?'1':'0';
					//mov abit to char array
					displace[pos--]=abit;
				}
				for(k=0;k<=pos;k++)
				{
					displace[k]='0';

				}
				/*now displace has binary value....find its 2's compliment*/
				for(index=0;index<8;index++)
					displace[index]=((int)displace[index]-48==0)?'1':'0';
				for(index=7;index>=0;index--)
				{
					if(displace[index]=='0')
					{
						displace[index]='1';
						break;
					}
					else
						displace[index]='0';
				}


				fr=0;
				return 0;
			}
		}
		/*if control reaches here than it means it did not find the symbol mentioned....so put 00000000 in displace*/
		strcpy(displace,"00000000");
		/*fref =0 for the first time*/
		strcpy(forward_ref[fref].symbol,symbol);
		forward_ref[fref].ptr=yyout;
		forward_ref[fref].offset=ftell(yyout);
		forward_ref[fref].loc=loc+2;
		strcpy(forward_ref[fref].object_code,object_code);  //disp unknown , not yet added
		fprintf(fp1,"%d\t\t%s\t\t%p\t\t%s\t\t%d\n",fref,forward_ref[fref].symbol,forward_ref[fref].ptr,forward_ref[fref].object_code,forward_ref[fref].loc);
		fref++;
		fr=1;
		return 0;
	}

	
%}
%%
[\n]						{strcpy(inst,"\0");return newline;}
"mov"						{instno=0;strcpy(opcode,yytext);strcat(inst,yytext);return TYPE2;}
"lahf"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE1;}
"sahf"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE1;}
"pushf"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE1;}
"pop"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE1;}
"aaa"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE1;}
"daa"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE1;}
"aas"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE1;}
"das"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE1;}
"cbw"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE1;}
"cwd"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE1;}
"into"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE1;}
"clc"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE1;}
"cmc"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE1;}
"stc"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE1;}
"cld"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE1;}
"std"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE1;}
"cli"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE1;}
"sti"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE1;}
"hlt"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE1;}
"int"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE4;}


"add"						{instno=0;strcpy(opcode,yytext);strcat(inst,yytext);return TYPE2;}
"or"						{instno=1;strcpy(opcode,yytext);strcat(inst,yytext);return TYPE2;}
"adc"						{instno=2;strcpy(opcode,yytext);strcat(inst,yytext);return TYPE2;}
"ssb"						{instno=3;strcpy(opcode,yytext);strcat(inst,yytext);return TYPE2;}
"and"						{instno=4;strcpy(opcode,yytext);strcat(inst,yytext);return TYPE2;}
"sub"						{instno=5;strcpy(opcode,yytext);strcat(inst,yytext);return TYPE2;}
"xor"						{instno=6;strcpy(opcode,yytext);strcat(inst,yytext);return TYPE2;}
"cmp"						{instno=7;strcpy(opcode,yytext);strcat(inst,yytext);return TYPE2;}


"je"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"jz"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"jl"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"jnge"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"jle"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"jng"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"jb"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"jnae"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"jbe"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"jna"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"jp"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"jpe"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"jo"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"js"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"jne"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"jnz"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"jnl"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"jge"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"jnle"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"jg"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"jnb"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"jae"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"jnbe"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"ja"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"jnp"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"jpo"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"jno"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"jns"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"loop"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"loopz"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"loope"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"loopnz"					{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"loopne"					{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}
"jcxz"						{strcpy(opcode,yytext);strcat(inst,yytext);return TYPE3;}



"mul"						{instno=4;strcpy(opcode,yytext);strcat(inst,yytext);return typemdnn;}
"div"						{instno=6;strcpy(opcode,yytext);strcat(inst,yytext);return typemdnn;}
"neg"						{instno=3;strcpy(opcode,yytext);strcat(inst,yytext);return typemdnn;}
"not"						{instno=2;strcpy(opcode,yytext);strcat(inst,yytext);return typemdnn;}


"@data"						{strcat(inst,yytext);return atdata;}


[ ][ ]*						{strcat(inst,yytext);return spaces;}
[,]						{strcat(inst,yytext);return comma;}


"AX"|"ax" 					{strcat(inst,yytext);regno1=regno2;regno2 = 0;return REGISTER16;}
"BX"|"bx" 					{strcat(inst,yytext);regno1=regno2;regno2 = 3;return REGISTER16;}
"CX"|"cx" 					{strcat(inst,yytext);regno1=regno2;regno2 = 1;return REGISTER16;}
"DX"|"dx" 					{strcat(inst,yytext);regno1=regno2;regno2 = 2;return REGISTER16;}

"SP"|"sp" 					{strcat(inst,yytext);regno1=regno2;regno2 = 4;return REGISTER16;}
"BP"|"bp" 					{strcat(inst,yytext);regno1=regno2;regno2 = 5;return REGISTER16;}
"SI"|"si" 					{strcat(inst,yytext);regno1=regno2;regno2 = 6;return REGISTER16;}
"DI"|"ci" 					{strcat(inst,yytext);regno1=regno2;regno2 = 7;return REGISTER16;}

"AL"|"al" 					{strcat(inst,yytext);regno1=regno2;regno2 = 0;return REGISTER8;}
"CL"|"cl" 					{strcat(inst,yytext);regno1=regno2;regno2 = 1;return REGISTER8;}
"DL"|"dl" 					{strcat(inst,yytext);regno1=regno2;regno2 = 2;return REGISTER8;}
"BL"|"bl" 					{strcat(inst,yytext);regno1=regno2;regno2 = 3;return REGISTER8;}
"AH"|"ah" 					{strcat(inst,yytext);regno1=regno2;regno2 = 4;return REGISTER8;}
"CH"|"ch" 					{strcat(inst,yytext);regno1=regno2;regno2 = 5;return REGISTER8;}
"DH"|"dh" 					{strcat(inst,yytext);regno1=regno2;regno2 = 6;return REGISTER8;}
"BH"|"bh" 					{strcat(inst,yytext);regno1=regno2;regno2 = 7;return REGISTER8;}

"ES"|"es" 					{strcat(inst,yytext);segreg = 0;return SEGREGISTER;}
"CS"|"cs" 					{strcat(inst,yytext);segreg = 1;return SEGREGISTER;}
"SS"|"ss" 					{strcat(inst,yytext);segreg = 2;return SEGREGISTER;}
"DS"|"ds" 					{strcat(inst,yytext);segreg = 3;return SEGREGISTER;}



"[bx][si]" 					{strcat(inst,yytext);dir_add_flag=0;addmodno = 0;return MEM;}
"[bx][di]" 					{strcat(inst,yytext);dir_add_flag=0;addmodno = 1;return MEM;}
"[bp][si]" 					{strcat(inst,yytext);dir_add_flag=0;addmodno = 2;return MEM;}
"[bp][di]" 					{strcat(inst,yytext);dir_add_flag=0;addmodno = 3;return MEM;}
"[si]" 						{strcat(inst,yytext);dir_add_flag=0;addmodno = 4;return MEM;}
"[di]" 						{strcat(inst,yytext);dir_add_flag=0;addmodno = 5;return MEM;}
"["[0-9a-f][0-9a-f][0-9a-f][0-9a-f][h]"]" 	{strcat(inst,yytext);strcpy(data,yytext);dir_add_flag=1;addmodno = 6;return MEM;}
"[bx]" 						{strcat(inst,yytext);dir_add_flag=0;addmodno = 7;return MEM;}



[0-9a-f][0-9a-f][0-9a-f][0-9a-f][h]		{strcpy(data,yytext);strcat(inst,yytext);return IMM16;}
[0-9][0-9][0-9][0-9]				{strcpy(data,yytext);strcat(inst,yytext);return IMM16;}
[0-9a-f][0-9a-f][h]				{strcpy(data,yytext);strcat(inst,yytext);return IMM8;}
[0-9][0-9]					{strcpy(data,yytext);strcat(inst,yytext);return IMM8;}


[a-zA-Z_][a-zA-Z0-9_]*				{strcat(inst,yytext);strcpy(symbol,yytext);return SYMBOL;}
[:]						{strcat(inst,yytext);return COLON;}

%%
