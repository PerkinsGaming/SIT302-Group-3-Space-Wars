class gmProj_Basic extends gmProjectile;

DefaultProperties
{
	ProjFlightTemplate=ParticleSystem'WP_ShockRifle.Particles.P_WP_ShockRifle_Ball'
	ProjExplosionTemplate=ParticleSystem'WP_ShockRifle.Particles.P_WP_ShockRifle_Ball_Impact'

	Speed=1150
	MaxSpeed=1150

	bCheckProjectileLight=true
	ProjectileLightClass=class'UTGame.UTShockBallLight'

	Damage=20
	MyDamageType=class'UTDmgType_ShockBall'
	LifeSpan=8.0

	bCollideWorld=true
	bProjTarget=True

	Begin Object Name=CollisionCylinder
		CollisionRadius=2
		CollisionHeight=2
		AlwaysLoadOnClient=True
		AlwaysLoadOnServer=True
		BlockNonZeroExtent=true
		BlockZeroExtent=true
		BlockActors=true
		CollideActors=true
	End Object

	AmbientSound=SoundCue'A_Weapon_ShockRifle.Cue.A_Weapon_SR_AltFireTravelCue'
	ExplosionSound=SoundCue'A_Weapon_ShockRifle.Cue.A_Weapon_SR_AltFireImpactCue'
}
