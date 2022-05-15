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

require 'ronin/cli/command'
require 'ronin/core/cli/logging'

require 'ronin/network/tcp/proxy'
require 'ronin/network/ssl/proxy'
require 'ronin/network/udp/proxy'

require 'hexdump/hexdump'

module Ronin
  class CLI
    module Commands
      #
      # Starts a TCP/UDP intercept proxy.
      #
      # ## Usage
      #
      #     ronin net:proxy [options]
      #
      # ## Options
      #
      #     -v, --[no-]verbose               Enable verbose output.
      #     -q, --[no-]quiet                 Disable verbose output.
      #         --[no-]silent                Silence all output.
      #     -t, --[no-]tcp                   TCP Proxy.
      #                                      Default: true
      #     -S, --[no-]ssl                   SSL Proxy.
      #     -u, --[no-]udp                   UDP Proxy.
      #     -x, --[no-]hexdump               Enable hexdump output.
      #     -H, --host [HOST]                Host to listen on.
      #                                      Default: "0.0.0.0"
      #     -p, --port [PORT]                Port to listen on.
      #     -s, --server [HOST[:PORT]]       Server to forward connections to.
      #     -r, --rewrite [/REGEXP/:STRING] Rewrite rules.
      #         --rewrite-client [/REGEXP/:STRING]
      #                                      Client rewrite rules.
      #         --rewrite-server [/REGEXP/:STRING]
      #                                      Server rewrite rules.
      #     -i, --ignore [/REGEXP/ [...]]    Ignore rules.
      #         --ignore-client [/REGEXP/ [...]]
      #                                      Client ignore rules.
      #         --ignore-server [/REGEXP/ [...]]
      #                                      Server ignore rules.
      #     -C, --close [/REGEXP/ [...]]     Close rules.
      #         --close-client [/REGEXP/ [...]]
      #                                      Client close rules.
      #         --close-server [/REGEXP/ [...]]
      #                                      Server close rules.
      #     -R, --reset [/REGEXP/ [...]]     Reset rules.
      #         --reset-client [/REGEXP/ [...]]
      #                                      Client reset rules.
      #         --reset-server [/REGEXP/ [...]]
      #                                      Server reset rules.
      #
      # ## Arguments
      #
      #     [PROXY_HOST:]PROXY_PORT          The local host and/or port to
      #                                      listen on.
      #     REMOTE_HOST:REMOTE_PORT          The remote server to proxy data to.
      #
      class NetProxy < Command

        include Core::CLI::Logging

        usage '[PROXY_HOST:]PROXY_PORT UPSTREAM_HOST:UPSTREAM_PORT'

        option :tcp, short: '-t',
                     desc: 'TCP Proxy' do
                       @protocol = :tcp
                     end

        option :ssl, short: '-S',
                     desc: 'SSL Proxy' do
                       @protocol = :ssl
                     end

        option :udp, short: '-u',
                     desc: 'UDP Proxy' do
                       @protocol = :udp
                     end

        option :hexdump, short: '-x',
                         long: '--[no-]hexdump',
                         value: {
                           type:     TrueClass,
                           required: false
                         },
                         desc: 'Enable hexdump output'

        option :rewrite, short: '-r',
                         value: {
                           type:  String,
                           usage: '/REGEXP/:STRING'
                         },
                         desc: 'Rewrite rules' do |value|
                         end

        option :rewrite_client, value: {
                                  type:  String,
                                  usage: '/REGEXP/:STRING',
                                },
                                desc: 'Client rewrite rules' do |value|
                                end

        option :rewrite_server, value: {
                                  type:  String,
                                  usage: '/REGEXP/:STRING',
                                },
                                desc: 'Server rewrite rules'

        option :ignore, short: '-i',
                        value: {type:  Regexp},
                        desc: 'Ignore rules'

        option :ignore_client, value: {type: Regexp},
                               desc: 'Client ignore rules'

        option :ignore_server, value: {type: Regexp},
                               desc: 'Server ignore rules'

        option :close, short: '-C',
                       value: {type:  Regexp},
                       desc: 'Close rules'

        option :close_client, value: {type: Regexp},
                              desc: 'Client close rules'

        option :close_server, value: {type: Regexp},
                              desc: 'Server close rules'

        option :reset, short: '-R',
                       value: {type: Regexp},
                       desc: 'Reset rules'

        option :reset_client, value: {type: Regexp},
                              desc: 'Client reset rules'

        option :reset_server, value: {type: Regexp},
                              desc: 'Server reset rules'

        argument :proxy, usage: '[PROXY_HOST:]PROXY_PORT',
                         desc:  'The host and/or port to listen on'

        argument :upstream, usage: 'UPSTREAM_HOST:UPSTREAM_PORT',
                            desc:  'The upstream server to proxy data to'

        description 'Starts a TCP/UDP/SSL intercept proxy'

        examples [
          "8080 google.com:80",
          "--udp --hexdump 0.0.0.0:53 4.2.2.1:53"
        ]

        man_page 'ronin-net-proxy.1'

        # The proxy protocol to use.
        #
        # @return [:tcp, :udp, :ssl]
        attr_reader :protocol

        #
        # Initializes the proxy command.
        #
        # @param [:tcp, :udp, :ssl] protocol
        #   The protocol to use.
        #
        def initialize(protocol: :tcp, **kwargs)
          super(**kwargs)

          @protocol = protocol

          @reset_client   = []
          @close_client   = []
          @ignore_client  = []
          @rewrite_client = []

          @reset_server   = []
          @close_server   = []
          @ignore_server  = []
          @rewrite_server = []

          @reset   = []
          @close   = []
          @ignore  = []
          @rewrite = []
        end

        #
        # Starts the proxy.
        #
        def run(*args)
          local, upstream = *args

          if local.include?(':')
            @proxy_host, @proxy_port = local.split(':',2)
            @proxy_port = @proxy_port.to_i
          else
            @proxy_port = local.to_i
          end

          @upstream_host, @upstream_port = upstream.split(':',2)
          @upstream_port = @upstream_port.to_i

          if options[:hexdump]
            @hexdumper = Hexdump::Hexdump.new
          end

          @proxy = proxy_class.new(
            port:   @proxy_port,
            host:   @proxy_host,
            server: [@upstream_host, @upstream_port]
          )

          case @protocol
          when :tcp, :ssl
            @proxy.on_client_connect do |client|
              print_outgoing client, '[connecting]'
            end

            @proxy.on_client_disconnect do |client,server|
              print_outgoing client, '[disconnecting]'
            end

            @proxy.on_server_connect do |client,server|
              print_incoming client, '[connected]'
            end

            @proxy.on_server_disconnect do |client,server|
              print_incoming client, '[disconnected]'
            end
          end

          @reset_client.each do |pattern|
            @proxy.on_client_data do |client,server,data|
              @proxy.reset! if data =~ pattern
            end
          end

          @close_client.each do |pattern|
            @proxy.on_client_data do |client,server,data|
              @proxy.close! if data =~ pattern
            end
          end

          @ignore_client.each do |pattern|
            @proxy.on_client_data do |client,server,data|
              @proxy.ignore! if data =~ pattern
            end
          end

          @rewrite_client.each do |pattern,replace|
            @proxy.on_client_data do |client,server,data|
              data.gsub!(pattern,replace)
            end
          end

          @reset_server.each do |pattern|
            @proxy.on_server_data do |client,server,data|
              @proxy.reset! if data =~ pattern
            end
          end

          @close_server.each do |pattern|
            @proxy.on_server_data do |client,server,data|
              @proxy.close! if data =~ pattern
            end
          end

          @ignore_server.each do |pattern|
            @proxy.on_server_data do |client,server,data|
              @proxy.ignore! if data =~ pattern
            end
          end

          @rewrite_server.each do |pattern,replace|
            @proxy.on_server_data do |client,server,data|
              data.gsub!(pattern,replace)
            end
          end

          @reset.each do |pattern|
            @proxy.on_data do |client,server,data|
              @proxy.reset! if data =~ pattern
            end
          end

          @close.each do |pattern|
            @proxy.on_data do |client,server,data|
              @proxy.close! if data =~ pattern
            end
          end

          @ignore.each do |pattern|
            @proxy.on_data do |client,server,data|
              @proxy.ignore! if data =~ pattern
            end
          end

          @rewrite.each do |pattern,replace|
            @proxy.on_data do |client,server,data|
              data.gsub!(pattern,replace)
            end
          end

          @proxy.on_client_data do |client,server,data|
            print_outgoing client
            print_data data
          end

          @proxy.on_server_data do |client,server,data|
            print_incoming client
            print_data data
          end

          log_info "Listening on #{@proxy_host}:#{@proxy_port} ..."
          @proxy.start
        end

        protected

        #
        # Determines the Proxy class based on the `--tcp` or `--udp`
        # options.
        #
        # @return [Network::TCP::Proxy, Network::UDP::Proxy]
        #   The proxy class.
        #
        def proxy_class
          case @protocol
          when :tcp then Network::TCP::Proxy
          when :udp then Network::UDP::Proxy
          when :ssl then Network::SSL::Proxy
          else
            raise(NotImplementedError,"#{@protocol.inspect} proxy value not supported")
          end
        end

        #
        # Returns the address for the connection.
        #
        # @param [(UDPSocket,(host, port)), TCPSocket, UDPSocket] connection
        #   The connection.
        #
        # @return [String]
        #   The address of the connection.
        #
        def address(connection)
          case connection
          when Array
            socket, (host, port) = connection

            "#{host}:#{port}"
          when TCPSocket, UDPSocket
            addrinfo = connection.peeraddr

            "#{addrinfo[3]}:#{addrinfo[1]}"
          end
        end

        #
        # Prints a connection header for an incoming event.
        #
        # @param [(UDPSocket,(host, port)), TCPSocket, UDPSocket] client
        #   The client.
        #
        # @param [String] event
        #   The optional name of the event.
        #
        def print_incoming(client,event=nil)
          log_info "#{address(client)} <- #{@proxy} #{event}"
        end

        #
        # Prints a connection header for an outgoing event.
        #
        # @param [(UDPSocket,(host, port)), TCPSocket, UDPSocket] client
        #   The client.
        #
        # @param [String] type
        #   The optional name of the event.
        #
        def print_outgoing(client,type=nil)
          log_info "#{address(client)} -> #{@proxy} #{type}"
        end

        #
        # Prints data from a message.
        #
        # @param [String] data
        #   The data from a message.
        #
        def print_data(data)
          if options[:hexdump] then @hexdumper.dump(data)
          else                      puts data
          end
        end

      end
    end
  end
end