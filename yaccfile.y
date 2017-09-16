%{
	#include<stdio.h>
	#include<string.h>
	#include"hdr.h"
	char *str="\t\t\t";
	extern FILE *yyout,*yyin;
	extern char *yytext;
	extern struct optable optab[2];
	extern char locctr[8];
	int i;
	
%}
%token newline mov or adc ssb xor cmp spaces comma deceightbitoprnd REGISTER16 REGISTER8 SEGREGISTER MEM atdata IMM16 IMM8 TYPE1 TYPE2 TYPE3 typemdnn SYMBOL COLON TYPE4
%%
INPUT:INPUTLINE newline INPUT|INPUTLINE	newline		{printf("\n\nblah blah\n\n");}
;


INPUTLINE:mov spaces REGISTER16 comma atdata 		{printf("Recognised\n");fprintf(yyout,"%s",inst);fprintf(yyout,"%s",str);fprintf(yyout,"%s","object code");fprintf(yyout,"%s","\n");}



|TYPE2 spaces REGISTER16 comma SEGREGISTER			{
									fprintf(yyout,"%s",locctr);
									fprintf(yyout,"%s",str);

									/*set flag bit*/
									reg_flag=1;
									flag_bit=reg16_segreg;
									/*segreg = segreg and regno2 =reg*/
									search_optab2(opcode,flag_bit);
									get_hex_obj(1);
									printf("Recognised segreg\n");
									fprintf(yyout,"%s",inst);
									fprintf(yyout,"%s",str);
									fprintf(yyout,"%s",object_code);
									fprintf(yyout,"%s",str);
									fprintf(yyout,"%s",hex_obj);
									fprintf(yyout,"%s","\n");
									regno1=-1; regno2=-1;

									loc+=strlen(hex_obj)/2;
									find_locctr(loc);
								}


|TYPE2 spaces SEGREGISTER comma REGISTER16			{
									fprintf(yyout,"%s",locctr);
									fprintf(yyout,"%s",str);

									/*set flag bit*/
									reg_flag=1;
									flag_bit=segreg_reg16;
									search_optab2(opcode,flag_bit);
									get_hex_obj(1);
									printf("Recognised\n");
									fprintf(yyout,"%s",inst);
									fprintf(yyout,"%s",str);
									fprintf(yyout,"%s",object_code);
									fprintf(yyout,"%s",str);
									fprintf(yyout,"%s",hex_obj);
									fprintf(yyout,"%s","\n");
									regno1=-1; regno2=-1;

									loc+=strlen(hex_obj)/2;
									find_locctr(loc);
								}



|TYPE2 spaces REGISTER16 comma REGISTER16			{
									fprintf(yyout,"%s",locctr);
									fprintf(yyout,"%s",str);

									/*set flag bit*/
									reg_flag=2;
									flag_bit=reg16_reg16;
									search_optab2(opcode,flag_bit);
									get_hex_obj(1);
									printf("Recognised\n");
									fprintf(yyout,"%s",inst);
									fprintf(yyout,"%s",str);
									fprintf(yyout,"%s",object_code);
									fprintf(yyout,"%s",str);
									fprintf(yyout,"%s",hex_obj);
									fprintf(yyout,"%s","\n");
									regno1=-1; regno2=-1;

									loc+=strlen(hex_obj)/2;
									find_locctr(loc);
								}
|TYPE2 spaces REGISTER8 comma REGISTER8				{
									fprintf(yyout,"%s",locctr);
									fprintf(yyout,"%s",str);

									/*set flag bit*/
									reg_flag=2;
									flag_bit=reg8_reg8; //changed
									search_optab2(opcode,flag_bit);
									get_hex_obj(1);
									printf("Recognised\n");
									fprintf(yyout,"%s",inst);
									fprintf(yyout,"%s",str);
									fprintf(yyout,"%s",object_code);
									fprintf(yyout,"%s",str);
									fprintf(yyout,"%s",hex_obj);
									fprintf(yyout,"%s","\n");
									regno1=-1; regno2=-1;

									loc+=strlen(hex_obj)/2;
									find_locctr(loc);
								}


