function OnInit()
{

}

function CheckApplication()
{
	var tSend={};
	tSend['sequence_id']=Math.round(new Date() / 1000);
	tSend['command']="check_application_profilemanager";
	
	SendWXMessage( JSON.stringify(tSend) );
}

function DownloadApplication()
{
	var tSend={};
	tSend['sequence_id']=Math.round(new Date() / 1000);
	tSend['command']="download_application_profilemanager";
	
	SendWXMessage( JSON.stringify(tSend) );
}

function OpenApplication()
{
	var tSend={};
	tSend['sequence_id']=Math.round(new Date() / 1000);
	tSend['command']="open_application_profilemanager";
	
	SendWXMessage( JSON.stringify(tSend) );
}

function GotoSelectionPage()
{
	window.location.href="../21/index.html";
}