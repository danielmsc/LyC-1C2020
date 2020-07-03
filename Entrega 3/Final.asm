include macros2.asm

include number.asm

.MODEL	LARGE

.386

.STACK 200h

MAXTEXTSIZE equ 50

.DATA

	a1 dd ?

	b1 dd ?

	variable1 db ?

	variable2 db ?

	p1 dd ?

	p2 dd ?

	p3 dd ?

	a dw ?

	b dw ?

	i dw ?

	_2 dw "2", '$'

	_5 dw "5", '$'

	_45_6 dd "45.6", '$'

	_6 dw "6", '$'

	_3 dw "3", '$'

	_0 dw "0", '$'

	_b_es_mayor_que_cero db "b es mayor que cero", '$',  19 dup (?)

	_Verdadero db "Verdadero", '$',  9 dup (?)

	_1 dw "1", '$'

	_Cantidad_de_alumnos db "Cantidad de alumnos", '$',  19 dup (?)

	_10 dw "10", '$'

	_10_iteraciones db "10 iteraciones", '$',  14 dup (?)

	_Factorial_de_4 db "Factorial de 4", '$',  14 dup (?)

	_Combinatorio_de_6_y_2 db "Combinatorio de 6 y 2", '$',  21 dup (?)

	_5_5 dd "5.5", '$'

	@res	dd	?

	@resFact	dd	?

	@auxFact	dd	?

	@res2	dd	?
	@res4	dd	?
	@res7	dd	?
	@res8	dd	?
	@res11	dd	?
	@res12	dd	?
	@res15	dd	?
	@res19	dd	?
	@res20	dd	?
	@res22	dd	?
	@res25	dd	?
	@res27	dd	?
	@res28	dd	?
	@res32	dd	?
	@res33	dd	?
	@res34	dd	?
	@res35	dd	?
	@res38	dd	?
	@res39	dd	?
	@res40	dd	?
	@res61	dd	?
	@res62	dd	?
	@res67	dd	?
	@res81	dd	?
	@res82	dd	?
	@res86	dd	?
	@res87	dd	?
	@res91	dd	?
	@res92	dd	?
	@res95	dd	?
	@res97	dd	?
	@res98	dd	?
	@res102	dd	?
	@res103	dd	?
	@res104	dd	?
	@res105	dd	?
	@res108	dd	?
	@res111	dd	?
	@res114	dd	?
	@res116	dd	?
	@res117	dd	?
	@res121	dd	?
	@res122	dd	?
	@res123	dd	?
	@res124	dd	?
	@res128	dd	?
	@res131	dd	?
	@res133	dd	?
	@res134	dd	?
	@res138	dd	?
	@res139	dd	?
	@res140	dd	?
	@res141	dd	?
	@res144	dd	?
	@res145	dd	?
	@res148	dd	?
	@res150	dd	?
	@res151	dd	?
	@res155	dd	?
	@res156	dd	?
	@res157	dd	?
	@res158	dd	?
	@res161	dd	?
	@res162	dd	?
	@res163	dd	?
	@res164	dd	?
	@res187	dd	?
	@res188	dd	?
	@res192	dd	?
	@res193	dd	?
.CODE
FILD b

FILD _2

FIST b

FSTP @res2 

FILD a

FILD b

FIST a

FSTP @res4 

FILD b

FILD _5

FMUL

FSTP @res7 

FLD b1

FILD @res7

FST b1

FSTP @res8 

FLD p2

FLD p3

FADD

FSTP @res11 

FLD p1

FLD @res11

FST p1

FSTP @res12 

FLD a1

FLD _45_599998

FMUL

FSTP @res15 

FILD _3

FILD b

FSUB

FSTP @res19 

FILD _6

FILD @res19

FDIV

FSTP @res20 

FLD @resFact

FILD _3

FIST @resFact

FSTP @res22 

FLD @resFact

FILD _1

FXCH

FCOM

FSTSW	ax

SAHF

JG ETIQ27

FLD @resFact

FILD _1

FIST @resFact

FSTP @res25 

JMP ETIQ37

ETIQ27:

