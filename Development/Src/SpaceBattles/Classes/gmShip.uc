class gmShip extends gmPawn;

var array<gmHardPoint> HardPoints;
var int Energy;
var int MaxEnergy;
var int EnergyRegen;
var float TurnRate;
var float MaxSpeed;
var gmShipMesh ShipMesh;

static function gmShip GetBasicShip(Controller Control)
{
	local gmShip ret;
	local Vector Offset;
	local array<gmWeaponController> WeapControls;

	WeapControls[0] = Control.Spawn(class'gmWeaponController');
	WeapControls[1] = Control.Spawn(class'gmWeaponController');
	WeapControls[0].ShipController = gmController(Control);
	WeapControls[1].ShipController = gmController(Control);

	ret = Control.Spawn(class'gmShip');
	ret.HealthMax = 2000;
	ret.Health = 2000;
	ret.MaxEnergy = 1000;
	ret.Energy = 1000;
	ret.EnergyRegen = 100;
	ret.TurnRate = 1.5;
	ret.MaxSpeed = 600.0;
	ret.ShipMesh = class'gmShipMesh'.static.GetMothershipShipMesh();
	ret.Mesh = new class'SkeletalMeshComponent';
	ret.Mesh.SetSkeletalMesh(ret.ShipMesh.ShipMesh);
	ret.Mesh.SetScale(ret.ShipMesh.BaseScale);
	ret.Mesh.SetTranslation(ret.ShipMesh.BaseTranslation);
	ret.Mesh.SetRotation(ret.ShipMesh.BaseRotation);
	ret.Mesh.SetLightEnvironment(ret.LightEnvironment);
	ret.AttachComponent(ret.Mesh);
	ret.HardPoints[0] = Control.Spawn(class'gmHardPoint');
	ret.HardPoints[0].Ship = ret;
	ret.HardPoints[0].MaxWeaponClass = 1;
	Offset.X = 0;
	Offset.Y = -64;
	Offset.Z = 8;
	ret.HardPoints[0].Offset = Offset;
	WeapControls[0].Possess(ret.HardPoints[0], false);
	ret.HardPoints[1] = Control.Spawn(class'gmHardPoint');
	ret.HardPoints[1].Ship = ret;
	ret.HardPoints[1].MaxWeaponClass = 1;
	Offset.X = 0;
	Offset.Y = +64;
	Offset.Z = 8;
	ret.HardPoints[1].Offset = Offset;
	WeapControls[1].Possess(ret.HardPoints[1], false);
	ret.SetLocation(Control.Location);

	return ret;
}

simulated function StartFire(byte FireModeNum)
{
	local int i;
	if (FireModeNum == 1)
	{
		for (i = 0; i < HardPoints.Length; ++i)
		{
			if (HardPoints[i].Weapon != None)
			{
				HardPoints[i].Weapon.BeginFire(0);
			}
		}
	}
}

simulated function StopFire(byte FireModeNum)
{
	local int i;
	if (FireModeNum == 1)
	{
		for (i = 0; i < HardPoints.Length; ++i)
		{
			if (HardPoints[i].Weapon != None)
			{
				HardPoints[i].Weapon.StopFire(0);
			}
		}
	}
}

event Tick(float DeltaTime)
{
	local Vector X, Y, Z, vX, vY, vZ;
	Super.Tick(DeltaTime);
	SetEnergy(Energy + EnergyRegen * DeltaTime);
	if (VSize(Velocity) != 0)
	{
		GetAxes(Rotation,X,Y,Z);
		vX = ProjectOnTo(Velocity, X * VSize(Velocity));
		vY = ProjectOnTo(Velocity, Y * VSize(Velocity));
		vZ = ProjectOnTo(Velocity, Z * VSize(Velocity));
		vX = vX * MaxSpeed / FMax(VSize(vX), MaxSpeed);
		vY = vY * MaxSpeed / FMax(VSize(vY), MaxSpeed);
		vZ = vZ * MaxSpeed / FMax(VSize(vZ), MaxSpeed);
		Velocity = vX + vY + vZ;
	}
}

function SetEnergy(int NewEnergy)
{
	Energy = Max(Min(NewEnergy, MaxEnergy), 0);
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
}

DefaultProperties
{
Begin Object Class=SkeletalMeshComponent Name=PawnMesh
  SkeletalMesh=SkeletalMesh'yourpackage.Ship_Skelton'
 End Object

	bJumpCapable=false
	LandMovementState=PlayerFlying
	AirSpeed=99999

	begin object class=DynamicLightEnvironmentComponent Name=UPawnEnvironment
		bSynthesizeSHLight=true
	end object

	LightEnvironment=UPawnEnvironment
	Components.Add(UPawnEnvironment)
}