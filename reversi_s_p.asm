ORG	10
BSA	RESET

LDA	A_INTRO
STA	MSG_A
LDA	CNT_INTRO
STA	MSG_CNT
BSA	MSG

LDA	A_GM
STA	MSG_A
LDA	CNT_GM
STA	MSG_CNT
BSA	MSG

INP_GM,	SKI
BUN	INP_GM
INP
ADD	VM30
STA	GM
BSA	O_ENTER

LDA	GM
SZA
BUN	INP_PL
LDA	A_DIF
STA	MSG_A
LDA	CNT_DIF
STA	MSG_CNT
BSA	MSG

INP_DIF,	SKI
BUN	INP_DIF
INP
ADD	VM30
STA	DIF
BSA	O_ENTER
BUN	PL1
INP_PL,
LDA	A_PL
STA	MSG_A
LDA	CNT_PL
STA	MSG_CNT
BSA	MSG

MAINL3, SKI	/ if(S_IN ready) skip next
BUN	MAINL3	/ goto L0 (S_IN not ready)
INP	/ AC(7:0) <- INPR
ADD	VM31
STA	PL
SZA
BUN	TOMAIN1
PL1,
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
BSA	CHECKMATE
LDA	PASS
ADD	VM2
SNA	/if(M[PASS]>=2)終了
BUN	MAIN_HLT

MAIN2,
BSA	O_ENTER	/改行
BSA	SEND
BSA	CHECKMATE
LDA	PASS
ADD	VM2
SPA	/if(M[PASS]>=2)ループを抜ける

BUN	MAIN1
MAIN_HLT,
BSA	JUDGE
HLT

////////////////////////////////subroutine RESET/////////////////////////////////////
RESET,	HEX 0
LDA	VM3C
STA	TRN_SUM
LDA	VM40
STA	RESETCT
CLA
STA	PL
LDA	A_D_CNST
STA	A_D
LDA	VH0
RESETL0,
STA	A_D I
ISZ	A_D
ISZ	RESETCT
BUN	RESETL0
LDA	A_D_CNST
ADD	VH27
STA	A_D
LDA	VH2
STA	A_D I
ISZ	A_D
LDA	VH1
STA	A_D I
LDA	A_D
ADD	VH7
STA	A_D
LDA	VH1
STA	A_D I
ISZ	A_D
LDA	VH2
STA	A_D I
BUN	RESET I
/////////////////////////////end of subroutine/////////////////////////////////////


////////////////////////////////subroutine CHECKMATE/////////////////////////////////////
CHECKMATE,	HEX 0
CLA
LDA	PTCNST
STA	PTTMP
LDA	VM40
STA	CHECKCT
LDA	PASS
SZA
BUN	CHECKMATEL0
BUN	FULL

CHECKMATEL0,
LDA	PTTMP I
SZA
BUN 	CHECKMATEL1
ISZ 	PTTMP
ISZ 	CHECKCT
BUN 	CHECKMATEL0

CHECKMATEL1,
CMA
INC
STA 	CHECKFLG
ISZ 	PTTMP
ISZ	CHECKCT

CHECKMATEL2,
LDA	PTTMP I
SZA
BUN 	CHECKMATEL3
ISZ 	PTTMP
ISZ	CHECKCT
BUN 	CHECKMATEL2
BUN	CHECKHLT

CHECKMATEL3,
ADD 	CHECKFLG
SZA
BUN 	CHECKMATE I
ISZ 	PTTMP
ISZ	CHECKCT
BUN CHECKMATEL2

FULL,
ISZ	TRN_SUM
BUN	CHECKMATEL0
BUN	CHECKHLT

CHECKHLT,
LDA	VH2
STA 	PASS
BUN	CHECKMATE I
/////////////////////////////end of subroutine/////////////////////////////////////


