module Puppet::Parser::Functions
  newfunction(:dns_srv, :type => :rvalue, :doc => <<-EOS
    Retrieves DNS SRV records and returns it as an array, sorted and shuffled
    in correspondence with the requirements of RFC2782.

    By default, each record in the array will be an array of [priority, weight,
    port, target] arrays.  To change the return type, you can specify a second
    argument, which is one of the strings 'priority', 'weight', 'port', 'target',
    'target:port', or 'target@port'.  In that case, only the specified field is
    returned; the special 'target:port'/'target@port' variants return the target
    and port joined with a colon or `@` symbol, as appropriate.
  EOS
  ) do |arguments|
    require 'resolv'
    require 'digest/md5'

    raise(Puppet::ParseError, "dns_srv(): Wrong number of arguments " +
          "given (#{arguments.size} for 1 or 2)") if arguments.size < 1 or arguments.size > 2

    [].tap do |list|
      # We want a stable order for our resolves both for consistency in the
      # shuffling phase, and also so that the string we feed into the seed
      # generator doesn't change from run to run.
      left = Resolv::DNS.new.getresources(arguments[0], Resolv::DNS::Resource::IN::SRV)
               .sort_by { |rr| [rr.target.to_s, rr.port] }
      seed = Digest::MD5.hexdigest(self['::fqdn'] + left.map { |rr| [rr.priority, rr.weight, rr.port, rr.target.to_s] }.inspect).hex
      prng = Random.new(seed)
      until left.empty?
        prio = left.map { |rr| rr.priority }.uniq.min
        candidates = left.select { |rr| rr.priority == prio }
        left -= candidates
        candidates.sort_by! { |rr| [rr.weight, rr.target.to_s] }
        until candidates.empty?
          selector = prng.rand(candidates.inject(1) { |n, rr| n + rr.weight })
          chosen = candidates.inject(0) do |n, rr|
            break rr if n + rr.weight >= selector
            n + rr.weight
          end
          candidates.delete(chosen)
          list << Target.new(chosen.target.to_s, chosen.port)
        end
      end
    end.map do |rr|
     case arguments[1]
      when nil
        [rr.priority, rr.weight, rr.port, rr.target.to_s]
      when 'target:port'
        "#{rr.target.to_s}:#{rr.port}"
      when 'target@port'
        "#{rr.target.to_s}@#{rr.port}"
      when 'priority', 'weight', 'port'
        rr.send(arguments[1])
      when 'target'
        rr.target.to_s
      else
        raise Puppet::ParseError "dns_srv(): invalid value #{arguments[1]} for second argument"
      end
    end
  end
end
