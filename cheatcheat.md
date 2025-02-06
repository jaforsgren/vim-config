# code

- gc - comment

---

## Navigation

- gd - move to local declaration
- ctrl U / D - up down
- w - forward to start of next word
- e - forward to end of next word
- b backward jump

- shift 3 move up on declarations

- ctrl p - List symbols

- 0 - jump to the start of the line
- opt + 4 ($) - jump to the end of the line

- 5gg or 5G - go to line 5

- opt + 3 - find word under marker

---

## Marks

- :marks - List of marks
- ma - set current position for mark A

---

## Folds

- za - toggle fold
- zM - close all folds
- zR - open all folds
- zm + zo - one level of folding

---

## Selection

- va - loads of selection stuff (vaw - select word, va( - select inside of "(" )

- dd - Delete current line
- D - Delete to end of line
- d0 - Delete to beginning of line-
- de - Delete to end of word
- db - Delete to start of word.
- da( - Delete evertyhing inside of "("
- dib Delete everything inside block.
- dii Delete everything inside indent

---

## Replace and yank

- :%s/old/new/g - Replace all old with new throughout file
- :%s/old/new/gc - Replace all old with new throughout file with confirmations
- ya( - yank everything inside of "("
- yiw - yank word under cursor
- ciw - Replace word under cursor
- yib cib - inner block
- - - cib + n + . - Repeat change word on all search matches

---

## help

- K - type hitns
- : Telescope keymaps

- install DAp : DapInstall python ()

- :help dap-mappings and :help dap-api

---
