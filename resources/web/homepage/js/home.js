/*var TestData={"sequence_id":"0","command":"studio_send_recentfile","data":[{"path":"D:\\work\\Models\\Toy\\3d-puzzle-cube-model_files\\3d-puzzle-cube.3mf","time":"2022\/3\/24 20:33:10"},{"path":"D:\\work\\Models\\Art\\Carved Stone Vase - remeshed+drainage\\Carved Stone Vase.3mf","time":"2022\/3\/24 17:11:51"},{"path":"D:\\work\\Models\\Art\\Kity & Cat\\Cat.3mf","time":"2022\/3\/24 17:07:55"},{"path":"D:\\work\\Models\\Toy\\鐩村墤.3mf","time":"2022\/3\/24 17:06:02"},{"path":"D:\\work\\Models\\Toy\\minimalistic-dual-tone-whistle-model_files\\minimalistic-dual-tone-whistle.3mf","time":"2022\/3\/22 21:12:22"},{"path":"D:\\work\\Models\\Toy\\spiral-city-model_files\\spiral-city.3mf","time":"2022\/3\/22 18:58:37"},{"path":"D:\\work\\Models\\Toy\\impossible-dovetail-puzzle-box-model_files\\impossible-dovetail-puzzle-box.3mf","time":"2022\/3\/22 20:08:40"}]};*/


function OnInit()
{	
	//-----Test-----
	//Set_RecentFile_MouseRightBtn_Event();
	
	
	//-----Official-----
    TranslatePage();

	SendMsg_GetLoginInfo();
	SendMsg_GetRecentFile();
	SendMsg_GetMakerWorldFeaturedPick();
	SendMsg_GetMakerWorldTrendingPick();
	SendMsg_GetMakerWorldDesignerPick();
	
	//InitMakerWorldFeaturedPick();
}

//------最佳打开文件的右键菜单功能----------
var RightBtnFilePath='';

var MousePosX=0;
var MousePosY=0;
var sImages = {};
function Set_RecentFile_MouseRightBtn_Event()
{
	$("#FileList .FileItem").mousedown(
		function(e)
		{			
			//FilePath
			RightBtnFilePath=$(this).attr('fpath');
			
			if(e.which == 3){
				//鼠标点击了右键+$(this).attr('ff') );
				ShowRecnetFileContextMenu();
			}else if(e.which == 2){
				//鼠标点击了中键
			}else if(e.which == 1){
				//鼠标点击了左键
				OnOpenRecentFile( encodeURI(RightBtnFilePath) );
			}
		});

	$(document).bind("contextmenu",function(e){
		//在这里书写代码，构建个性右键化菜单
		return false;
	});	
	
    $(document).mousemove( function(e){
		MousePosX=e.pageX;
		MousePosY=e.pageY;
		
		let ContextMenuWidth=$('#recnet_context_menu').width();
		let ContextMenuHeight=$('#recnet_context_menu').height();
	
		let DocumentWidth=$(document).width();
		let DocumentHeight=$(document).height();
		
		//$("#DebugText").text( ContextMenuWidth+' - '+ContextMenuHeight+'<br/>'+
		//					 DocumentWidth+' - '+DocumentHeight+'<br/>'+
		//					 MousePosX+' - '+MousePosY +'<br/>' );
	} );
	

	$(document).click( function(){		
		var e = e || window.event;
        var elem = e.target || e.srcElement;
        while (elem) {
			if (elem.id && elem.id == 'recnet_context_menu') {
                    return;
			}
			elem = elem.parentNode;
		}		
		
		$("#recnet_context_menu").hide();
	} );

	
}


