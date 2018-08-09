function websocket_client(data) {
    console.log(data.message);
    $('#debug-area').append(data.message);
}