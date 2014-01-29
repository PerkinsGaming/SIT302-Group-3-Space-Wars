class gmHUD extends UTHUD;

var const Texture2D MouseTexture;

var Vector WorldOrigin;
var Vector WorldDirection;

var const int BarLength;

function DrawBar(String Title, float Value, float MaxValue,int X, int Y, int R, int G, int B)
{

    local int PosX, i;
	local float FilledLength;

    PosX = X; // Where we should draw the next rectangle
    FilledLength = BarLength * Value / MaxValue; // Number of active rectangles to draw
    i=0; // Number of rectangles already drawn

    /* Displays active rectangles */
	Canvas.SetDrawColor(R, G, B, 200);
	for (i = 0; i < int(FilledLength); ++i)
    {
        Canvas.SetPos(PosX, Y);
        Canvas.DrawRect(8, 12);

        PosX += 10;
    }
	if (i < BarLength)
	{
		Canvas.SetPos(PosX, Y);
		Canvas.DrawRect((FilledLength - FFloor(FilledLength)) * 8, 12);

		/* Displays desactived rectangles */
		Canvas.SetDrawColor(255,255,255,80);
		Canvas.SetPos(PosX + (FilledLength - FFloor(FilledLength)) * 8, Y);
		Canvas.DrawRect(8 - (FilledLength - FFloor(FilledLength)) * 8, 12);
		PosX += 10;
		while(++i < BarLength)
		{
			Canvas.SetPos(PosX, Y);
			Canvas.DrawRect(8, 12);

			PosX += 10;
		}
	}

    /* Displays a title */
    Canvas.SetPos(PosX + 15, Y);
    Canvas.SetDrawColor(R, G, B, 200);
    Canvas.Font = class'Engine'.static.GetSmallFont();
    Canvas.DrawText(Title);

} 

function DrawGameHud()
{
	DrawBar("Health", PawnOwner.Health, PawnOwner.HealthMax,20,20,200,80,80);
	if (gmShip(PawnOwner) != None)
	{
		DrawBar("Energy", gmShip(PawnOwner).Energy, gmShip(PawnOwner).MaxEnergy,20,40,80,80,200);
	}
}

//Code adapted from here: http://forums.epicgames.com/threads/729046-Creating-a-Moving-Crosshair-(Sidescroller)
simulated event PostRender()
{
	local gmInput MouseInput;
	local Vector2D MousePosition;
	local UIInteraction UIController;
	DrawGameHud();
	PreCalcValues();
	Super.PostRender();

	if (Canvas != None)
	{
		UIController = PlayerOwner.GetUIController();
		
		if (UIController != none && UIController.SceneClient != none)
		{
			MouseInput = gmInput(PlayerOwner.PlayerInput);
			MousePosition.X = MouseInput.MousePosition.X;
			MousePosition.Y = MouseInput.MousePosition.Y;

			Canvas.DeProject(MousePosition, WorldOrigin, WorldDirection);

			Canvas.SetPos(MousePosition.X - 32, MousePosition.Y - 32);
			Canvas.SetDrawColor(255, 255, 255, 255);
			Canvas.DrawTile(MouseTexture, 64, 64, 320, 0, 64, 64);
		}
	}
}

DefaultProperties
{
	MouseTexture=Texture2D'UI_HUD.HUD.UTCrossHairs'
	BarLength=20
}