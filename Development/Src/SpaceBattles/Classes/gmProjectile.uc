class gmProjectile extends UTProjectile abstract;

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	local gmShip Ship;
	Ship = gmHardPoint(Instigator).Ship;
	if (gmProjectile(Other) != None && gmHardPoint(gmProjectile(Other).Instigator) != None && gmHardPoint(gmProjectile(Other).Instigator).Ship == Ship)
	{
		return;
	}
	else if (Other == Ship)
	{
		return;
	}
	else if (gmHardPoint(Other) != None && gmHardPoint(Other).Ship == Ship)
	{
		return;
	}
	Super.ProcessTouch(Other, HitLocation, HitNormal);
}

DefaultProperties
{
}