function HandleStudio( pVal )
{
	let strCmd = pVal['command'];
	//alert(strCmd);
	
	if(strCmd=='get_recent_projects')
	{
		ShowRecentFileList(pVal['response']);
	}
	else if(strCmd=='studio_userlogin')
	{
		SetLoginInfo(pVal['data']['avatar'],pVal['data']['name']);
	}
	else if(strCmd=='studio_useroffline')
	{
		SetUserOffline();
	}
	else if( strCmd=="studio_set_mallurl" )
	{
		SetMallUrl( pVal['data']['url'] );
	}
	else if( strCmd=="studio_clickmenu" )
	{
		let strName=pVal['data']['menu'];
		
		GotoMenu(strName);
	}
	else if( strCmd=="network_plugin_installtip" )
	{
		let nShow=pVal["show"]*1;
		
	    if(nShow==1)
		{
			$("#NoPluginTip").show();
			$("#NoPluginTip").css("display","flex");
		}
		else
		{
			$("#NoPluginTip").hide();
		}
	}
	else if( strCmd=="modelmall_model_advise_get")
	{
		var m_FeaturedModelList=null;

		//alert('hot');
		if( m_FeaturedModelList!=null )
		{
			let SS1=JSON.stringify(pVal['hits']);
			let SS2=JSON.stringify(m_FeaturedModelList);
			
			if( SS1==SS2 )
				return;
		}

	    m_FeaturedModelList=pVal['hits'];
			
		ShowMakerWorldFeaturedPick( m_FeaturedModelList );
		//ShowMakerWorldTrendingPick( m_FeaturedModelList );
		//ShowMakerWorldDesignerPick( m_FeaturedModelList );
	}
}

function GotoMenu( strMenu )
{
	let MenuList=$(".BtnItem");
	let nAll=MenuList.length;
	
	for(let n=0;n<nAll;n++)
	{
		let OneBtn=MenuList[n];
		
		if( $(OneBtn).attr("menu")==strMenu )
		{
			$(".BtnItem").removeClass("BtnItemSelected");			
			
			$(OneBtn).addClass("BtnItemSelected");
			
			$("div[board]").hide();
			$("div[board=\'"+strMenu+"\']").show();
		}
	}
}

function SetLoginInfo( strAvatar, strName ) 
{
	$("#Login1").hide();
	
	$("#UserAvatarIcon").prop("src",strAvatar);
	$("#UserName").text(strName);
	
	$("#Login2").show();
	$("#Login2").css("display","flex");
}

function SetUserOffline()
{
	$("#UserAvatarIcon").prop("src","img/c.jpg");
	$("#UserName").text('');
	$("#Login2").hide();	
	
	$("#Login1").show();
	$("#Login1").css("display","flex");
}

function SetMallUrl( strUrl )
{
	$("#MallWeb").prop("src",strUrl);
}


function ShowRecentFileList( pList )
{
	let nTotal=pList.length;
	
	let strHtml='';
	for(let n=0;n<nTotal;n++)
	{
		let OneFile=pList[n];
		
		let sPath=OneFile['path'];
		let sImg=OneFile["image"] || sImages[sPath];
		let sTime=OneFile['time'];
		let sName=OneFile['project_name'];
		sImages[sPath] = sImg;
		
		//let index=sPath.lastIndexOf('\\')>0?sPath.lastIndexOf('\\'):sPath.lastIndexOf('\/');
		//let sShortName=sPath.substring(index+1,sPath.length);
		
		let TmpHtml='<div class="FileItem"  fpath="'+sPath+'"  >'+
				'<a class="FileTip" title="'+sPath+'"></a>'+
				'<div class="FileImg" ><img src="'+sImg+'" onerror="this.onerror=null;this.src=\'img/d.png\';"  alt="No Image"  /></div>'+
				'<div class="FileName TextS1">'+sName+'</div>'+
				'<div class="FileDate">'+sTime+'</div>'+
			    '</div>';
		
		strHtml+=TmpHtml;
	}
	
	$("#FileList").html(strHtml);	
	
    Set_RecentFile_MouseRightBtn_Event();
	UpdateRecentClearBtnDisplay();
}

