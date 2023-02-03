# CPU-Hardwired Project

<h2 align="center"> CPU design introduction </h2>
There are some types of CPU architectures out there and they can be classified according to several types of architectures:

- <p>Von Neumann Architecture: <br>
  The Von Neumann architecture has one memory for storing instruction and data.</p>

- <p>Harvard Architecture: <br>
  The Harvard architecture has two types of memory:
  - instruction memory (to store instructions)
  - data memory (to store data that the CPU uses during program execution)</p>

- <p>RISC Architecture: <br>
  RISC (Reduced Instruction Set Computer) is a CPU that implement hardware only for instruction set that in use in common compilers</p>

- <p>CISC Architecture: <br>
  CISC (Complex Instruction Set Computer) has a more complex instructions in the instruction set that the compiler need to brake some instructions into sub-instructions</p>

- <p>Pipelined Architecture:<br>
  The structure of the pipeline architecture is built in such a way that all instructions (in the instruction set) have a fixed number of execution stages.<br>
  When each instruction (in the instruction set) can be decomposed into several stages, we (as CPU designers) can implement hardware that executes each step
  and additional hardware that chains the result of each step to the next step.<br>
  And then when the hardware of a specific stage has finished working on an instruction it moves to execute the same stage for the next instruction.</p>

- <p>Single Cycle Architecture:<br>
  The structure of this architecture is built in such a way that every instruction (in the instruction set) consume number of CPU clock cycle,<br>
  that defined in the instruction set.<br>
  This architecture can execute only one instruction in every clock cycle, its a significant disadvantage compare to the pipeline architecture.</p>
<br>
<h2 align="center"> Hardwired Architecture </h2>
<p> The hardwired architecture is a Von Neumann single cycle architecture <br>
    According to the figure below, this architecture consists a bus that connected to the CPU registers and the memory.
</p>
    <h4> Figure 1: Hardwired CPU Architecture </h4>
    <img src = "https://user-images.githubusercontent.com/83784945/216547132-5251203e-6bbb-49aa-9654-375c783f22f8.png">
<p>
  The Hardwired CPU resgisters are described in the following table:
</p>
  <h4> Figure 2: Hardwired Architecture Register Description </h4>
  <img src = "https://user-images.githubusercontent.com/83784945/216549701-817403f5-74ee-4af9-abc4-0747af7a78b7.png">
  <b>Note</b>: In my design TR register does not currently exist because it used for interrupt,<br>
               and I still have not implement a hardware for executing ISR (Interrupt Service Routine).<br>
               
               
  <h4>Harwired CPU Instruction Set</h4>
  The instruction set of the Hardwired CPU is very basic and simple.<br>
  For each bit in the instruction has different meaning so we can easily decode the instruction into hardware to execution.<br>
  <h4>Figure 3: Hardwired CPU Instruction Set:</h4>
  <img src="https://user-images.githubusercontent.com/83784945/216560999-e9491b71-3dec-4624-a2e8-84f47f6f6cea.png">
</p>

<h2 align = "center"> Design Principles </h2>
<p>
  To design the CPU we need to implement in HDL (Hardware Description Language) the hardware <br>
  and verified it for check that the hardware work well as we expected.<br><br>
</p>
  <b>Design Stages:</b><br>
<h5>&bull; Implementing the register modules and the memory of the CPU</h5>
<h5>&bull; Implement the bus imterface between the modules</h5>
  <b>Note:<b> As we can see in the architecture diagram the output of the bus connected to all the registers and the memory parallel inputs.<br>
  And also the input of the bus get the output of all of this modules.<br>
  The problem with this is when we try to connect some output signals to the same signal we got a multiple driver for this signal<br>
  and our design can be damaged.<br>
  So, we implement a multiplexer (the MuxBus module) that enable only for one input catch the bus signals.<br>
<h5>&bull; Implement Adder and Logic module for logic operations and arithmetic calculatations and also for transfer data between the memory and the accumulator.</h5>
<h5>&bull; Implement the control unit module that generate the control signals.<br>
  This module does not exist in the diagram but it's a necessery module for decoding the instructions and execute them.</h5>

<h5>&bull; Creating the top module and integrate between the sub-modules.</h5>

