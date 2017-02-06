#include <a_samp>
#include <streamer>

/*
if (objectid == HausInfo[h][hTor])
{
	if (SpielerInfo[playerid][uHausschluessel] == h)
	{
		TuerSelected[playerid][0] = h;
		TuerSelected[playerid][1] = 3;
		if (HausInfo[h][hTorOpen] == 0) HausInfo[h][hTorOpen] = 1;
		else HausInfo[h][hTorOpen] = 0;
		moveGate(HausInfo[h][hTor], 1.27, 1.14, 1.45, 1, HausInfo[h][hTorOpen] == 1)
		CancelSelectTextDraw(playerid);
	}
	goto afterhaus;
}
*/

// moveGate Function, hab ich aber noch nicht getestet. Nur so ausm Kopf in Pawno eingetippelt ^^

///@credits by Alf21
///
///@desciption Move a gate with the behavior to rotate parallel to its own z-achsis on opening
///
///@param 'objectid' ([int]) id of the object that should be moved
///@param 'xDepth' (float) additional x-achsis depth of the moved object
///@param 'yDepth' (float) additional y-achsis depth of the moved object
///@param 'height' (float) additional height of the moved object
///@param 'speed' (float) speed of the movement
///@param 'open' (bool) the gate should be (true)opened / (false)closed ?
///@return ['open' (bool)] useless / without any sense, such the return of the inserted (bool) 'open'
stock moveGate(objectid, Float:xDepth, Float:yDepth, Float:height, Float:speed, bool:open)
{
	new Float:X, Float:Y, Float:Z,              // position of the object
		Float:RX, Float:RY, Float:RZ;           // rotation of the object

	GetDynamicObjectPos(objectid, X, Y, Z); 	// get the object position
	GetDynamicObjectRot(objectid, RX, RY, RZ); 	// get the object rotation

	// bug prevention
    while (RZ >= 360.0) // normalize the z-achsis rotation if it is buggy (eg.: 360degrees == 0degrees) to avoid bugs
        RZ = -360.0;
	// if you want, you can do the same with 'RX' (float) and 'RY' (float) but thats not beneficial for the calculations here

    new Float:trz = RZ; // just a cache / temporary variable

    // x-achsis position, y-achsis rotation
    if (RZ > 180.0) // normalize for clean x-achsis calculations
        trz -= 180.0;
    new Float:nx = (trz - 90.0) / 90.0 * xDepth; // extra position values added to the normal position
    new Float:nry = (trz - 90.0) * -1.0; // extra rotation values added to the normal rotation
    if (RZ > 180.0) // fix issue caused in x-achsis normalization
        nx *= -1.0;

    trz = RZ; // reset the cache / temporary variable

    // y-achsis position, x-achsis rotation
    if (RZ < 90.0) // normalize for clean y-achsis calculations
        trz += 180.0;
    new Float:ny = (trz - 180.0) / 90.0 * yDepth; // extra position values added to the normal position
    new Float:nrx = (trz - 180.0) * -1.0; //extra rotation values added to the normal rotation
    if (RZ < 90.0) // fix issue caused in y-achsis normalization
        ny *= -1.0;

	if (open) MoveDynamicObject(objectid, X + nx, Y + ny, Z + height, speed, RX + nrx, RY + nry, RZ); // on open: add values
	else MoveDynamicObject(objectid, X - nx, Y - ny, Z - height, speed, RX - nrx, RY - nry, RZ); // on close: substract values

	return open;
}
