/*Copyright 2019-2023 Kai D. Gonzalez*/

// This file is part of the 'lit' project.
// Lexical splITter.

import std.string : strip;
import std.stdio;

enum lit_state
{
  LIT_STATE_START, // Start
  LIT_NEST, // Nested (inside of parenthesis, that type of thing)
  LIT_END, // End
}

struct lit_wrapper
{
private:
  char _left;
  char _right;
public:

  void create(char left, char right)
  {
    this._left = left;
    this._right = right;
  }

  char left()
  {
    return _left;
  }

  char right()
  {
    return _right;
  }
}

struct lit_rules
{
private:
  lit_wrapper[] wrappers;
  char delim;
public:
  lit_state state = lit_state.LIT_STATE_START;
  void wrap(char left, char right)
  {
    wrappers ~= lit_wrapper(left, right);
  }

  void delimiter(char d)
  {
    delim = d;
  }

  char get_delim()
  {
    return delim;
  }

  bool get_wrapper(char n)
  { // get a wrapper based on its left char
    for (int i = 0; i < wrappers.length; i++)
    {
      if (wrappers[i].left() == n)
      {
        return true;
      }
    }
    return false;
  }

  bool get_wrapper_right(char n)
  { // get a wrapper based on its left char
    for (int i = 0; i < wrappers.length; i++)
    {
      if (wrappers[i].right() == n)
      {
        return true;
      }
    }
    return false;
  }
}


string[] lit(string s, lit_rules rules)
{
  string[] ret;
  string tmp;

  lit_state state = rules.state;

  int d = -1;

  for (int i = 0; i < s.length; i++)
  {
    if (rules.get_wrapper(s[i]) && state == lit_state.LIT_STATE_START && d == -1)
    {
      state = lit_state.LIT_NEST;
      d = 0;
    }
    else if (rules.get_wrapper_right(s[i]) && state == lit_state.LIT_NEST && d == 0 && s[i - 1] != '\\')
    {
      state = lit_state.LIT_STATE_START;
      ret ~= strip(tmp);
      tmp = "";
      d = -1;
    }
    else if (rules.get_wrapper(s[i]) && state == lit_state.LIT_NEST)
    {
      d++;
      tmp ~= s[i];
    }
    else if (rules.get_wrapper_right(s[i]) && state == lit_state.LIT_NEST)
    {
      d--;
      tmp ~= s[i];
    }
    else if ((s[i] == rules.get_delim() || i == s.length -1) && state != lit_state.LIT_NEST
            && d == -1)
    {
      if (i == s.length - 1) tmp ~= s[i];
      if (tmp.length <= 0) continue;

      ret ~= strip(tmp);

      tmp = "";
    }
    else
    {
      tmp ~= s[i];
    }
  }

  if (d > 0)
  {
    throw new Exception ("lit(): Unbalanced wrappers for expression '" ~ s ~ "'");
  }

  return ret;
}

// you can split with either a simple delimiter,
// or with a lit_rules object
// both will work
// the char overload is simply a wrapper for the lit_rules version
string[] lit (string s, char delim)
{
  lit_rules r = lit_rules();
  r.delimiter(delim);
  return lit(s, r);
}

void main()
{

  lit_rules rules = lit_rules();

  rules.wrap('[', ']');
  rules.wrap('(', ')');

  string[] s1 = "[hello world] (hello world) again".lit(rules);

  writefln("%s", s1);
}