function ShowRecnetFileContextMenu()
{
	$("#recnet_context_menu").offset({top: 10000, left:-10000});
	$('#recnet_context_menu').show();
	
	let ContextMenuWidth=$('#recnet_context_menu').width();
	let ContextMenuHeight=$('#recnet_context_menu').height();
	
    let DocumentWidth=$(document).width();
	let DocumentHeight=$(document).height();

	let RealX=MousePosX;
	let RealY=MousePosY;
	
	if( MousePosX + ContextMenuWidth + 24 >DocumentWidth )
		RealX=DocumentWidth-ContextMenuWidth-24;
	if( MousePosY+ContextMenuHeight+24>DocumentHeight )
		RealY=DocumentHeight-ContextMenuHeight-24;
	
	$("#recnet_context_menu").offset({top: RealY, left:RealX});
}

/*-------RecentFile MX Message------*/
function SendMsg_GetLoginInfo()
{
	var tSend={};
	tSend['sequence_id']=Math.round(new Date() / 1000);
	tSend['command']="get_login_info";
	
	SendWXMessage( JSON.stringify(tSend) );	
}


function SendMsg_GetRecentFile()
{
	var tSend={};
	tSend['sequence_id']=Math.round(new Date() / 1000);
	tSend['command']="get_recent_projects";
	
	SendWXMessage( JSON.stringify(tSend) );
}


function OnLoginOrRegister()
{
	var tSend={};
	tSend['sequence_id']=Math.round(new Date() / 1000);
	tSend['command']="homepage_login_or_register";
	
	SendWXMessage( JSON.stringify(tSend) );	
}

function OnClickModelDepot()
{
	var tSend={};
	tSend['sequence_id']=Math.round(new Date() / 1000);
	tSend['command']="homepage_modeldepot";
	
	SendWXMessage( JSON.stringify(tSend) );		
}

function OnClickNewProject()
{
	var tSend={};
	tSend['sequence_id']=Math.round(new Date() / 1000);
	tSend['command']="homepage_newproject";
	
	SendWXMessage( JSON.stringify(tSend) );		
}

function OnClickOpenProject()
{
	var tSend={};
	tSend['sequence_id']=Math.round(new Date() / 1000);
	tSend['command']="homepage_openproject";
	
	SendWXMessage( JSON.stringify(tSend) );		
}

function OnOpenRecentFile( strPath )
{
	var tSend={};
	tSend['sequence_id']=Math.round(new Date() / 1000);
	tSend['command']="homepage_open_recentfile";
	tSend['data']={};
	tSend['data']['path']=decodeURI(strPath);
	
	SendWXMessage( JSON.stringify(tSend) );	
}

function OnDeleteRecentFile( )
{
	var tSend={};
	tSend['sequence_id']=Math.round(new Date() / 1000);
	tSend['command']="homepage_delete_recentfile";
	tSend['data']={};
	tSend['data']['path']=decodeURI(RightBtnFilePath);
	
	SendWXMessage( JSON.stringify(tSend) );	

	$("#recnet_context_menu").hide();
	
	let AllFile=$(".FileItem");
	let nFile=AllFile.length;
	for(let p=0;p<nFile;p++)
	{
		let pp=AllFile[p].getAttribute("fpath");
		if(pp==RightBtnFilePath)
			$(AllFile[p]).remove();
	}	
	
	UpdateRecentClearBtnDisplay();
}

function OnDeleteAllRecentFiles()
{
	var tSend={};
	tSend['sequence_id']=Math.round(new Date() / 1000);
	tSend['command']="homepage_delete_all_recentfile";
	
	SendWXMessage( JSON.stringify(tSend) );		
	
	$('#FileList').html('');
	
	UpdateRecentClearBtnDisplay();
}

function UpdateRecentClearBtnDisplay()
{
    let AllFile=$(".FileItem");
	let nFile=AllFile.length;	
	if( nFile>0 )
		$("#RecentClearAllBtn").show();
	else
		$("#RecentClearAllBtn").hide();
}




function OnExploreRecentFile( )
{
	var tSend={};
	tSend['sequence_id']=Math.round(new Date() / 1000);
	tSend['command']="homepage_explore_recentfile";
	tSend['data']={};
	tSend['data']['path']=decodeURI(RightBtnFilePath);
	
	SendWXMessage( JSON.stringify(tSend) );	
	
	$("#recnet_context_menu").hide();
}

