ORG	10
LDA	A_PL
STA	MSG_A
LDA	CNT_PL
STA	MSG_CNT
BSA	MSG

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
BSA	O_ENTER	/改行
BSA	RECEIVE
LDA	PASS
ADD	VM2
SNA	/if(M[PASS]>=2)終了
HLT

MAIN2,
BSA	O_ENTER	/改行
BSA	SEND

LDA	PASS
ADD	VM2
SPA	/if(M[PASS]>=2)ループを抜ける

BUN	MAIN1

HLT


////////////////////////////////subroutine MESSAGE/////////////////////////////////////
MSG, HEX	0
CLA
SIO

MSGL1,	LDA	MSG_A	I
MSGL2, SKO	/ if(S_OUT ready) skip next
BUN	MSGL2	/ goto SENDL2(P_OUT not ready)
OUT
ISZ	MSG_A
ISZ	MSG_CNT
BUN	MSGL1

BUN	MSG	I
/////////////////////////////end of subroutine/////////////////////////////////////



////////////////////////////////subroutine INPUT/////////////////////////////////////
INPUT,	HEX	0
	LDA	A_IN
	STA	MSG_A
	LDA	CNT_IN
	STA	MSG_CNT
	BSA	MSG

	SIO
INCL,	LDA	VM10
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
	LDA A_INER_CNST
	STA A_INER
	LDA CT_INER_CNST
	STA CT_INER
	CLA
	STA	STN
INL0,	SKI
	BUN INL0
	INP
	STA P1 I
	ADD SP
	SZA
	BUN INL0_1
	BUN INPASS
INL0_1,	LDA P1 I
	ADD SI
	SNA
	BUN INERROR
	LDA P1 I
	ADD SA
	SNA
	BUN INCOLUMN
	LDA P1 I
	ADD LP
	SZA
	BUN INL0_2
	BUN INPASS
INL0_2,	LDA P1 I
	ADD LI
	SNA
	BUN INERROR
	LDA P1 I
	ADD LA
	SNA
	BUN INCOLUMN
	LDA P1 I
	ADD C9
	SNA
	BUN INERROR
	LDA P1 I
	ADD C1
	SNA
	BUN INROW
	BUN INERROR

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

INERROR,	SKO
	BUN INERROR
	LDA A_INER I
	OUT
	ISZ A_INER
	ISZ CT_INER
	BUN INERROR
	BUN INCL

INPASS,	LDA VH7A
	STA STN
	BUN	INPUT	I
/////////////////////////////end of subroutine/////////////////////////////////////



//////////////////////////////subroutine RECEIVE/////////////////////////////////////
RECEIVE, HEX	0
/パラレル入力待機
CLA
PIO
RECEIVEL0, SKI	/ if(S_IN ready) skip next
BUN	RECEIVEL0	/ goto L0 (S_IN not ready)
INP / AC(7:0) <- INPR
STA	STN

BSA	PASSCNT

LDA	PASS
_B_, SZA
BUN	RECEIVEL1	/パスの場合RECEIVEL1まで飛ぶ

BSA	REFRESH
RECEIVEL1, BSA	SHOW
BSA	O_ENTER	/改行
BSA	TRNCNT
BUN	RECEIVE	I
/////////////////////////////end of subroutine/////////////////////////////////////


//////////////////////////////subroutine SEND/////////////////////////////////////
SEND,	HEX	0
SENDL0,
BSA	INPUT
BSA	O_ENTER	/改行

BSA	PASSCNT

LDA	PASS
_B_,SZA
BUN	SENDL1	/パスの場合SEND1まで飛ぶ

BSA	REFRESH
LDA	TAFG
SZA
BUN	TYPE_AG
BSA	SHOW
BSA	O_ENTER	/改行


SENDL1, 
/パラレル出力する
PIO
LDA	STN
SENDL2, SKO	/ if(S_OUT ready) skip next
BUN	SENDL2	/ goto SENDL2(P_OUT not ready)
OUT

BSA	TRNCNT

BUN	SEND	I
TYPE_AG, LDA	A_INER
STA	MSG_A
LDA	CT_INER
STA	MSG_CNT
BSA	MSG
BUN	SENDL0
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

/M[STN]<0 パスの時
ISZ	PASS
BUN	PASSCNT	I

/M[STN]>0 パスでないとき
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

/show label
LDA	VM8
STA	L