////////////////////////////////subroutine JUDGE/////////////////////////////////////
JUDGE, HEX	0
LDA	VM40
STA	J_CNT
CLA
STA	O_STN_SUM
STA	T_STN_SUM
LDA	PTCNST
STA	PTTMP
JUDGEL0,
LDA	PTTMP	I
ADD	VM1
SPA
BUN	JUDGEL1
SZA
BUN	T_CNT
ISZ	O_STN_SUM
BUN	JUDGEL1
T_CNT,
ISZ	T_STN_SUM
JUDGEL1,
ISZ	PTTMP
ISZ	J_CNT
BUN	JUDGEL0
LDA	A_PL1_SUM_CNST
STA	A_PL1_SUM
LDA	A_PL2_SUM_CNST
STA	A_PL2_SUM
//display PL1,PL2 STN_SUM
LDA	O_STN_SUM
BSA	BTOD
LDA	Z
STA	A_PL1_SUM	I
ISZ	A_PL1_SUM
LDA	X
STA	A_PL1_SUM	I
LDA	T_STN_SUM
BSA	BTOD
LDA	Z
STA	A_PL2_SUM	I
ISZ	A_PL2_SUM
LDA	X
STA	A_PL2_SUM	I
LDA	A_STN_SUM
STA	MSG_A
LDA	CNT_STN_SUM
STA	MSG_CNT
BSA	MSG
BSA	O_ENTER

LDA	PL
SZA
BUN	T_JUDGE
//PL1
LDA	O_STN_SUM
LON
LDA	T_STN_SUM
CMA
INC
ADD	O_STN_SUM
BUN	JUDGEL2
T_JUDGE,	//PL2
LDA	T_STN_SUM
LON
LDA	O_STN_SUM
CMA
INC
ADD	T_STN_SUM
JUDGEL2,
SPA
BUN	LOSE
SZA
BUN	WIN
//draw
LDA	A_DRAW
STA	MSG_A
LDA	CNT_DRAW
STA	MSG_CNT
BUN	JUDGEL3
LOSE,
LDA	A_LOSE
STA	MSG_A
LDA	CNT_LOSE
STA	MSG_CNT
BUN	JUDGEL3
WIN,
LDA	A_WIN
STA	MSG_A
LDA	CNT_WIN
STA	MSG_CNT
BUN	JUDGEL3
JUDGEL3,
BSA	MSG
BUN	JUDGE	I
/////////////////////////////end of subroutine/////////////////////////////////////



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
	BUN INERROR
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
	BUN INERROR
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
LDA	GM
SZA
BUN	P_INP
BUN	R_COM
/パラレル入力待機
P_INP,
CLA
PIO
RECEIVEL0, SKI	/ if(S_IN ready) skip next
BUN	RECEIVEL0	/ goto L0 (S_IN not ready)
INP / AC(7:0) <- INPR
STA	STN
BUN	RECEIVEL1,

R_COM,
BSA	COM

RECEIVEL1,
BSA	PASSCNT

LDA	PASS
_B_, SZA
BUN	RECEIVEL2	/パスの場合RECEIVEL1まで飛ぶ

BSA	REFRESH
RECEIVEL2, BSA	SHOW
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
BUN	SEND_SHOW
BUN	TYPE_AG
SEND_SHOW,
BSA	SHOW
BSA	O_ENTER	/改行


SENDL1, 
LDA	GM
SZA
BUN	P_OUT
BUN	SENDL3
/パラレル出力する
P_OUT,
PIO
LDA	STN
SENDL2, SKO	/ if(S_OUT ready) skip next
BUN	SENDL2	/ goto SENDL2(P_OUT not ready)
OUT

SENDL3,
BSA	TRNCNT

BUN	SEND	I
TYPE_AG,
LDA	A_TA
STA	MSG_A
LDA	CNT_TA
STA	MSG_CNT
BSA	MSG
BSA	O_ENTER

LDA	A_INER
STA	MSG_A
LDA	CT_INER
STA	MSG_CNT
BSA	MSG
BSA	O_ENTER
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

