
#define reg16_reg16 1
#define reg8_reg8 0
#define reg8_imm8 2
#define reg16_imm16 3

#define reg8_mem8 4
#define mem8_reg8 5
#define reg16_mem16 6
#define mem16_reg16 7
/*This macro is only for mul div neg and not instructions*/
#define mdnn8 8
#define mdnn16 9
#define reg16_segreg 10
#define segreg_reg16 11
/*For cli,sti,lahf etc...*/
#define byte1 12

#define JUMP_INST 13

#define MAX_LEN 70

FILE *fp,*fp1;

char inst[25];
int reg_flag;//0 for no reg, 1 and 2
int regno1;
int regno2;
int segreg;
int instno;//stores the values of opcode in instruction  {add=0,or=1,adc=2,ssb=3,and=4 etc...}
int dir_add_flag;
int addmodno;  //stores value of addressing mode used
char object_code[40];//it will store the final object code
char hex_obj[20];
char opcode[10];//stores the opcode
char data[10];//it stores 8/16 bit hex or dec number
char databin[20];
char locctr[8];
char locctr_bin[40];
int loc;
int flag_bit;//reg16 to reg16, reg8 to reg8,reg to imm8,reg16 to imm16 
int sym_count;
int fref;
int disp;
char displace[10];
int fr;

char symbol[20]; //to store the symbols

/*To store values*/
struct node
{
	char opcode[10];
	char bin_eqv[10];
	int regflag;
	char mod[3];
	char rbm[4];
	char reg[4];
	char data[20];
};

/*To store info about opcodes and machine equivalents*/
struct inst_info
{
	int flag;//reg16 to reg16, reg8 to reg8,reg8 to imm8,reg to imm16 , reg8-mem8 , mem8-reg8 , reg16-mem16 , mem16-reg16
	char bin_eqv[40];
	int length;
	
};

struct optable
{
	char opcode[10];
	int n_o_opcode;
	struct inst_info info[10];
};


struct symtable
{
	char symbol[20];
	int address;
};


struct for_ref_table
{
	char symbol[20];  //with 20 or less characters
	FILE *ptr;       //pointer to store value of file pointer
	long int offset;
	char object_code[40];  //to store object code
	int loc;
};


int search_optab1(char *opcode);

int search_optab2(char *opcode,int flag_bit);

void find_missing_codes(struct node temp);

void get_regno(int n,char *reg);

void dec2bin();

void hex2bin();

void decorhex2bin();

void get_objcode7();

void get_hex_obj(int flag);

void find_locctr(int loc);

int enter_symtab();

int search_symtab();
