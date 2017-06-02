require 'resolv'

module Puppet::Parser::Functions
	newfunction(:dns_aaaa, :type => :rvalue, :doc => <<-EOS
		Retrieves DNS AAAA records and returns it as an array. Each record in the
		array will be a IPv6 address.
		EOS
	) do |arguments|
		res = Resolv::DNS.new
		
		arguments.flatten.map do |name|
			unless name.is_a? String
				raise Puppet::ParseError,
				      "dns_aaaa: Only accepts strings (you gave me #{name.inspect})"
			end
			
			res.getresources(name, Resolv::DNS::Resource::IN::AAAA).sort_by { |r| r.address.to_s }.map do |r|
				r.address.to_s
			end
		end.flatten
	end
end
