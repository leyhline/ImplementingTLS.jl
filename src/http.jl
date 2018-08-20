using Sockets

module http

const HTTPPORT = 80

function parseUrl(uri::String)
    host = replace(uri, r"^.*?//" => "")
    NamedTuple{(:host, :path)}(split(host, "/", limit=2))
end

function main()
    host, path = parseUrl("http://google.com/")
    hostName = getaddrinfo(host, IPv4)
    println("Corresponding IP address: $hostName")
    socket = connect(hostName, HTTPPORT)
    println("Retrieving document: '$path'")
    println("Shutting down.")
end

end