import os

class HandheldHalting:
    def __init__(self, filename):
        self.filename = os.path.abspath(os.getcwd() + filename)
        self.inputdata = self.getinputdata()

        self.acc = 0 # Accumulator
        self.eip = 0 # Instruction pointer
        self.processed_instructions = []
        self.changed_instructions = []
        self.processed_change = False

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

    def reset(self):
        self.acc = 0
        self.eip = 0
        self.processed_instructions = []
        self.processed_change = False

    def run(self):
        while True:
            # If we're going out of range, reset
            if self.eip >= len(self.inputdata):
                self.reset()
                continue

            instruction = self.inputdata[self.eip]

            # If we've seen this instruction before, reset
            if self.duplicate_instruction(self.eip, instruction):
                print('Encountered loop, terminating.')
                self.reset()
                continue

            # We've not seen this instruction before, so store it
            self.store_instruction(self.eip, instruction)
            
            if instruction[0:3] == 'nop':
                self.eip += 1
            elif instruction[0:3] == 'jmp':
                # If this jmp isn't in changed_instructions and we haven't 
                # changed an instruction yet this round, change it now
                if self.eip not in self.changed_instructions and self.processed_change == False:
                    # Store this jmp
                    self.changed_instructions.append(self.eip)
                    # Perform NOP instead
                    self.eip += 1
                    # Mark that we've changed an instruction this round
                    self.processed_change = True
                else: # Or else just jmp as normal
                    self.eip += 0 + (int(instruction[4:]))
            elif instruction[0:3] == 'acc':
                self.eip += 1
                self.acc += 0 + (int(instruction[4:]))

            if self.eip == len(self.inputdata):
                print(self.acc)
                # print(self.acc, self.eip, self.changed_instructions)
                break

handheldhalting = HandheldHalting('./input/day8.txt')
handheldhalting.run()
