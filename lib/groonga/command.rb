# Copyright (C) 2012-2017  Kouhei Sutou <kou@clear-code.com>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

require "groonga/command/version"

require "groonga/command/error"

require "groonga/command/column-copy"
require "groonga/command/column-create"
require "groonga/command/column-list"
require "groonga/command/column-remove"
require "groonga/command/column-rename"
require "groonga/command/config-delete"
require "groonga/command/config-get"
require "groonga/command/config-set"
require "groonga/command/delete"
require "groonga/command/dump"
require "groonga/command/get"
require "groonga/command/index-column-diff"
require "groonga/command/io-flush"
require "groonga/command/load"
require "groonga/command/logical-count"
require "groonga/command/logical-range-filter"
require "groonga/command/logical-select"
require "groonga/command/logical-shard-list"
require "groonga/command/logical-table-remove"
require "groonga/command/log-level"
require "groonga/command/log-put"
require "groonga/command/normalize"
require "groonga/command/object-exist"
require "groonga/command/object-inspect"
require "groonga/command/object-remove"
require "groonga/command/plugin-register"
require "groonga/command/plugin-unregister"
require "groonga/command/query-expand"
require "groonga/command/query-log-flags-add"
require "groonga/command/query-log-flags-get"
require "groonga/command/query-log-flags-remove"
require "groonga/command/query-log-flags-set"
require "groonga/command/range-filter"
require "groonga/command/register"
require "groonga/command/reindex"
require "groonga/command/request-cancel"
require "groonga/command/ruby-eval"
require "groonga/command/ruby-load"
require "groonga/command/schema"
require "groonga/command/select"
require "groonga/command/shutdown"
require "groonga/command/status"
require "groonga/command/suggest"
require "groonga/command/table-copy"
require "groonga/command/table-create"
require "groonga/command/table-list"
require "groonga/command/table-remove"
require "groonga/command/table-rename"
require "groonga/command/table-tokenize"
require "groonga/command/thread-limit"
require "groonga/command/tokenize"
require "groonga/command/truncate"
