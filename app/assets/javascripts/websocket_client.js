function websocket_client(data) {
    // console.log(data.serial_number);
    // $('#debug-area').append(data.serial_number);
    var serial = data.serial_number;
    var elem = '#'+serial;

    // create element if it does not exist
    if (!($(elem).length)) {
        $('#client-status').append("<button name=\"button\" type=\"button\" class=\"device-btn\" id=\""+serial+"\">"+serial+"</button>")
    }

    var newClass = "";
    var timestamp = new Date(data.timestamp);
    if (data.timestamp == null) {
        // client never ran
         newClass = "btn-default";
    } else if (new Date() - timestamp > 30*1000) {
        // client ran before 30 seconds
        newClass = "btn-danger";
    } else {
        // client is workimg
        newClass = "btn-success";
    }
    $(elem).removeClass("btn-primary btn-default btn-success btn-info btn-warning btn-danger");
    $(elem).addClass(newClass);
}