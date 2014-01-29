class gmWeaponTemplate extends Object;

var int WeaponClass;
var int EnergyCost;
var float WeaponDamage;
var float ProjectileSpeed;
var float FireInterval;
var UDKSkeletalMeshComponent SkeletalMesh;

var class<Projectile> WeaponProjectile;

static function gmWeaponTemplate GetBasicWeapon()
{
	local gmWeaponTemplate ret;
	local Vector Trans;
	local Rotator Rot;
	Trans.X = 0;
	Trans.Y = 0;
	Trans.Z = 0;
	Rot.Yaw = 0;

	ret = New class'gmWeaponTemplate';

	ret.WeaponClass = 1;
	ret.WeaponDamage = 20;
	ret.ProjectileSpeed = 1.5;
	ret.FireInterval = 0.25;
	ret.EnergyCost = 10;

	ret.SkeletalMesh = New class'UDKSkeletalMeshComponent';
	ret.SkeletalMesh.SetSkeletalMesh(SkeletalMesh'WP_RocketLauncher.Mesh.SK_WP_RocketLauncher_1P');
	ret.SkeletalMesh.SetPhysicsAsset(None);
	ret.SkeletalMesh.SetAnimTreeTemplate(AnimTree'WP_RocketLauncher.Anims.AT_WP_RocketLauncher_1P_Base');
	ret.SkeletalMesh.AnimSets[0] = AnimSet'WP_RocketLauncher.Anims.K_WP_RocketLauncher_1P_Base';
	ret.SkeletalMesh.SetTranslation(Trans);
	ret.SkeletalMesh.SetRotation(Rot);
	ret.SkeletalMesh.SetScale(1.0);
	ret.SkeletalMesh.bUpdateSkelWhenNotRendered = true;
	ret.WeaponProjectile = class'gmProj_Basic';
	return ret;
}

DefaultProperties
{
}
