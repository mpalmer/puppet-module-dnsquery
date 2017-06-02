require 'resolv'

module Puppet::Parser::Functions
	newfunction(:dns_ptr, :type => :rvalue, :doc => <<-EOS
		Retrieves DNS PTR records and returns it as an array. Each record in the
		array will be a name.
		EOS
	) do |arguments|
		res = Resolv::DNS.new
		
		arguments.flatten.map do |name|
			unless name.is_a? String
				raise Puppet::ParseError,
				      "dns_ptr: Only accepts strings (you gave me #{name.inspect})"
			end
			
			res.getresources(name, Resolv::DNS::Resource::IN::PTR).map do |r|
				r.name.to_s
			end
		end.flatten
	end
end
