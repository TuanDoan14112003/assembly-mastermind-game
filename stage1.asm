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
HALT

codemakerPrompt: .ASCIZ "Enter codemaker name:"
codebreakerPrompt: .ASCIZ "\nEnter codebreaker name:"
numberOfGuessesPrompt: .ASCIZ "\nEnter the maximum number of guesses:"
codemaker: .BLOCK 128
codebreaker: .BLOCK 128
codemakerMsg: .ASCIZ "\nCodemaker name is "
codebreakerMsg: .ASCIZ "\nCodebreaker name is "
numberOfGuessesMsg: .ASCIZ "\nMaximum number of guesses: "