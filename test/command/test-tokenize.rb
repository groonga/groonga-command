# -*- coding: utf-8 -*-
#
# Copyright (C) 2013-2015  Kouhei Sutou <kou@clear-code.com>
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

class TokenizeCommandTest < Test::Unit::TestCase
  private
  def tokenize_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::Tokenize.new(pair_arguments,
                                   ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      tokenizer  = "TokenDelimit"
      string     = "groonga ruby linux"
      normalizer = "NormalizerAuto"
      flags      = "NONE"
      mode       = "ADD"
      token_filters = "TokenFilterStem"

      ordered_arguments = [
        tokenizer,
        string,
        normalizer,
        flags,
        mode,
        token_filters
      ]
      command = tokenize_command({}, ordered_arguments)
      assert_equal({
                     :tokenizer  => tokenizer,
                     :string     => string,
                     :normalizer => normalizer,
                     :flags      => flags,
                     :mode       => mode,
                     :token_filters => token_filters,
                   },
                   command.arguments)
    end
  end

  class TokenizerTest < self
    def test_reader
      command = tokenize_command(:tokenizer => "TokenBigram")
      assert_equal("TokenBigram", command.tokenizer)
    end
  end

  class StringTest < self
    def test_reader
      command = tokenize_command(:string => "Hello World")
      assert_equal("Hello World", command.string)
    end
  end

  class NormalizerTest < self
    def test_reader
      command = tokenize_command(:normalizer => "NormalizerAuto")
      assert_equal("NormalizerAuto", command.normalizer)
    end
  end

  class FlagsTest < self
    def test_nil
      command = tokenize_command
      assert_equal([], command.flags)
    end

    def test_empty
      command = tokenize_command(:flags => "")
      assert_equal([], command.flags)
    end

    def test_pipe_separator
      command = tokenize_command(:flags => "NONE|ENABLE_TOKENIZED_DELIMITER")
      assert_equal(["NONE", "ENABLE_TOKENIZED_DELIMITER"], command.flags)
    end

    def test_space_separator
      command = tokenize_command(:flags => "NONE ENABLE_TOKENIZED_DELIMITER")
      assert_equal(["NONE", "ENABLE_TOKENIZED_DELIMITER"], command.flags)
    end

    def test_spaces_around_separator
      command = tokenize_command(:flags => "NONE | ENABLE_TOKENIZED_DELIMITER")
      assert_equal(["NONE", "ENABLE_TOKENIZED_DELIMITER"], command.flags)
    end
  end

  class ModeTest < self
    def test_reader
      command = tokenize_command(:mode => "ADD")
      assert_equal("ADD", command.mode)
    end
  end

  class TokenFiltersTest < self
    def test_nil
      command = tokenize_command
      assert_equal([], command.token_filters)
    end

    def test_empty
      command = tokenize_command(:token_filters => "")
      assert_equal([], command.token_filters)
    end

    def test_comma_separator
      token_filters = "TokenFilterStem,TokenFilterStopWord"
      command = tokenize_command(:token_filters => token_filters)
      assert_equal(["TokenFilterStem", "TokenFilterStopWord"],
                   command.token_filters)
    end

    def test_spaces_around_separator
      token_filters = "TokenFilterStem , TokenFilterStopWord"
      command = tokenize_command(:token_filters => token_filters)
      assert_equal(["TokenFilterStem", "TokenFilterStopWord"],
                   command.token_filters)
    end
  end
end
