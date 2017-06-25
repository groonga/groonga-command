# News

## 1.3.3: 2017-06-25

### Improvements

  * {Groonga::Command::Select#drilldown_filter}: Added.

  * {Groonga::Command::QueryLogFlagsAdd}: Added.

  * {Groonga::Command::QueryLogFlagsGet}: Added.

  * {Groonga::Command::QueryLogFlagsRemove}: Added.

  * {Groonga::Command::QueryLogFlagsSet}: Added.

## 1.3.2: 2017-01-18

### Improvements

  * {Groonga::Command::Format::Command}: Supported pretty print.

## 1.3.1: 2016-12-08

### Improvements

  * {Groonga::Command::Select#slices}: Changed return value from
    `Hash<String, Groonga::Command::Select>` to `Hash<String,
    Groonga::Command::Select::Slice`.

### Fixes

  * {Groonga::Command::TableCreate#token_filters}: Fixed a bug that
    multiple token filters can't be parsed.

## 1.3.0: 2016-12-08

### Improvements

  * {Groonga::Command::Load}: Supported `output_ids` parameter.

  * {Groonga::Command::Select}: Supported slices.

## 1.2.8: 2016-10-11

### Improvements

  * {Groonga::Command::Select}: Supported labeled drilldowns.

  * {Groonga::Command::Select}: Supported `adjuster` parameter.

  * {Groonga::Command::Select}: Supported `drilldown_calc_types` parameter.

  * {Groonga::Command::Select}: Supported `drilldown_calc_target` parameter.

  * {Groonga::Command::Select}: Supported `sort_keys` parameter.

  * {Groonga::Command::Select}: Supported `drilldown_sort_keys` parameter.

  * {Groonga::Command::Select#sort_keys}: Added.

  * {Groonga::Command::Select#sortby}: Deprecated. Use
    {Groonga::Command::Select#sort_keys} instead.

  * {Groonga::Command::Select#drilldown_sort_keys}: Added.

## 1.2.7: 2016-08-15

### Improvements

  * {Groonga::Command::TableCopy}: Added.

## 1.2.6: 2016-08-09

### Improvements

  * {Groonga::Command::Base#initialize}: Accepted Symbol as command name.

## 1.2.5: 2016-08-08

### Improvements

  * {Groonga::Command::Register#path}: Added.

## 1.2.4: 2016-08-08

### Improvements

  * {Groonga::Command::ColumnCreate#name}: Added.

  * {Groonga::Command::ColumnRemove#table}: Added.

  * {Groonga::Command::ColumnRemove#name}: Added.

  * {Groonga::Command::ColumnRename#table}: Added.

  * {Groonga::Command::ColumnRename#name}: Added.

  * {Groonga::Command::ColumnRename#new_name}: Added.

  * {Groonga::Command::TableCreate#name}: Added.

  * {Groonga::Command::TableRename#name}: Added.

  * {Groonga::Command::TableRename#new_name}: Added.

## 1.2.3: 2016-08-08

### Improvements

  * {Groonga::Command::Base#initialize}: Made command name optional.

## 1.2.2: 2016-08-05

### Improvements

  * {Groonga::Command::TableCreate#value_type}: Added.

## 1.2.1: 2016-08-03

### Improvements

  * {Groonga::Command::Schema}: Added.
  * {Groonga::Command::QueryExpand}: Added.
  * {Groonga::Command::TableCreate#token_filters}: Added.

## 1.2.0: 2016-03-21

### Improvements

  * Suppressed a warning.

## 1.1.9: 2016-03-21

### Fixes

  * Fixed a bug that correct command name isn't used.

## 1.1.8: 2016-03-21

### Improvements

  * {Groonga::Command::Shutdown}: Added.
  * {Groonga::Command::TableRemove#name}: Added.
  * {Groonga::Command::TableRemove#dependent?}: Added.
  * {Groonga::Command::Base#request_id}: Added.
  * {Groonga::Command.all}: Added.
  * {Groonga::Command.find}: Supported `Symbol` as command name.
  * {Groonga::Command::Base#command_name}: Added. Because
    {Groonga::Command::Base#name} may be overwritten by subclasses. For
    example, {Groonga::Command::TableRemove#name} overwrites it.
  * {Groonga::Command::Base#name}: Made deprecated.

## 1.1.7: 2016-03-07

### Improvements

  * Renamed to {Groonga::Command::ObjectInspect} from
    `Groonga::Command::Inspect`.
  * {Groonga::Command::ObjectRemove}: Added.

## 1.1.6: 2016-02-03

### Improvements

  * `Groonga::Command::Inspect`: Added.

## 1.1.5: 2016-01-19

### Improvements

  * Renamed to {Groonga::Command::ConfigGet} from `Groonga::Command::ConfGet`.
  * Renamed to {Groonga::Command::ConfigSet} from `Groonga::Command::ConfSet`.
  * Renamed to {Groonga::Command::ConfigDelete} from
    `Groonga::Command::ConfDelete`.

## 1.1.4: 2016-01-13

### Improvements

  * `Groonga::Command::ConfGet`: Added.
  * `Groonga::Command::ConfSet`: Added.
  * `Groonga::Command::ConfDelete`: Added.

## 1.1.3: 2015-08-19

### Improvements

  * {Groonga::Command::ColumnCopy}: Added.
  * {Groonga::Command::IOFlush}: Added.
  * {Groonga::Command::LogLevel}: Added.
  * {Groonga::Command::LogPut}: Added.
  * {Groonga::Command::LogicalSelect}: Added.
  * {Groonga::Command::LogicalShardList}: Added.
  * {Groonga::Command::LogicalTableRemove}: Added.
  * {Groonga::Command::ObjectExist}: Added.
  * {Groonga::Command::TableList}: Added.
  * {Groonga::Command::ThreadLimit}: Added.

## 1.1.2: 2015-04-02

### Improvements

  * {Groonga::Command::PluginRegister}: Added.
  * {Groonga::Command::PluginUnregister}: Added.

## 1.1.1: 2015-02-13

### Improvements

  * {Groonga::Command::LogicalRangeFilter}: Added.
    [GitHub#4] [Patch by Hiroshi Hatake]
  * {Groonga::Command::LogicalCount}: Added.
    [GitHub#5] [Patch by Hiroshi Hatake]

### Fixes

  * Fixed return type in YARD doc.
    [GitHub#7] [Patch by Hiroshi Hatake]

## 1.1.0: 2015-02-09

### Improvements

  * {Groonga::Command::RangeFilter}: Added.
  * {Groonga::Command::TableTokenize}: Added.
  * {Groonga::Command::Tokenize#mode}: Added.
  * {Groonga::Command::Tokenize#token_filters}: Added.
  * {Groonga::Command::RequestCancel}: Added.

## 1.0.9: 2014-10-02

### Improvements

  * {Groonga::Command::Base#path_prefix}: Added.
    [GitHub#1] [Patch by Hajime Wakahara]
  * {Groonga::Command::Base#path_prefix=}: Added. It is for customizing
    "/d" position in command URI.
    [GitHub#1] [Patch by Hajime Wakahara]

### Thanks

  * Hajime Wakahara

## 1.0.8: 2014-09-30

### Improvements

  * {Groonga::Command::Base#key?}: Added.
  * Accepted nil value arguments on formatting to URI or command line.
    Nil value arguments are ignored.

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

  * Extracted `Groonga::Command::Parser` as groonga-command-parser gem.
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
