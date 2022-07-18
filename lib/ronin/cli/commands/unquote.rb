#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin.
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/cli/string_methods_command'
require 'ronin/support/format'

module Ronin
  class CLI
    module Commands
      #
      # Unquotes a double/single quoted string.
      #
      # ## Usage
      #
      #     ronin unquote [options] [STRING ... | -i FILE]
      #
      # ## Options
      #
      #     -i, --input FILE                 Optional input file
      #     -o, --output FILE                Optional output file
      #     -M, --multiline                  Process each line separately
      #     -n, --keep-newlines              Preserves newlines at the end of each line
      #     -c, --c                          Unquotes the C string
      #     -j, --js                         Unquotes the JavaScript String
      #     -S, --shell                      Unquotes the Shell String
      #     -P, --powershell                 Unquotes the PowerShell String
      #     -s, --string                     Unquotes the Ruby String
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [STRING ...]                     Optional string value(s) to process
      #
      class Unquote < StringMethodsCommand

        option :c, short: '-c',
                   desc: 'Unquotes the C string' do
                     require 'ronin/support/format/c'
                     @method_calls << :c_unquote
                   end

        option :js, short: '-j',
                    desc: 'Unquotes the JavaScript String' do
                      require 'ronin/support/format/js'
                      @method_calls << :js_unquote
                    end

        option :shell, short: '-S',
                       desc: 'Unquotes the Shell String' do
                         require 'ronin/support/format/shell'
                         @method_calls << :shell_unquotes
                       end

        option :powershell, short: '-P',
                            desc: 'Unquotes the PowerShell String' do
                              require 'ronin/support/format/powershell'
                              @method_calls << :powershell_unquote
                            end

        option :string, short: '-s',
                        desc: 'Unquotes the Ruby String' do
                          require 'ronin/support/format/text'
                          @method_calls << :unquote
                        end

        description 'Unquotes a double/single quoted string'

        #
        # Unquotes the String.
        #
        # @param [String] string
        #   The String to unquote.
        #
        # @return [String]
        #   The unquoted String.
        #
        # @note
        #   If no options are given, then `--string` is assumed.
        #
        def process_string(string)
          if @method_calls.empty?
            string.unquote
          else
            super(string)
          end
        end

      end
    end
  end
end