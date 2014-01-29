class gmInput extends UTPlayerInput;

var IntPoint MousePosition;

event PlayerInput(float DeltaTime)
{
	if (myHUD != None) 
	{
		MousePosition.X = Clamp(MousePosition.X + aMouseX, 0, myHUD.SizeX); 
		MousePosition.Y = Clamp(MousePosition.Y - aMouseY, 0, myHUD.SizeY); 
	}

	Super.PlayerInput(DeltaTime);
}

defaultproperties
{
}