|TYPE2 spaces REGISTER16 comma IMM16				{
									fprintf(yyout,"%s",locctr);
									fprintf(yyout,"%s",str);

									/*set flag bit*/
									flag_bit=reg16_imm16;
								/*find out binary value of data and store in char array*/
								/*Data dec/hex is available in global data array*/
									decorhex2bin();
								//binary data is in data bin
								printf("bin = %s\n",databin);
								/*regno of reg used is in regno2*/
								/*call search_optab2*/
									search_optab2(opcode,flag_bit);
									
									get_hex_obj(1);
									printf("Recognised\n");
									fprintf(yyout,"%s",inst);
									fprintf(yyout,"%s",str);
									fprintf(yyout,"%s",object_code);
									fprintf(yyout,"%s",str);
									fprintf(yyout,"%s",hex_obj);
									fprintf(yyout,"%s","\n");
									regno1=-1; regno2=-1;

									loc+=strlen(hex_obj)/2;
									find_locctr(loc);
								}

|TYPE2 spaces REGISTER8 comma IMM8				{
									fprintf(yyout,"%s",locctr);
									fprintf(yyout,"%s",str);

									/*set flag bit*/
									flag_bit=reg8_imm8;
								/*find out binary value of data and store in char array*/
								/*Data dec/hex is available in global data array*/
									decorhex2bin();
								//binary data is in data bin
								printf("bin = %s\n",databin);
								/*regno of reg used is in regno2*/
								/*call search_optab2*/
									search_optab2(opcode,flag_bit);
									get_hex_obj(1);
									printf("Recognised\n");
									fprintf(yyout,"%s",inst);
									fprintf(yyout,"%s",str);
									fprintf(yyout,"%s",object_code);
									fprintf(yyout,"%s",str);
									fprintf(yyout,"%s",hex_obj);
									fprintf(yyout,"%s","\n");
									regno1=-1; regno2=-1;

									loc+=strlen(hex_obj)/2;
									find_locctr(loc);
								}


|TYPE2 spaces REGISTER8 comma MEM				{
									fprintf(yyout,"%s",locctr);
									fprintf(yyout,"%s",str);

									/*set flag bit*/
									reg_flag=1; //tells number of registers used
									flag_bit=reg8_mem8;
									search_optab2(opcode,flag_bit);
									get_hex_obj(1);
									printf("Recognised\n");
									fprintf(yyout,"%s",inst);
									fprintf(yyout,"%s",str);
									fprintf(yyout,"%s",object_code);
									fprintf(yyout,"%s",str);
									fprintf(yyout,"%s",hex_obj);
									fprintf(yyout,"%s","\n");
									regno1=-1; regno2=-1;

									loc+=strlen(hex_obj)/2;
									find_locctr(loc);
								}

|TYPE2 spaces MEM comma REGISTER8				{
									fprintf(yyout,"%s",locctr);
									fprintf(yyout,"%s",str);

									/*set flag bit*/
									reg_flag=1; //tells number of registers used
									flag_bit=mem8_reg8;
									search_optab2(opcode,flag_bit);
									get_hex_obj(1);
									printf("Recognised\n");
									fprintf(yyout,"%s",inst);
									fprintf(yyout,"%s",str);
									fprintf(yyout,"%s",object_code);
									fprintf(yyout,"%s",str);
									fprintf(yyout,"%s",hex_obj);
									fprintf(yyout,"%s","\n");
									regno1=-1; regno2=-1;
	
									loc+=strlen(hex_obj)/2;
									find_locctr(loc);
								}

|TYPE2 spaces REGISTER16 comma MEM				{
									fprintf(yyout,"%s",locctr);
									fprintf(yyout,"%s",str);

									/*set flag bit*/
									reg_flag=1; //tells number of registers used
									flag_bit=reg16_mem16;
									search_optab2(opcode,flag_bit);
									get_hex_obj(1);
									printf("Recognised\n");
									fprintf(yyout,"%s",inst);
									fprintf(yyout,"%s",str);
									fprintf(yyout,"%s",object_code);
									fprintf(yyout,"%s",str);
									fprintf(yyout,"%s",hex_obj);
									fprintf(yyout,"%s","\n");
									regno1=-1; regno2=-1;

									loc+=strlen(hex_obj)/2;
									find_locctr(loc);
								}

