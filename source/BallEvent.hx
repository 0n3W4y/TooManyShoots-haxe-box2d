package;

import flash.events.Event;

class BallEvent extends Event{

	public static var BALL_OFF_SCREEN:String = "BallOfScreen";
	public static var BALL_HIT_BONUS:String = "BallHitBonus";

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false){
		super(type, bubbles, cancelable);
	}

	public override function clone(){
		return new BallEvent(type, bubbles, cancelable);
	}

	public override function toString(){
		return formatToString("BallEvent", "type", "bubbles", "cancelable", "eventPhase");
	}

}