# -*- ruby -*-
#
# Copyright (C) 2012-2020  Sutou Kouhei <kou@clear-code.com>
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

base_dir = File.dirname(__FILE__)
lib_dir = File.join(base_dir, "lib")

$LOAD_PATH.unshift(lib_dir)
require "groonga/command/version"

clean_white_space = lambda do |entry|
  entry.gsub(/(\A\n+|\n+\z)/, '') + "\n"
end

Gem::Specification.new do |spec|
  spec.name = "groonga-command"
  spec.version = Groonga::Command::VERSION.dup

  spec.authors = ["Kouhei Sutou"]
  spec.email = ["kou@clear-code.com"]

  readme = File.read("README.md")
  readme.force_encoding("UTF-8") if readme.respond_to?(:force_encoding)
  entries = readme.split(/^\#\#\s(.*)$/)
  description = clean_white_space.call(entries[entries.index("Description") + 1])
  spec.summary, spec.description, = description.split(/\n\n+/, 3)

  spec.files = ["README.md", "Rakefile", "Gemfile", "#{spec.name}.gemspec"]
  spec.files += [".yardopts"]
  spec.files += Dir.glob("lib/**/*.rb")
  spec.files += Dir.glob("doc/text/*")
  spec.test_files += Dir.glob("test/**/*")
  # Dir.chdir("bin") do
  #   spec.executables = Dir.glob("*")
  # end

  spec.homepage = "https://github.com/groonga/groonga-command"
  spec.licenses = ["LGPLv2.1+"]
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency("json")

  spec.add_development_dependency("bundler")
  spec.add_development_dependency("packnga")
  spec.add_development_dependency("rake")
  spec.add_development_dependency("red-arrow")
  spec.add_development_dependency("redcarpet")
  spec.add_development_dependency("test-unit")
  spec.add_development_dependency("test-unit-notify")
  spec.add_development_dependency("yard")
end

