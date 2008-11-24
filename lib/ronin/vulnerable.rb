#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#++
#

require 'ronin/extensions/meta'

module Ronin
  module Vulnerable
    def self.included(base)
      base.metaclass_eval do
        #
        # Returns the Hash of the vulnerability names and the methods used
        # to test for them.
        #
        def vulns
          @vulns ||= {}
        end

        #
        # Returns +true+ if the class has a vulnerability test for the
        # vulnerability with the specified _name_, returns +false+
        # otherwise.
        #
        def vulnerable_to?(name)
          name = name.to_sym

          self.ancestors.each do |ancestor|
            if ancestor.include?(Vulnerable)
              return true if ancestor.vulns.has_key?(name)
            end
          end

          return false
        end

        protected

        #
        # Registers new vulnerability tests using the specified _mapping_ of
        # vulnerability names and the method names used to test for them.
        # 
        #   vulnerable_to :lfi => :test_lfi
        #
        def vulnerable_to(mapping={})
          mapping.each do |name,method_name|
            unless vulnerable_to?(name)
              self.vulns[name.to_sym] = method_name.to_sym
            end
          end

          return self
        end
      end
    end

    #
    # Iterates over each vulnerability name and the method name used to
    # test for the vulnerability, passing each name and method name to the
    # given _block_.
    #
    def each_vuln(&block)
      self.class.ancestors.each do |ancestor|
        if ancestor.include?(Vulnerable)
          ancestor.vulns.each(&block)
        end
      end

      return self
    end

    #
    # Returns a Hash of vulnerability names and the objects which represent
    # the detected vulnerabilities. If a _block_ is given, each object
    # that represents a detected vulnerability will be passed to the
    # _block_.
    #
    def vulns(options={},&block)
      found_vulns = {}

      each_vuln do |name,test_method|
        results = send(test_method,options)

        results.each(&block) if block
        found_vulns[name] = results
      end

      return found_vulns
    end
  end
end
