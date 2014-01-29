class gmInfo extends GameInfo;

var bool Linear;

static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
	return default.Class;
}

DefaultProperties
{
	DefaultPawnClass=class'gmPlayer'
	PlayerControllerClass=class'gmController'
	HUDType=class'gmHUD'
	bDelayedStart=false
	Linear=false
}