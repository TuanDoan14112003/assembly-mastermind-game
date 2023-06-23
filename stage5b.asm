MOV R0, #codemakerPrompt
STR R0, .WriteString    ; print codemaker prompt  
MOV R0, #codemaker
STR R0, .ReadString ; read codemaker name

MOV R0, #codebreakerPrompt
STR R0, .WriteString   ; print codebreaker prompt
MOV R0, #codebreaker
STR R0, .ReadString ; read codebreaker name

MOV R0, #numberOfGuessesPrompt
STR R0, .WriteString   ; print number of guesses prompt
LDR R1, .InputNum ; read number of guesses 

MOV R0, #codemakerMsg
STR R0, .WriteString ; print codemaker message
MOV R0, #codemaker
STR R0, .WriteString ; print codemaker name

MOV R0, #codebreakerMsg
STR R0, .WriteString ; print codebreaker message
MOV R0, #codebreaker
STR R0, .WriteString ; print codebreaker name

MOV R0, #numberOfGuessesMsg
STR R0, .WriteString ; print number of guesses message
STR R1, .WriteUnsignedNum ; print number of guesses


MOV R0,#0x0A
STRB R0,.WriteChar ; print a new line character
MOV R0, #codemaker
STR R0, .WriteString ; print the codemaker name
MOV R0, #secretcodePrompt
STR R0, .WriteString

PUSH {R0}
MOV R0, #secretcode
BL getcode ; get the secret code
POP {R0}


askQuerycode:
MOV R0,#0x0A
STRB R0,.WriteChar ; print a new line character
MOV R0, #codebreaker
STR R0, .WriteString ; print the codebreaker name
MOV R0, #querycodePrompt
STR R0, .WriteString ; print the query code prompt
STR R1, .WriteUnsignedNum ; print the current guess number

PUSH {R0}
MOV R0, #querycode
BL getcode ; get the query code
POP {R0}

PUSH {R0, R1}
MOV R0, #secretcode
MOV R1, #querycode
BL comparecodes
MOV R3, R0 ;case1
MOV R4, R1 ;case2
POP {R0,R1}


MOV R0,#0x0A
STRB R0,.WriteChar ; print a new line character
MOV R0, #case1Msg
STR R0, .WriteString
STR R3, .WriteUnsignedNum

MOV R0, #case2Msg
STR R0, .WriteString
STR R4, .WriteUnsignedNum

CMP R3, #4 ;check if case 1 is 4
BNE checkGuessNumber
MOV R0,#0x0A
STRB R0,.WriteChar ; print a new line character
MOV R0, #codebreaker
STR R0, .WriteString ; print codebreaker name
MOV R0, #codebreakerWinMsg
STR R0, .WriteString ; print you win message
B gameover

checkGuessNumber:
SUB R1, R1, #1
CMP R1, #0 ; Compare the current guess number with 0
BNE askQuerycode

MOV R0,#0x0A
STRB R0,.WriteChar ; print a new line character
MOV R0, #codebreaker
STR R0, .WriteString ; print codebreaker name
MOV R0, #codebreakerLoseMsg 
STR R0, .WriteString ; print you lose message
gameover:
MOV R0, #gameoverMsg
STR R0, .WriteString ; print game over message
HALT

getcode:
    ; R0: the array that will store the code
    PUSH {R2,R3,R4} 
    MOV R2, R0 ; copy input of R0 to R2

    loop:
    MOV R3, #codePrompt 
    STR R3, .WriteString ;print the code prompt
    STR R2, .ReadString ; read the string 
    MOV R3, #0 ; index

    checkcode:
    LDRB R4, [R2 + R3]
    CMP R4, #0x72 ; compare R4 with r
    BEQ cont
    CMP R4, #0x67 ; compare R4 with g
    BEQ cont
    CMP R4, #0x62 ; compare R4 with b
    BEQ cont
    CMP R4, #0x79 ; compare R4 with y
    BEQ cont
    CMP R4, #0x70 ; compare R4 with p
    BEQ cont
    CMP R4, #0x63 ; compare R4 with c
    BEQ cont
    B loop ; if it doesn't match any of the color then restart everything again

    cont:
    ADD R3, R3, #1 ; increment the index
    CMP R3, #4 ; check if the index is 4
    BLT checkcode ;  if it is less than 4 then check the next code
    LDRB R4, [R2 + R3] ; if the index is 4 then check the next value to see if it is null
    CMP R4, #0
    BNE loop ; if the last character is not null then restart everything again


    POP {R2,R3,R4}
    RET

comparecodes:
    ;R0 secretcode, R1 querycode
    PUSH {R2,R3,R4,R5,R6,R7}
    MOV R2, R0 ; copy secretcode to R2
    MOV R3, R1 ; copy querycode to R3
    MOV R0, #0 ;case 1
    MOV R1, #0 ; case 2
    MOV R4, #0 ; index for secret code

    iterateSecretcode:
    LDRB R5, [R2 + R4] ; get secretcode peg at index
    LDRB R6, [R3 + R4] ; get querycode peg at index
    CMP R5, R6 ; check the pegs
    BNE else
    ADD R0, R0, #1 ; increment case 1
    B incrementSecretcodeIndex

    else:
    MOV R7, #0 ; index for query code

    iterateQuerycode:
    LDRB R6, [R3 + R7] ; get querycode peg at index
    CMP R5, R6
    BNE incrementQuerycodeIndex
    ADD R1, R1, #1 ; increment case 2
    B incrementSecretcodeIndex

    incrementQuerycodeIndex:
    ADD R7, R7, #1 
    CMP R7, #4
    BNE iterateQuerycode


    incrementSecretcodeIndex:
    ADD R4, R4, #1
    CMP R4, #4
    BNE iterateSecretcode ; stop if index reaches 4 
    POP {R2,R3,R4,R5,R6,R7}
    RET



codemakerPrompt: .ASCIZ "Enter codemaker name:"
codebreakerPrompt: .ASCIZ "\nEnter codebreaker name:"
numberOfGuessesPrompt: .ASCIZ "\nEnter the maximum number of guesses:"
codemaker: .BLOCK 128
codebreaker: .BLOCK 128
codemakerMsg: .ASCIZ "\nCodemaker name is "
codebreakerMsg: .ASCIZ "\nCodebreaker name is "
numberOfGuessesMsg: .ASCIZ "\nMaximum number of guesses: "
codePrompt: .ASCIZ "\nEnter a code: "
secretcodePrompt: .ASCIZ ", please enter a 4-character secret code"
secretcode: .BLOCK 128
querycode: .BLOCK 128
querycodePrompt: .ASCIZ ", this is guess number: "
case1Msg: .ASCIZ "Position matches: "
case2Msg: .ASCIZ ", Colour matches: "
codebreakerWinMsg: .ASCIZ ", you WIN!"
codebreakerLoseMsg: .ASCIZ ", you LOSE!"
gameoverMsg: .ASCIZ "\nGame Over!"