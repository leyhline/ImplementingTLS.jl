module http

using Sockets

const HTTPPORT = 80

function main()
    host, path = parseUrl("http://www.google.com/")
    hostName = getaddrinfo(host, IPv4)
    println("Corresponding IP address: $hostName")
    connection = connect(hostName, HTTPPORT)
    println("Retrieving document: '$path'")
    httpGet(connection, String(path), String(host))
    received = String(read(connection))
    println(received)
    println("Shutting down.")
end

function parseUrl(uri::String)
    host = replace(uri, r"^.*?//" => "")
    NamedTuple{(:host, :path)}(split(host, "/", limit=2))
end

function httpGet(connection, path::String, host::String)
    write(connection, "GET /$path HTTP/1.1\r\n")
    write(connection, "Host: $host\r\n")
    write(connection, "Connection: close\r\n\r\n")
end

end