|TYPE2 spaces MEM comma REGISTER16				{
									fprintf(yyout,"%s",locctr);
									fprintf(yyout,"%s",str);

									/*set flag bit*/
									reg_flag=1; //tells number of registers used
									flag_bit=mem16_reg16;
									search_optab2(opcode,flag_bit);
									get_hex_obj(1);
									printf("Recognised\n");
									fprintf(yyout,"%s",inst);
									fprintf(yyout,"%s",str);
									fprintf(yyout,"%s",object_code);
									fprintf(yyout,"%s",str);
									fprintf(yyout,"%s",hex_obj);
									fprintf(yyout,"%s","\n");
									regno1=-1; regno2=-1;

									loc+=strlen(hex_obj)/2;
									find_locctr(loc);
								}



|TYPE4 spaces IMM8						{
									fprintf(yyout,"%s",locctr);
									fprintf(yyout,"%s",str);
								

									/*set flag bit*/
									flag_bit=byte1;
									search_optab2(opcode,flag_bit);
									printf("Recognised3\n");
									get_hex_obj(1);
									printf("Recognised\n");
									fprintf(yyout,"%s",inst);
									fprintf(yyout,"%s",str);
									fprintf(yyout,"%s","\t");
									fprintf(yyout,"%s",object_code);
									fprintf(yyout,"%s",str);fprintf(yyout,"%s","\t");
									fprintf(yyout,"%s",hex_obj);
									fprintf(yyout,"%s","\n");

									loc+=strlen(hex_obj)/2;
									find_locctr(loc);
								
								}



|TYPE1								{
									fprintf(yyout,"%s",locctr);
									fprintf(yyout,"%s",str);

									/*set flag bit*/
									flag_bit=byte1;
									search_optab2(opcode,flag_bit);
									printf("Recognised3\n");
									get_hex_obj(1);
									printf("Recognised\n");
									fprintf(yyout,"%s",inst);
									fprintf(yyout,"%s",str);
									fprintf(yyout,"%s","\t");
									fprintf(yyout,"%s",object_code);
									fprintf(yyout,"%s",str);fprintf(yyout,"%s","\t");
									fprintf(yyout,"%s",hex_obj);
									fprintf(yyout,"%s","\n");

									loc+=strlen(hex_obj)/2;
									find_locctr(loc);
								}



|typemdnn spaces REGISTER8					{
									fprintf(yyout,"%s",locctr);
									fprintf(yyout,"%s",str);

									/*set flag bit*/
									flag_bit=mdnn8;
								/*regno of reg used is in regno2*/
								/*call search_optab2*/
									search_optab2(opcode,flag_bit);
									printf("Recognised3\n");
									get_hex_obj(1);
									printf("Recognised\n");
									fprintf(yyout,"%s",inst);
									fprintf(yyout,"%s",str);
									fprintf(yyout,"%s",object_code);
									fprintf(yyout,"%s",str);
									fprintf(yyout,"%s",hex_obj);
									fprintf(yyout,"%s","\n");
									regno1=-1; regno2=-1;
										
									loc+=strlen(hex_obj)/2;
									find_locctr(loc);
								
								}


|typemdnn spaces REGISTER16					{
									fprintf(yyout,"%s",locctr);
									fprintf(yyout,"%s",str);

									/*set flag bit*/
									flag_bit=mdnn16;
								/*regno of reg used is in regno2*/
								/*call search_optab2*/
									search_optab2(opcode,flag_bit);
									get_hex_obj(1);
									printf("Recognised\n");
									fprintf(yyout,"%s",inst);
									fprintf(yyout,"%s",str);
									fprintf(yyout,"%s",object_code);
									fprintf(yyout,"%s",str);
									fprintf(yyout,"%s",hex_obj);
									fprintf(yyout,"%s","\n");
									regno1=-1; regno2=-1;

									loc+=strlen(hex_obj)/2;
									find_locctr(loc);
								
								}

|SYMBOL spaces COLON						{
									enter_symtab();
									fprintf(fp,"%s%s%s%s%d\n",symbol,str,locctr,str,loc);
									fprintf(yyout,"%s%s%s%s\n",locctr,str,inst,str);
								}

