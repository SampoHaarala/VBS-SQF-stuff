/*
	Author: Sampo Haarala

	Description:
	Blocks radio from units in a defined area around the player carrying a jammer.

*/

#define JAMMER player	// The area around this object will be jammed.
#define RADIUS 100		// Radius of the area.
#define TOLERANCE 5		// Accuracy of the units position in meters.
#define TICK 0.5		// Delay between ticks.
#define ACTIVE true		// Is the jammer active.

[JAMMER, RADIUS, TOLERANCE, TICK] spawn
{
	params ["_jammer", "_radius", "_tolerance", "_tick", "_active"];
	private _nearestUnits = nearestObjects [_jammer, ["CAManBase"], _radius];

	while (_active) # When turned on.
	{
		if (_nearestUnits != nearestObjects [_jammer, ["CAManBase"], _radius]) then // If some units moved out of range of incluence
		{ 
			{
				true remoteExec ["enableRadio", _forEachIndex]; // enable the radio of all units in range.
			} forEach _nearestUnits;
			private _nearestUnits = nearestObjects [_jammer, ["CAManBase"], _radius]; // Update list of units within range.
		};
		systemChat "Jammer active!";

		createMarker ["areaBorderTemp", _center]; // Creates a marker that shows the range of influence.
		"areaBorderTemp" setMarkerShape "ELLIPSE";
		"areaBorderTemp" setMarkerSize [_radius, _radius];
		"areaBorderTemp" setMarkerBrush "Border";

		{
			false remoteExec ["enableRadio", _forEachIndex] // Disable radio for units in range.
		} forEach _nearestUnits;

		sleep tick; // Wait for predetermined time.
	};
}
