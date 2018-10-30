module Puppet::Parser::Functions
  newfunction(:dns_ns, :type => :rvalue, :doc => <<-EOS
    Retrieves the records associated with an NS rrname and returns the values
    as an array of strings.
    EOS
  ) do |arguments|
    require 'resolv'

    raise(Puppet::ParseError, "dns_ns(): Wrong number of arguments " +
          "given (#{arguments.size} for 1)") if arguments.size != 1

    Resolv::DNS.new.getresources(arguments[0], Resolv::DNS::Resource::IN::NS).map(&:name).map(&:to_s)
  end
end
