require_relative "rest_example_server/version"
require 'socket'
# Very special thanks to
# https://practicingruby.com/articles/implementing-an-http-file-server

module RestExampleServer
  class SocketListen
    attr_accessor :server
    def initialize port=8181
      @data = { 'apache' => 'apache', 'bsd' => 'mit', 'chef' => 'apache' }
      @data.default="NONE"
      @port = port || 8181
      @server = TCPServer.new @port
      loop {
        client = server.accept
        request = client.gets
        client.puts handle request
        client.close
      }
    end

    def handle arg
      verb = arg.split()[0]
      arg=arg.split()[1..-1].join(" ")
      if verb == 'GET'
        return handle_get arg
      end
    end

    def handle_get arg
      path = (arg.split[0]).split('/')[1..-1]
      if path.nil?
        keys=[]
        @data.each do |key,value|
          keys << key
        end
        puts keys
        return keys
      elsif path.size == 2
        @data[path[0].chomp] = path[1]
        puts path[1]
        return path[1]
      else
        puts path[0] + " => " + @data[path[0]] 
        return @data[path[0]] + "    "
      end
    end
  end
  SocketListen.new()
end