FLD @auxFact

FILD _3

FIST @auxFact

FSTP @res27 

FLD @auxFact

FILD _1

FSUB

FSTP @res28 

ETIQ29:

FLD @auxFact

FILD _1

FXCH

FCOM

FSTSW	ax

SAHF

JG ETIQ32

JMP ETIQ37

ETIQ32:

FLD @resFact

FLD @auxFact

FMUL

FSTP @res32 

FLD @resFact

FILD @res32

FIST @resFact

FSTP @res33 

FLD @auxFact

FILD _1

FSUB

FSTP @res34 

FLD @auxFact

FILD @res34

FIST @auxFact

FSTP @res35 

JMP ETIQ29

ETIQ37:

FILD @res20

FLD @resFact

FMUL

FSTP @res38 

FLD @res15

FLD @res38

FADD

FSTP @res39 

FLD b1

FLD @res39

FST b1

FSTP @res40 

FILD b

FILD _0

FXCH

FCOM

FSTSW	ax

SAHF

JLE ETIQ51

displayString "b es mayor que cero"

FILD b

FILD _0

FXCH

FCOM

FSTSW	ax

SAHF

JL ETIQ51

displayString "Verdadero"

ETIQ51:

FILD a

FILD b

FXCH

FCOM

FSTSW	ax

SAHF

JLE ETIQ63

FILD _1

FILD _0

FXCH

FCOM

FSTSW	ax

SAHF

JLE ETIQ63

FILD a

FILD _1

FADD

FSTP @res61 

FILD b

FILD @res61

FIST b

FSTP @res62 

ETIQ63:

displayString "Cantidad de alumnos"

getFloat a

displayFloat a, 2

FILD i

FILD _0

FIST i

FSTP @res67 

ETIQ68:

FILD i

FILD _10

FXCH

FCOM

FSTSW	ax

SAHF

JGE ETIQ74

displayString "10 iteraciones"

JMP ETIQ68

ETIQ74:

displayFloat b, 2

FILD b

FILD _0

FXCH

FCOM

FSTSW	ax

SAHF

JLE ETIQ84

FILD b

FILD _1

FADD

FSTP @res81 

FILD b

FILD @res81

FIST b

FSTP @res82 

JMP ETIQ88

ETIQ84:

FILD b

FILD _2

FADD

FSTP @res86 

FILD b

FILD @res86

FIST b

FSTP @res87 

ETIQ88:

displayString "Factorial de 4"

FILD _3

FILD _1

FADD

FSTP @res91 

FLD @resFact

FILD @res91

FIST @resFact

FSTP @res92 

FLD @resFact

FILD _1

FXCH

FCOM

FSTSW	ax

SAHF

JG ETIQ97

FLD @resFact

FILD _1

FIST @resFact

FSTP @res95 

JMP ETIQ107

ETIQ97:

FLD @auxFact

FILD @res91

FIST @auxFact

FSTP @res97 

FLD @auxFact

FILD _1

FSUB

FSTP @res98 

ETIQ99:

FLD @auxFact

FILD _1

FXCH

FCOM

FSTSW	ax

SAHF

JG ETIQ102

JMP ETIQ107

ETIQ102:

FLD @resFact

FLD @auxFact

FMUL

FSTP @res102 

FLD @resFact

FILD @res102

FIST @resFact

FSTP @res103 

FLD @auxFact

FILD _1

FSUB

FSTP @res104 

FLD @auxFact

FILD @res104

FIST @auxFact

FSTP @res105 

JMP ETIQ99

ETIQ107:

FILD a

FILD _2

FIST a

FSTP @res108 

displayString "Combinatorio de 6 y 2"

FLD @resFact

FILD _6

FIST @resFact

FSTP @res111 

FLD @resFact

FILD _1

FXCH

FCOM

FSTSW	ax

SAHF

JG ETIQ116

FLD @resFact

FILD _1

FIST @resFact

FSTP @res114 

JMP ETIQ126

ETIQ116:

FLD @auxFact

FILD _6

FIST @auxFact

FSTP @res116 

FLD @auxFact

