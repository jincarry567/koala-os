#### Bochs debug command

* `b address`  set breakpoint on pysical address
* `c` execute to next breakpoint
* `s` one step execute
* `info cpu` show register info
* `r` show register info
* `sreg` show register info
* `creg` show register info
* `xp /nuf addr` show content in physical address, for: `xp /10bx 0x100000`
* `x /nuf addr` show content in linear address 
* `u start end` disassembly memory for:`u 0x100000 0x100010`