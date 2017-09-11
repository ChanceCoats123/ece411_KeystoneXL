# Keystone-XL

Notes from Chance:

I noticed that during a write to the L1D, the address changed on the following cycle after a read.
The pipeline moved along, as it should have, but the output of the address mux (to the L1D address)
changed while the write signal was changing from 1 to 0 (from the previous write). This incurred a
cache miss since the address was not present in the cache and the allocate state was entered by the
L1D cache when it should have returned to the idle state since the previous operation was a success.

Possible solutions: 
	Register the address to the L1D inside the data path.
	Register the address inside the cache.
	Add combinational logic inside the cache to avoid this corner case.
	
My advice:
	It seems like adding combinational logic to the cache makes the most sense since it doesn't
incur a 1-cycle penalty that registering does. My thoughts on how to fix this (primarily towards
Ryan since we used the same cache design), is to always transition back to the idle state if the
mem_resp signal is given. This seems obvious in hindsight, but we must have missed it during MP2.

Update: It appears I have fixed the above issue. I sent the mem_resp signal to the cache control unit.
If this signal is high when the controller is in the idling state (in the case of a 1 cycle hit),
then a registered value called "serviced" goes high. Once in the tag compare state, if the serviced value
is high, then the next state is the idle state (like it is supposed to be). Once back in the idle state,
if the mem_resp is low, then the serviced value becomes zero to reset the signal.
