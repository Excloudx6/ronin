#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

module Ronin
  module UI
    module Output
      module Terminal
        class Color

          GREEN = "\e[32m"
          CYAN = "\e[36m"
          YELLOW = "\e[33m"
          RED = "\e[31m"
          CLEAR = "\e[0m"

          #
          # Writes data to `STDOUT`.
          #
          # @param [String] data
          #   The data to write.
          #
          # @since 1.0.0
          #
          def self.write(data)
            STDOUT.write(data)
          end

          #
          # Prints one or more messages as `info` messages.
          #
          # @param [Array] messages
          #   The messages to print.
          #
          # @since 1.0.0
          #
          def self.print_info(*messages)
            messages.each { |mesg| puts "#{GREEN}[-] #{mesg}#{CLEAR}" }
          end

          #
          # Prints one or more messages as `debug` mssages.
          #
          # @param [Array] messages
          #   The messages to print.
          #
          # @since 1.0.0
          #
          def self.print_debug(*messages)
            messages.each { |mesg| puts "#{CYAN}[=] #{mesg}#{CLEAR}" }
          end

          #
          # Prints one or more messages as `warning` mssages.
          #
          # @param [Array] messages
          #   The messages to print.
          #
          # @since 1.0.0
          #
          def self.print_warning(*messages)
            messages.each { |mesg| puts "#{YELLOW}[*] #{mesg}#{CLEAR}" }
          end

          #
          # Prints one or more messages as `error` mssages.
          #
          # @param [Array] messages
          #   The messages to print.
          #
          # @since 1.0.0
          #
          def self.print_error(*messages)
            messages.each { |mesg| puts "#{RED}[!] #{mesg}#{CLEAR}" }
          end

        end
      end
    end
  end
end
