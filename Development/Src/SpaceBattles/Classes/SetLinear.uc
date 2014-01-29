// extend UIAction if this action should be UI Kismet Action instead of a Level Kismet Action
class SetLinear extends SequenceAction;

var() bool  Linear;

event Activated()
{
	local gmInfo Game;
	Game = gmInfo(GetWorldInfo().Game);
	if (Game != None)
	{
		Game.Linear = Linear;
	}
}

defaultproperties
{
	ObjName="Set Linear"
	ObjCategory="UdkProject Actions"
	VariableLinks(0)=(ExpectedType=class'SeqVar_Bool',LinkDesc="Linear",PropertyName=Linear)
}