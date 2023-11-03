<!--Copyright 2019-2023 Kai D. Gonzalez-->

# lit - Lexical splIT

How a split function was supposed to be in the first place.

## How it works

LIT is like a simple split function, but with some extra features like adding
different kinds of tokens, such as comments, strings, and so on.

Essentially a split function made for language developers.

## Example

```d
import std.stdio : writefln;

import lit : lit, lit_rules, lit_token;

void main() {
  string[] tn = "hello world".lit(' '); // ["hello", "world"]
  string[] tn2= "hello, world".lit(','); // ["hello", "world"]

  // you can define rules for splitting tokens
  lit_rules r = lit_rules();
  
  r.wrap('(', ')');

  string[] tn3= "(hello world) world".lit(r); // ["hello world", "world"]
}

```
