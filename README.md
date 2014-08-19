This module contains query functions for DNS for use in Puppet.

# Usage

## `dns_a`

Retrieves DNS A records for each argument and returns an array of IPv4
addresses, as dotted-quad strings.  The number of elements in the return
array MAY NOT match the number of arguments passed in, if some names have
multiple IP addresses.


## `dns_aaaa`

Retrieves DNS AAAA records for each argument and returns an array of IPv6
addresses, as RFC5952 "canonical form" strings.  The number of elements in
the return array MAY NOT match the number of arguments passed in, if some
names have multiple IP addresses.


## `dns_cname`

Retrieves a DNS CNAME record for a single specified name and returns it as a
string.


## `dns_mx`

Retrieves DNS MX records for a single specified name and returns them as an
array.  Each record in the array will be an array of [preference, exchange]
arrays.  Second argument is optional and can be either 'preference' or
'exchange', if supplied an array of only those elements is returned.


## `dns_ptr`

Retrieves DNS PTR records for each argument and returns an array of strings. 
The number of elements in the return array MAY NOT match the number of
arguments passed in, if some names have multiple PTR records.


## `dns_srv`

Retrieves DNS SRV records for a single specified name and returns them as an
array.  Each record in the array will be an array of [priority, weight,
port, target] arrays.  Second argument is optional and can be either
'priority', 'weight', 'port' or 'target', if supplied an array of only those
elements is returned.


## `dns_txt`

Retrieves DNS TXT records for a single specified name and returns them as an
array.  Each record in the array will be a array containing the string of
the TXT record.