function OnLogOut()
{
	var tSend={};
	tSend['sequence_id']=Math.round(new Date() / 1000);
	tSend['command']="homepage_logout";
	
	SendWXMessage( JSON.stringify(tSend) );	
}

function BeginDownloadNetworkPlugin()
{
	var tSend={};
	tSend['sequence_id']=Math.round(new Date() / 1000);
	tSend['command']="begin_network_plugin_download";
	
	SendWXMessage( JSON.stringify(tSend) );		
}

function OutputKey(keyCode, isCtrlDown, isShiftDown, isCmdDown) {
	var tSend = {};
	tSend['sequence_id'] = Math.round(new Date() / 1000);
	tSend['command'] = "get_web_shortcut";
	tSend['key_event'] = {};
	tSend['key_event']['key'] = keyCode;
	tSend['key_event']['ctrl'] = isCtrlDown;
	tSend['key_event']['shift'] = isShiftDown;
	tSend['key_event']['cmd'] = isCmdDown;

	SendWXMessage(JSON.stringify(tSend));
}

//-------------User Manual------------

function OpenWikiUrl( strUrl )
{
	var tSend={};
	tSend['sequence_id']=Math.round(new Date() / 1000);
	tSend['command']="userguide_wiki_open";
	tSend['data']={};
	tSend['data']['url']=strUrl;
	
	SendWXMessage( JSON.stringify(tSend) );	
}

//-------------Applications------------

function ShowNotice( nShow )
{
	if(nShow==0)
	{
		$("#NoticeMask").hide();
		$("#NoticeBody").hide();
	}
	else
	{
		$("#NoticeMask").show();
		$("#NoticeBody").show();
	}
}

//-------------Libraries------------------

function OpenLibraryUrl( strUrl )
{
	var tSend={};
	tSend['sequence_id']=Math.round(new Date() / 1000);
	tSend['command']="homepage_open_library";
	tSend['data']={};
	tSend['data']['url']=strUrl;
	
	SendWXMessage( JSON.stringify(tSend) );	
}

//-------------Socials------------------

function OpenSocialUrl( strUrl )
{
	var tSend={};
	tSend['sequence_id']=Math.round(new Date() / 1000);
	tSend['command']="homepage_open_social";
	tSend['data']={};
	tSend['data']['url']=strUrl;
	
	SendWXMessage( JSON.stringify(tSend) );	
}

