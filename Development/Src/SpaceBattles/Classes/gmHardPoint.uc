class gmHardPoint extends UTPawn;

var int MaxWeaponClass;
var Vector Offset;
var gmWeaponTemplate WeaponTemplate;
var gmShip Ship;

function bool Mount(gmWeaponTemplate Template)
{
	local gmWeapon Weap;
	if (Template.WeaponClass > MaxWeaponClass)
	{
		return false;
	}
	if (WeaponTemplate != None)
	{
		DetachComponent(WeaponTemplate.SkeletalMesh);
		InvManager.RemoveFromInventory(Weapon);
	}
	WeaponTemplate = Template;
	WeaponTemplate.SkeletalMesh.SetLightEnvironment(LightEnvironment);
	AttachComponent(WeaponTemplate.SkeletalMesh);
	Weap = Self.Spawn(class'gmWeapon');
	Weap.WeaponProjectiles[0] = WeaponTemplate.WeaponProjectile;
	Weap.FireInterval[0] = WeaponTemplate.FireInterval;
	Weap.MaxAmmoCount = 1;
	Weap.AmmoCount = 1;
	Weap.WeaponTemplate = Template;

	InvManager.AddInventory(Weap);

	return true;
}

function bool Unmount()
{
	if (WeaponTemplate == None)
	{
		return false;
	}
	DetachComponent(WeaponTemplate.SkeletalMesh);
	InvManager.RemoveFromInventory(Weapon);
	WeaponTemplate = None;
}

event Tick(float DeltaTime)
{
	local gmITarget TargetInterface;
	Super.Tick(DeltaTime);
	SetLocation(Ship.Location + (Offset >> Ship.Rotation));
	Weapon.SetLocation(Location);
	TargetInterface = gmITarget(gmWeaponController(Controller).ShipController);
	if (TargetInterface != None)
	{
		SetRotation(Rotator(TargetInterface.Target() - Location));
	}
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
}

DefaultProperties
{
	begin object class=DynamicLightEnvironmentComponent Name=UPawnEnvironment
		bSynthesizeSHLight=true
	end object

	LightEnvironment=UPawnEnvironment
	Components.Add(UPawnEnvironment)

	bIsInvulnerable=true
	CollisionType=COLLIDE_NoCollision
	CollisionComponent=None
	MaxWeaponClass=1
	Offset=(X=0,Y=0,Z=0)
	WeaponTemplate=None
	Weapon=None
}
