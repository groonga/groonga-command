# News

## 1.0.7: 2014-03-15

### Improvements

  * {Groonga::Command::ColumnCreate#sources}: Added.
  * {Groonga::Command::ColumnCreate#table}: Added.
  * {Groonga::Command::ColumnCreate#type}: Added.
  * {Groonga::Command::TableCreate#key_type}: Added.
  * {Groonga::Command::TableCreate#default_tokenizer}: Added.
  * {Groonga::Command::TableCreate#normalizer}: Added.

## 1.0.6: 2013-10-29

### Improvements

  * {Groonga::Command::Status}: Added.
  * {Groonga::Command::Select}: Added accessor for "values" parameter.
  * {Groonga::Command::Tokenize}: Added.
  * {Groonga::Command::ColumnList}: Added.
  * {Groonga::Command::Normalize}: Added.
  * {Groonga::Command::RubyEval}: Added.
  * {Groonga::Command::RubyLoad}: Added.

## 1.0.5: 2013-09-29

### Improvements

  * Extracted {Groonga::Command::Parser} as groonga-command-parser gem.
    Now, groonga-command gem doesn't depend on any extension libraries.

## 1.0.4: 2013-09-18

### Improvements

  * {Groonga::Command::TableCreate}: Supported "--normalizer" parameter.
  * {Groonga::Command::Select}: Supported all parameters.

### Fixes

  * Fixed a bug that is caused by using with rroonga.

## 1.0.3: 2013-07-23

### Improvements

  * Added predicate methods of table_create flags
    to {Groonga::Command::TableCreate}
    * {Groonga::Command::TableCreate#table_no_key?}
    * {Groonga::Command::TableCreate#table_hash_key?}
    * {Groonga::Command::TableCreate#table_pat_key?}
    * {Groonga::Command::TableCreate#table_dat_key?}
    * {Groonga::Command::TableCreate#key_with_sis?}
  * Added predicate methods of column_create flags
    to {Groonga::Command::ColumnCreate}
    * {Groonga::Command::ColumnCreate#column_scalar?}
    * {Groonga::Command::ColumnCreate#column_vector?}
    * {Groonga::Command::ColumnCreate#column_index?}
    * {Groonga::Command::ColumnCreate#with_section?}
    * {Groonga::Command::ColumnCreate#with_weight?}
    * {Groonga::Command::ColumnCreate#with_position?}

## 1.0.2: 2013-06-27

### Improvements

  * Supported "dump" command.
  * Added {Groonga::Command::Base#output_type}.
  * [http] Supported key only parameter.
  * Supported {Groonga::Command::Select#conditions} without
    filter parameter.

## 1.0.1: 2012-12-06

It's bug fix release.

### Improvements

  * Supported "register" command.

### Fixes

  * Asigned value and columns of "load" command to a result command
    correctly in stand alone parsing.

## 1.0.0: 2012-11-29

The first release!!!