SHOWLOOP1, LDA	VH9
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
BUN SHOWL1	/ goto SHOWL1(S_OUT not ready)
OUT	/ OUTR <- AC(7:0)

LDA	VH7C

SHOWL2, SKO	/ if(S_OUT ready) skip next
BUN SHOWL2	/ goto SHOWL2(S_OUT not ready)
OUT	/ OUTR <- AC(7:0)

ISZ	PTTMP	/スキップされることはない
ISZ	L	/SHOWLOOP2を抜けるか判定
BUN	SHOWLOOP2

BSA	O_ENTER

ISZ	K
BUN	SHOWLOOP1

BUN	SHOW	I
/////////////////////////////////end of subroutine/////////////////////////////////////


//////////////////////////////subroutine REFRESH/////////////////////////////////////
REFRESH, HEX	0
CLA
STA	TAFG
LDA	STN
ADD	PTCNST
STA	PTSTN
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
_B_,LDA	TAFG
SZA
BUN	REFRESHL1
BUN	REFRESH	I
/とりあえず入力された石の部分だけ更新する
REFRESHL1,
LDA	STN
ADD	PTCNST
STA	PTSTN
LDA	TRN
STA	PTSTN	I
BUN	REFRESH	I
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


//////////////////////////////subroutine BTOD///////////////////////////////////////////
BTOD, HEX	0
//arg0 : AC
STA	X
CLA
STA	Z
LDA	X
BTODL0,
ADD	VMA
SZE
BUN	BTODL1
ADD	VHA
ADD	VH30
STA	X
LDA	Z
ADD	VH30
STA	Z
BUN	BTOD	I
BTODL1,
ISZ	Z
BUN	BTODL0
//////////////////////////////end of subroutine////////////////////////////////////

//////////////////////////////subroutine COM///////////////////////////////////////////
COM, HEX	0
CLA
STA	MAX_SUM_STN
STA	MIN_SUM_STN
STA	SUM_SUM_TN_STN
STA	FSTFG
LDA	VM40
STA	J_CNT
LDA	PTCNST
STA	PTSTN
ISZ	SCHFG
LDA	A_COM
STA	MSG_A
LDA	CNT_COM
STA	MSG_CNT
BSA	MSG
BSA	O_ENTER

COML0,
LDA	PTSTN	I
SZA
BUN	COML1

CLA
STA	SUM_TN_STN
//上方向
LDA	VM8
STA	GONUM
LDA	VH8
STA	BACKNUM
LDA	VH64
STA	EDGE	/引いたら絶対に負になる数を代入
BSA	CROSS
LDA	SUM_TN_STN
ADD	CNT_TN_STN
STA	SUM_TN_STN
//下方向
LDA	VH8
STA	GONUM
LDA	VM8
STA	BACKNUM
LDA	VH64
STA	EDGE	/引いたら絶対に負になる数を代入
BSA	CROSS
LDA	SUM_TN_STN
ADD	CNT_TN_STN
STA	SUM_TN_STN
//左方向
LDA	VM1
STA	GONUM
LDA	VH1
STA	BACKNUM
LDA	VH7
STA	EDGE
BSA	CROSS
LDA	SUM_TN_STN
ADD	CNT_TN_STN
STA	SUM_TN_STN
//右方向
LDA	VH1
STA	GONUM
LDA	VM1
STA	BACKNUM
CLA
STA	EDGE
BSA	CROSS
LDA	SUM_TN_STN
ADD	CNT_TN_STN
STA	SUM_TN_STN
//左上
LDA	VM9
STA	GONUM
LDA	VH9
STA	BACKNUM
LDA	VH7
STA	EDGE
BSA	CROSS
LDA	SUM_TN_STN
ADD	CNT_TN_STN
STA	SUM_TN_STN
//右下
LDA	VH9
STA	GONUM
LDA	VM9
STA	BACKNUM
CLA
STA	EDGE
BSA	CROSS
LDA	SUM_TN_STN
ADD	CNT_TN_STN
STA	SUM_TN_STN
//右上
LDA	VM7
STA	GONUM
LDA	VH7
STA	BACKNUM
CLA
STA	EDGE
BSA	CROSS
LDA	SUM_TN_STN
ADD	CNT_TN_STN
STA	SUM_TN_STN
//左下
LDA	VH7
STA	GONUM
LDA	VM7
STA	BACKNUM
LDA	VH7
STA	EDGE
BSA	CROSS
LDA	SUM_TN_STN
ADD	CNT_TN_STN
STA	SUM_TN_STN
ADD	SUM_SUM_TN_STN
STA	SUM_SUM_TN_STN