WSOUT1,	LDA	VH20
SKO
BUN	WSOUT1
OUT

WSOUT2,	LDA	VH20
SKO
BUN	WSOUT2
OUT

APOUT,	LDA	VH49
ADD	L
SKO
BUN	APOUT
OUT
ISZ	L
BUN	WSOUT2
BSA	O_ENTER

SHOWLOOP1, LDA	VH9	/必要無いがラベルを付けるため
ADD	K
ADD	VH30
SKO
BUN	SHOWLOOP1
OUT
LINEOUT, LDA VH7C
SKO
BUN LINEOUT
OUT
LDA	VM8
STA	L

SHOWLOOP2, LDA	PTTMP	I

ADD	VM1
SPA
LDA	VM2E	/M[PTTMP] - 1 = -1 つまりM[PTTMP] = 0
SZA
ADD	VH24	/(M[PTTMP] - 1 = 1 つまりM[PTTMP] = 2 )またはM[PTTMP] = 0
ADD	VH2A	/M[PTTMP] = 1のとき1+VM1+VH2A=VH2A=*, M[PTTMP] = 2のとき2+VM1+VH24+VH2A=VH4F=O, M[PTTMP] = 0のとき0+VM1+VM2E+VH24+VH2A=VH20

SHOWL1, SKO	/ if(S_OUT ready) skip next
BUN SHOWL1	/ goto SHOWLOOP(S_OUT not ready)
OUT	/ OUTR <- AC(7:0)

LDA	VH7C

SHOWL2, SKO	/ if(S_OUT ready) skip next
BUN SHOWL2	/ goto SHOWLOOP(S_OUT not ready)
OUT	/ OUTR <- AC(7:0)

ISZ	PTTMP	/スキップされることはない
ISZ	L	/SHOWLOOP2を抜けるか判定
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
CLA
STA	TAFG
//上方向
LDA	VM8
STA	GONUM
LDA	VH8
STA	BACKNUM
LDA	VH64
STA	EDGE	/引いたら絶対に負になる数を代入
BSA	CROSS
//下方向
LDA	VH8
STA	GONUM
LDA	VM8
STA	BACKNUM
LDA	VH64
STA	EDGE	/引いたら絶対に負になる数を代入
BSA	CROSS
//左方向
LDA	VM1
STA	GONUM
LDA	VH1
STA	BACKNUM
LDA	VH7
STA	EDGE
BSA	CROSS
//右方向
LDA	VH1
STA	GONUM
LDA	VM1
STA	BACKNUM
CLA
STA	EDGE
BSA	CROSS
//左上
LDA	VM9
STA	GONUM
LDA	VH9
STA	BACKNUM
LDA	VH7
STA	EDGE
BSA	CROSS
//右下
LDA	VH9
STA	GONUM
LDA	VM9
STA	BACKNUM
CLA
STA	EDGE
BSA	CROSS
//右上
LDA	VM7
STA	GONUM
LDA	VH7
STA	BACKNUM
CLA
STA	EDGE
BSA	CROSS
//左下
LDA	VH7
STA	GONUM
LDA	VM7
STA	BACKNUM
LDA	VH7
STA	EDGE
BSA	CROSS
//
LDA	TAFG
SZA
BUN	REFRESHHLT
/とりあえず入力された石の部分だけ更新する
LDA	STN
ADD	PTCNST
STA	PTSTN
LDA	TRN
STA	PTSTN	I
REFRESHHLT,	BUN	REFRESH	I
/////////////////////////////////end of subroutine/////////////////////////////////////


//////////////////////////////subroutine MUL///////////////////////////////////////////
MUL, HEX	0
CLE
CLA
STA	Z
MULL0,
CLE	/ E <- 0
LDA	Y	/ AC <- M[Y]
SZA	/(AC==0)ならば次命令スキップ
BUN	LY	/ goto LY
BUN	MUL	I
/ M[Y] >>= 1
LY, CIR	/ AC(15:0) >>= 1
STA	Y	/ M[Y] <- AC
SZE	/(E==0)ならば次命令スキップ
BUN LZ	/ goto LP
/ M[X] <<= 1
LX, LDA	X	/ AC <- M[X]
CIL	/ AC <<= 1
STA	X	/ M[X] <- AC
BUN	MULL0	/ goto L0
/ M[P] += M[X]
LZ, LDA	X	/ AC <- M[X]
ADD	Z	/ AC <- AC + M[P]
STA	Z	/ M[P] <- AC
CLE	/ E <- 0
BUN	LX	/ goto LX
//////////////////////////////end of subroutine////////////////////////////////////

