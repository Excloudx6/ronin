#
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/ui/output/output'

module Ronin
  module UI
    module Output
      module Helpers
        protected

        #
        # Prints the given _messages_.
        #
        # @example
        #   puts 'some data'
        #
        # @since 0.3.0
        #
        def puts(*messages)
          Output.handler.puts(*messages)
        end

        #
        # Prints the given _messages_ as info diagnostics.
        #
        # @example
        #   print_info 'Connecting ...'
        #
        # @since 0.3.0
        #
        def print_info(*messages)
          Output.handler.print_info(*messages)
        end

        #
        # Prints the given _messages_ as debugging diagnostics,
        # if verbose output was enabled.
        #
        # @example
        #   print_debug "var1: #{var1.inspect}"
        #
        # @since 0.3.0
        #
        def print_debug(*messages)
          if Output.verbose?
            Output.handler.print_debug(*messages)
          end
        end

        #
        # Prints the given _messages_ as warning diagnostics,
        # if verbose output was enabled.
        #
        # @example
        #   print_warning 'Detecting a restricted character in the buffer'
        #
        # @since 0.3.0
        #
        def print_warning(*messages)
          if Output.verbose?
            Output.handler.print_warning(*messages)
          end
        end

        #
        # Prints the given _messages_ as error diagnostics.
        #
        # @example
        #   print_error 'Could not connect!'
        #
        # @since 0.3.0
        #
        def print_error(*messages)
          Output.handler.print_error(*messages)
        end
      end
    end
  end
end
