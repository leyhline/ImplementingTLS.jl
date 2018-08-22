module webserver

using Sockets

const HTTPPORT = 80
const LOOPBACKADDR = ip"127.0.0.1"
const BACKLOG = 5

function main()
    server = listen(LOOPBACKADDR, HTTPPORT, backlog=BACKLOG)
    while true
        connection = accept(server)
        name, port = getpeername(connection)
        println("Connected with: $name on $port")
        handleRequest(connection)
    end
end

function handleRequest(connection)
    while isopen(connection)
        request = readline(connection, keep=true)
        print(request)
        if startswith(request, "GET")
            write(connection,
                "HTTP/1.1 200 OK\r\n" *
                "Connection: close\r\n" *
                "Content-Type:text/html\r\n\r\n" *
                "<html><head><title>Test Page</title></head><body><p>Hello World!</p></body></html>\r\n")
        else
            write(connection,
                "HTTP/1.1 501 Not Implemented\r\n" *
                "Connection: close\r\n\r\n")
        end
        println("Closing connection.")
        close(connection)
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end

end