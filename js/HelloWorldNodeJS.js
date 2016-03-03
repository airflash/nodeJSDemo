// --------------------------------------
// Imports
// --------------------------------------
var net = require('net');
var mySocket;

// --------------------------------------
// Construct The Socket
// --------------------------------------
// create the server and register event listeners
var server = net.createServer(function(socket) {
	mySocket = socket;
	mySocket.on("connect", onConnect);
	mySocket.on("data", onData);
});

// --------------------------------------
// Events
// --------------------------------------
/**
 * Handles the Event: <code>"connect"</code>.
 *
*/
function onConnect()
{
	console.log("Connected to Flash");
}

/**
 * Handles the Event: <code>"data"</code>.
 *
 * When flash sends us data, this method will handle it
 *
*/
function onData(d)
{
	if(d == "exit\0")
	{
		console.log("exit");
		mySocket.end();
		server.close();
	}
	else
	{
		console.log("From Flash = " + d);
		mySocket.write(d, 'utf8');
	}
}

// --------------------------------------
// Start the Socket
// --------------------------------------
server.listen(9001, "127.0.0.1");