require 'resolv'

module Puppet::Parser::Functions
	newfunction(:dns_a, :type => :rvalue, :doc => <<-EOS
		Retrieves DNS A records and returns it as an array. Each record in the
		array will be an IPv4 address.
		EOS
	) do |arguments|
		res = Resolv::DNS.new
		
		arguments.flatten.map do |name|
			unless name.is_a? String
				raise Puppet::ParserError,
				      "dns_a: Only accepts strings (you gave me #{name.inspect})"
			end
			
			res.getresources(name, Resolv::DNS::Resource::IN::A).map do |r|
				r.address.to_s
			end
		end.flatten
	end
end
