function ClosePage() {
	var tSend = {};
	tSend['sequence_id'] = Math.round(new Date() / 1000);
	tSend['command'] = "close_page";
	SendWXMessage(JSON.stringify(tSend));
}

/*document.onkeydown = function (event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];

    if (window.event) {
        try { e.keyCode = 0; } catch (e) { }
        e.returnValue = false;
    }
};*/

document.onkeydown = function (event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];

    // Prüfen, ob das Ereignis auf einem Input-Feld stattfindet
    var target = e.target || e.srcElement;
    var isInputField = target.tagName.toLowerCase() === 'input' || target.tagName.toLowerCase() === 'textarea';

    if (!isInputField) {
        if (window.event) {
            try { e.keyCode = 0; } catch (e) { }
            e.returnValue = false;
        } else {
            e.preventDefault();
        }
    }
};

window.addEventListener('wheel', function (event) {
    if (event.ctrlKey === true || event.metaKey) {
        event.preventDefault();
    }
}, { passive: false });