LDA	DIF
SZA
BUN	DIF1
LDA	SUM_TN_STN	/ DIF = 0
SZA
BUN	DIF0L0
BUN	COML1
DIF0L0,
LDA	FSTFG
SZA
BUN	DIF0L1
LDA	VH1
STA	FSTFG
LDA	PTSTN
STA	PTTMP2
LDA	P1_CNST
STA	B_CHK
BUN	COML1
DIF0L1,
LDA	B_CHK
AND	VH1
SZA
BUN	DIF0L3
DIF0L2,
LDA	B_CHK
CIR
STA	B_CHK
BUN	COML1
DIF0L3,
LDA	PTSTN
STA	PTTMP2
BUN	DIF0L2

DIF1,
ADD	VM1
SZA
BUN	DIF2
TO_DIF1,
LDA	SUM_TN_STN	/ DIF = 1
CMA
INC
ADD	MAX_SUM_STN
SZA
BUN	DIF1L0
BUN	DIF0L0
DIF1L0,
SNA
BUN	COML1
LDA	SUM_TN_STN
STA	MAX_SUM_STN
LDA	PTSTN
STA	PTTMP2
BUN	COML1

DIF2,	/ DIF = 2
LDA	SUM_TN_STN
SZA
BUN	DIF2L0
BUN	COML1
DIF2L0,
LDA	J_CNT
ADD	VH40
SZA
BUN	DIF2L1
BUN	DIF2L4
DIF2L1,
LDA	J_CNT
ADD	VH39
SZA
BUN	DIF2L2
BUN	DIF2L4
DIF2L2,
LDA	J_CNT
ADD	VH8
SZA
BUN	DIF2L3
BUN	DIF2L4
DIF2L3,
LDA	J_CNT
ADD	VH1
SZA
BUN	DIF2L5
DIF2L4,
LDA	PTSTN
STA	PTTMP2
BUN	COML2
DIF2L5,
LDA	TRN_SUM
ADD	VH28
SNA
BUN	TO_DIF1
LDA	SUM_TN_STN
CMA
INC
ADD	MIN_SUM_STN
SPA
BUN	COML1
SZA
BUN	DIF2L6
BUN	DIF0L0
DIF2L6,
LDA	SUM_TN_STN
STA	MIN_SUM_STN
LDA	PTSTN
STA	PTTMP2
BUN	COML1

COML1,
ISZ	PTSTN
ISZ	J_CNT
BUN	COML0

LDA	SUM_SUM_TN_STN
SZA
BUN	COML2
LDA	VH7A
STA	STN
BUN	COML3
COML2,
LDA	PTCNST
CMA
INC
ADD	PTTMP2
STA	STN
COML3,
CLA
STA	SCHFG
BUN	COM	I
//////////////////////////////end of subroutine////////////////////////////////////

