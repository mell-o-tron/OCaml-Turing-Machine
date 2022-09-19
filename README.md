# OCaml-Turing-Machine
## Turing Machine
A Turing machine is usually represented as a 4-tuple: $M = (Q, \Sigma, \delta, q_0)$, where: 
- $Q$ is a set of states
- $\Sigma$ is an alphabet containing two special characters `#` and `>`, representing respectively the empty character and a character from which the cursor can be moved only to the right
- $\delta$ is the transition relation (or partial/total function)
- $q_0$ is the initial state

However, this representation assumes that the alphabet consists of all the symbols contained in the *tape*, and that the set containing the states consists exactly of all the states that appear in the definition of the relation function; hence the Turing machine is defined as:

```ocaml
type t_machine  = TM of transition * state;;
```
That is, as the couple $M = (\delta, q_0)$.

## Configuration

A configuration of the machine consists of:
- The list of characters that come before the "current character" (i.e. the one the *cursor* is pointing to)
- The current character
- The list of characters that come after the current character.

A configuration may also simply consist of `Done`. 

```ocaml
type config     = Conf of state * character list * character * character list | Done;;
```

A step takes a configuration as its argument, applies the transition "function" and moves the cursor, returning the new configuration of the machine.
