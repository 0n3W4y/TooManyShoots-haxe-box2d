package;

import flash.events.Event;

class PegEvent extends Event{

	public static var PEG_LIT_UP:String = "PegLitUp";

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