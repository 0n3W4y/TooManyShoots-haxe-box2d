package;


import flash.display.Sprite;
import box2D.dynamics.B2World;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2Fixture;
import box2D.collision.shapes.B2CircleShape;


import flash.events.EventDispatcher;
import flash.display.DisplayObject;


class Actor {
	
	private var _body:B2Body;
	private var _costume:Sprite;
	public var world_scale:Float;
	public var world:B2World;
	public var world_sprite:Sprite;

	
	public function new(body:B2Body, costume:Sprite){

		world_scale = Global.world_scale;
		world = Global.world;
		world_sprite = Global.world_sprite;
		_costume = costume;
		_body = body;

		updateMyLook();
	}

	public function updateNow(){
		if (_body.getType() != STATIC_BODY){
			updateMyLook();
		}
		childSpecificUpdate();

	}

	public function destroy(){

	}

	private function updateMyLook(){
		_costume.x = _body.getPosition().x * world_scale;
		_costume.y = _body.getPosition().y * world_scale;
		_costume.rotation = _body.getAngle() * 180/Math.PI;
	}

	private function childSpecificUpdate(){

	}

}