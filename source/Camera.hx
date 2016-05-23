package;

import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import flash.display.Stage;

class Camera extends Sprite{

	private static var ZOOM_IN_AMT:Float = 3.3;
	
	public function new()
	{
		super();		
	}

	public function zoomTo(whatPoint:Point)
	{
		this.scaleX = ZOOM_IN_AMT;
		this.scaleY = ZOOM_IN_AMT;


		this.x = -whatPoint.x + ZOOM_IN_AMT;
		this.y = -whatPoint.y + ZOOM_IN_AMT;

		this.color = 0xaa0012;

		trace ( this.stageWidth + " stageWidth");
	}

	public function zoomOut()
	{
		this.scaleX = 1.0;
		this.scaleY = 1.0;

		this.x = 0;
		this.y = 0;
	}

}