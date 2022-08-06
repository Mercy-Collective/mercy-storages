MC = {}
MC.Storages = {}

// Clicks

$(document).on('click', '.submit', function(e){
    e.preventDefault();
    MC.Storages.Submit();
    MC.Storages.Close();
});

// Functions

MC.Storages.Open = function() {
    $('#pass').val('');
    $(".keypad-container").fadeIn(250);
}

MC.Storages.Close = function() {
    $(".keypad-container").fadeOut(250);
    $.post(`https://${GetParentResourceName()}/Close`);
}

MC.Storages.Submit = function() {
    $.post(`https://${GetParentResourceName()}/CheckPincode`, JSON.stringify({
        pincode: $('#pass').val(),
    }));
}

// Listener

window.addEventListener('message', function(event) {
    let Action = event.data.Action;
    switch(Action) {
        case "Open":
            $(".keypad-container").fadeIn(250);
        break;
    }
});

document.onkeyup = function (data) {
    if (data.code == 'Enter' ) {
        MC.Storages.Submit();
        MC.Storages.Close();
    } else if (data.code == 'Escape' ) {
        MC.Storages.Close();
    }
}