//-------------Library MakerWorld Featured Designers------------------
/*var MakerWorldDesignerSwiper=null;
function InitMakerWorldDesignerPick()
{
	if( MakerWorldDesignerSwiper!=null )
	{
		MakerWorldDesignerSwiper.destroy(true,true);
		MakerWorldDesignerSwiper=null;
	}	
	
	MakerWorldDesignerSwiper = new Swiper('#MakerWorld_FeaturedDesignerSwiper.swiper', {
            slidesPerView : 'auto',
		    spaceBetween: 6,
			navigation: {
				nextEl: '.swiper-button-next',
				prevEl: '.swiper-button-prev',
			},
		    slidesPerView : 'auto',
		    slidesPerGroup : 3
			});
}

function SendMsg_GetMakerWorldDesignerPick()
{
	var tSend={};
	tSend['sequence_id']=Math.round(new Date() / 1000);
	tSend['command']="modelmall_model_advise_get";
	
	SendWXMessage( JSON.stringify(tSend) );
	
	setTimeout("SendMsg_GetMakerWorldDesignerPick()",3600*1000*1);
}

function ShowMakerWorldDesignerPick( ModelList )
{
	let PickTotal=ModelList.length;

	if(PickTotal==0)
	{
		$('#MakerWorld_FeaturedDesignerList').html('');
		$('#MakerWorld_FeaturedDesignerArea').hide();
		
		return;
	}
	
	let strPickHtml='';
	
	for(let a=0;a<PickTotal;a++)
	{
		let OnePickModel=ModelList[a];
		
		let ModelID=OnePickModel['design']['id'];
		let ModelName=OnePickModel['design']['title'];
		let ModelCover=OnePickModel['design']['cover']+'?image_process=resize,w_200/format,webp';
		
		let DesignerName=OnePickModel['design']['designCreator']['name'];
		let DesignerAvatar=OnePickModel['design']['designCreator']['avatar']+'?image_process=resize,w_32/format,webp';
		
		strPickHtml+='<div class="LibraryModelItemPiece swiper-slide"  onClick="OpenOneMakerWorldFeaturedDesigner('+ModelID+')" >'+
			    '<div class="LibraryModelDesignerInfo"><img src="'+DesignerAvatar+'" /><span class="TextS2">'+DesignerName+'</span></div>'+
				'	<div class="LibraryModelItemPreviewBlock"><img class="LibraryModelPreviewImage" src="'+ModelCover+'" /></div>'+
				'	<div  class="LibraryModelNameText TextS1">'+ModelName+'</div>'+
				'</div>';
	}
	
	$('#MakerWorld_FeaturedDesignerList').html(strPickHtml);
	InitMakerWorldDesignerPick();
	$('#MakerWorld_FeaturedDesignerArea').show();
}

function OpenOneMakerWorldFeaturedDesigner( ModelID )
{
	//alert(ModelID);
	var tSend={};
	tSend['sequence_id']=Math.round(new Date() / 1000);
	tSend['command']="modelmall_model_open";
	tSend['data']={};
	tSend['data']['id']=ModelID;
	
	SendWXMessage( JSON.stringify(tSend) );		
}*/

//-------------Library MakerWorld Featured Models------------------
var MakerWorldFeaturedSwiper=null;
function InitMakerWorldFeaturedPick()
{
	if( MakerWorldFeaturedSwiper!=null )
	{
		MakerWorldFeaturedSwiper.destroy(true,true);
		MakerWorldFeaturedSwiper=null;
	}	
	
	MakerWorldFeaturedSwiper = new Swiper('#MakerWorld_FeaturedModelSwiper.swiper', {
            slidesPerView : 'auto',
		    spaceBetween: 6,
			navigation: {
				nextEl: '.swiper-button-next',
				prevEl: '.swiper-button-prev',
			},
		    slidesPerView : 'auto',
		    slidesPerGroup : 3
			});
}

function SendMsg_GetMakerWorldFeaturedPick()
{
	var tSend={};
	tSend['sequence_id']=Math.round(new Date() / 1000);
	tSend['command']="modelmall_model_advise_get";
	
	SendWXMessage( JSON.stringify(tSend) );
	
	setTimeout("SendMsg_GetMakerWorldFeaturedPick()",3600*1000*1);
}

function ShowMakerWorldFeaturedPick( ModelList )
{
	let PickTotal=ModelList.length;

	if(PickTotal==0)
	{
		$('#MakerWorld_FeaturedModelList').html('');
		$('#MakerWorld_FeaturedModelArea').hide();
		
		return;
	}
	
	let strPickHtml='';
	
	for(let a=0;a<PickTotal;a++)
	{
		let OnePickModel=ModelList[a];
		
		let ModelID=OnePickModel['design']['id'];
		let ModelName=OnePickModel['design']['title'];
		let ModelCover=OnePickModel['design']['cover']+'?image_process=resize,w_200/format,webp';
		
		let DesignerName=OnePickModel['design']['designCreator']['name'];
		let DesignerAvatar=OnePickModel['design']['designCreator']['avatar']+'?image_process=resize,w_32/format,webp';
		
		strPickHtml+='<div class="LibraryModelItemPiece swiper-slide"  onClick="OpenOneMakerWorldFeaturedModel('+ModelID+')" >'+
			    '<div class="LibraryModelDesignerInfo"><img src="'+DesignerAvatar+'" /><span class="TextS2">'+DesignerName+'</span></div>'+
				'	<div class="LibraryModelItemPreviewBlock"><img class="LibraryModelPreviewImage" src="'+ModelCover+'" /></div>'+
				'	<div  class="LibraryModelNameText TextS1">'+ModelName+'</div>'+
				'</div>';
	}
	
	$('#MakerWorld_FeaturedModelList').html(strPickHtml);
	InitMakerWorldFeaturedPick();
	$('#MakerWorld_FeaturedModelArea').show();
}

