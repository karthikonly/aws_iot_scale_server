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
    var timenow = new Date();
    if (data.timestamp == null) {
        // client never ran
         newClass = "btn-default";
    } else {
        var timestamp = new Date(data.timestamp);
        if (timenow - timestamp > 30 * 1000) {
            // client ran before 30 seconds
            newClass = "btn-danger";
        } else {
            // client is workimg
            newClass = "btn-success";
        }
    }

    // handle command and response status
    if (data.issue_time == null) {
        // do nothing. no command ever issued
    } else {
        var command_timestamp = new Date(data.issue_time);
        // if command was issued within last 5 minutes, bother put status, otherwise dont bother
        if (timenow - command_timestamp < 60*1000) {
            if (data.response_time == null) {
                // response not received yet. put warning
                newClass = "btn-warning";
            } else {
                var response_timestamp = new Date(data.response_time);
                if (response_timestamp >= command_timestamp) {
                    newClass = "btn-primary";
                } else {
                    newClass = "btn-warning";
                }
            }
        }
    }

    $(elem).removeClass("btn-primary btn-default btn-success btn-info btn-warning btn-danger");
    $(elem).addClass(newClass);
}

$(function() {
    $(".device-btn").click(function(event) {
        var id = $(this).attr('id');
        $.post("/api/issue_command", { serial_number: id, command: "test command" } )
            .done(function( data ) {
                // console.log("issued test command to " + id);
            });
    });
});