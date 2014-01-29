class gmController extends UTPlayerController implements(gmITarget);

var const Vector TraceWidth;
var const Rotator CamRotate;

var bool Linear;
var bool Rotate;

simulated event PostBeginPlay()
{
	local gmShip Ship;
	Super.PostBeginPlay();
	bNoCrosshair=true;
	Ship = class'gmShip'.static.GetBasicShip(Self);
	Possess(Ship, false);
	Ship.HardPoints[0].Mount(class'gmWeaponTemplate'.static.GetBasicWeapon());
	Ship.HardPoints[1].Mount(class'gmWeaponTemplate'.static.GetBasicWeapon());
}

simulated event GetPlayerViewPoint(out Vector POVLocation, out Rotator POVRotation)
{
	local Vector X, Y, Z;
	local Vector HitLocation, HitNormal, PawnTarget, CamOff;
	Super.GetPlayerViewPoint(POVLocation, POVRotation);
	if (Pawn != None)
	{
		if (Pawn.Mesh != None)
		{
			Pawn.Mesh.SetOwnerNoSee(false);
		}
		if (Pawn.Weapon != None) 
		{
			Pawn.Weapon.SetHidden(true);
		}
		GetAxes(Pawn.Rotation, X, Y, Z);
		PawnTarget = Pawn.Location + X*512;
		CamOff = Normal(Z/2-X);
		if (gmShip(Pawn) != None)
		{
			CamOff *= gmShip(Pawn).ShipMesh.CamScale;
		}
		POVLocation = Pawn.Location + CamOff*256;
		if (Trace(HitLocation, HitNormal, POVLocation, Pawn.Location, false, TraceWidth) != None)
		{
			POVLocation = HitLocation;
		}
		POVRotation = Rotator(PawnTarget - POVLocation);
	}
}

function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc)
{
	return Rotator(Target() - StartFireLoc);
}

state PlayerFlying
{
	ignores SeePlayer, HearNoise, Bump;

	function PlayerMove(float DeltaTime)
	{
		local Vector X, Y, Z, vY, vZ;
		UpdateRotation(DeltaTime);
		GetAxes(Rotation,X,Y,Z);
		if (Linear)
		{
			Pawn.Acceleration = PlayerInput.aForward*X + PlayerInput.aStrafe*Y + PlayerInput.aUp*Z;
			vY = ProjectOnTo(Pawn.Velocity, Y * VSize(Pawn.Velocity));
			vZ = ProjectOnTo(Pawn.Velocity, Z * VSize(Pawn.Velocity));
			if (PlayerInput.aStrafe == 0)
			{
				if (VSize(vY) != 0)
				{
					if (VSize(vY + Y) < VSize(vY - Y))
					{
						Pawn.Acceleration += Y * FMin(VSize(vY), 1);
					}
					else
					{
						Pawn.Acceleration -= Y * FMin(VSize(vY), 1);
					}
				}
			}
			if (PlayerInput.aUp == 0)
			{
				if (VSize(vZ) != 0)
				{
					if (VSize(vZ + Z) < VSize(vZ - Z))
					{
						Pawn.Acceleration += Z * FMin(VSize(vZ), 1);
					}
					else
					{
						Pawn.Acceleration -= Z * FMin(VSize(vZ), 1);
					}
				}
			}
			Pawn.Acceleration = Pawn.AccelRate * Normal(Pawn.Acceleration);
		}
		else
		{
			if (bPressedJump)
			{
				Rotate = !Rotate;
				bPressedJump = false;
			}
			Pawn.Acceleration = PlayerInput.aForward*X + PlayerInput.aStrafe*Y/* + PlayerInput.aUp*Z*/;
			Pawn.Acceleration = Pawn.AccelRate * Normal(Pawn.Acceleration);
		}
	}

	function UpdateRotation(float DeltaTime)
	{
		local gmInput MyInput;
		local Rotator DeltaRot, newRotation, ViewRotation;
		if (Rotate)
		{
			MyInput = gmInput(PlayerInput);

			ViewRotation = Rotation;
			if (Pawn!=none)
			{
				Pawn.SetDesiredRotation(ViewRotation);
			}

			DeltaRot.Yaw	= -((myHUD.SizeX - 2*MyInput.MousePosition.X) / myHUD.SizeX) * 8192 * DeltaTime * gmShip(Pawn).TurnRate;
			DeltaRot.Pitch	=  ((myHUD.SizeY - 2*MyInput.MousePosition.Y) / myHUD.SizeY) * 8192 * DeltaTime * gmShip(Pawn).TurnRate;

			ProcessViewRotation( DeltaTime, ViewRotation, DeltaRot );
			SetRotation(ViewRotation);

			ViewShake( deltaTime );

			NewRotation = ViewRotation;

			if ( Pawn != None )
				Pawn.FaceRotation(NewRotation, deltatime);
		}
	}

	function ProcessMove(float DeltaTime, Vector newAccell, EDoubleClickDir DoubleClickMove, rotator DeltaRot)
	{
		Super.ProcessMove(DeltaTime, newAccell, DoubleClickMove, DeltaRot);
	}
}

event PlayerTick(float DeltaTime)
{
	super.PlayerTick(DeltaTime);
	Linear = gmInfo(WorldInfo.Game).Linear;
}

event Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);
}

function Vector Target()
{
	local int ScaleFactor;
	ScaleFactor = Linear ? 1500 : 3000;
	return gmHUD(myHUD).WorldOrigin + gmHUD(myHUD).WorldDirection * ScaleFactor;
}

DefaultProperties
{
	TraceWidth=(X=15,Y=15,Z=15)
	CamRotate=(Pitch=-8192,Yaw=0,Roll=0)
	InputClass=class'gmInput'
	Rotate=false
}