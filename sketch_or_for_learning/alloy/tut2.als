sig Object {}

sig File in Object {}
sig Dir in Object {}

fact { no File & Dir }

run example {}
