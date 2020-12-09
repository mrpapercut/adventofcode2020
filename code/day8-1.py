import os

class HandheldHalting:
    def __init__(self, filename):
        self.filename = os.path.abspath(os.getcwd() + filename)
        self.inputdata = self.getinputdata()

        self.acc = 0 # Accumulator
        self.eip = 0 # Instruction pointer
        self.processed_instructions = []

    def getinputdata(self):
        fh = open(self.filename, 'r')

        contents = fh.read()
        fh.close()

        return contents.split("\n")

    def store_instruction(self, eip, instruction):
        # Store eip + instruction to mark as processed
        self.processed_instructions.append(':'.join([str(self.eip), instruction]))

    def duplicate_instruction(self, eip, instruction):
        # Check if we've seen this exact instruction before
        return ':'.join([str(self.eip), instruction]) in self.processed_instructions

    def run(self):
        while True:
            instruction = self.inputdata[self.eip]

            # If we've seen this instruction before, print accumulator and terminate
            if self.duplicate_instruction(self.eip, instruction):
                print(self.acc)
                break

            # We've not seen this instruction before, so store it
            self.store_instruction(self.eip, instruction)
            
            if instruction[0:3] == 'nop':
                self.eip += 1
            elif instruction[0:3] == 'jmp':
                self.eip += 0 + (int(instruction[4:]))
            elif instruction[0:3] == 'acc':
                self.eip += 1
                self.acc += 0 + (int(instruction[4:]))

handheldhalting = HandheldHalting('./input/day8.txt')
handheldhalting.run()
