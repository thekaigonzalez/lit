<!--Copyright 2019-2023 Kai D. Gonzalez-->

# lit - Lexical splIT

How a split function was supposed to be in the first place.

## How it works

LIT is a powerful split function designed specifically for language developers. It offers a wide range of features and customization options to handle complex tokenization tasks.

With LIT, you can easily split strings into different kinds of tokens, such as comments, strings, and more. It supports advanced parsing capabilities, allowing you to accurately identify and extract specific language constructs.

One of the key strengths of LIT is its flexibility. It provides various options to customize the tokenization process, including support for custom delimiters, escape sequences, and nested tokenization. This makes it ideal for handling even the most intricate language parsing requirements.

Whether you're building a programming language, creating a syntax highlighter, or working on any other language-related project, LIT is the go-to choice for efficient and accurate tokenization.

## Example

```d
import std.stdio : writefln;

import lit : lit, lit_rules;

void main() {
  string[] tn = "hello world".lit(' '); // ["hello", "world"]
  string[] tn2= "hello, world".lit(','); // ["hello", "world"]

  // you can define rules for splitting tokens
  lit_rules r = lit_rules();
  
  r.wrap('(', ')');

  string[] tn3= "(hello world) world".lit(r); // ["hello world", "world"]
}

```
