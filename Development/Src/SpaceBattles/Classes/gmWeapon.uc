class gmWeapon extends UTWeapon;//Weapon;

var gmWeaponTemplate WeaponTemplate;

simulated function FireAmmunition()
{
	local gmITarget WeapTarget;
	local Vector HitLocation, HitNormal;
	local gmShip Ship;
	local Vector TraceWidth;
	local float CollisionRadius;
	CollisionRadius = WeaponTemplate.WeaponProjectile.default.CylinderComponent.CollisionRadius;
	TraceWidth.X = CollisionRadius;
	TraceWidth.Y = CollisionRadius;
	TraceWidth.Z = CollisionRadius;
	WeapTarget = gmWeaponController(Instigator.Controller).ShipController;
	if (WeapTarget != None)
	{
		Ship = gmShip(gmWeaponController(Instigator.Controller).ShipController.Pawn);
		if (Trace(HitLocation, HitNormal, WeapTarget.Target(), GetPhysicalFireStartLoc(), true, TraceWidth) != Ship) //Don't shoot yourself.
		{
			if (WeaponTemplate.EnergyCost <= Ship.Energy)
			{
				Ship.SetEnergy(Ship.Energy - WeaponTemplate.EnergyCost);
				ProjectileFire();
				NotifyWeaponFired(CurrentFireMode);
				return;
			}
		}
	}
}

simulated function Vector GetPhysicalFireStartLoc(optional Vector AimDir)
{
	local Vector X, Y, Z;
	GetAxes(Rotation, X, Y, Z);
	return Location + X * ProjectileSpawnOffset;
}

event Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);
}

DefaultProperties
{
}