ORG	10
LDA	A_PL_CNST
STA	A_PL
LDA	CNT_PL_CNST
STA	CNT_PL

CLA
SIO

MAINL1,	LDA	A_PL	I
MAINL2, SKO	/ if(S_OUT ready) skip next
BUN	MAINL2	/ goto SENDL2(P_OUT not ready)
OUT
ISZ	A_PL
ISZ	CNT_PL
BUN	MAINL1

MAINL3, SKI	/ if(S_IN ready) skip next
BUN	MAINL3	/ goto L0 (S_IN not ready)
INP	/ AC(7:0) <- INPR
ADD	VM31
SZA
BUN	TOMAIN1
BSA	O_ENTER
BSA	SHOW
BUN	MAIN2	/INPUT=PL1

TOMAIN1,	/INPUT=PL2
BSA	O_ENTER
BSA	SHOW
BUN	MAIN1

MAIN1,
BSA	O_ENTER	/���s
BSA	RECEIVE

MAIN2,
BSA	O_ENTER	/���s
BSA	SEND

LDA	PASS
ADD	VM2
SZA	/if(M[PASS]=2)���[�v�𔲂���

BUN	MAIN1

HLT


////////////////////////////////subroutine INPUT/////////////////////////////////////
INPUT,	HEX	0
	SIO
	LDA	VM10
	STA	K
	LDA	VH8
	STA	Y
	LDA	VM1
	STA	FLAGR
	STA	FLAGL
	LDA	VM2
	STA	CT
	LDA	P1_CNST
	STA	P1
	CLA
	STA	STN
INL0,	SKI
	BUN INL0
	INP
	STA P1 I
	ADD SI
	SNA
	BUN INPASS
	LDA P1 I
	ADD SA
	SNA
	BUN INCOLUMN
	LDA P1 I
	ADD LI
	SNA
	BUN INPASS
	LDA P1 I
	ADD LA
	SNA
	BUN INCOLUMN
	LDA P1 I
	ADD C9
	SNA
	BUN INPASS
	LDA P1 I
	ADD C1
	SNA
	BUN INROW
	BUN INPASS

INROW,	ISZ FLAGR
	BUN INPASS
	STA X
	BSA MUL
	LDA Z
	ADD STN
	STA STN
	ISZ P1
	ISZ CT
	BUN INL0
	BUN	INPUT	I
INCOLUMN,	ISZ FLAGL
	BUN INPASS
	ADD STN
	STA STN
	ISZ P1
	ISZ CT
	BUN INL0
	BUN	INPUT	I

INPASS,	LDA VH7A
	STA STN
	BUN	INPUT	I
/////////////////////////////end of subroutine/////////////////////////////////////



//////////////////////////////subroutine RECEIVE/////////////////////////////////////
RECEIVE, HEX	0
/�p���������͑ҋ@
CLA
PIO
RECEIVEL0, SKI	/ if(S_IN ready) skip next
BUN	RECEIVEL0	/ goto L0 (S_IN not ready)
INP / AC(7:0) <- INPR
STA	STN

BSA	PASSCNT

LDA	PASS
_B_, SZA
BUN	RECEIVEL1	/�p�X�̏ꍇRECEIVEL1�܂Ŕ��

BSA	REFRESH
RECEIVEL1, BSA	SHOW
BSA	O_ENTER	/���s
BSA	TRNCNT
BUN	RECEIVE	I
/////////////////////////////end of subroutine/////////////////////////////////////


//////////////////////////////subroutine SEND/////////////////////////////////////
SEND,	HEX	0
BSA	INPUT
BSA	O_ENTER	/���s

BSA	PASSCNT

LDA	PASS
_B_,SZA
BUN	SENDL1	/�p�X�̏ꍇSEND1�܂Ŕ��

BSA	REFRESH
BSA	SHOW
BSA	O_ENTER	/���s

SENDL1, 
/�p�������o�͂���
PIO
LDA	STN
SENDL2, SKO	/ if(S_OUT ready) skip next
BUN	SENDL2	/ goto SENDL2(P_OUT not ready)
OUT

BSA	TRNCNT

BUN	SEND	I
/////////////////////////////end of subroutine/////////////////////////////////////


//////////////////////////////subroutine ENTER/////////////////////////////////////
O_ENTER, HEX	0
SIO
LDA	VHA
MAINL, SKO	/ if(S_OUT ready) skip next
BUN	MAINL	/ goto SHOWLOOP(S_OUT not ready)
OUT
BUN	O_ENTER	I
/////////////////////////////end of subroutine/////////////////////////////////////

//////////////////////////////subroutine TURN/////////////////////////////////////
TRNCNT, HEX	0
LDA	TRN
CMA
INC
ADD	VH3
STA	TRN	/M[TRN] <- 3- M[TRN]
LDA	VH1
BUN	TRNCNT	I
//////////////////////////////end of subroutine///////////////////////////////////


//////////////////////////////subroutine PASSCNT///////////////////////////////////
PASSCNT, HEX	0
LDA	STN
ADD	VM7A
SPA
BUN	PASSCNTL1

/M[STN]<0 �p�X�̎�
ISZ	PASS
BUN	PASSCNT	I

/M[STN]>0 �p�X�łȂ��Ƃ�
PASSCNTL1,
CLA
STA	PASS
BUN	PASSCNT	I
//////////////////////////////end of subroutine///////////////////////////////////


//////////////////////////////subroutine SHOW/////////////////////////////////////
SHOW, HEX	0
SIO	/ IOT <- 1 (serial-IO)
LDA	VM8
STA	K
LDA	PTCNST
STA	PTTMP

SHOWLOOP1, CLA	/�K�v���������x����t���邽��
LDA	VM8
STA	L

SHOWLOOP2, LDA	PTTMP	I

ADD	VM1
SPA
LDA	VM2E	/M[PTTMP] - 1 = -1 �܂�M[PTTMP] = 0
SZA
ADD	VH24	/(M[PTTMP] - 1 = 1 �܂�M[PTTMP] = 2 )�܂���M[PTTMP] = 0
ADD	VH2A	/M[PTTMP] = 1�̂Ƃ�1+VM1+VH2A=VH2A=*, M[PTTMP] = 2�̂Ƃ�2+VM1+VH24+VH2A=VH4F=O, M[PTTMP] = 0�̂Ƃ�0+VM1+VM2E+VH24+VH2A=VH20

SHOWL1, SKO	/ if(S_OUT ready) skip next
BUN SHOWL1	/ goto SHOWLOOP(S_OUT not ready)
OUT	/ OUTR <- AC(7:0)

LDA	VH7C

SHOWL2, SKO	/ if(S_OUT ready) skip next
BUN SHOWL2	/ goto SHOWLOOP(S_OUT not ready)
OUT	/ OUTR <- AC(7:0)

ISZ	PTTMP	/�X�L�b�v����邱�Ƃ͂Ȃ�
ISZ	L	/SHOWLOOP2�𔲂��邩����
BUN	SHOWLOOP2

LDA	VHA
SHOWL3, SKO	/ if(S_OUT ready) skip next
BUN SHOWL3	/ goto SHOWLOOP(S_OUT not ready)
OUT	/ OUTR <- AC(7:0)

ISZ	K
BUN	SHOWLOOP1

BUN	SHOW	I
/////////////////////////////////end of subroutine/////////////////////////////////////


//////////////////////////////subroutine REFRESH/////////////////////////////////////
REFRESH, HEX	0
/�Ƃ肠�������͂��ꂽ�΂̕��������X�V����
LDA	STN
ADD	PTCNST
STA	PTSTN
LDA	TRN
STA	PTSTN	I
//�����
LDA	VM8
STA	GONUM
LDA	VH8
STA	BACKNUM
LDA	VH64
STA	EDGE	/���������΂ɕ��ɂȂ鐔����
BSA	CROSS
//������
LDA	VH8
STA	GONUM
LDA	VM8
STA	BACKNUM
LDA	VH64
STA	EDGE	/���������΂ɕ��ɂȂ鐔����
BSA	CROSS
//������
LDA	VM1
STA	GONUM
LDA	VH1
STA	BACKNUM
LDA	VH7
STA	EDGE
BSA	CROSS
//�E����
LDA	VH1
STA	GONUM
LDA	VM1
STA	BACKNUM
CLA
STA	EDGE
BSA	CROSS
//����
LDA	VM9
STA	GONUM
LDA	VH9
STA	BACKNUM
LDA	VH7
STA	EDGE
BSA	CROSS
//�E��
LDA	VH9
STA	GONUM
LDA	VM9
STA	BACKNUM
CLA
STA	EDGE
BSA	CROSS
//�E��
LDA	VM7
STA	GONUM
LDA	VH7
STA	BACKNUM
CLA
STA	EDGE
BSA	CROSS
//����
LDA	VH7
STA	GONUM
LDA	VM7
STA	BACKNUM
LDA	VH7
STA	EDGE
BSA	CROSS

BUN	REFRESH	I
/////////////////////////////////end of subroutine/////////////////////////////////////


//////////////////////////////subroutine MUL///////////////////////////////////////////
MUL, CLE
CLA
STA	Z
MULL0, HEX	0
CLE	/ E <- 0
LDA	Y	/ AC <- M[Y]
SZA	/(AC==0)�Ȃ�Ύ����߃X�L�b�v
BUN	LY	/ goto LY
BUN	MUL	I
/ M[Y] >>= 1
LY, CIR	/ AC(15:0) >>= 1
STA	Y	/ M[Y] <- AC
SZE	/(E==0)�Ȃ�Ύ����߃X�L�b�v
BUN LP	/ goto LP
/ M[X] <<= 1
LX, LDA	X	/ AC <- M[X]
CIL	/ AC <<= 1
STA	X	/ M[X] <- AC
BUN	MULL0	/ goto L0
/ M[P] += M[X]
LP, LDA	X	/ AC <- M[X]
ADD	Z	/ AC <- AC + M[P]
STA	Z	/ M[P] <- AC
CLE	/ E <- 0
BUN	LX	/ goto LX
//////////////////////////////end of subroutine////////////////////////////////////

//////////////////////////////subroutine CROSS/////////////////////////////////////
/��������l����
CROSS, HEX	0
/PT��΂�u�����ʒu�ɑ�������z��v�f�̃A�h���X�Ƃ���
LDA	PTSTN
STA	PTTMP

/do{ i++; } while(STN-8i>= PTCNST(�A���_�[�t���[�z��͈͊O) && STN-8i < PTCNST+64 (�I�[�o�[�t���[�z��͈͊O) && D[STN-8i] != 0(�܂��΂��u����ĂȂ��}�X) && D[STN-8i] != M[TRN](�����̐F�̐΂��u���Ă���}�X))
/do����
CROSSLOOP, LDA	PTTMP
ADD	GONUM
STA	PTTMP
/while����
LDA	PTCNST
ADD	EDGE
CMA
INC
ADD	PTTMP
ADD	VH8	/�����ADD VM8�̑ł�����
CROSSLOOP3, 
ADD	VM8
SPA
BUN	CROSSL	/AC<0 =>���Β[�ł͂Ȃ�
SZA
BUN	CROSSLOOP3
BUN	CROSSHLT	/AC=0 =>���Β[�ɓ��Bdo while�I��
CROSSL,LDA		PTCNST
CMA
ADD	PTTMP
INC
SPA
BUN	CROSSHLT	/if STN-8i < PTCNST
LDA	PTCNST
ADD	VH40	/+64
CMA
ADD	PTTMP
INC
SNA
BUN	CROSSHLT	/STN-8i >= PTCNST+64
LDA	PTTMP	I
SZA
BUN	CROSS1	/if D[STN-8i] != 0 
BUN	CROSSHLT	/if D[STN-8i] == 0 
CROSS1,  CMA
ADD	TRN
INC
SZA
BUN	CROSSLOOP	/if D[STN-8i] != M[TRN]  


/if(D[STN-8i] == M[TRN]) �߂��đS���΂𔽓]
/do{ i++; �΂������̐F�ɂ���} while(STN+8i != PTSTN(���͂��������܂łЂ�����Ԃ���))
/do{ i++; �΂������̐F�ɂ���}
CROSSLOOP2, LDA	TRN
STA	PTTMP	I
LDA	PTTMP
ADD	BACKNUM
STA	PTTMP
/while(STN+8i != PTSTN(���͂��������܂łЂ�����Ԃ���))
CMA
ADD	PTSTN
INC
SZA
BUN	CROSSLOOP2

/else �����ς��Ȃ�
CROSSHLT, BUN	CROSS	I
/////////////////////////////////end of subroutine/////////////////////////////////////

//�f�[�^
VH1, DEC	1
VM1, DEC	-1
VH7, DEC	7
VM7, DEC	-7
VH8, DEC	8
VM8, DEC	-8
VM2, DEC	-2
VH3, HEX	3
VH9, DEC	9
VM9, DEC	-9
VH24, HEX	24
VH2A, HEX	2A
VH40, HEX	40	/10�i����64
VM10, DEC	-16
VH64, HEX	64
VH7A, HEX	7A
VM7A, DEC	-122
VHA, HEX	A
VMA, DEC	-10
VM2E, DEC	-46
VM31, DEC	-49
VH20, HEX	20
VH7C, HEX	7C	/|
VM41, DEC	-65
BACKNUM, DEC	-8
GONUM, DEC	8
EDGE, DEC	0
PASS,DEC	0	/�p�X�����͂��ꂽ��1�A�A�����ăp�X�����͂��ꂽ��2
K, DEC		0	/for����int i
L, DEC		0	/for����int i
STN, DEC	0	/Stone.���u���ꂽ�΂̒ʂ��ԍ�
TRN, DEC	1	/���݂̃^�[����1��2�̂ǂ��炩
PTSTN, DEC	0	/���u���ꂽ�΂̔z��v�f�̃A�h���X
PTTMP, DEC	0	/�R���s���[�^�������Ă���΂̔z��v�f�̃A�h���X
PTCNST, SYM D / M[PT] = �i���x�� D �̃A�h���X�A���������֎~�j
A_PL_CNST,	SYM PL
A_PL,	SYM PL
CNT_PL_CNST,DEC -6		/ CNT_BMG = -6
CNT_PL,DEC -6		/ CNT_BMG = -6
PL,
CHR	P
CHR	L
CHR	1
HEX	2F
CHR	2
CHR	>
P1,	SYM ADDRESS
P1_CNST,	SYM ADDRESS
ADDRESS,	HEX 0
	HEX 0
FLAGR,	DEC -1
FLAGL,	DEC -1
CT,	DEC -2
AD,	DEC 0
C1,	DEC -49
C9,	DEC -57
LA,	DEC -65
LI,	DEC -73
SA,	DEC -97
SI,	DEC -105
X,	DEC 0
Y,	DEC 8
Z,	DEC 0
KN,	DEC -16
P, DEC 0	/ M[P] = 0�i�������K�v�j
D, HEX 0 	/ D[0]
   DEC 0	/ D[1]
   DEC 0	/ D[2]
   DEC 0	/ D[3]
   DEC 0	/ D[4]
   DEC 0	/ D[5]
   DEC 0	/ D[6]
   DEC 0	/ D[7]
   DEC 0	/ D[8]
   DEC 0	/ D[9]
   DEC 0	/ D[10]
   DEC 0	/ D[11]
   DEC 0	/ D[12]
   DEC 0	/ D[13]
   DEC 0	/ D[14]
   DEC 0	/ D[15]
   DEC 0	/ D[16]
   DEC 0	/ D[17]
   DEC 0	/ D[18]
   DEC 0	/ D[19]
   DEC 0	/ D[20]
   DEC 0	/ D[21]
   DEC 0	/ D[22]
   DEC 0	/ D[23]
   DEC 0	/ D[24]
   DEC 0	/ D[25]
   DEC 0	/ D[26]
   DEC 2	/ D[27]
   DEC 1	/ D[28]
   DEC 0	/ D[29]
   DEC 0	/ D[30]
   DEC 0	/ D[31]
   DEC 0	/ D[32]
   DEC 0	/ D[33]
   DEC 0	/ D[34]
   DEC 1	/ D[35]
   DEC 2	/ D[36]
   DEC 0	/ D[37]
   DEC 0	/ D[38]
   DEC 0	/ D[39]
   DEC 0	/ D[40]
   DEC 0	/ D[41]
   DEC 0	/ D[42]
   DEC 0	/ D[43]
   DEC 0	/ D[44]
   DEC 0	/ D[45]
   DEC 0	/ D[46]
   DEC 0	/ D[47]
   DEC 0	/ D[48]
   DEC 0	/ D[49]
   DEC 0	/ D[50]
   DEC 0	/ D[51]
   DEC 0	/ D[52]
   DEC 0	/ D[53]
   DEC 0	/ D[54]
   DEC 0	/ D[55]
   DEC 0	/ D[56]
   DEC 0	/ D[57]
   DEC 0	/ D[58]
   DEC 0	/ D[59]
   DEC 0	/ D[60]
   DEC 0	/ D[61]
   DEC 0	/ D[62]
   DEC 0	/ D[63]
END