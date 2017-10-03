module Puppet::Parser::Functions
  newfunction(:dns_srv, :type => :rvalue, :doc => <<-EOS
    Retrieves DNS SRV records and returns it as an array.  Each record in
    the array will be an array of [priority, weight, port, target] arrays.
    Second argument is optional and can be either 'priority', 'weight',
    'port', 'target', 'target:port'.  In that case, only the specified field
    is returned; the special 'target:port' variant returns the target and
    port joined with a colon.
  EOS
  ) do |arguments|
    require 'resolv'

    raise(Puppet::ParseError, "dns_srv(): Wrong number of arguments " +
          "given (#{arguments.size} for 1 or 2)") if arguments.size < 1 or arguments.size > 2

    Resolv::DNS.new.getresources(arguments[0],Resolv::DNS::Resource::IN::SRV).collect do |res|
      if arguments.size == 1 then
        [res.priority, res.weight, res.port, res.target.to_s]
      else
        case arguments[1]
        when 'target:port'
          "#{res.target.to_s}:#{res.port}"
        when 'priority', 'weight', 'port'
          res.send(arguments[1])
        when 'target'
          res.target.to_s
        else
          raise Puppet::ParseError "dns_srv(): invalid value #{arguments[1]} for second argument"
        end
      end
    end
  end
end