|SYMBOL COLON							{
									enter_symtab();
									fprintf(fp,"%s%s%s%s%d\n",symbol,str,locctr,str,loc);
									fprintf(yyout,"%s%s%s%s\n",locctr,str,inst,str);
								}

|TYPE3 spaces SYMBOL						{
									/*Handles all jump instructions*/
									fprintf(yyout,"%s%s%s%s",locctr,str,inst,str);

									/*set flag bit*/
									reg_flag=0;
									flag_bit=JUMP_INST;
									search_optab2(opcode,flag_bit);
									printf("\n\n\n\n\nfrf = %d\n\n\n\n\n\n",fr);
									if(fr==0)
									{//convert object code into hexadecimal
									 get_hex_obj(1);
									 //display hex_obj
									 fprintf(yyout,"%s%s%s\n",object_code,str,hex_obj);
									}
									else
									{//get_hex_obj(1);
									 //display hex_obj
									 //fprintf(yyout,"%s%s%s\n",object_code,str,"XXXX");
									 fprintf(yyout,"%s\t\t\t%s",object_code,"XXXX");
									}
									fprintf(yyout,"\n");
									loc+=strlen(hex_obj)/2;
									find_locctr(loc);
									//increment locctr value by 2 bytes
								}


;


%%
extern struct symtable symtab[20];
extern struct for_ref_table forward_ref[6];
int main(int argc,char *argv[])
{
	int i,x,bit,pos,k,j,index;
	char abit;
	if((fp=fopen("symtab.txt","w"))==NULL)
	{
		printf("Fail\n");
		return 0;
	}

	if((fp1=fopen("forreftab.txt","w"))==NULL)
	{
		printf("Fail\n");
		return 0;
	}
	
	strcpy(locctr,"0000h");
	printf("\nopcode= %s\nn_o_opcode = %d\nbin_eqv = %s\n",optab[0].opcode,optab[0].n_o_opcode,optab[0].info[0].bin_eqv);
	printf("\nopcode= %s\nn_o_opcode = %d\nbin_eqv = %s\n",optab[0].opcode,optab[0].n_o_opcode,optab[0].info[1].bin_eqv);
	yyin=fopen("input.asm","r");
	printf("\n enter : \n");
	yyout=fopen("newfile.txt","w");
	if(yyparse()==0)
		printf("\n success \n");
	
	/*Main part is over...Now its the time to solve Forward reference problem*/
	/*Info about forward reference is in structure for_ref_table */
	printf("\n\nFREF = %d\n\n",fref);
	/*fref contains the number of forward references*/









	for(i=0;i<fref;i++)
	{
		/*search forward_ref[fref].symbol in symbol table*/
		for(j=0;j<sym_count;j++)
		{
			if(strcmp(symtab[j].symbol,forward_ref[i].symbol)==0)
			{
				disp = symtab[j].address - forward_ref[i].loc ;// this is +ve displacement in decimal....find its binary and then 2's compliment
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
			//	/*now displace has binary value....find its 2's compliment*/
			//	for(index=0;index<8;index++)
			//		displace[index]=((int)displace[index]-48==0)?'1':'0';
			//	for(index=7;index>=0;index--)
			//	{
			//		if(displace[index]=='0')
			//		{
			//			displace[index]='1';
			//			break;
			//		}
			//		else
			//			displace[index]='0';
			//	}
			//	//2's compliment is stored in displace
				strcpy(object_code,forward_ref[i].object_code);
				strcat(object_code,displace);
				get_hex_obj(1);
				/*now we have object code in object_code and hexadecimal value in hex_obj...output it to ptr*/
				//fprintf(forward_ref[i].ptr,"\t\t%s\t\t%s\n",object_code,hex_obj);
				fseek(yyout,forward_ref[i].offset,SEEK_SET);
				fprintf(yyout,"%s\t\t\t%s",object_code,hex_obj);
			}
		}
	}









	fclose(yyout);
	fclose(fp);
	//fclose(yyin);
	return 0;
}
int yyerror(char *err)
{
	//printf("%s",err);
	return -1;
}
