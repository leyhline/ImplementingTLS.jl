module http

using Sockets

const HTTPPORT = 80

function main()
    if length(ARGS) != 1
        println("Usage: $PROGRAM_FILE url")
        exit(1)
    end
    url = ARGS[1]
    println("Connecting to: $url on $HTTPPORT")
    host, path = parseUrl(url)
    hostName = getaddrinfo(host, IPv4)
    println("Corresponding IP address: $hostName")
    connection = connect(hostName, HTTPPORT)
    try
        httpGet(connection, String(path), String(host))
        println("Retrieving document: '$path'")
        response = read(connection)
        print(String(response))
    finally
        println("Shutting down.")
        close(connection)
    end
end

function parseUrl(uri::String)
    host = replace(uri, r"^.*?//" => "")
    NamedTuple{(:host, :path)}(split(host, "/", limit=2))
end

function httpGet(connection, path::String, host::String)
    write(connection,
        "GET /$path HTTP/1.1\r\n" *
        "Host: $host\r\n" *
        "Connection: close\r\n\r\n")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end

end