//////////////////////////////subroutine CROSS/////////////////////////////////////
/コメントでは上方向の場合を例にしている
CROSS, HEX	0
CLA
STA	CNT_TN_STN
/PTを石を置いた位置に相当する配列要素のアドレスとする
LDA	PTSTN
STA	PTTMP
LDA	PTSTN	I
SZA
BUN	CROSSHLT
CLA
STA	CNT_CROSSLOOP
/do{ i++; } while(STN-8i>= PTCNST(アンダーフロー配列範囲外) && STN-8i < PTCNST+64 (オーバーフロー配列範囲外) && D[STN-8i] != 0(まだ石が置かれてないマス) && D[STN-8i] != M[TRN](自分の色の石が置いてあるマス))
/do部分
CROSSLOOP, ISZ	CNT_CROSSLOOP
LDA	PTTMP
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

LDA	SCHFG
SZA
BUN	SEARCH

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
LDA	CNT_CROSSLOOP
ADD	VM2
SNA
ISZ	TAFG
/else 何も変えない
CROSSHLT, BUN	CROSS	I
SEARCH,
LDA	PTTMP
ADD	BACKNUM
STA	PTTMP
CMA
INC
ADD	PTSTN
SZA
BUN	INC_STN
BUN	CROSS	I
INC_STN,
ISZ	CNT_TN_STN
BUN	SEARCH
/////////////////////////////////end of subroutine/////////////////////////////////////

//データ
VH0, DEC	0
VH1, DEC	1
VM1, DEC	-1
VH7, DEC	7
VM7, DEC	-7
VH8, DEC	8
VM8, DEC	-8
VH2, DEC	2
VM2, DEC	-2
VH3, HEX	3
VH9, DEC	9
VM9, DEC	-9
VH27, DEC	27
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
VM30, DEC	-48
VM31, DEC	-49
VH20, HEX	20
VH28, HEX	28
VH7C, HEX	7C	/|
VH30, HEX	30
VH39, HEX	39
VM3C, DEC	-60
VH49, HEX	49
VM20, DEC	-32
VM40, DEC	-64
VM41, DEC	-65
CNT_CROSSLOOP, DEC	0
CHECKCT, DEC 	0
CHECKFLG, DEC	0
RESETCT, DEC 	0
BACKNUM, DEC	-8
GONUM, DEC	8
EDGE, DEC	0
PASS,DEC	0	/パスが入力されたら1、連続してパスが入力されたら2
K, DEC		0	/for文のint i
L, DEC		0	/for文のint i
STN, DEC	0	/Stone.今置かれた石の通し番号
TRN, DEC	1	/現在のターンは1と2のどちらか
TRN_SUM, DEC	0
PTSTN, DEC	0	/今置かれた石の配列要素のアドレス
PTTMP, DEC	0	/コンピュータが今見ている石の配列要素のアドレス
PTTMP2, DEC	0
PTCNST, SYM D / M[PT] = （ラベル D のアドレス、書き換え禁止）
MSG_A,	HEX	0
MSG_CNT, HEX	0

A_INTRO, SYM STR_INTRO
CNT_INTRO, DEC -76
STR_INTRO,
HEX	2D
HEX	2D
HEX	2D
CHR	R
CHR	E
CHR	V
CHR	E
CHR	R
CHR	S
CHR	I
HEX	2D
HEX	2D
HEX	2D
HEX	0A
CHR	P
CHR	L
CHR	1
CHR	'
CHR	s
HEX	20
CHR	p
CHR	i
CHR	e
CHR	c
CHR	e
HEX	3A
HEX	20
HEX	2A
HEX	2C
HEX	20
CHR	P
CHR	L
CHR	2
CHR	'
CHR	s
HEX	3A
HEX	20
HEX	4F
HEX	2E
HEX	0A
CHR	I
CHR	n
CHR	p
CHR	u
CHR	t
HEX	20
CHR	c
CHR	o
CHR	r
CHR	d
CHR	i
CHR	n
CHR	a
CHR	t
CHR	e
CHR	s
HEX	20
CHR	t
CHR	o
HEX	20
CHR	p
CHR	u
CHR	t
HEX	20
CHR	t
CHR	h
CHR	e
HEX	20
CHR	p
CHR	i
CHR	e
CHR	c
CHR	e
CHR	s
HEX	2E
HEX	0A

