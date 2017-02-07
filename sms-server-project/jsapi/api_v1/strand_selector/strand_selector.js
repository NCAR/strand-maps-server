// JS for the strand selector widgets

// Called on page load...

var currentMenu = null;
var doCloseMenu = true;
function onPageLoadSelector(){
	var keywordBox = $('keywordBox');
	/*
	// do not pre focus on keyword box
	if(keywordBox){
		keywordBox.focus();	
	}
	*/
	if($$('.menuController'))
	{
		$$('.menuController').each(function (el) {
			 $(el).observe('click', openMenu);
			 $(el).observe('touchstart', openMenu);
		});
		
		$$('#id_nav_menu li ul li').each(function (el) {
			 $(el).observe('click', cancelCloseMenu);
			 $(el).observe('touchstart', cancelCloseMenu);
		});
	}
}
function cancelCloseMenu(event)
{doCloseMenu=false;}

// Open a ul menu by giving it the class name menuOpen
function openMenu(event){
	//This step event is used to cancel the body click event that should close the
	// menu. But since they clicked on another menu keep it open. This is used instead
	// of using timed events
	cancelCloseMenu(event)
	
	// Disable the viewing screen. This was added for touch screens, Letting it
	// still listen for events causes issues
	if ( typeof disableViewableMapEvents == 'function' )
	{
		try
		{
			disableViewableMapEvents();
		}
		catch(err)
		{}
	}	
	element = $(Event.element(event));
	submenu = Element.next(element, 'ul')

	if(currentMenu!=null && currentMenu.id!='id_nav_menu' && currentMenu!=submenu )
	{
		currentMenu.removeClassName('menuOpen')
	}
	currentMenu = submenu
	submenu.addClassName('menuOpen');
	$$('body')[0].observe('click', closeMenu);	
	$$('body')[0].observe('touchstart', closeMenu);
}

//Close all menus by removing the class name menuOpen from all menus
function closeMenu(event)
{
	if(doCloseMenu)
	{
		$$('body')[0].stopObserving('click', closeMenu);
		$$('body')[0].stopObserving('touchstart', closeMenu);
		$$('.menuOpen').each(function (el) {
				return $(el).removeClassName('menuOpen');
			});
		
		// Re-enable the viewing screen. This was added for touch screens
		if ( typeof enableViewableMapEvents == 'function' ) 
		{
			try
			{
				enableViewableMapEvents();
			}
			catch(err)
			{}
		}
	}
	else
	{
		doCloseMenu = true;
	}
}

function clear_keywordbox()
{
	$('keywordBox').value = "";
	$('keywordBox').setStyle({
		  color: '#000'
		});
} 
function onMapTableOver(id) {
	$(id).addClassName('mapTableOver');
}

function onMapTableOut(id) {
	$(id).removeClassName('mapTableOver');
}