//////////////////////////////subroutine CROSS/////////////////////////////////////
/上方向を考える
CROSS, HEX	0
/PTを石を置いた位置に相当する配列要素のアドレスとする
LDA	PTSTN
STA	PTTMP

/do{ i++; } while(STN-8i>= PTCNST(アンダーフロー配列範囲外) && STN-8i < PTCNST+64 (オーバーフロー配列範囲外) && D[STN-8i] != 0(まだ石が置かれてないマス) && D[STN-8i] != M[TRN](自分の色の石が置いてあるマス))
/do部分
CROSSLOOP, LDA	PTTMP
ADD	GONUM
STA	PTTMP
/while部分
LDA	PTCNST
ADD	EDGE
CMA
INC
ADD	PTTMP
ADD	VH8	/初回のADD VM8の打ち消し
CROSSLOOP3, 
ADD	VM8
SPA
BUN	CROSSL	/AC<0 =>反対端ではない
SZA
BUN	CROSSLOOP3
BUN	CROSSHLT	/AC=0 =>反対端に到達do while終了
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


/if(D[STN-8i] == M[TRN]) 戻って全部石を反転
/do{ i++; 石を自分の色にする} while(STN+8i != PTSTN(入力した文字までひっくり返した))
/do{ i++; 石を自分の色にする}
CROSSLOOP2, LDA	TRN
STA	PTTMP	I
LDA	PTTMP
ADD	BACKNUM
STA	PTTMP
/while(STN+8i != PTSTN(入力した文字までひっくり返した))
CMA
ADD	PTSTN
INC
SZA
BUN	CROSSLOOP2
ISZ	TAFG
/else 何も変えない
CROSSHLT, BUN	CROSS	I
/////////////////////////////////end of subroutine/////////////////////////////////////

//データ
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
VH40, HEX	40	/10進数で64
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
VH30, HEX	30
VH49, HEX	49
VM41, DEC	-65
BACKNUM, DEC	-8
GONUM, DEC	8
EDGE, DEC	0
PASS,DEC	0	/パスが入力されたら1、連続してパスが入力されたら2
K, DEC		0	/for文のint i
L, DEC		0	/for文のint i
STN, DEC	0	/Stone.今置かれた石の通し番号
TRN, DEC	1	/現在のターンは1と2のどちらか
PTSTN, DEC	0	/今置かれた石の配列要素のアドレス
PTTMP, DEC	0	/コンピュータが今見ている石の配列要素のアドレス
PTCNST, SYM D / M[PT] = （ラベル D のアドレス、書き換え禁止）
MSG_A,	HEX	0
MSG_CNT, HEX	0

A_PL,	SYM STR_PL
CNT_PL,DEC -7		/ CNT_BMG = -6
STR_PL,
CHR	P
CHR	L
CHR	1
HEX	2F
CHR	2
CHR	?
CHR	>

A_IN,	SYM STR_IN
CNT_IN,DEC -10		/ CNT_BMG = -6
STR_IN,
CHR	Y
CHR	O
CHR	U
CHR	R
HEX	20
CHR	T
CHR	U
CHR	R
CHR	N
CHR	>

A_INER,	SYM INER
A_INER_CNST,	SYM INER
CT_INER_CNST,	DEC -11
CT_INER,	DEC -11
INER,	CHR I
	CHR N	
	CHR P
	CHR U
	CHR T
	HEX 20
	CHR A
	CHR G
	CHR A
	CHR I
	CHR N

P1,	SYM ADDRESS
P1_CNST,	SYM ADDRESS
ADDRESS,	HEX 0
	HEX 0
FLAGR,	DEC -1
FLAGL,	DEC -1
TAFG,	DEC 0	/ type again flag
CT,	DEC -2
AD,	DEC 0
C1,	DEC -49
C9,	DEC -57
LA,	DEC -65
LI,	DEC -73
LP,	DEC -80
SA,	DEC -97
SI,	DEC -105
SP,	DEC -112
X,	DEC 0
Y,	DEC 8
Z,	DEC 0
KN,	DEC -16
P, DEC 0	/ M[P] = 0（初期化必要）
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