A_GM,	SYM MSG_GM
CNT_GM,DEC -27
MSG_GM,
CHR	G
CHR	A
CHR	M
CHR	E
CHR	M
CHR	O
CHR	D
CHR	E
HEX	20
CHR	S
CHR	I
CHR	N
CHR	G
CHR	L
CHR	E
CHR	:
CHR	0
HEX	2F
CHR	M
CHR	U
CHR	L
CHR	T
CHR	I
CHR	:
CHR	1
CHR	?
CHR	>

A_DIF,	SYM MSG_DIF
CNT_DIF,	DEC -18
MSG_DIF,
CHR	D
CHR	I
CHR	F
CHR	F
CHR	I
CHR	C
CHR	U
CHR	L
CHR	T
CHR	Y
CHR	:
CHR	0
HEX	2F
CHR	1
HEX	2F
CHR	2
CHR	?
CHR	>

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

A_COM,	SYM MSG_COM
CNT_COM,DEC -9	/ CNT_BMG = -6
MSG_COM,
CHR	C
CHR	O
CHR	M
HEX	20
CHR	T
CHR	U
CHR	R
CHR	N
CHR	>

A_INER,	SYM INER
A_INER_CNST,	SYM INER
CT_INER_CNST,	DEC -12
CT_INER,	DEC -12
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
	HEX 0A

A_TA,	SYM TA
CNT_TA,	DEC -13
TA,	CHR I
	CHR N	
	CHR V
	CHR A
	CHR L
	CHR I
	CHR D
	HEX 20
	CHR P
	CHR L
	CHR A
	CHR C
	CHR E


A_STN_SUM,	SYM MSG_STN_SUM
A_PL1_SUM_CNST,	SYM PL1_SUM
A_PL2_SUM_CNST,	SYM PL2_SUM
A_PL1_SUM,	SYM PL1_SUM
A_PL2_SUM,	SYM PL2_SUM
CNT_STN_SUM,	DEC -13
MSG_STN_SUM,	CHR P
	CHR L
	CHR 1
	HEX 3A
PL1_SUM,	HEX 0
	HEX 0
	HEX 20
	CHR P
	CHR L
	CHR 2
	HEX 3A
PL2_SUM,	HEX 0
	HEX 0

A_WIN,	SYM MSG_WIN
CNT_WIN,	DEC -8
MSG_WIN,	CHR Y
	CHR O
	CHR U
	HEX 20
	CHR W
	CHR I
	CHR N
	HEX 21
A_LOSE,	SYM MSG_LOSE
CNT_LOSE,	DEC -8
MSG_LOSE,	CHR Y
	CHR O
	CHR U
	HEX 20
	CHR L
	CHR O
	CHR S
	CHR E

A_DRAW,	SYM MSG_DRAW
CNT_DRAW,	DEC -4
MSG_DRAW,	CHR D
	CHR R
	CHR A
	CHR W

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
LP,	DEC -80
SA,	DEC -97
SI,	DEC -105
SP,	DEC -112
X,	DEC 0
Y,	DEC 8
Z,	DEC 0
KN,	DEC -16
DIF,	DEC 0
TAFG,	DEC 0	/ type again flag
SCHFG,	DEC 0
FSTFG,	DEC 0
SUM_TN_STN,	DEC 0
SUM_SUM_TN_STN,	DEC 0
CNT_TN_STN,	DEC 0
MAX_SUM_STN,	DEC 0
MIN_SUM_STN,	DEC 0
J_CNT,	DEC -64
B_CHK,	HEX 0
O_STN_SUM,	DEC 0
T_STN_SUM,	DEC 0
PL,	DEC 0	/0:PL1,1:PL2
GM,	DEC 0
COMLP,	DEC 0
P, DEC 0	/ M[P] = 0（初期化必要）
A_D, SYM D
A_D_CNST, SYM D
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