function OpenOneMakerWorldFeaturedModel( ModelID )
{
	//alert(ModelID);
	var tSend={};
	tSend['sequence_id']=Math.round(new Date() / 1000);
	tSend['command']="modelmall_model_open";
	tSend['data']={};
	tSend['data']['id']=ModelID;
	
	SendWXMessage( JSON.stringify(tSend) );		
}

//-------------Library MakerWorld Trending Models------------------
/*var MakerWorldTrendingSwiper=null;
function InitMakerWorldTrendingPick()
{
	if( MakerWorldTrendingSwiper!=null )
	{
		MakerWorldTrendingSwiper.destroy(true,true);
		MakerWorldTrendingSwiper=null;
	}	
	
	MakerWorldTrendingSwiper = new Swiper('#MakerWorld_TrendingModelSwiper.swiper', {
            slidesPerView : 'auto',
		    spaceBetween: 6,
			navigation: {
				nextEl: '.swiper-button-next',
				prevEl: '.swiper-button-prev',
			},
		    slidesPerView : 'auto',
		    slidesPerGroup : 3
			});
}

function SendMsg_GetMakerWorldTrendingPick()
{
	var tSend={};
	tSend['sequence_id']=Math.round(new Date() / 1000);
	tSend['command']="get_makerworld_models";
	
	SendWXMessage( JSON.stringify(tSend) );
	
	setTimeout("SendMsg_GetMakerWorldTrendingPick()",3600*1000*1);
}

function ShowMakerWorldTrendingPick( ModelList )
{
	let PickTotal=ModelList.length;

	if(PickTotal==0)
	{
		$('#MakerWorld_TrendingModelList').html('');
		$('#MakerWorld_TrendingModelArea').hide();
		
		return;
	}
	
	let strPickHtml='';
	
	for(let a=0;a<PickTotal;a++)
	{
		let OnePickModel=ModelList[a];
		
		let ModelID=OnePickModel['design']['id'];
		let ModelName=OnePickModel['design']['title'];
		let ModelCover=OnePickModel['design']['cover']+'?image_process=resize,w_200/format,webp';
		
		let DesignerName=OnePickModel['design']['designCreator']['name'];
		let DesignerAvatar=OnePickModel['design']['designCreator']['avatar']+'?image_process=resize,w_32/format,webp';
		
		strPickHtml+='<div class="LibraryModelItemPiece swiper-slide"  onClick="OpenOneMakerWorldTrendingModel('+ModelID+')" >'+
			    '<div class="LibraryModelDesignerInfo"><img src="'+DesignerAvatar+'" /><span class="TextS2">'+DesignerName+'</span></div>'+
				'	<div class="LibraryModelItemPreviewBlock"><img class="LibraryModelPreviewImage" src="'+ModelCover+'" /></div>'+
				'	<div  class="LibraryModelNameText TextS1">'+ModelName+'</div>'+
				'</div>';
	}
	
	$('#MakerWorld_TrendingModelList').html(strPickHtml);
	InitMakerWorldTrendingPick();
	$('#MakerWorld_TrendingModelArea').show();
}

function OpenOneMakerWorldTrendingModel( ModelID )
{
	//alert(ModelID);
	var tSend={};
	tSend['sequence_id']=Math.round(new Date() / 1000);
	tSend['command']="modelmall_model_open";
	tSend['data']={};
	tSend['data']['id']=ModelID;
	
	SendWXMessage( JSON.stringify(tSend) );		
}*/

//---------------Global-----------------
window.postMessage = HandleStudio;

