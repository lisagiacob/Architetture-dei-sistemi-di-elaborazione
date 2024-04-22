.data
v1:	.double 3.26,71.46,87.19,45.58,94.46,82.53,74.42,13.68
	.double	22.55,98.57,76.77,2.23,54.88,33.96,42.38,31.3
	.double	86.87,12.23,3.68,45.15,34.82,25.69,51.99,55.42
	.double	6.83,1.82,67.35,74.39,18.35,59.73,28.22,3.8
	.double	85.9,27.34,61,48.79,33.26,62.5,36.73,61.51
	.double	75.55, 34.27,10.23,40.54,75.22,40.41,52.18,51.52
	.double	80.02,68.37,70.93,54.87,37.93,66.3,79.41,31.89
	.double	22.2,31.06,89.88,71.58,47.42,89.27,93.28,6.07
	
v2:	.double 67.92,41.06,96.15,23.97,56.02,47.86,84.72,48.71
	.double	75.04,90.61,3.28,6.6,85.92,46.35,10.02,88.33
	.double	39.44,86.93,93.19,94.57,56.35,74.46,21.63,41.48
	.double	34.52,47.06,65.99,19.79,11.97,75.02,59.17,29.78
	.double	45.23,96.9,9.76,4.49,59.6,54.23,49.48,37.11
	.double	79.44,64.68,4.61,44.33,28.11,76.92,39.28,17.63
	.double	88.4,21.19,38.53,9.34,93.53,99.16,18.1,13.92
	.double	25.97,65.1,71.75,42.14,82.08,50.25,73.95,94.01
	
v3:	.double 82.5,59.73,37.22,96.09,59.77,60.58,76.15,53.68
	.double	52.56,18.8,68.84,24.17,84.33,92.82,45.94,17.63
	.double	88.24,7.14,85.36,52.64,42.2,72.79,12.42,88.86
	.double	15.79,64.3,89.52,3.71,6.93,88.06,23.13,91.76
	.double	25.26,93.91,73.66,10.39,33.61,23.27,7.24,99.33
	.double	92.87,8.32,64.17,24.79,92.67,79.94,68.33,8.39
	.double	53.39,73.77,25.22,17.17,46.72,82.55,33.97,20.93
	.double	31.39,41.52,61.78,12.35,92,97.33,35.47,44.75
	
v4:	.double 82.59,39.26,73.92,32.79,52.04,9.71,72.45,40.54
	.double	13.6,82.81,83.48,83.68,75.23,97.02,79.01,86.52
	.double	73.68,46.59,66.58,3,27.92,31.32,4.91,39.34
	.double	42.64,95.26,27.28,59.04,6.45,10.84,82.4,76.45
	.double	72.05,46.58,57.73,62.59,4.94,41.4,38.7,22.76
	.double	19.99,85.08,80.68,38.59,34.66,3.28,84.85,36.53
	.double	76.92,22.18,9.21,32.36,16.48,99.2,83.64,72.55
	.double	27.91,29.09,10.35,30.66,23.09,28.8,83.65,80.02
	
v5:	.space 512
v6:	.space 512
v7:	.space 512

.text
sub.d	F11, F0, F0 	# double k=0
dadd	R15, R0, R0		
daddui	R2, R0, 256											

sub.d	F12, F0, F0		# double p=0
dadd	R1, R0, R0		#inizializzo i a 0
daddui	R3, R0, 1		# int m=1

loop:		#32
	l.d		F1, v1(R1)	#Serve a riga 64



	
	dsllv		R3, R3, R15 # shifto m di i
		
	# Casto m da int a double
	mtc1		R3, F13		 # Sposto m in un regirstro F
	cvt.d.l		F13, F13	 # Converto a double
	
	mul.d		F12, F1, F13 # p = v1*m
	l.d		F4, v4(R1)	#Serve a riga 83
	l.d		F2, v2(R1)
	l.d		F3, v3(R1)
	# Converto da double a int
	add.d	F10, F11, F1
	cvt.l.d		F13, F12
	mfc1		R3, F13
		
	mul.d	F5, F12, F2
	
		add.d	F10, F2, F3
		daddui	R1, R1, 8
		daddui	R15, R15, 1
	
	add.d	F5, F5, F3
	add.d	F5, F5, F4

	s.d		F5, v5(R1)

	div.d	F6, F5, F10

	s.d		F6, v6(R1)



	mul.d	F7, F6, F10

	s.d		F7, v7(R1)

	beq		R1, R2, stop	
		
	#UNROLL
	l.d		F1, v1(R1)	#Serve a riga 64
	l.d		F4, v4(R1)	#Serve a riga 83
	l.d		F2, v2(R1)


	dmul		R20, R3, R15		# m*i
	# Casto da int a double
	mtc1		R20, F20		# Sposto m in un regirstro F
	cvt.d.l		F20, F20	 	# Converto a double
	div.d		F12, F1, F20	# p=v1[i]/(m*i)
	
	#Casto v4 a int
	cvt.l.d		F20, F4
	mfc1		R20, F20 		# Sposto v4 in un registro R
	
	dsrlv 		R20, R20, R15	# v4/2^i
	
	mtc1		R20, F11		# k=
	cvt.d.l		F11, F11
	
	l.d		F3, v3(R1)
	add.d	F10, F11, F1
	mul.d	F5, F12, F2
	add.d	F5, F5, F3
	add.d	F5, F5, F4

	s.d		F5, v5(R1)

	div.d	F6, F5, F10

	add.d	F10, F2, F3
	daddui	R1, R1, 8
	daddui	R15, R15, 1
	mul.d	F7, F6, F10

	s.d		F6, v6(R1)
	s.d		F7, v7(R1)

	beq		R1, R2, stop
	j		loop

stop:
	HALT