FILD _1

FSUB

FSTP @res117 

ETIQ118:

FLD @auxFact

FILD _1

FXCH

FCOM

FSTSW	ax

SAHF

JG ETIQ121

JMP ETIQ126

ETIQ121:

FLD @resFact

FLD @auxFact

FMUL

FSTP @res121 

FLD @resFact

FILD @res121

FIST @resFact

FSTP @res122 

FLD @auxFact

FILD _1

FSUB

FSTP @res123 

FLD @auxFact

FILD @res123

FIST @auxFact

FSTP @res124 

JMP ETIQ118

ETIQ126:

FLD @resFact

FILD _2

FIST @resFact

FSTP @res128 

FLD @resFact

FILD _1

FXCH

FCOM

FSTSW	ax

SAHF

JG ETIQ133

FLD @resFact

FILD _1

FIST @resFact

FSTP @res131 

JMP ETIQ143

ETIQ133:

FLD @auxFact

FILD _2

FIST @auxFact

FSTP @res133 

FLD @auxFact

FILD _1

FSUB

FSTP @res134 

ETIQ135:

FLD @auxFact

FILD _1

FXCH

FCOM

FSTSW	ax

SAHF

JG ETIQ138

JMP ETIQ143

ETIQ138:

FLD @resFact

FLD @auxFact

FMUL

FSTP @res138 

FLD @resFact

FILD @res138

FIST @resFact

FSTP @res139 

FLD @auxFact

FILD _1

FSUB

FSTP @res140 

FLD @auxFact

FILD @res140

FIST @auxFact

FSTP @res141 

JMP ETIQ135

ETIQ143:

FILD _6

FILD _2

FSUB

FSTP @res144 

FLD @resFact

FILD @res144

FIST @resFact

FSTP @res145 

FLD @resFact

FILD _1

FXCH

FCOM

FSTSW	ax

SAHF

JG ETIQ150

FLD @resFact

FILD _1

FIST @resFact

FSTP @res148 

JMP ETIQ160

ETIQ150:

FLD @auxFact

FILD @res144

FIST @auxFact

FSTP @res150 

FLD @auxFact

FILD _1

FSUB

FSTP @res151 

ETIQ152:

FLD @auxFact

FILD _1

FXCH

FCOM

FSTSW	ax

SAHF

JG ETIQ155

JMP ETIQ160

ETIQ155:

FLD @resFact

FLD @auxFact

FMUL

FSTP @res155 

FLD @resFact

FILD @res155

FIST @resFact

FSTP @res156 

FLD @auxFact

FILD _1

FSUB

FSTP @res157 

FLD @auxFact

FILD @res157

FIST @auxFact

FSTP @res158 

JMP ETIQ152

ETIQ160:

FLD @resFact

FLD @resFact

FMUL

FSTP @res161 

FLD @resFact

FLD @res161

FDIV

FSTP @res162 

FLD @res

FLD @res162

STR @res

FSTP @res163 

FILD a

FLD @res163

FST a

FSTP @res164 

FILD a

FILD _5

FXCH

FCOM

FSTSW	ax

SAHF

JLE ETIQ196

ETIQ169:

FILD b

FILD _6

FXCH

FCOM

FSTSW	ax

SAHF

JLE ETIQ195

FILD _2

FILD _1

FXCH

FCOM

FSTSW	ax

SAHF

JLE ETIQ195

FLD _5_500000

FLD p3

FXCH

FCOM

FSTSW	ax

SAHF

JG ETIQ194

FILD b

FILD _0

FXCH

FCOM

FSTSW	ax

SAHF

JLE ETIQ190

FLD @resFact

FILD _1

FADD

FSTP @res187 

FILD b

FLD @res187

FST b

FSTP @res188 

JMP ETIQ194

ETIQ190:

FILD b

FILD _2

FADD

FSTP @res192 

FILD b

FILD @res192

FIST b

FSTP @res193 

ETIQ194:

JMP ETIQ169

ETIQ195:

JMP ETIQ169

ETIQ196:

ffree
mov ax,4c00h
int 21h
End