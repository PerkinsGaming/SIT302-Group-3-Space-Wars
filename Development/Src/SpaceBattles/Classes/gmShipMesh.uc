class gmShipMesh extends Object;

var SkeletalMesh ShipMesh;
var float BaseScale;
var float CamScale;
var Vector BaseTranslation;
var Rotator BaseRotation;

static function gmShipMesh GetBasicShipMesh()
{
	local gmShipMesh ret;
	ret = new class'gmShipMesh';
	return ret;
}

static function gmShipMesh GetMothershipShipMesh()
{
	local gmShipMesh ret;
	ret = new class'gmShipMesh';
	ret.ShipMesh = SkeletalMesh'yourpackage.Ship_Skelton';
	ret.BaseScale = 0.1;
	ret.CamScale = 2.0;
	ret.BaseTranslation.X = 0;
	ret.BaseTranslation.Y = 0;
	ret.BaseTranslation.Z = -32;
	ret.BaseRotation.Pitch = 0;
	ret.BaseRotation.Yaw = 16384;
	ret.BaseRotation.Roll = 0;
	return ret;
}

DefaultProperties
{
}
